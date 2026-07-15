using Microsoft.UI.Xaml.Controls;
using GoPlay_IPTV_App.ViewModels;
using Microsoft.Extensions.DependencyInjection;

namespace GoPlay_IPTV_App;

/// <summary>
/// An empty page that can be used on its own or navigated to within a Frame.
/// </summary>
public sealed partial class SettingsPage : Page
{
    public SettingsViewModel ViewModel { get; }

    public SettingsPage()
    {
        InitializeComponent();
        ViewModel = App.CurrentApp.Services.GetRequiredService<SettingsViewModel>();
        DataContext = ViewModel;
    }
}
