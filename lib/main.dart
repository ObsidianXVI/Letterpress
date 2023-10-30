import 'package:flutter/material.dart';
import 'package:letterpress/letterpress-engine/components/lp_components.dart';
import 'package:letterpress/letterpress-engine/utils/utils.dart';
import 'package:letterpress/letterpress-engine/views/lp_views.dart';
import 'package:letterpress/letterpress-engine/store/lp_store.dart';
import 'package:octane/octane_ds/octane_ds.dart';

class LPRoutes {
  static const String lp_home = '/';
  static const String lp_gallery = '/gallery';
  static const String lp_blogules = '/blogules';
  static const String lp_timelapse = '/timelapse';
}

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: LPRoutes.lp_home,
      routes: {
        LPRoutes.lp_home: (_) => const LetterpressApp(),
        LPRoutes.lp_timelapse: (_) => const LetterpressTimelapse(),
        LPRoutes.lp_gallery: (_) => const LetterpressGallery(),
        LPRoutes.lp_blogules: (_) => const LetterpressBlogulesView(),
        '/dev': (_) => const DevView(),
      }
        ..addEntries(
          List<MapEntry<String, Widget Function(BuildContext)>>.generate(
            LPStore.posts.length,
            (i) => MapEntry(
              "posts/${LPStore.posts[i].postConfigs.title.urlSafeSlug}",
              (_) => Material(
                child: LetterpressPostView(
                  child: LPStore.posts[i],
                ),
              ),
            ),
          ),
        )
        ..addEntries(
          List<MapEntry<String, Widget Function(BuildContext)>>.generate(
            LPStore.blogules.length,
            (i) => MapEntry(
              "${LPRoutes.lp_blogules}/${LPStore.blogules[i].title.urlSafeSlug}",
              (_) => Material(
                child: LetterpressBloguleView(
                  child: LPStore.blogules[i],
                ),
              ),
            ),
          ),
        ),
    ),
  );
}
