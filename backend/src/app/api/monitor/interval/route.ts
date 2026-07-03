import { NextResponse } from 'next/server';
import { createAdminSupabaseClient } from '../../../../utils/supabase';
import { initializeScheduler } from '../../../../utils/monitor-service';

export async function POST(request: Request) {
  try {
    const authHeader = request.headers.get('authorization') || request.headers.get('x-admin-token');
    const token = authHeader?.replace('Bearer ', '').trim();
    const correctToken = process.env.ADMIN_SECRET_TOKEN || 'GoLiveAdminSecret2026';

    if (!token || token !== correctToken) {
      return NextResponse.json({ error: 'Unauthorized Access Secret Required' }, { status: 401 });
    }

    const { intervalMinutes } = await request.json();
    if (!intervalMinutes || typeof intervalMinutes !== 'number' || intervalMinutes < 1) {
      return NextResponse.json({ 
        success: false, 
        error: 'Invalid interval duration. Must be at least 1 minute.' 
      }, { status: 400 });
    }

    const supabaseAdmin = createAdminSupabaseClient(correctToken);

    // Save configuration update to the single settings record
    const { error: updateErr } = await supabaseAdmin
      .from('app_settings')
      .update({
        monitor_interval_minutes: intervalMinutes,
        updated_at: new Date().toISOString()
      })
      .eq('id', 1);

    if (updateErr) throw updateErr;

    // Reinstate scheduler timer with the new configuration
    await initializeScheduler();

    return NextResponse.json({
      success: true,
      message: `Automated scan interval successfully set to run every ${intervalMinutes} minutes.`
    });
  } catch (error: any) {
    return NextResponse.json({ 
      success: false, 
      error: error.message || 'Failed to update automated scan settings' 
    }, { status: 500 });
  }
}
