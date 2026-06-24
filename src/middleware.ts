import { NextResponse } from 'next/server';
import type { NextRequest } from 'next/server';

export function middleware(request: NextRequest) {
  const url = request.nextUrl.pathname;
  const searchParams = request.nextUrl.search;
  const method = request.method;
  
  // Log the incoming request method, path, and timestamp
  console.log(`[Request] ${method} ${url}${searchParams} - ${new Date().toISOString()}`);
  
  return NextResponse.next();
}

export const config = {
  matcher: [
    /*
     * Match all request paths except for the ones starting with:
     * - _next/static (static files)
     * - _next/image (image optimization files)
     * - favicon.ico (favicon file)
     * - assets (public assets/logos)
     */
    '/((?!_next/static|_next/image|favicon.ico|assets).*)',
  ],
};
