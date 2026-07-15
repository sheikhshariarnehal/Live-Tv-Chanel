using System;
using Microsoft.UI.Xaml;
using Microsoft.UI.Xaml.Data;

namespace GoPlay_IPTV_App.Converters
{
    public class NullToVisibilityConverter : IValueConverter
    {
        public bool Inverse { get; set; }

        public object Convert(object value, Type targetType, object parameter, string language)
        {
            bool isNull = value == null;
            bool result = Inverse ? !isNull : isNull;
            return result ? Visibility.Visible : Visibility.Collapsed;
        }

        public object ConvertBack(object value, Type targetType, object parameter, string language)
        {
            throw new NotImplementedException();
        }
    }
}
