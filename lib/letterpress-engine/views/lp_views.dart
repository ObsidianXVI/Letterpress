library letterpress.views;

import 'package:flutter/material.dart';
import 'package:letterpress/letterpress-engine/components/lp_components.dart';
import 'package:letterpress/letterpress-engine/store/lp_store.dart';
import 'package:letterpress/letterpress-engine/utils/utils.dart';
import 'package:letterpress/main.dart';

abstract class Routable {
  final String base;
  final String route;
  final Widget Function(BuildContext) buildFn;

  const Routable({
    required this.base,
    required this.route,
    required this.buildFn,
  });

  String toSlug() => base + route;
}

class TGIFHomeView extends StatelessWidget {
  const TGIFHomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: DimensionTools.getWidth(context),
        height: DimensionTools.getHeight(context),
        color: LPTheme.grey800,
        child: SelectionArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(50),
              child: Column(
                children: [
                  LPText.header1(content: 'TGIF Challenge'),
                  const SizedBox(height: 100),
                  SingleChildScrollView(
                    child: SelectionArea(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List<Widget>.generate(
                          LPStore.tgif_posts.length,
                          (i) {
                            return Align(
                              alignment: Alignment.topLeft,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                      LPRoutes.map[LPStore.tgif_posts[i]]!);
                                },
                                child: SelectionContainer.disabled(
                                  child: Container(
                                    width: 800,
                                    height: 200,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: LPTheme.grey600,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          LPStore
                                              .tgif_posts[i].postConfigs.title,
                                          style: TextStyle(
                                            color: LPTheme.grey800,
                                            fontSize: 30,
                                            fontFamily:
                                                LPFontFamily.headers.name,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
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

class LetterpressPostView extends StatelessWidget {
  final LPPost child;
  const LetterpressPostView({
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: LPTheme.grey800,
        child: child,
      ),
    );
  }
}
