using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Threading.Tasks;
using CommunityToolkit.Mvvm.Input;
using GoPlay.IPTV.Core.Models;
using GoPlay.IPTV.Core.Repositories;
using GoPlay_IPTV_App.Services;

namespace GoPlay_IPTV_App.ViewModels
{
    public class MainPageViewModel : ViewModelBase
    {
        private readonly IChannelRepository _channelRepository;
        private readonly ICategoryRepository _categoryRepository;
        private readonly INavigationService _navigationService;
        private readonly List<Channel> _categoryChannels = new();

        private Category? _selectedCategory;
        private Channel? _selectedChannel;
        private string _searchQuery = string.Empty;
        
        private bool _isPlaying = true;
        private double _volume = 80;
        private bool _isMuted = false;

        public ObservableCollection<Category> Categories { get; } = new();
        public ObservableCollection<Channel> Channels { get; } = new();

        public Category? SelectedCategory
        {
            get => _selectedCategory;
            set
            {
                if (SetProperty(ref _selectedCategory, value))
                {
                    _ = LoadChannelsAsync();
                }
            }
        }

        public Channel? SelectedChannel
        {
            get => _selectedChannel;
            set
            {
                if (SetProperty(ref _selectedChannel, value))
                {
                    // Automatically mark playing when a new channel is selected
                    IsPlaying = value != null;
                }
            }
        }

        public string SearchQuery
        {
            get => _searchQuery;
            set
            {
                if (SetProperty(ref _searchQuery, value))
                {
                    FilterChannels();
                }
            }
        }

        public bool IsPlaying
        {
            get => _isPlaying;
            set
            {
                if (SetProperty(ref _isPlaying, value))
                {
                    OnPropertyChanged(nameof(PlayPauseGlyph));
                }
            }
        }

        public double Volume
        {
            get => _volume;
            set
            {
                if (SetProperty(ref _volume, value))
                {
                    if (value > 0)
                    {
                        IsMuted = false;
                    }
                    OnPropertyChanged(nameof(VolumeGlyph));
                }
            }
        }

        public bool IsMuted
        {
            get => _isMuted;
            set
            {
                if (SetProperty(ref _isMuted, value))
                {
                    OnPropertyChanged(nameof(VolumeGlyph));
                }
            }
        }

        public string PlayPauseGlyph => IsPlaying ? "\uE769" : "\uE768";

        public string VolumeGlyph => IsMuted || Volume == 0 
            ? "\uE74F" 
            : (Volume < 33 ? "\uE992" : (Volume < 66 ? "\uE993" : "\uE994"));

        public IAsyncRelayCommand LoadDataCommand { get; }
        public IAsyncRelayCommand<Channel> SelectChannelCommand { get; }
        
        public IRelayCommand TogglePlayCommand { get; }
        public IRelayCommand ToggleMuteCommand { get; }
        public IRelayCommand PreviousChannelCommand { get; }
        public IRelayCommand NextChannelCommand { get; }
        public IRelayCommand NavigateToSettingsCommand { get; }

        public MainPageViewModel(IChannelRepository channelRepository, ICategoryRepository categoryRepository, INavigationService navigationService)
        {
            _channelRepository = channelRepository;
            _categoryRepository = categoryRepository;
            _navigationService = navigationService;

            LoadDataCommand = new AsyncRelayCommand(LoadDataAsync);
            SelectChannelCommand = new AsyncRelayCommand<Channel>(SelectChannelAsync);
            
            TogglePlayCommand = new RelayCommand(TogglePlay);
            ToggleMuteCommand = new RelayCommand(ToggleMute);
            PreviousChannelCommand = new RelayCommand(NavigatePreviousChannel);
            NextChannelCommand = new RelayCommand(NavigateNextChannel);
            NavigateToSettingsCommand = new RelayCommand(NavigateToSettings);
        }

        private void NavigateToSettings()
        {
            _navigationService.NavigateTo(typeof(SettingsPage));
        }

        private void TogglePlay()
        {
            IsPlaying = !IsPlaying;
        }

        private void ToggleMute()
        {
            IsMuted = !IsMuted;
        }

        private void NavigatePreviousChannel()
        {
            if (SelectedChannel == null || Channels.Count == 0) return;
            int index = Channels.IndexOf(SelectedChannel);
            if (index > 0)
            {
                SelectedChannel = Channels[index - 1];
            }
        }

        private void NavigateNextChannel()
        {
            if (SelectedChannel == null || Channels.Count == 0) return;
            int index = Channels.IndexOf(SelectedChannel);
            if (index < Channels.Count - 1)
            {
                SelectedChannel = Channels[index + 1];
            }
        }

        private async Task LoadDataAsync()
        {
            if (IsBusy) return;
            IsBusy = true;

            try
            {
                Categories.Clear();
                var categoriesList = await _categoryRepository.GetAllCategoriesAsync();
                foreach (var category in categoriesList)
                {
                    Categories.Add(category);
                }

                // Add a virtual "All Channels" category if not empty
                if (Categories.Count > 0)
                {
                    SelectedCategory = Categories[0];
                }
            }
            catch (Exception ex)
            {
                // Handle or log error
                System.Diagnostics.Debug.WriteLine($"Error loading categories: {ex.Message}");
            }
            finally
            {
                IsBusy = false;
            }
        }

        private async Task LoadChannelsAsync()
        {
            if (SelectedCategory == null) return;

            try
            {
                _categoryChannels.Clear();
                var channelsList = await _channelRepository.GetChannelsByCategoryAsync(SelectedCategory.Id);
                foreach (var channel in channelsList)
                {
                    _categoryChannels.Add(channel);
                }
                FilterChannels();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error loading channels: {ex.Message}");
            }
        }

        private void FilterChannels()
        {
            Channels.Clear();
            var filtered = _categoryChannels.AsEnumerable();
            if (!string.IsNullOrWhiteSpace(SearchQuery))
            {
                filtered = filtered.Where(c => c.Name.Contains(SearchQuery, StringComparison.OrdinalIgnoreCase));
            }
            foreach (var channel in filtered)
            {
                Channels.Add(channel);
            }
        }

        private Task SelectChannelAsync(Channel? channel)
        {
            if (channel != null)
            {
                SelectedChannel = channel;
            }
            return Task.CompletedTask;
        }
    }
}


