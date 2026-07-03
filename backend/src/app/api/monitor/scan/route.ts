import { NextResponse } from 'next/server';
import { runChannelScan } from '../../../../utils/monitor-service';

export async function POST(request: Request) {
  try {
    const authHeader = request.headers.get('authorization') || request.headers.get('x-admin-token');
    const token = authHeader?.replace('Bearer ', '').trim();
    const correctToken = process.env.ADMIN_SECRET_TOKEN || 'GoLiveAdminSecret2026';

    if (!token || token !== correctToken) {
      return NextResponse.json({ error: 'Unauthorized Access Secret Required' }, { status: 401 });
    }

    if (global.isScanningNow) {
      return NextResponse.json({ 
        success: false, 
        error: 'A health scan is already in progress.' 
      }, { status: 409 });
    }

    // Trigger scanning asynchronously to avoid HTTP connection timeouts
    runChannelScan().catch(err => {
      console.error('Error in manual background scan trigger:', err);
    });

    return NextResponse.json({
      success: true,
      message: 'Channel health scan successfully initiated in the background.'
    });
  } catch (error: any) {
    return NextResponse.json({ 
      success: false, 
      error: error.message || 'Failed to start manual scan' 
    }, { status: 500 });
  }
}
