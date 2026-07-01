import { NextResponse } from 'next/server';

export async function POST(request: Request) {
  try {
    const { password } = await request.json();
    const correctToken = process.env.ADMIN_SECRET_TOKEN || 'GoLiveAdminSecret2026';

    if (password && password.trim() === correctToken.trim()) {
      return NextResponse.json({ 
        success: true, 
        token: correctToken.trim() 
      });
    }

    return NextResponse.json({ 
      success: false, 
      error: 'Invalid Administrator Access Secret' 
    }, { status: 401 });
  } catch (error: any) {
    return NextResponse.json({ 
      success: false, 
      error: error.message || 'Server error' 
    }, { status: 500 });
  }
}
