library letterpress.store;

import 'package:letterpress/design_system/design_system.dart';
import 'package:letterpress/utils/utils.dart';
import 'package:letterpress/main.dart';

part './modules/turbocal_mod_a.dart';
part './modules/generic/homage_27_11_23.dart';
part './modules/lighthouse/a_formal_intro_to_lh.dart';
part './modules/hyperion/enter_autonomic_computing.dart';
part './modules/octane/perfekshun.dart';
part './modules/turbocal/skeletons_gold_chests_and_other_swashbuckling_treasures.dart';
part './modules/turbocal/dead_men_tell_no_tales.dart';
part './modules/hyperion/create_art_not_code.dart';
part './modules/affogato/openly_open_source.dart';
part './modules/affogato/dns_ssl_smtp_and_other_fun_acronyms.dart';
part './modules/affogato/creating_a_banger_landing_page.dart';
part './modules/cortado/pricing_a_saas_built_on_cloud_services.dart';
part './modules/cortado/cortado_initial_post.dart';

class LPStore {
  static final List<LPPost> posts = [
    // assorted_reflections_from_hyperion,
    // challenging_puzzles_involved_in_writing_an_IDE_from_scratch,
    // on_the_intricacies_of_managing_an_open_source_project,
    cortado_build_in_public,
    bootstrapping_without_boots_or_straps,
  ];
  static final List<LPModule> blogules = [
    lh_a_formal_intro_to_lh,
    enter_autonomic_computing,
    perfekshun,
    homage_27_11_23,
    cortado_initial_post,
    // skeletons_gold_chests_and_other_swashbuckling_treasures,
    openly_open_source,
    dns_ssl_smtp_and_other_fun_acronyms,
    creating_a_banger_landing_page,
    pricing_a_saas_built_on_cloud_services,
    create_art_not_code,
  ];
}

final LPPost turbocal_post = LPPost(
  title: 'Complex Calendar Widget in Flutter (Turbocal)',
  description:
      'Designing a Google Calendar-like widget from scratch in Flutter.',
  publicationDate: DateTime(2023, 3, 10),
  lastUpdate: DateTime(2023, 6, 2),
  blogules: [
    TurbocalModuleA(renderWithPost: true),
  ],
);

final LPPost assorted_reflections_from_hyperion = LPPost(
  isPreviewMode: true,
  title: 'Assorted Reflections from Hyperion',
  description:
      'Thoughts on the design process, collaborating with A.I., and grappling with the unknown.',
  publicationDate: DateTime(2024, 11, 23),
  lastUpdate: DateTime(2024, 11, 23),
  blogules: [
    create_art_not_code,
    create_art_not_code,
  ],
);

final LPPost challenging_puzzles_involved_in_writing_an_IDE_from_scratch =
    LPPost(
  isPreviewMode: true,
  lastUpdate: DateTime(2025, 3, 17),
  publicationDate: DateTime(2025, 3, 17),
  title: 'Challenging puzzles involved in writing an IDE from scratch',
  description:
      "I discuss a few key architectural and implementation conundrums I encountered while building the Affogato Editor, and how I approached them. A fun read for software engineers.",
  blogules: [
    openly_open_source,
  ],
);

final LPPost on_the_intricacies_of_managing_an_open_source_project = LPPost(
  isPreviewMode: false,
  lastUpdate: DateTime(2025, 3, 17),
  publicationDate: DateTime(2025, 3, 17),
  title: 'On the Intricacies of Managing an Open-Source Project',
  description:
      "I discuss a few key architectural and implementation conundrums I encountered while building the Affogato Editor, and how I approached them. A fun read for software engineers.",
  blogules: [
    openly_open_source,
    dns_ssl_smtp_and_other_fun_acronyms,
  ],
);

final LPPost bootstrapping_without_boots_or_straps = LPPost(
  isPreviewMode: true,
  lastUpdate: DateTime(2025, 3, 19),
  publicationDate: DateTime(2025, 3, 19),
  title: 'Bootstrapping Without Boots or Straps',
  description:
      "Launching Cortado, a SaaS, with zero knowledge, background, network, or finances.",
  blogules: [
    openly_open_source,
    dns_ssl_smtp_and_other_fun_acronyms,
  ],
);

final LPPost cortado_build_in_public = LPPost(
  blogules: [cortado_initial_post],
  lastUpdate: DateTime(2026, 5, 2),
  publicationDate: DateTime(2026, 5, 2),
  title: "Build-In-Public: Developing a complex BaaS from scratch",
  description:
      "Cortado is a plug-and-play backend-as-a-service to power cloud-based IDEs built in Flutter, by handling file operations, resource provisioning, LSP, extension support, etc.",
  isPreviewMode: true,
);

final LPModule create_art_not_code = Create_Art_Not_Code(renderWithPost: false);
final LPModule turbocalModuleA = TurbocalModuleA(renderWithPost: false);
final LPModule lh_a_formal_intro_to_lh =
    A_Formal_Intro_To_Lh(renderWithPost: false);
final LPModule enter_autonomic_computing =
    Enter_Autonomic_Computing(renderWithPost: false);
final LPModule perfekshun = Perfekshun(renderWithPost: false);
final LPModule homage_27_11_23 = Homage_27_11_23(renderWithPost: false);
final LPModule skeletons_gold_chests_and_other_swashbuckling_treasures =
    SkeletonsGoldChestsAndOtherSwashbucklingTreasures(renderWithPost: false);
final LPModule dead_men_tell_no_tales_about_collision_resolution =
    DeadMenTellNoTalesAboutCollisionResolution(renderWithPost: false);
final LPModule openly_open_source = Openly_Open_Source(
  renderWithPost: false,
  isPreviewMode: true,
);

final LPModule dns_ssl_smtp_and_other_fun_acronyms =
    DNS_SSL_SMTP_And_Other_Fun_Acronyms(
  renderWithPost: false,
  isPreviewMode: true,
);

final LPModule pricing_a_saas_built_on_cloud_services =
    Pricing_A_SaaS_Built_On_Cloud_Services(
  isPreviewMode: true,
  renderWithPost: false,
);

final LPModule creating_a_banger_landing_page = Creating_A_Banger_Landing_Page(
  renderWithPost: false,
  isPreviewMode: true,
);

final LPModule cortado_initial_post =
    CortadoInitialPost(isPreviewMode: true, renderWithPost: false);
