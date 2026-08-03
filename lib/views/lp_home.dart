part of letterpress.views;

class LetterpressApp extends StatefulWidget {
  const LetterpressApp({super.key});

  @override
  State<StatefulWidget> createState() => LetterpressAppState();
}

class LetterpressAppState extends State<LetterpressApp> {
  final ScrollController postCarouselController = ScrollController();
  final ScrollController bloguleCarouselController = ScrollController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // A slow drift across the carousel on arrival, hinting that there is more
      // to the side. Guarded because a short list may not overflow at all, in
      // which case there is nothing to scroll and no client attached.
      for (final ScrollController controller in [
        postCarouselController,
        bloguleCarouselController,
      ]) {
        if (!controller.hasClients) continue;
        if (controller.position.maxScrollExtent <= 0) continue;
        controller.animateTo(
          controller.position.maxScrollExtent,
          duration: const Duration(seconds: 15),
          curve: Curves.linear,
        );
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    postCarouselController.dispose();
    bloguleCarouselController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final LPViewportData vp = LPViewport.of(context);

    return Material(
      color: LPColor.platenWhite_500,
      child: LPSelectionArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // The masthead is the one section that genuinely wants the whole
              // viewport — it is a full-bleed title and nothing else.
              SizedBox(
                width: vp.size.width,
                height: vp.size.height,
                child: Padding(
                  padding: EdgeInsets.only(
                    top: vp.pick(mobile: 0, desktop: 10),
                    left: vp.pick(mobile: 0, desktop: 10),
                  ),
                  child: Text(
                    'LET\nTER\nPRESS',
                    style: heroTitle.apply(),
                  ),
                ),
              ),
              _HomeSection(
                title: 'About',
                child: SizedBox(
                  width: vp.pick(
                    mobile: vp.size.width * 0.89,
                    desktop: vp.size.width * 0.45,
                  ),
                  child: LPTextSpan(lpTextComponents: [
                    LPText.plainBody(
                      content:
                          """Letterpress is a blog about coding, design, SWE, and all that good stuff. I started this initially to document my reflections and knowledge as I worked on various projects.

It includes short-form Blogules, in-depth Posts, and even newsletters. I do not claim to be a professional coder or prolific writer, but in a sea full of vessels out on different voyages, this is the logbook of a particular one.""",
                      color: LPColor.gripperBlue_400,
                    ),
                  ]),
                ),
              ),
              _HomeSection(
                title: 'Newsletters',
                child: _SectionBlurb(
                  text:
                      "We are a society strangling in unnecessary words, circular constructions, pompous frills and meaningless jargon. — William Zinsser",
                ),
              ),
              // Discover used to share a section with Newsletters, which meant a
              // heading, two long quotes and a 520px-tall carousel all competing
              // for one viewport's height — the carousel simply fell off the
              // bottom. Each of these is now its own section, sized by content.
              _HomeSection(
                title: 'Discover',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionBlurb(
                      text:
                          "They are driven by a compulsion to put some part of themselves on paper, and yet they don't just write what comes naturally. They sit down to commit an act of literature, and the self who emerges on paper is far stiffer than the person who sat down to write. The problem is to find the real man or woman behind the tension. — William Zinsser",
                      maxWidth: 900,
                    ),
                    SizedBox(height: vp.pick(mobile: 32, desktop: 60)),
                    _Carousel(
                      controller: postCarouselController,
                      children: [
                        for (final post in LPStore.posts)
                          PromoCard(
                            size: SizeVariant.large,
                            article: post,
                            description: post.description,
                            onTap: () => Navigator.pushNamed(
                              context,
                              "${LPRoutes.lp_posts}/${post.title.urlSafeSlug}",
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              _HomeSection(
                title: 'Blogules',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionBlurb(
                      text:
                          "Musings, insights, and personal experiences in byte-sized reads.",
                    ),
                    SizedBox(height: vp.pick(mobile: 32, desktop: 60)),
                    _Carousel(
                      controller: bloguleCarouselController,
                      children: [
                        for (final blogule in LPStore.blogules)
                          PromoCard(
                            size: SizeVariant.medium,
                            article: blogule,
                            description: blogule.isPreviewMode
                                ? "COMING SOON"
                                : blogule.publicationDate.toDateString(),
                            onTap: () => Navigator.of(context).pushNamed(
                              "${LPRoutes.lp_blogules}/${blogule.title.urlSafeSlug}",
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: vp.pick(mobile: 60, desktop: 100)),
            ],
          ),
        ),
      ),
    );
  }
}

/// A titled band on the home page.
///
/// Height comes from the content rather than the viewport. Section titles are
/// set in very large display type, so pinning a section to the viewport height
/// leaves almost nothing for the content beneath it on shorter windows.
class _HomeSection extends StatelessWidget {
  final String title;
  final Widget child;

  const _HomeSection({
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final LPViewportData vp = LPViewport.of(context);

    return Container(
      width: double.infinity,
      color: LPColor.inkBlue_500,
      padding: EdgeInsets.only(
        left: vp.pick(mobile: scaled(20, 16), desktop: scaled(60, 30)),
        right: vp.pick(mobile: scaled(24, 24), desktop: scaled(60, 30)),
        top: vp.pick(mobile: scaled(30, 24), desktop: scaled(60, 30)),
        bottom: vp.pick(mobile: scaled(40, 32), desktop: scaled(80, 40)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: sectionTitle.apply(
              const TextStyle(color: LPColor.rollerBlue_500),
            ),
          ),
          SizedBox(height: vp.pick(mobile: 24, desktop: 40)),
          child,
        ],
      ),
    );
  }
}

/// Standing text under a section title.
class _SectionBlurb extends StatelessWidget {
  final String text;
  final double maxWidth;

  const _SectionBlurb({
    required this.text,
    this.maxWidth = 600,
  });

  @override
  Widget build(BuildContext context) {
    final LPViewportData vp = LPViewport.of(context);

    return SizedBox(
      // Fixed widths were overflowing narrow viewports; the intended measure is
      // a maximum, not a fixed size.
      width: math.min(maxWidth, vp.size.width * vp.pick(mobile: 0.89, desktop: 0.8)),
      child: Text(
        text,
        style: body.apply(const TextStyle(color: LPColor.gripperBlue_400)),
      ),
    );
  }
}

/// Horizontally scrolling row of promo cards.
class _Carousel extends StatelessWidget {
  final ScrollController controller;
  final List<Widget> children;

  const _Carousel({
    required this.controller,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final LPViewportData vp = LPViewport.of(context);
    final double gap = vp.pick(mobile: 20, desktop: 40);

    return SingleChildScrollView(
      controller: controller,
      clipBehavior: Clip.none,
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int i = 0; i < children.length; i++) ...[
            children[i],
            if (i != children.length - 1) SizedBox(width: gap),
          ],
        ],
      ),
    );
  }
}
