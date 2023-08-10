library letterpress.store;

import 'package:letterpress/letterpress-engine/store/modules/turbocal_mod_a.dart';

import '../components/lp_components.dart';
part './tgif-week1_turbocal_complex_calendar_widget_flutter.dart';

class LPStore {
  static final List<LPPost> posts = [turbocal_post];
  static final List<LPModule> modules = [
    TurbocalModuleA(renderWithPost: false),
  ];
}
