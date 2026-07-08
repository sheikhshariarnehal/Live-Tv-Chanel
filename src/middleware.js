export async function onRequest(context, next) {
  const { request, cookies, redirect, url } = context;
  const adminPassword = process.env.ADMIN_PASSWORD || import.meta.env.ADMIN_PASSWORD || 'admin123';

  if (url.pathname.startsWith('/admin') && url.pathname !== '/admin/login') {
    const session = cookies.get('admin_session')?.value;
    if (session !== adminPassword) {
      return redirect('/admin/login');
    }
  }

  const startTime = Date.now();

  // Execute the request
  const response = await next();

  const duration = Date.now() - startTime;
  const status = response.status;
  
  // Format standard request logs for Docker/stdout
  console.log(`[${new Date().toISOString()}] ${request.method} ${url.pathname}${url.search || ''} - ${status} (${duration}ms)`);

  return response;
}
