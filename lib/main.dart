import 'package:flutter/material.dart';
import 'package:letterpress/letterpress-engine/components/lp_components.dart';
import 'package:letterpress/letterpress-engine/store/modules/turbocal_mod_a.dart';
import 'package:letterpress/letterpress-engine/views/lp_views.dart';
import 'package:letterpress/letterpress-engine/store/lp_store.dart';

class LPRoutes {
  static const String lp_home = '/';
  static const String lp_gallery = '/gallery';
  static const String lp_blogules = '/blogules';

  static final Map<LPPost, String> postUrls = {
    turbocal_post: '/posts/week1-turbocal-complex-calendar-widget-flutter',
  };
  static final Map<LPModule, String> bloguleUrls = {
    turbocalModuleA: '/blogules/turbocalModuleA',
  };
}

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: LPRoutes.lp_home,
      routes: {
        LPRoutes.lp_home: (_) => const LetterpressApp(),
        LPRoutes.lp_gallery: (_) => const LetterpressGallery(),
        LPRoutes.lp_blogules: (_) => const LetterpressBlogulesView(),
      }
        ..addEntries(
          List<MapEntry<String, Widget Function(BuildContext)>>.generate(
            LPRoutes.postUrls.length,
            (i) => MapEntry(
              LPRoutes.postUrls.values.elementAt(i),
              (_) => Material(
                child: LetterpressPostView(
                  child: LPRoutes.postUrls.keys.elementAt(i),
                ),
              ),
            ),
          ),
        )
        ..addEntries(
          List<MapEntry<String, Widget Function(BuildContext)>>.generate(
            LPRoutes.bloguleUrls.length,
            (i) => MapEntry(
              LPRoutes.bloguleUrls.values.elementAt(i),
              (_) => Material(
                child: LetterpressBloguleView(
                  child: LPRoutes.bloguleUrls.keys.elementAt(i),
                ),
              ),
            ),
          ),
        ),
    ),
  );
}
