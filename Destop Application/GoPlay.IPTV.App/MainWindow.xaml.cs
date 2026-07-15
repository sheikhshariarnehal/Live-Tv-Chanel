using Microsoft.UI.Xaml;
using GoPlay_IPTV_App.Services;
using GoPlay_IPTV_App.ViewModels;
using Microsoft.Extensions.DependencyInjection;

// To learn more about WinUI, the WinUI project structure,
// and more about our project templates, see: http://aka.ms/winui-project-info.

namespace GoPlay_IPTV_App;

/// <summary>
/// The application window. This hosts a Frame that displays pages.
/// </summary>
public sealed partial class MainWindow : Window
{
    public MainWindowViewModel ViewModel { get; }

    public MainWindow()
    {
        Console.WriteLine("MainWindow.ctor: Start");
        try
        {
            Console.WriteLine("MainWindow.ctor: InitializeComponent");
            InitializeComponent();

            Console.WriteLine("MainWindow.ctor: Setting Custom TitleBar");
            ExtendsContentIntoTitleBar = true;
            SetTitleBar(AppTitleBar);

            Console.WriteLine("MainWindow.ctor: Setting Window Icon");
            try
            {
                AppWindow.SetIcon("Assets/AppIcon.ico");
            }
            catch (System.Exception ex)
            {
                Console.WriteLine($"MainWindow.ctor: SetIcon warning: {ex.Message}");
            }

            Console.WriteLine("MainWindow.ctor: Resolving NavigationService");
            var navService = (NavigationService)App.CurrentApp.Services.GetRequiredService<INavigationService>();
            navService.Initialize(RootFrame);

            Console.WriteLine("MainWindow.ctor: Resolving MainWindowViewModel");
            ViewModel = App.CurrentApp.Services.GetRequiredService<MainWindowViewModel>();

            Console.WriteLine("MainWindow.ctor: Navigating to MainPage");
            RootFrame.Navigate(typeof(MainPage));
        }
        catch (System.Exception ex)
        {
            Console.WriteLine($"CRITICAL ERROR in MainWindow ctor: {ex}");
            throw;
        }
        Console.WriteLine("MainWindow.ctor: End");
    }
}

