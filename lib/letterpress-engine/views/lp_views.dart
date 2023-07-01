library letterpress.views;

import 'package:flutter/material.dart';
import 'package:letterpress/letterpress-engine/components/lp_components.dart';
import 'package:letterpress/letterpress-engine/store/lp_store.dart';
import 'package:letterpress/letterpress-engine/utils/utils.dart';

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
        child: const Center(
          child: SingleChildScrollView(
            child: SelectionArea(
              child: Column(
                children: [],
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
