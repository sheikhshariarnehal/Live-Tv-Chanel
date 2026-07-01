import 'dart:js_interop' as js;

@js.JS('eval')
external void _jsEval(js.JSString script);

void triggerRemoveLoadingSplash() {
  try {
    _jsEval('''
      var splash = document.getElementById("loading-splash");
      if (splash) {
        splash.classList.add("fade-out");
        setTimeout(function() {
          splash.remove();
        }, 400);
      }
    '''.toJS);
  } catch (e) {
    // Ignore errors
  }
}
