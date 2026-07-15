using System;
using System.Net.Http;
using Windows.ApplicationModel;
using Windows.ApplicationModel.Activation;
using Windows.Foundation;
using Windows.Foundation.Collections;
using Microsoft.UI.Xaml;
using Microsoft.UI.Xaml.Controls;
using Microsoft.UI.Xaml.Controls.Primitives;
using Microsoft.UI.Xaml.Data;
using Microsoft.UI.Xaml.Input;
using Microsoft.UI.Xaml.Media;
using Microsoft.UI.Xaml.Navigation;
using Microsoft.UI.Xaml.Shapes;
using Microsoft.Extensions.DependencyInjection;
using GoPlay.IPTV.Core.Repositories;
using GoPlay.IPTV.Infrastructure.Repositories;
using GoPlay_IPTV_App.Services;
using GoPlay_IPTV_App.ViewModels;

// To learn more about WinUI, the WinUI project structure,
// and more about our project templates, see: http://aka.ms/winui-project-info.

namespace GoPlay_IPTV_App;

/// <summary>
/// Provides application-specific behavior to supplement the default Application class.
/// </summary>
public partial class App : Application
{
    private Window? _window;
    
    public IServiceProvider Services { get; }

    public static App CurrentApp => (App)Current;
    
    /// <summary>
    /// Initializes the singleton application object.  This is the first line of authored code
    /// executed, and as such is the logical equivalent of main() or WinMain().
    /// </summary>
    public App()
    {
        InitializeComponent();
        Services = ConfigureServices();
    }

    private static IServiceProvider ConfigureServices()
    {
        var services = new ServiceCollection();

        // HttpClient for Supabase API
        services.AddSingleton<HttpClient>(sp =>
        {
            var client = new HttpClient();
            client.DefaultRequestHeaders.Add("apikey", "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhxbWh1dnNqbHlrcmR1c2ZrbWVnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODI4MjI3OTEsImV4cCI6MjA5ODM5ODc5MX0.sfNEW7QG0idyVVRHlDtYjITDfIbsFQQm2u9a3ffoNoA");
            client.DefaultRequestHeaders.Authorization = new System.Net.Http.Headers.AuthenticationHeaderValue("Bearer", "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhxbWh1dnNqbHlrcmR1c2ZrbWVnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODI4MjI3OTEsImV4cCI6MjA5ODM5ODc5MX0.sfNEW7QG0idyVVRHlDtYjITDfIbsFQQm2u9a3ffoNoA");
            return client;
        });

        // Repositories
        services.AddSingleton<IChannelRepository, SupabaseChannelRepository>();
        services.AddSingleton<ICategoryRepository, SupabaseCategoryRepository>();

        // Navigation
        services.AddSingleton<INavigationService, NavigationService>();

        // ViewModels
        services.AddSingleton<MainWindowViewModel>();
        services.AddTransient<MainPageViewModel>();
        services.AddTransient<SettingsViewModel>();

        // Views
        services.AddSingleton<MainWindow>();
        services.AddTransient<MainPage>();
        services.AddTransient<SettingsPage>();

        return services.BuildServiceProvider();
    }

    /// <summary>
    /// Invoked when the application is launched.
    /// </summary>
    /// <param name="args">Details about the launch request and process.</param>
    protected override void OnLaunched(Microsoft.UI.Xaml.LaunchActivatedEventArgs args)
    {
        Console.WriteLine("App.OnLaunched: Start");
        try
        {
            Console.WriteLine("App.OnLaunched: Resolving MainWindow...");
            _window = Services.GetRequiredService<MainWindow>();
            Console.WriteLine("App.OnLaunched: MainWindow resolved successfully.");
            
            Console.WriteLine("App.OnLaunched: Activating MainWindow...");
            _window.Activate();
            Console.WriteLine("App.OnLaunched: MainWindow Activated successfully.");
        }
        catch (Exception ex)
        {
            Console.WriteLine($"CRITICAL STARTUP ERROR in OnLaunched: {ex}");
            System.Diagnostics.Debug.WriteLine($"CRITICAL STARTUP ERROR: {ex}");
            throw;
        }
    }
}

