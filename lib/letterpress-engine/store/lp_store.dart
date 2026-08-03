library letterpress.store;

import 'package:letterpress/design_system/design_system.dart';
import 'package:letterpress/utils/utils.dart';
import 'package:letterpress/main.dart';

part './content.config.dart';

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

/// Every blogule artifact that exists, whether or not it is published.
///
/// This is a registry, not a publication list. What actually appears on the
/// site — in what order, and what is still COMING SOON — is decided in
/// [ContentConfig]. An artifact can sit here indefinitely without being shown;
/// keeping the two apart is the point.
///
/// `isPreviewMode` is deliberately not set here. Whether a piece is out yet is
/// a publishing decision, so it lives in the config, and the config is what the
/// views consult.
class LPStore {
  const LPStore._();

  static final LPModule turbocalModuleA =
      TurbocalModuleA(renderWithPost: false);
  static final LPModule lhAFormalIntroToLh =
      A_Formal_Intro_To_Lh(renderWithPost: false);
  static final LPModule enterAutonomicComputing =
      Enter_Autonomic_Computing(renderWithPost: false);
  static final LPModule perfekshun = Perfekshun(renderWithPost: false);
  static final LPModule homage271123 = Homage_27_11_23(renderWithPost: false);
  static final LPModule createArtNotCode =
      Create_Art_Not_Code(renderWithPost: false);
  static final LPModule skeletonsGoldChests =
      SkeletonsGoldChestsAndOtherSwashbucklingTreasures(renderWithPost: false);
  static final LPModule deadMenTellNoTales =
      DeadMenTellNoTalesAboutCollisionResolution(renderWithPost: false);

  static final LPModule openlyOpenSource = Openly_Open_Source(
    renderWithPost: false,
    isPreviewMode: false,
  );
  static final LPModule dnsSslSmtpAndOtherFunAcronyms =
      DNS_SSL_SMTP_And_Other_Fun_Acronyms(
    renderWithPost: false,
    isPreviewMode: false,
  );
  static final LPModule pricingASaasBuiltOnCloudServices =
      Pricing_A_SaaS_Built_On_Cloud_Services(
    renderWithPost: false,
    isPreviewMode: false,
  );
  static final LPModule creatingABangerLandingPage =
      Creating_A_Banger_Landing_Page(
    renderWithPost: false,
    isPreviewMode: false,
  );
  static final LPModule cortadoInitialPost = CortadoInitialPost(
    renderWithPost: false,
    isPreviewMode: false,
  );

  /// Published posts, as renderable articles. Sourced from [ContentConfig].
  static List<LPPost> get posts => ContentConfig.builtPosts;

  /// Published blogules, in the order the config lists them.
  static List<LPModule> get blogules => ContentConfig.publishedBlogules;
}
