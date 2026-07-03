import { NextResponse } from 'next/server';
import { createAdminSupabaseClient } from '../../../../utils/supabase';

export async function GET(request: Request) {
  try {
    const authHeader = request.headers.get('authorization') || request.headers.get('x-admin-token');
    const token = authHeader?.replace('Bearer ', '').trim();
    const correctToken = process.env.ADMIN_SECRET_TOKEN || 'GoLiveAdminSecret2026';

    if (!token || token !== correctToken) {
      return NextResponse.json({ error: 'Unauthorized Access Secret Required' }, { status: 401 });
    }

    const { searchParams } = new URL(request.url);
    const channelId = searchParams.get('channelId');

    if (!channelId) {
      return NextResponse.json({ error: 'Missing channelId parameter' }, { status: 400 });
    }

    const supabaseAdmin = createAdminSupabaseClient(correctToken);

    // 1. Fetch channel info
    const { data: channel, error: chErr } = await supabaseAdmin
      .from('channels')
      .select('id, name, stream_url, proxy, drm')
      .eq('id', channelId)
      .single();

    if (chErr || !channel) {
      return NextResponse.json({ error: 'Channel not found' }, { status: 404 });
    }

    // 2. Fetch last 20 history records
    const { data: logs, error: logErr } = await supabaseAdmin
      .from('channel_health_history')
      .select('*')
      .eq('channel_id', channelId)
      .order('checked_at', { ascending: false })
      .limit(20);

    if (logErr) throw logErr;

    return NextResponse.json({
      success: true,
      channel,
      logs: logs || []
    });
  } catch (error: any) {
    return NextResponse.json({ 
      success: false, 
      error: error.message || 'Failed to fetch channel logs' 
    }, { status: 500 });
  }
}
