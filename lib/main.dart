import 'package:flutter/material.dart';
import 'package:letterpress/letterpress-engine/components/lp_components.dart';
import 'package:letterpress/letterpress-engine/views/lp_views.dart';
import 'package:letterpress/letterpress-engine/store/lp_store.dart';

class LPRoutes {
  static const String tgif_home = '/tgif';
  static const String tgif_turbocal =
      '/tgif/week1-turbocal-complex-calendar-widget-flutter';
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('OBSiDIAN'),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed(LPRoutes.tgif_turbocal);
              },
              child: const Text('Turbocal Post'),
            ),
          ],
        ),
      ),
    );
  }
}
