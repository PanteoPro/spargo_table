import 'package:spargo_table/src/table/web_utils/i_web_utils.dart';
import 'dart:js_interop';
import 'package:web/web.dart' as web;

class WebUtils implements IWebUtils {
  static final listeners = <web.EventListener>[];
  @override
  void preventBrowserDrag() {
    final listener = (web.Event e) {
      e.preventDefault();
      e.stopPropagation();
      return false;
    }.toJS;

    web.document.addEventListener('dragstart', listener);
    web.document.addEventListener('dragover', listener);
    web.document.addEventListener('drop', listener);
    listeners.add(listener);
  }

  @override
  void cleanup() {
    for (final l in listeners) {
      web.document.removeEventListener('dragstart', l);
      web.document.removeEventListener('dragover', l);
      web.document.removeEventListener('drop', l);
    }
    listeners.clear();
  }
}
