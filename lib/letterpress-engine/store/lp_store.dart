library letterpress.store;

import '../components/lp_components.dart';

part './modules/turbocal_mod_a.dart';
part './modules/lighthouse/a_formal_intro_to_lh.dart';

class LPStore {
  static final List<LPPost> posts = [turbocal_post];
  static final List<LPModule> modules = [
    turbocalModuleA,
    lh_a_formal_intro_to_lh,
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
