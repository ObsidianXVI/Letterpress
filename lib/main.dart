import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:letterpress/design_system/design_system.dart';
import 'package:letterpress/utils/utils.dart';
import 'package:letterpress/views/lp_views.dart';
import 'package:letterpress/letterpress-engine/store/lp_store.dart';
import 'package:project_redline/dimensions/dimensions.dart';
import 'package:project_redline/multi_platform/multi_platform.dart';

class LPRoutes {
  static const String lp_home = '/';
  static const String lp_gallery = '/gallery';
  static const String lp_blogules = '/blogules';
  static const String lp_timelapse = '/timelapse';
  static const String lp_posts = '/posts';
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Multiplatform.init(
    platformSelector: LPBreakpoints.select,
    baseStyle: const TextStyle(fontFamily: 'Fraunces_Standard'),
  );
  runApp(const LetterpressRoot());
}

/// Builds the route table from the store.
///
/// Kept separate from [LetterpressRoot.build] so the map is constructed once
/// rather than on every viewport change.
Map<String, WidgetBuilder> _buildRoutes() {
  return <String, WidgetBuilder>{
    LPRoutes.lp_home: (_) => const LetterpressApp(),
    if (kDebugMode) LPRoutes.lp_timelapse: (_) => const LetterpressTimelapse(),
    if (kDebugMode) LPRoutes.lp_blogules: (_) => const LetterpressBlogulesView(),
    if (kDebugMode) '/dev': (_) => const DevView(),
  }
    ..addEntries(
      LPStore.posts.map(
        (post) => MapEntry(
          "${LPRoutes.lp_posts}/${post.title.urlSafeSlug}",
          (_) => Material(child: LetterpressRenderView(child: post)),
        ),
      ),
    )
    ..addEntries(
      LPStore.blogules.map(
        (blogule) => MapEntry(
          "${LPRoutes.lp_blogules}/${blogule.title.urlSafeSlug}",
          (_) => Material(child: LetterpressRenderView(child: blogule)),
        ),
      ),
    );
}

class LetterpressRoot extends StatefulWidget {
  const LetterpressRoot({super.key});

  @override
  State<LetterpressRoot> createState() => LetterpressRootState();
}

class LetterpressRootState extends State<LetterpressRoot>
    with WidgetsBindingObserver {
  late final Map<String, WidgetBuilder> routes = _buildRoutes();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Flutter's own selection toolbar is suppressed on web whenever the
    // browser's context menu is enabled, which it is by default. Leaving it
    // enabled is what gives readers the native right-click menu — with the
    // browser's own Copy, Search and translate entries — over article text.
    assert(BrowserContextMenu.enabled);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// The viewport changes size constantly on the web: window resizes, device
  /// rotation, browser chrome sliding in and out. Recomputing the platform here
  /// keeps [Multiplatform.currentPlatform] honest; [LPViewport] is what
  /// actually propagates the change down past the navigator.
  @override
  void didChangeMetrics() {
    final DetectedPlatform next =
        Multiplatform.platformSelector(Dimensions.width(), Dimensions.height());
    setState(() => Multiplatform.currentPlatform = next);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Letterpress',
      initialRoute: LPRoutes.lp_home,
      builder: (context, child) => LPViewport(child: child!),
      routes: routes,
    );
  }
}
