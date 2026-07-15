using System;
using Microsoft.UI.Xaml.Controls;

namespace GoPlay_IPTV_App.Services
{
    /// <summary>
    /// Implementation of Frame-based navigation service.
    /// </summary>
    public class NavigationService : INavigationService
    {
        private Frame? _frame;

        public void Initialize(Frame frame)
        {
            _frame = frame;
        }

        public bool NavigateTo(Type pageType, object? parameter = null)
        {
            if (_frame == null)
                throw new InvalidOperationException("NavigationService is not initialized with a Frame.");

            return _frame.Navigate(pageType, parameter);
        }

        public bool GoBack()
        {
            if (_frame == null)
                throw new InvalidOperationException("NavigationService is not initialized.");

            if (_frame.CanGoBack)
            {
                _frame.GoBack();
                return true;
            }
            return false;
        }

        public bool CanGoBack => _frame?.CanGoBack ?? false;
    }
}
