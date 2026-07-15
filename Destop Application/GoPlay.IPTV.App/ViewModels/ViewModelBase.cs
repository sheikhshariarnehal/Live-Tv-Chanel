using CommunityToolkit.Mvvm.ComponentModel;

namespace GoPlay_IPTV_App.ViewModels
{
    /// <summary>
    /// Base class for all ViewModels in the application.
    /// </summary>
    public abstract class ViewModelBase : ObservableObject
    {
        private bool _isBusy;

        public bool IsBusy
        {
            get => _isBusy;
            set => SetProperty(ref _isBusy, value);
        }
    }
}
