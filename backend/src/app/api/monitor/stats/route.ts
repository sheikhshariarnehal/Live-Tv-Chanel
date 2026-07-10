import { NextResponse } from 'next/server';
import { createAdminSupabaseClient } from '../../../../utils/supabase';
import { initializeScheduler } from '../../../../utils/monitor-service';

export async function GET(request: Request) {
  try {
    const authHeader = request.headers.get('authorization') || request.headers.get('x-admin-token');
    const token = authHeader?.replace('Bearer ', '').trim();
    const correctToken = process.env.ADMIN_SECRET_TOKEN || 'GoLiveAdminSecret2026';

    if (!token || token !== correctToken) {
      return NextResponse.json({ error: 'Unauthorized Access Secret Required' }, { status: 401 });
    }

    const supabaseAdmin = createAdminSupabaseClient(correctToken);

    // Initialize scheduler on first load if it's not active
    if (!global.monitorIntervalId) {
      await initializeScheduler();
    }

    // 1. Fetch all channels using pagination (bypass 1000-row PostgREST limit)
    const BATCH_SIZE = 1000;
    let offset = 0;
    const channels: any[] = [];

    while (true) {
      const { data: batch, error: chErr } = await supabaseAdmin
        .from('channels')
        .select('*')
        .order('sort_order', { ascending: true })
        .range(offset, offset + BATCH_SIZE - 1);

      if (chErr) throw chErr;
      if (!batch || batch.length === 0) break;
      channels.push(...batch);

      if (batch.length < BATCH_SIZE) break;
      offset += BATCH_SIZE;
    }

    // 2. Fetch categories
    const { data: categories, error: catErr } = await supabaseAdmin
      .from('categories')
      .select('id, name');
    
    if (catErr) throw catErr;
    const catMap = new Map(categories?.map(c => [c.id, c.name]) || []);

    // 3. Fetch latest health details
    const { data: healths, error: hErr } = await supabaseAdmin
      .from('channel_health')
      .select('*');
    
    if (hErr) throw hErr;
    const healthMap = new Map(healths?.map(h => [h.channel_id, h]) || []);

    // 4. Fetch last scan run
    const { data: lastScans } = await supabaseAdmin
      .from('channel_health_scans')
      .select('*')
      .order('scanned_at', { ascending: false })
      .limit(1);
    
    const lastScan = lastScans && lastScans[0] ? lastScans[0] : null;

    // 5. Fetch interval settings
    const { data: settings } = await supabaseAdmin
      .from('app_settings')
      .select('monitor_interval_minutes')
      .eq('id', 1)
      .single();
    
    const intervalMinutes = settings?.monitor_interval_minutes || 5;

    // Map channels to statuses and calculate summaries
    let working = 0;
    let offline = 0;
    let slow = 0;
    let drmCount = 0;
    let proxyCount = 0;

    const mappedChannels = (channels || []).map(ch => {
      const h = healthMap.get(ch.id);
      
      if (ch.drm && ch.drm.type) drmCount++;
      if (ch.proxy) proxyCount++;

      if (h) {
        if (h.status === 'working') working++;
        else if (h.status === 'offline') offline++;
        else if (h.status === 'slow') slow++;
      } else {
        offline++; // defaults to offline if never scanned
      }

      return {
        id: ch.id,
        name: ch.name,
        stream_url: ch.stream_url,
        proxy: ch.proxy,
        drm: ch.drm,
        category_id: ch.category,
        category_name: catMap.get(ch.category) || 'Uncategorized',
        health: h ? {
          status: h.status,
          http_status: h.http_status,
          response_time: h.response_time,
          playlist_status: h.playlist_status,
          segment_status: h.segment_status,
          proxy_status: h.proxy_status,
          drm_status: h.drm_status,
          headers_status: h.headers_status,
          geo_status: h.geo_status,
          error_message: h.error_message,
          checked_at: h.checked_at,
        } : null
      };
    });

    return NextResponse.json({
      success: true,
      stats: {
        totalChannels: channels?.length || 0,
        working,
        offline,
        slow,
        drmChannels: drmCount,
        proxyChannels: proxyCount,
        lastScanTime: lastScan ? lastScan.scanned_at : (global.lastScanTime || null),
        isScanning: !!global.isScanningNow,
        intervalMinutes
      },
      channels: mappedChannels
    });
  } catch (error: any) {
    return NextResponse.json({ success: false, error: error.message || 'Failed to fetch monitoring stats' }, { status: 500 });
  }
}
