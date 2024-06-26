library letterpress.store;

import 'package:letterpress/design_system/design_system.dart';
import 'package:letterpress/utils/utils.dart';
import 'package:letterpress/main.dart';

part './modules/turbocal_mod_a.dart';
part './modules/generic/homage_27_11_23.dart';
part './modules/lighthouse/a_formal_intro_to_lh.dart';
part './modules/hyperion/enter_autonomic_computing.dart';
part './modules/octane/perfekshun.dart';

class LPStore {
  static final List<LPPost> posts = [];
  static final List<LPModule> blogules = [
    // turbocalModuleA,
    lh_a_formal_intro_to_lh,
    enter_autonomic_computing,
    perfekshun,
    homage_27_11_23,
  ];
}

final LPPost turbocal_post = LPPost(
  postConfigs: LPPostConfigs(
      title: 'Complex Calendar Widget in Flutter (Turbocal)',
      description:
          'Designing a Google Calendar-like widget from scratch in Flutter.',
      publicationDate: DateTime(2023, 3, 10),
      lastUpdate: DateTime(2023, 6, 2),
      includeTableOfContents: true,
      modules: [
        TurbocalModuleA(renderWithPost: true),
      ]),
);

final LPModule turbocalModuleA = TurbocalModuleA(renderWithPost: false);
final LPModule lh_a_formal_intro_to_lh =
    A_Formal_Intro_To_Lh(renderWithPost: false);
final LPModule enter_autonomic_computing =
    Enter_Autonomic_Computing(renderWithPost: false);
final LPModule perfekshun = Perfekshun(renderWithPost: false);
final LPModule homage_27_11_23 = Homage_27_11_23(renderWithPost: false);
