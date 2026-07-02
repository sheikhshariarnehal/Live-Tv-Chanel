export async function onRequest({ request }, next) {
  const startTime = Date.now();
  const url = new URL(request.url);

  // Execute the request
  const response = await next();

  const duration = Date.now() - startTime;
  const status = response.status;
  
  // Format standard request logs for Docker/stdout
  console.log(`[${new Date().toISOString()}] ${request.method} ${url.pathname}${url.search || ''} - ${status} (${duration}ms)`);

  return response;
}
