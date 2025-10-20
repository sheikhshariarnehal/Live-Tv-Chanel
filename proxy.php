<?php
/**
 * Simple CORS Proxy for HLS Streams
 * This proxy helps resolve mixed content and CORS issues
 * 
 * Usage: proxy.php?url=http://example.com/stream.m3u8
 */

// Enable error reporting for debugging (disable in production)
// error_reporting(E_ALL);
// ini_set('display_errors', 1);

// Set headers to allow CORS
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Range');
header('Access-Control-Expose-Headers: Content-Length, Content-Range');

// Handle preflight OPTIONS request
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

// Get the URL parameter
$url = isset($_GET['url']) ? $_GET['url'] : '';

if (empty($url)) {
    http_response_code(400);
    die('Error: No URL provided. Usage: proxy.php?url=YOUR_STREAM_URL');
}

// Validate URL
if (!filter_var($url, FILTER_VALIDATE_URL)) {
    http_response_code(400);
    die('Error: Invalid URL provided');
}

// Initialize cURL
$ch = curl_init();

// Set cURL options
curl_setopt($ch, CURLOPT_URL, $url);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_FOLLOWLOCATION, true);
curl_setopt($ch, CURLOPT_MAXREDIRS, 5);
curl_setopt($ch, CURLOPT_TIMEOUT, 30);
curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, false);

// Forward Range header if present (for video seeking)
if (isset($_SERVER['HTTP_RANGE'])) {
    curl_setopt($ch, CURLOPT_HTTPHEADER, array('Range: ' . $_SERVER['HTTP_RANGE']));
}

// Get headers
curl_setopt($ch, CURLOPT_HEADER, true);
curl_setopt($ch, CURLOPT_NOBODY, false);

// Execute request
$response = curl_exec($ch);

// Check for errors
if (curl_errno($ch)) {
    http_response_code(500);
    die('Error: ' . curl_error($ch));
}

// Get response info
$header_size = curl_getinfo($ch, CURLINFO_HEADER_SIZE);
$http_code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
$content_type = curl_getinfo($ch, CURLINFO_CONTENT_TYPE);

curl_close($ch);

// Separate headers and body
$headers = substr($response, 0, $header_size);
$body = substr($response, $header_size);

// Set response code
http_response_code($http_code);

// Forward important headers
if ($content_type) {
    header('Content-Type: ' . $content_type);
}

// Parse and forward other important headers
$header_lines = explode("\r\n", $headers);
foreach ($header_lines as $header) {
    if (stripos($header, 'Content-Length:') === 0 ||
        stripos($header, 'Content-Range:') === 0 ||
        stripos($header, 'Accept-Ranges:') === 0) {
        header($header);
    }
}

// Output the body
echo $body;
?>
