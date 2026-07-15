using System;

namespace GoPlay_IPTV_App.Services
{
    /// <summary>
    /// Contract for page navigation service in the application.
    /// </summary>
    public interface INavigationService
    {
        bool NavigateTo(Type pageType, object? parameter = null);
        bool GoBack();
        bool CanGoBack { get; }
    }
}
