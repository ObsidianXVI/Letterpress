part of letterpress.store;

// ============================================================================
//  CONTENT CONFIG
//
//  The single place that decides what the site publishes: which posts and
//  blogules appear, in what order, which are still COMING SOON, which blogules
//  each post is assembled from, and which newsletters ride the carousel.
//
//  What a piece *is* — its components, its copy, its cover and other assets —
//  stays with the piece, in store/modules/ and registered in lp_store.dart.
//  This file only decides what is shown. Publishing something should mean
//  editing this file and nothing else.
// ============================================================================

/// A newsletter masthead. Issues are published under it over time.
class LPNewsletter {
  /// As it appears on the page.
  final String name;

  /// Stable identifier, used for subscription records and issue filenames.
  /// Changing it orphans existing subscriptions, so don't.
  final String slug;

  final String description;

  /// Asset name under `assets/images/newsletters/`, without extension. Null
  /// until real cover artwork exists, in which case the carousel draws a plain
  /// panel in its place.
  final String? coverImgName;

  const LPNewsletter({
    required this.name,
    required this.slug,
    required this.description,
    this.coverImgName,
  });
}

/// A post as published: its own metadata, plus the blogules it is built from.
///
/// Posts have no artifact file of their own — a post *is* a sequence of
/// blogules with a title over it — so its metadata lives here alongside its
/// composition rather than in a file that would contain nothing else.
class LPPostEntry {
  final String title;
  final String description;
  final DateTime publicationDate;
  final DateTime lastUpdate;

  /// Shown on the card instead of a date, and the card refuses to open.
  final bool comingSoon;

  /// In reading order. These are the artifacts from [LPStore].
  final List<LPModule> blogules;

  const LPPostEntry({
    required this.title,
    required this.description,
    required this.publicationDate,
    required this.lastUpdate,
    required this.blogules,
    this.comingSoon = false,
  });

  LPPost build() => LPPost(
        title: title,
        description: description,
        publicationDate: publicationDate,
        lastUpdate: lastUpdate,
        blogules: blogules,
        isPreviewMode: comingSoon,
      );
}

/// A blogule as published: which artifact, and whether it is out yet.
class LPBloguleEntry {
  final LPModule article;
  final bool comingSoon;

  const LPBloguleEntry(this.article, {this.comingSoon = false});
}

class ContentConfig {
  const ContentConfig._();

  // --------------------------------------------------------------------------
  //  POSTS — shown in the Discover carousel, in this order.
  // --------------------------------------------------------------------------
  static final List<LPPostEntry> posts = [
    LPPostEntry(
      title: 'Build-In-Public: Developing a complex BaaS from scratch',
      description:
          'Cortado is a plug-and-play backend-as-a-service to power cloud-based IDEs built in Flutter, by handling file operations, resource provisioning, LSP, extension support, etc.',
      publicationDate: DateTime(2026, 5, 2),
      lastUpdate: DateTime(2026, 5, 2),
      comingSoon: true,
      blogules: [LPStore.cortadoInitialPost],
    ),
    LPPostEntry(
      title: 'Bootstrapping Without Boots or Straps',
      description:
          'Launching Cortado, a SaaS, with zero knowledge, background, network, or finances.',
      publicationDate: DateTime(2025, 3, 19),
      lastUpdate: DateTime(2025, 3, 19),
      comingSoon: true,
      blogules: [
        LPStore.openlyOpenSource,
        LPStore.dnsSslSmtpAndOtherFunAcronyms,
      ],
    ),
  ];

  // --------------------------------------------------------------------------
  //  BLOGULES — shown in the Blogules carousel, in this order.
  // --------------------------------------------------------------------------
  static final List<LPBloguleEntry> blogules = [
    LPBloguleEntry(LPStore.lhAFormalIntroToLh),
    LPBloguleEntry(LPStore.enterAutonomicComputing),
    LPBloguleEntry(LPStore.perfekshun),
    LPBloguleEntry(LPStore.homage271123),
    LPBloguleEntry(LPStore.cortadoInitialPost, comingSoon: true),
    LPBloguleEntry(LPStore.openlyOpenSource, comingSoon: true),
    LPBloguleEntry(LPStore.dnsSslSmtpAndOtherFunAcronyms, comingSoon: true),
    LPBloguleEntry(LPStore.creatingABangerLandingPage, comingSoon: true),
    LPBloguleEntry(LPStore.pricingASaasBuiltOnCloudServices, comingSoon: true),
    LPBloguleEntry(LPStore.createArtNotCode),
  ];

  // --------------------------------------------------------------------------
  //  NEWSLETTERS — shown in the rotating carousel, in this order.
  // --------------------------------------------------------------------------
  static const List<LPNewsletter> newsletters = [
    LPNewsletter(
      name: 'preprint',
      slug: 'preprint',
      description:
          'Research worth reading, condensed — with the arguments left intact.',
    ),
    LPNewsletter(
      name: 'The Indie Bagel',
      slug: 'the-indie-bagel',
      description: 'The best thing since sliced bread, for indie builders.',
    ),
    LPNewsletter(
      name: 'Bleeding Edge',
      slug: 'bleeding-edge',
      description: 'What is being built at the front, and what it costs.',
    ),
    LPNewsletter(
      name: 'Undercurrents',
      slug: 'undercurrents',
      description: 'The slower shifts underneath the news cycle.',
    ),
    LPNewsletter(
      name: 'Eventide',
      slug: 'eventide',
      description: 'Special editions, when the occasion calls for one.',
    ),
  ];

  /// The posts, built into renderable articles. Built once: [LPPost] assembles
  /// its components from its blogules, which is not free.
  static final List<LPPost> builtPosts =
      posts.map((LPPostEntry entry) => entry.build()).toList();

  /// Blogule artifacts in published order, for routing and rendering.
  static final List<LPModule> publishedBlogules =
      blogules.map((LPBloguleEntry entry) => entry.article).toList();

  /// Whether [article] is still marked COMING SOON, by config rather than by
  /// anything baked into the artifact.
  static bool isComingSoon(LPArticle article) {
    for (final LPBloguleEntry entry in blogules) {
      if (identical(entry.article, article)) return entry.comingSoon;
    }
    for (int i = 0; i < posts.length; i++) {
      if (identical(builtPosts[i], article)) return posts[i].comingSoon;
    }
    return false;
  }
}
