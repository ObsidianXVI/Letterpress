part of letterpress.views;

class LetterpressApp extends StatefulWidget {
  const LetterpressApp({super.key});

  @override
  State<StatefulWidget> createState() => LetterpressAppState();
}

class LetterpressAppState extends State<LetterpressApp> {
  final ScrollController postCarouselController = ScrollController();
  final ScrollController bloguleCarouselController = ScrollController();
  final ScrollController newsletterCarouselController = ScrollController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animateCarousel(postCarouselController);
      _animateCarousel(bloguleCarouselController);
      _animateCarousel(newsletterCarouselController);
    });
    super.initState();
  }

  @override
  void dispose() {
    postCarouselController.dispose();
    bloguleCarouselController.dispose();
    newsletterCarouselController.dispose();
    super.dispose();
  }

  void _animateCarousel(ScrollController controller) {
    if (!mounted || !controller.hasClients) {
      return;
    }

    final ScrollPosition position = controller.position;
    if (!position.hasContentDimensions || position.maxScrollExtent <= 0) {
      return;
    }

    controller.animateTo(
      position.maxScrollExtent,
      duration: const Duration(seconds: 15),
      curve: Curves.linear,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: LPColor.platenWhite_500,
      child: Container(
        color: LPColor.platenWhite_500,
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHero(context),
              _buildAboutSection(context),
              _buildDiscoverySection(
                context: context,
                title: 'Discover',
                subtitle: 'An illuminating set of posts, curated by hand.',
                controller: postCarouselController,
                cards: [
                  for (final LPPost post in LPStore.posts)
                    PromoCard(
                      size: SizeVariant.large,
                      article: post,
                      description: post.description,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          "${LPRoutes.lp_posts}/${post.slug}",
                        );
                      },
                    ),
                ],
              ),
              _buildDiscoverySection(
                context: context,
                title: 'Blogules',
                subtitle:
                    'Musings, insights, and personal experiences in byte-sized reads.',
                controller: bloguleCarouselController,
                cards: [
                  for (final LPModule blogule in LPStore.blogules)
                    PromoCard(
                      size: SizeVariant.medium,
                      article: blogule,
                      description: blogule.isPreviewMode
                          ? 'COMING SOON'
                          : blogule.publicationDate.toDateString(),
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          "${LPRoutes.lp_blogules}/${blogule.slug}",
                        );
                      },
                    ),
                ],
              ),
              if (LPStoreRemoteContent.newsletters.isNotEmpty)
                _buildDiscoverySection(
                  context: context,
                  title: 'Newsletters',
                  subtitle:
                      'Longer-form dispatches pulled from public PDF files in the content bucket.',
                  controller: newsletterCarouselController,
                  cards: [
                    for (final LPNewsletter newsletter
                        in LPStoreRemoteContent.newsletters)
                      _buildNewsletterCard(newsletter),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHero(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    final double topPadding = width < 600 ? 16 : 10;
    final double leftPadding = width < 600 ? 16 : 10;

    return Padding(
      padding: EdgeInsets.only(top: topPadding, left: leftPadding),
      child: Text('LET\nTER\nPRESS', style: heroTitle.apply()),
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    final EdgeInsets sectionPadding = _sectionPadding(context);
    final double width = MediaQuery.sizeOf(context).width;
    final double maxCopyWidth = width >= 900 ? width * 0.45 : width;

    return Container(
      color: LPColor.inkBlue_500,
      width: double.infinity,
      padding: sectionPadding,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxCopyWidth.clamp(0.0, 720.0).toDouble(),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About',
              style: SectionTitle().apply(
                const TextStyle(color: LPColor.rollerBlue_500),
              ),
            ),
            SizedBox(height: width >= 900 ? 40 : 24),
            SelectionArea(
              child: LPTextSpan(
                lpTextComponents: [
                  LPText.plainBody(
                    content:
                        """Letterpress is a blog about coding, design, SWE, and all that good stuff. I started this initially to document my reflections and knowledge as I worked on various projects.

It includes short-form Blogules, in-depth Posts, and even newsletters. I do not claim to be a professional coder or prolific writer, and there are many blogs out there like this one, but this is mine. In a sea full of vessels out on different voyages, this is the logbook of a particular one.""",
                    color: LPColor.gripperBlue_500,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiscoverySection({
    required BuildContext context,
    required String title,
    required String subtitle,
    required ScrollController controller,
    required List<Widget> cards,
  }) {
    final EdgeInsets sectionPadding = _sectionPadding(context);
    final double width = MediaQuery.sizeOf(context).width;

    return Container(
      color: LPColor.inkBlue_500,
      width: double.infinity,
      padding: sectionPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: SectionTitle().apply(
              const TextStyle(color: LPColor.rollerBlue_500),
            ),
          ),
          const SizedBox(height: 20),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 620),
            child: Text(
              subtitle,
              style: BodyB1().apply(
                const TextStyle(color: LPColor.gripperBlue_500),
              ),
            ),
          ),
          SizedBox(height: width >= 900 ? 56 : 36),
          SelectionContainer.disabled(
            child: SingleChildScrollView(
              controller: controller,
              clipBehavior: Clip.none,
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (int i = 0; i < cards.length; i++) ...[
                    cards[i],
                    if (i != cards.length - 1)
                      SizedBox(width: width >= 900 ? 36 : 20),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  EdgeInsets _sectionPadding(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    final double horizontal = width >= 1200
        ? 60
        : width >= 900
            ? 40
            : 20;
    final double top = width >= 900 ? 60 : 28;
    final double bottom = width >= 900 ? 28 : 20;

    return EdgeInsets.fromLTRB(horizontal, top, horizontal, bottom);
  }

  Widget _buildNewsletterCard(LPNewsletter newsletter) {
    final String? pdfUrl = newsletter.pdfUrl;

    return SelectionContainer.disabled(
      child: GestureDetector(
        onTap: () {
          if (newsletter.isPreviewMode || pdfUrl == null) {
            return;
          }
          openExternalUrl(pdfUrl);
        },
        child: Container(
          width: 280,
          height: 396,
          decoration: BoxDecoration(
            color: LPColor.inkBlue_500,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: LPColor.rollerBlue_500.withOpacity(0.55),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 170,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: LPColor.rollerBlue_500.withOpacity(0.4),
                    ),
                    gradient: LinearGradient(
                      colors: [
                        LPColor.inkBlue_700,
                        LPColor.inkBlue_500.withOpacity(0.7),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'PDF',
                      style: code.apply(
                        const TextStyle(color: LPColor.gripperBlue_500),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  newsletter.title,
                  style: mediumFunky.apply(
                    const TextStyle(color: LPColor.gripperBlue_500),
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const Spacer(),
                Text(
                  newsletter.description,
                  style: body2.apply(
                    const TextStyle(color: LPColor.rollerBlue_500),
                  ),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 16),
                Text(
                  newsletter.isPreviewMode || pdfUrl == null
                      ? 'COMING SOON'
                      : newsletter.publicationDate.toDateString(),
                  style: body2.apply(
                    const TextStyle(
                      color: LPColor.gripperBlue_400,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
