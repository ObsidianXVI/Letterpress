import 'package:flutter/material.dart';
import 'package:letterpress/letterpress-engine/components/lp_components.dart';
import 'package:letterpress/letterpress-engine/utils/utils.dart';
import 'package:letterpress/letterpress-engine/views/lp_views.dart';
import 'package:letterpress/letterpress-engine/store/lp_store.dart';

class LPRoutes {
  static const String tgif_home = '/tgif';
  static const String tgif_turbocal =
      '/tgif/week1-turbocal-complex-calendar-widget-flutter';
  static final Map<LPPost, String> map = {
    turbocal_post: tgif_turbocal,
  };
}

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LetterpressApp(),
      routes: {
        LPRoutes.tgif_home: (context) => const Material(
              child: TGIFHomeView(),
            ),
        LPRoutes.tgif_turbocal: (context) =>
            Material(child: LetterpressPostView(child: turbocal_post)),
      },
    ),
  );
}

class LetterpressApp extends StatelessWidget {
  const LetterpressApp({super.key});
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Container(
          width: DimensionTools.getWidth(context),
          height: DimensionTools.getHeight(context),
          color: LPTheme.grey800,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                LPText.header1(
                  content: 'Letterpress',
                  alignment: Alignment.center,
                ),
                const SizedBox(height: 120),
                LPTextSpan(
                  lpTextComponents: [
                    LPText.plainBody(content: 'A blogging site by '),
                    LPText.hyperlink(
                      content: 'OBSiDIAN',
                      url: 'https://github.com/ObsidianXVI',
                    ),
                    LPText.plainBody(
                      content: ' about coding, design, and the likes.',
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: 300,
                  height: 100,
                  child: ListView(
                    children: List<Widget>.generate(LPRoutes.map.keys.length,
                        (int i) {
                      return Center(
                        child: LPText.hyperlink(
                          content:
                              LPRoutes.map.keys.elementAt(i).postConfigs.title,
                          url: null,
                          action: () {
                            Navigator.of(context)
                                .pushNamed(LPRoutes.map.values.elementAt(i));
                          },
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
