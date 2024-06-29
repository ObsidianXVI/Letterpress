import 'dart:html';

import 'package:flutter/material.dart';
import 'package:letterpress/utils/utils.dart';
import 'package:letterpress/views/lp_views.dart';
import 'package:letterpress/letterpress-engine/store/lp_store.dart';
import 'package:octane/octane_ds/octane_ds.dart';
import 'package:project_redline/multi_platform/multi_platform.dart';

class LPRoutes {
  static const String lp_home = '/';
  static const String lp_gallery = '/gallery';
  static const String lp_blogules = '/blogules';
  static const String lp_timelapse = '/timelapse';
  static const String unknownPlatform = '/unknown';
}

void main() {
  Multiplatform.init(
    platformSelector: (width, height) {
      if (1200 <= width && width <= 1600) {
        if (750 <= height && height <= 1000) {
          return const DesktopPlatform();
        }
      } else if (400 <= width && width <= 590) {
        if (600 <= height && height <= 1000) {
          return const MobilePlatform();
        }
      }
      return const UnknownPlatform();
    },
    baseStyle: const TextStyle(fontFamily: 'Fraunces_Standard'),
  );
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: LPRoutes.lp_home,
      routes: {
        LPRoutes.lp_home: (_) => const LetterpressApp(),
        LPRoutes.lp_timelapse: (_) => const LetterpressTimelapse(),
        LPRoutes.lp_gallery: (_) => const LetterpressGallery(),
        LPRoutes.lp_blogules: (_) => const LetterpressBlogulesView(),
        LPRoutes.unknownPlatform: (_) => Material(
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Center(
                  child: Text(
                    "Sorry, but this website only supports mobile and desktop viewports. Your viewport (${document.body?.clientWidth}x${document.body?.clientHeight}) does not fall into these two categories. To avoid embarassingly hideous layouts and scaling, I would rather show this pathetic error message than the actual site itself. Try viewing the website on a mobile or desktop device, and refresh the browser window.",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
        //'/dev': (_) => const DevView(),
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
