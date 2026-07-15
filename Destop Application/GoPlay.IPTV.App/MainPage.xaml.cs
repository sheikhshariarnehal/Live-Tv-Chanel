using System;
using System.Text.Json;
using System.Threading.Tasks;
using Microsoft.UI.Xaml;
using Microsoft.UI.Xaml.Controls;
using Microsoft.UI.Xaml.Navigation;
using GoPlay_IPTV_App.ViewModels;
using Microsoft.Extensions.DependencyInjection;

namespace GoPlay_IPTV_App;

/// <summary>
/// The main content page displayed inside the application window.
/// </summary>
public sealed partial class MainPage : Page
{
    private WebView2 PlayerWebView;
    private bool _isWebViewInitialized = false;
    private bool _isNavigationCompleted = false;
    private TaskCompletionSource<bool>? _navigationTcs;

    public MainPageViewModel ViewModel { get; }

    public MainPage()
    {
        InitializeComponent();
        ViewModel = App.CurrentApp.Services.GetRequiredService<MainPageViewModel>();
        DataContext = ViewModel;

        ViewModel.PropertyChanged += ViewModel_PropertyChanged;
    }

    protected override void OnNavigatedTo(NavigationEventArgs e)
    {
        base.OnNavigatedTo(e);
        _ = ViewModel.LoadDataCommand.ExecuteAsync(null);
    }

    private async void ViewModel_PropertyChanged(object? sender, System.ComponentModel.PropertyChangedEventArgs e)
    {
        if (e.PropertyName == nameof(ViewModel.SelectedChannel))
        {
            await PlaySelectedChannelAsync();
        }
        else if (e.PropertyName == nameof(ViewModel.IsPlaying))
        {
            if (_isWebViewInitialized && _isNavigationCompleted)
            {
                var action = ViewModel.IsPlaying ? "play()" : "pause()";
                try
                {
                    await PlayerWebView.ExecuteScriptAsync($"document.getElementById('video').{action}");
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Debug.WriteLine($"Error toggling video playback: {ex.Message}");
                }
            }
        }
        else if (e.PropertyName == nameof(ViewModel.Volume))
        {
            if (_isWebViewInitialized && _isNavigationCompleted)
            {
                try
                {
                    await PlayerWebView.ExecuteScriptAsync($"document.getElementById('video').volume = {ViewModel.Volume / 100.0}");
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Debug.WriteLine($"Error setting video volume: {ex.Message}");
                }
            }
        }
        else if (e.PropertyName == nameof(ViewModel.IsMuted))
        {
            if (_isWebViewInitialized && _isNavigationCompleted)
            {
                try
                {
                    await PlayerWebView.ExecuteScriptAsync($"document.getElementById('video').muted = {ViewModel.IsMuted.ToString().ToLower()}");
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Debug.WriteLine($"Error muting video: {ex.Message}");
                }
            }
        }
    }

    private async Task EnsurePlayerInitializedAsync()
    {
        if (_isWebViewInitialized) return;

        try
        {
            // Configure WebView2 Environment options to disable web security, allow autoplay, and disable HTTP cache
            var options = new Microsoft.Web.WebView2.Core.CoreWebView2EnvironmentOptions();
            options.AdditionalBrowserArguments = "--disable-web-security --autoplay-policy=no-user-gesture-required --disable-http-cache";
                
            var environment = await Microsoft.Web.WebView2.Core.CoreWebView2Environment.CreateWithOptionsAsync(null, null, options);

            // Dynamically instantiate WebView2 control
            PlayerWebView = new WebView2();
            PlayerWebView.HorizontalAlignment = Microsoft.UI.Xaml.HorizontalAlignment.Stretch;
            PlayerWebView.VerticalAlignment = Microsoft.UI.Xaml.VerticalAlignment.Stretch;

            // Initialize WebView2 with our custom environment options
            await PlayerWebView.EnsureCoreWebView2Async(environment);
            
            // Add the initialized control to the parent container grid
            PlayerContainer.Children.Add(PlayerWebView);
            
            _isWebViewInitialized = true;

            var assetsDir = System.IO.Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "Assets");
            if (!System.IO.Directory.Exists(assetsDir))
            {
                System.IO.Directory.CreateDirectory(assetsDir);
            }
            var playerPath = System.IO.Path.Combine(assetsDir, "player.html");
            System.IO.File.WriteAllText(playerPath, GetPlayerHtml());

            // Map the virtual host goplay.premium to the Assets folder to establish a Secure Context for EME DRM APIs
            PlayerWebView.CoreWebView2.SetVirtualHostNameToFolderMapping(
                "goplay.premium",
                assetsDir,
                Microsoft.Web.WebView2.Core.CoreWebView2HostResourceAccessKind.Allow);

            _isNavigationCompleted = false;
            _navigationTcs = new TaskCompletionSource<bool>();
            PlayerWebView.NavigationCompleted += PlayerWebView_NavigationCompleted;

            // Navigate to the secure local page using the virtual host with HTTPS scheme to enable EME DRM APIs
            PlayerWebView.CoreWebView2.Navigate("https://goplay.premium/player.html");

            // Wait for navigation to finish
            await _navigationTcs.Task;

            // Add resource request filters for all schemes to ensure HTTPS interception
            PlayerWebView.CoreWebView2.AddWebResourceRequestedFilter("*", Microsoft.Web.WebView2.Core.CoreWebView2WebResourceContext.All);
            PlayerWebView.CoreWebView2.AddWebResourceRequestedFilter("http://*", Microsoft.Web.WebView2.Core.CoreWebView2WebResourceContext.All);
            PlayerWebView.CoreWebView2.AddWebResourceRequestedFilter("https://*", Microsoft.Web.WebView2.Core.CoreWebView2WebResourceContext.All);
            PlayerWebView.CoreWebView2.WebResourceRequested += CoreWebView2_WebResourceRequested;

            // Listen to messages from JavaScript (for playback progress, buffering, etc.)
            PlayerWebView.CoreWebView2.WebMessageReceived += CoreWebView2_WebMessageReceived;
        }
        catch (Exception ex)
        {
            System.Diagnostics.Debug.WriteLine($"Failed to initialize WebView2: {ex}");
        }
    }

    private void CoreWebView2_WebResourceRequested(object sender, object e)
    {
        var channel = ViewModel.SelectedChannel;
        if (channel == null) return;

        try
        {
            dynamic args = e;
            string uri = args.Request.Uri;

            // Only intercept external stream requests (ignore local player.html or assets)
            if (uri.StartsWith("https://goplay.premium", StringComparison.OrdinalIgnoreCase) || 
                uri.StartsWith("http://goplay.premium", StringComparison.OrdinalIgnoreCase))
            {
                return;
            }

            // Always strip default Referer and Origin headers to bypass Varnish CDN blocks
            try
            {
                args.Request.Headers.Remove("Referer");
                args.Request.Headers.Remove("Origin");
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error removing headers: {ex.Message}");
            }

            // Inject custom channel-specific headers from the database
            if (channel.Headers != null && channel.Headers.Count > 0)
            {
                foreach (var header in channel.Headers)
                {
                    try
                    {
                        args.Request.Headers.SetHeader(header.Key, header.Value);
                    }
                    catch (Exception ex)
                    {
                        System.Diagnostics.Debug.WriteLine($"Error setting header {header.Key}: {ex.Message}");
                    }
                }
            }
        }
        catch (Exception ex)
        {
            System.Diagnostics.Debug.WriteLine($"Error in WebResourceRequested: {ex.Message}");
        }
    }

    private void PlayerWebView_NavigationCompleted(object sender, object e)
    {
        _isNavigationCompleted = true;
        _navigationTcs?.TrySetResult(true);
    }



    private void CoreWebView2_WebMessageReceived(object sender, object e)
    {
        try
        {
            dynamic args = e;
            var message = args.TryGetWebMessageAsString();
            System.Diagnostics.Debug.WriteLine($"[WebView JS Log] {message}");
            Console.WriteLine($"[WebView JS Log] {message}");
            
            try
            {
                var logPath = @"d:\Poject\GoPlay\player_debug.log";
                System.IO.File.AppendAllText(logPath, $"[{DateTime.Now:yyyy-MM-dd HH:mm:ss}] {message}\n");
            }
            catch {}
        }
        catch (Exception ex)
        {
            System.Diagnostics.Debug.WriteLine($"Error receiving web message: {ex}");
        }
    }

    private void UpdateUserAgent(GoPlay.IPTV.Core.Models.Channel channel)
    {
        try
        {
            if (channel.Headers != null)
            {
                foreach (var header in channel.Headers)
                {
                    if (header.Key.Equals("User-Agent", StringComparison.OrdinalIgnoreCase))
                    {
                        PlayerWebView.CoreWebView2.Settings.UserAgent = header.Value;
                        return;
                    }
                }
            }
            // Reset to default
            PlayerWebView.CoreWebView2.Settings.UserAgent = "";
        }
        catch (Exception ex)
        {
            System.Diagnostics.Debug.WriteLine($"Error updating User-Agent: {ex.Message}");
        }
    }

    private async Task PlaySelectedChannelAsync()
    {
        var channel = ViewModel.SelectedChannel;
        if (channel == null) return;

        await EnsurePlayerInitializedAsync();

        if (_isWebViewInitialized && _isNavigationCompleted)
        {
            try
            {
                // Update User-Agent Settings dynamically before playing
                UpdateUserAgent(channel);

                // Serialize DRM and headers to JSON matching the naming policy
                var jsonOptions = new JsonSerializerOptions 
                { 
                    PropertyNamingPolicy = JsonNamingPolicy.SnakeCaseLower 
                };
                
                var drmJson = channel.Drm != null 
                    ? JsonSerializer.Serialize(channel.Drm, jsonOptions) 
                    : "null";
                    
                var headersJson = channel.Headers != null 
                    ? JsonSerializer.Serialize(channel.Headers, jsonOptions) 
                    : "null";

                var script = $"initPlayer(\"{channel.StreamUrl}\", {drmJson}, {headersJson})";
                await PlayerWebView.ExecuteScriptAsync(script);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error playing channel: {ex.Message}");
            }
        }
    }

    private string GetPlayerHtml()
    {
        return @"<!DOCTYPE html>
<html>
<head>
  <meta charset=""utf-8"">
  <meta name=""viewport"" content=""width=device-width, initial-scale=1"">
  <meta name=""referrer"" content=""no-referrer"">
  <title>GoPlay DRM Player</title>
  <!-- Load mux.js first to enable HLS TS demuxing support in Shaka Player -->
  <script src=""https://cdnjs.cloudflare.com/ajax/libs/mux.js/6.0.1/mux.min.js""></script>
  <!-- Load Shaka Player from CDN -->
  <script src=""https://cdnjs.cloudflare.com/ajax/libs/shaka-player/4.3.5/shaka-player.compiled.js""></script>
  <style>
    body, html {
      margin: 0;
      padding: 0;
      width: 100%;
      height: 100%;
      background: black;
      overflow: hidden;
      display: flex;
      justify-content: center;
      align-items: center;
    }
    video {
      width: 100%;
      height: 100%;
      outline: none;
      background: black;
    }
    #error-container {
      display: none;
      color: #ff5252;
      font-family: sans-serif;
      text-align: center;
      padding: 20px;
      position: absolute;
      z-index: 10;
    }
  </style>
</head>
<body>
  <video id=""video"" autoplay crossorigin=""anonymous""></video>
  <div id=""error-container""></div>

  <script>
    let player = null;

    const notify = (event, data) => {
      if (window.chrome && window.chrome.webview) {
        window.chrome.webview.postMessage(JSON.stringify({ event: event, data: data }));
      }
    };

    // Redirect console messages to C# for debugging
    const logOriginal = console.log;
    const errorOriginal = console.error;
    const warnOriginal = console.warn;
    const infoOriginal = console.info;
    
    console.log = (...args) => {
      logOriginal.apply(console, args);
      notify('log', args.join(' '));
    };
    console.error = (...args) => {
      errorOriginal.apply(console, args);
      notify('error', args.join(' '));
    };
    console.warn = (...args) => {
      warnOriginal.apply(console, args);
      notify('warn', args.join(' '));
    };
    console.info = (...args) => {
      infoOriginal.apply(console, args);
      notify('info', args.join(' '));
    };

    async function initPlayer(streamUrl, drmConfig, headers) {
      console.log(""initPlayer called with url: "" + streamUrl);
      const video = document.getElementById('video');
      const errorContainer = document.getElementById('error-container');
      
      // Clear existing error
      errorContainer.style.display = 'none';

      // Attach video event listeners
      video.addEventListener('play', () => notify('onPlayStateChanged', true));
      video.addEventListener('pause', () => notify('onPlayStateChanged', false));
      video.addEventListener('waiting', () => notify('onBufferingStateChanged', true));
      video.addEventListener('playing', () => notify('onBufferingStateChanged', false));
      video.addEventListener('timeupdate', () => notify('onProgressChanged', { currentTime: video.currentTime, duration: video.duration || 0 }));

      // Install polyfills
      shaka.polyfill.installAll();

      if (!shaka.Player.isBrowserSupported()) {
        errorContainer.textContent = 'Browser does not support DRM playback.';
        errorContainer.style.display = 'block';
        return;
      }

      if (player) {
        try {
          await player.destroy();
        } catch (e) {
          console.error(""Error destroying previous player:"", e);
        }
      }

      player = new shaka.Player(video);
      
      // Set up error handler
      player.addEventListener('error', (event) => {
        const error = event.detail;
        console.error('Shaka player error:', error);
        errorContainer.textContent = 'Playback Error: Code ' + error.code + ' (Category: ' + error.category + ', Severity: ' + error.severity + ')';
        errorContainer.style.display = 'block';
        notify('onError', 'Error code: ' + error.code);
      });

      // Register request filter to inject custom headers (for Referer, User-Agent, Auth, etc.)
      if (headers) {
        player.getNetworkingEngine().registerRequestFilter((type, request) => {
          for (const [key, value] of Object.entries(headers)) {
            request.headers[key] = value;
          }
        });
      }

      // Resolve case-insensitive DRM properties (handles both C# PascalCase and JS camelCase)
      const drmType = drmConfig ? (drmConfig.Type || drmConfig.type || '').toLowerCase().trim() : '';
      const kid = drmConfig ? (drmConfig.Kid || drmConfig.kid) : null;
      const key = drmConfig ? (drmConfig.Key || drmConfig.key) : null;
      const clearKeys = drmConfig ? (drmConfig.ClearKeys || drmConfig.clearKeys || drmConfig.clear_keys) : null;
      const licenseUrl = drmConfig ? (drmConfig.LicenseUrl || drmConfig.licenseUrl || drmConfig.license_url) : null;
      const licenseHeaders = drmConfig ? (drmConfig.Headers || drmConfig.headers || drmConfig.license_headers) : null;

      // Register response filter to modify manifest on-the-fly for ClearKey
      if (drmType === 'clearkey') {
        player.getNetworkingEngine().registerResponseFilter((type, response) => {
          if (type === shaka.net.NetworkingEngine.RequestType.MANIFEST) {
            try {
              const textDecoder = new TextDecoder('utf-8');
              let manifestText = textDecoder.decode(response.data);
              
              // Skip modifying HLS playlists (M3U8) which are not XML
              if (manifestText.trim().startsWith('#EXTM3U')) {
                return;
              }
              
              // Parse XML using browser DOMParser to strip PlayReady and Widevine ContentProtection elements
              const parser = new DOMParser();
              const xmlDoc = parser.parseFromString(manifestText, 'application/xml');
              
              const allElements = xmlDoc.getElementsByTagName('*');
              for (let i = allElements.length - 1; i >= 0; i--) {
                const el = allElements[i];
                if (el.localName === 'ContentProtection') {
                  const schemeId = el.getAttribute('schemeIdUri');
                  if (schemeId) {
                    const schemeLower = schemeId.toLowerCase();
                    // Strip PlayReady (9a04f079...) and Widevine (edef8ba9...) ContentProtection tags
                    if (schemeLower.includes('9a04f079') || 
                        schemeLower.includes('edef8ba9')) {
                      el.parentNode.removeChild(el);
                    }
                  }
                }
              }
              
              const serializer = new XMLSerializer();
              manifestText = serializer.serializeToString(xmlDoc);
              
              const textEncoder = new TextEncoder();
              response.data = textEncoder.encode(manifestText).buffer;
              console.log('Successfully stripped PlayReady and Widevine DRM tags from manifest.');
            } catch (e) {
              console.error('Error in manifest response filter:', e);
            }
          }
        });
      }

      // Configure DRM
      if (drmType) {
        try {
          const shakaDrmConfig = {};

          if (drmType === 'widevine') {
            shakaDrmConfig.preferredKeySystems = ['com.widevine.alpha'];
            shakaDrmConfig.servers = {
              'com.widevine.alpha': licenseUrl
            };
            if (licenseHeaders) {
              player.getNetworkingEngine().registerRequestFilter((type, request) => {
                if (type === shaka.net.NetworkingEngine.RequestType.LICENSE) {
                  for (const [key, value] of Object.entries(licenseHeaders)) {
                    request.headers[key] = value;
                  }
                }
              });
            }
          } else if (drmType === 'clearkey') {
            shakaDrmConfig.preferredKeySystems = ['org.w3.clearkey'];
            if (clearKeys && Object.keys(clearKeys).length > 0) {
              shakaDrmConfig.clearKeys = clearKeys;
            } else if (kid && key) {
              shakaDrmConfig.clearKeys = {};
              const kidLower = kid.toLowerCase().trim();
              const keyLower = key.toLowerCase().trim();
              shakaDrmConfig.clearKeys[kidLower] = keyLower;
            }
          }

          player.configure({ drm: shakaDrmConfig });
        } catch (e) {
          console.error('Error parsing DRM config:', e);
        }
      }

      try {
        await player.load(streamUrl);
        console.log('Stream loaded successfully!');
        notify('onLoadSuccess', streamUrl);
      } catch (e) {
        console.error('Error loading stream: ', e);
        errorContainer.textContent = 'Error loading stream: Code ' + e.code + ' (Category: ' + e.category + ', Severity: ' + e.severity + ')';
        errorContainer.style.display = 'block';
        notify('onError', 'Error code: ' + e.code);
      }
    }
  </script>
</body>
</html>";
    }
}



