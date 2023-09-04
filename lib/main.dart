import 'package:flutter/material.dart';
import 'package:letterpress/letterpress-engine/components/lp_components.dart';
import 'package:letterpress/letterpress-engine/views/lp_views.dart';
import 'package:letterpress/letterpress-engine/store/lp_store.dart';
import 'package:octane/octane_ds/octane_ds.dart';

class LPRoutes {
  static const String lp_home = '/';
  static const String lp_gallery = '/gallery';
  static const String lp_blogules = '/blogules';
  static const String lp_timelapse = '/timelapse';

  static final Map<LPPost, String> postUrls = {
    turbocal_post: '/posts/week1-turbocal-complex-calendar-widget-flutter',
  };
  static final Map<LPModule, String> bloguleUrls = {
    turbocalModuleA: '/blogules/turbocalModuleA',
    lh_a_formal_intro_to_lh: '/blogules/a_formal_intro_to_lighthouse',
  };
}

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/dev', // LPRoutes.lp_home,
      routes: {
        LPRoutes.lp_home: (_) => const LetterpressApp(),
        LPRoutes.lp_timelapse: (_) => const LetterpressTimelapse(),
        LPRoutes.lp_gallery: (_) => const LetterpressGallery(),
        LPRoutes.lp_blogules: (_) => const LetterpressBlogulesView(),
        '/dev': (_) => const DevView(),
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

class DevView extends StatelessWidget {
  const DevView({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Container(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Main Title',
                    style: LPFont.mainTitle(textColor: OctaneTheme.obsidian800)
                        .textStyle,
                  ),
                  Text(
                    'Sub Title',
                    style: LPFont.subTitle(textColor: OctaneTheme.obsidian800)
                        .textStyle,
                  ),
                  Text(
                    'Header 1',
                    style: LPFont.header1(textColor: OctaneTheme.obsidian800)
                        .textStyle,
                  ),
                  Text(
                    'Header 2',
                    style: LPFont.header2(textColor: OctaneTheme.obsidian800)
                        .textStyle,
                  ),
                  Text(
                    'Header 3',
                    style: LPFont.header3(textColor: OctaneTheme.obsidian800)
                        .textStyle,
                  ),
                  Text(
                    'Header 4',
                    style: LPFont.header4(textColor: OctaneTheme.obsidian800)
                        .textStyle,
                  ),
                  Text(
                    'Body',
                    style: LPFont.body(textColor: OctaneTheme.obsidian800)
                        .textStyle,
                  ),
                  Text(
                    'Button',
                    style: LPFont.body(textColor: OctaneTheme.obsidian800)
                        .textStyle,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
