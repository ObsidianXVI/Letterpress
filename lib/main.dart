import 'package:flutter/material.dart';
import 'package:letterpress/letterpress-engine/components/lp_components.dart';
import 'package:letterpress/letterpress-engine/views/lp_views.dart';
import 'package:letterpress/letterpress-engine/store/lp_store.dart';

class LPRoutes {
  static const String lp_home = '/';
  static const String lp_gallery = '/gallery';
  static const String tgif_home = '/tgif';
  static const String tgif_turbocal =
      '/tgif/week1-turbocal-complex-calendar-widget-flutter';
  static final Map<LPPost, String> postUrls = {
    turbocal_post: tgif_turbocal,
  };
}

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: LPRoutes.lp_home,
      routes: {
        LPRoutes.lp_home: (context) => const LetterpressApp(),
        LPRoutes.lp_gallery: (context) => const LetterpressGallery(),
        LPRoutes.tgif_turbocal: (context) =>
            Material(child: LetterpressPostView(child: turbocal_post)),
      },
    ),
  );
}
