using System.Collections.Generic;
using CommunityToolkit.Mvvm.Input;
using GoPlay_IPTV_App.Services;

namespace GoPlay_IPTV_App.ViewModels
{
    public class SettingsViewModel : ViewModelBase
    {
        private readonly INavigationService _navigationService;

        private string _selectedQuality = "FHD";
        private bool _enableCaching = true;
        private string _selectedTheme = "System";

        public List<string> Qualities { get; } = new() { "FHD (1080p)", "HD (720p)", "SD (480p)" };
        public List<string> Themes { get; } = new() { "System", "Dark", "Light" };

        public string SelectedQuality
        {
            get => _selectedQuality;
            set => SetProperty(ref _selectedQuality, value);
        }

        public bool EnableCaching
        {
            get => _enableCaching;
            set => SetProperty(ref _enableCaching, value);
        }

        public string SelectedTheme
        {
            get => _selectedTheme;
            set => SetProperty(ref _selectedTheme, value);
        }

        public IRelayCommand GoBackCommand { get; }

        public SettingsViewModel(INavigationService navigationService)
        {
            _navigationService = navigationService;
            GoBackCommand = new RelayCommand(GoBack);
        }

        private void GoBack()
        {
            if (_navigationService.CanGoBack)
            {
                _navigationService.GoBack();
            }
        }
    }
}
