import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:letterpress/utils/browser_runtime.dart';
import 'package:letterpress/utils/utils.dart';
import 'package:letterpress/views/lp_views.dart';
import 'package:letterpress/letterpress-engine/store/lp_store.dart';

class LPRoutes {
  static const String lp_home = '/';
  static const String lp_gallery = '/gallery';
  static const String lp_blogules = '/blogules';
  static const String lp_posts = '/posts';
  static const String unknownPlatform = '/unknown';
}

void initializeLetterpressPlatforms() {
  Multiplatform.init(
    platformSelector: (width, height) {
      if (width < 320) {
        return const UnknownPlatform();
      }
      if (width < 720) {
        return const MobilePlatform();
      }
      if (width < 1100) {
        return const TabletPlatform();
      }
      if (width >= 1100) {
        return const DesktopPlatform();
      }
      return const UnknownPlatform();
    },
    baseStyle: const TextStyle(fontFamily: 'Fraunces_Standard'),
  );
}

Route<dynamic> generateLetterpressRoute(RouteSettings settings) {
  final String routeName = settings.name ?? LPRoutes.lp_home;
  Widget? page;

  if (routeName == LPRoutes.lp_home) {
    page = const LetterpressApp();
  } else if (routeName == '/dev' && kDebugMode) {
    page = const DevView();
  } else if (routeName == LPRoutes.unknownPlatform) {
    page = const _UnsupportedViewportView();
  }

  if (page == null) {
    final post = LPStore.postForRoute(routeName);
    final blogule = LPStore.bloguleForRoute(routeName);
    final article = post ?? blogule;

    if (article != null) {
      page = Material(child: LetterpressRenderView(child: article));
    }
  }

  page ??= const LetterpressApp();

  return MaterialPageRoute<void>(builder: (_) => page!, settings: settings);
}

class LetterpressRootApp extends StatelessWidget {
  final String initialRoute;

  LetterpressRootApp({this.initialRoute = LPRoutes.lp_home, super.key}) {
    initializeLetterpressPlatforms();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      onGenerateRoute: generateLetterpressRoute,
      onUnknownRoute: generateLetterpressRoute,
    );
  }
}

class _UnsupportedViewportView extends StatelessWidget {
  const _UnsupportedViewportView();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Center(
          child: Text(
            "Sorry, but this website needs a bit more room than your current viewport (${currentViewportDescription()}). Try widening the browser window or switching to a larger device.",
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(LetterpressRootApp());
}
