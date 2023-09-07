library letterpress.ds;

import 'package:flutter/material.dart';
import 'package:letterpress/letterpress-engine/letterpress_engine.dart';
import 'package:octane/octane_ds/octane_ds.dart';

class LPCardWidget extends StatelessWidget {
  final double width;
  final double height;
  final Widget child;

  const LPCardWidget({
    required this.width,
    required this.height,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: OctaneTheme.obsidianC150,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: OctaneTheme.obsidianC050),
      ),
      child: child,
    );
  }
}
