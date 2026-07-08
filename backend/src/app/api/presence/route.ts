import { NextResponse } from 'next/server';
import { createAdminSupabaseClient } from '../../../utils/supabase';

export async function POST(request: Request) {
  try {
    const body = await request.json();
    const {
      device_id,
      device_name,
      os_version,
      app_version,
      status,
      current_channel_id,
      current_channel_name,
      country_code: clientCountryCode,
    } = body;

    if (!device_id) {
      return NextResponse.json({ error: 'device_id is required' }, { status: 400 });
    }

    // Resolve client IP address
    const xForwardedFor = request.headers.get('x-forwarded-for');
    const xRealIp = request.headers.get('x-real-ip');
    let ipAddress = xForwardedFor 
      ? xForwardedFor.split(',')[0].trim() 
      : (xRealIp || '127.0.0.1');

    // Remove IPv6 loopback representation if local
    if (ipAddress === '::1' || ipAddress === '::ffff:127.0.0.1') {
      ipAddress = '127.0.0.1';
    }

    // Resolve Country Code
    // Vercel Geolocation header OR Cloudflare Geolocation header OR Client-provided fallback OR 'UN' (Unknown)
    let countryCode = 
      request.headers.get('x-vercel-ip-country') ||
      request.headers.get('cf-ipcountry') ||
      clientCountryCode ||
      'UN';

    // Standardize to uppercase 2-letter code
    countryCode = countryCode.trim().toUpperCase();
    if (countryCode.length !== 2) {
      countryCode = 'UN';
    }

    // Get admin secret token to authenticate DB write
    const correctToken = process.env.ADMIN_SECRET_TOKEN || 'GoLiveAdminSecret2026';
    const supabaseAdmin = createAdminSupabaseClient(correctToken);

    // Upsert user presence
    const { error } = await supabaseAdmin
      .from('user_presence')
      .upsert(
        {
          device_id,
          device_name: device_name || 'Generic Device',
          os_version: os_version || 'Unknown OS',
          app_version: app_version || '1.0.0',
          status: status || 'online',
          current_channel_id: current_channel_id || null,
          current_channel_name: current_channel_name || null,
          ip_address: ipAddress,
          country_code: countryCode,
          last_active_at: new Date().toISOString(),
        },
        { onConflict: 'device_id' }
      );

    if (error) {
      console.error('Error upserting user presence:', error);
      return NextResponse.json({ success: false, error: error.message }, { status: 500 });
    }

    return NextResponse.json({
      success: true,
      resolved_ip: ipAddress,
      resolved_country: countryCode,
    });
  } catch (error: any) {
    console.error('Error in presence API route:', error);
    return NextResponse.json({ success: false, error: error.message || 'Internal Server Error' }, { status: 500 });
  }
}
