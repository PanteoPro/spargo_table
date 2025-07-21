abstract interface class IWebUtils {
  void preventBrowserDrag();
  void cleanup();
}

class WebUtils implements IWebUtils {
  @override
  void cleanup() {}

  @override
  void preventBrowserDrag() {}
}
