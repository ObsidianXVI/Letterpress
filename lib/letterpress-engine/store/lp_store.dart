library letterpress.store;

import 'package:letterpress/letterpress-engine/store/modules/turbocal_mod_a.dart';

import '../components/lp_components.dart';

class LPStore {
  static final List<LPPost> posts = [turbocal_post];
  static final List<LPModule> modules = [
    turbocalModuleA,
    turbocalModuleA,
    turbocalModuleA,
    turbocalModuleA,
    turbocalModuleA
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
