import 'package:web/web.dart' as web;

String currentViewportDescription() {
  final width = web.document.body?.clientWidth;
  final height = web.document.body?.clientHeight;
  return '${width ?? '?'}x${height ?? '?'}';
}

void openExternalUrl(String url) {
  web.window.open(url, '_blank');
}
