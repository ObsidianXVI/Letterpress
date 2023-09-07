library letterpress.views;

import 'package:flutter/material.dart';
import 'package:letterpress/letterpress-engine/components/lp_components.dart';
import 'package:letterpress/letterpress-engine/store/lp_store.dart';
import 'package:letterpress/letterpress-engine/utils/utils.dart';
import 'package:letterpress/design_system/design_system.dart';
import 'package:letterpress/main.dart';
import 'package:octane/octane_ds/octane_ds.dart';

part './lp_home.dart';
part './lp_post_view.dart';
part './lp_gallery.dart';
part 'lp_blogules.dart';
part './lp_blogule_view.dart';
part './lp_timelapse.dart';

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
