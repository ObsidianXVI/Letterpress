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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      postCarouselController.animateTo(
          postCarouselController.position.maxScrollExtent,
          duration: const Duration(seconds: 15),
          curve: Curves.linear);
      bloguleCarouselController.animateTo(
          bloguleCarouselController.position.maxScrollExtent,
          duration: const Duration(seconds: 15),
          curve: Curves.linear);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: LPColor.platenWhite_500,
      child: Center(
        child: ViewportSize(
          child: Container(
            color: LPColor.platenWhite_500,
            width: double.infinity,
            height: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ViewportSize(
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: Multiplatform.currentPlatform ==
                                const MobilePlatform()
                            ? 0
                            : 10,
                        left: Multiplatform.currentPlatform ==
                                const MobilePlatform()
                            ? 0
                            : 10,
                      ),
                      child: Text(
                        'LET\nTER\nPRESS',
                        style: heroTitle.apply(),
                      ),
                    ),
                  ),
                  ViewportSize(
                    child: Container(
                      color: LPColor.inkBlue_500,
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: Multiplatform.currentPlatform ==
                                  const DesktopPlatform()
                              ? scaled(60, 30)
                              : scaled(20, 16),
                          top: Multiplatform.currentPlatform ==
                                  const DesktopPlatform()
                              ? scaled(60, 30)
                              : scaled(20, 16),
                          right: Multiplatform.currentPlatform ==
                                  const DesktopPlatform()
                              ? scaled(60, 30)
                              : scaled(24, 24),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'About',
                                  style: SectionTitle().apply(
                                    const TextStyle(
                                        color: LPColor.rollerBlue_500),
                                  ),
                                ),
                                SizedBox(
                                  height: Multiplatform.currentPlatform ==
                                          const DesktopPlatform()
                                      ? scaled(40, 30)
                                      : scaled(30, 20),
                                ),
                                SizedBox(
                                  width: Multiplatform.currentPlatform ==
                                          const DesktopPlatform()
                                      ? 0.25 * Dimensions.width()
                                      : Dimensions.width() * 0.89,
                                  child: Text(
                                    """Letterpress is a blog site by OBSiDIAN about coding and design stuff — but with a twist. More than just a disjoint sequence of short articles on varying subjects, in the Letterpress model, short articles known as Blogules focusing on a particular subject can be published and read individually. However, multiple Blogules can be strung together to create a Post, making for a longer read but providing a broader insight on a specific subject.

I started Letterpress because I wanted to document my thoughts and learning points as I worked on various coding projects. Thus, Blogules tagged with the same project name are also collated into what are known as Journals. Each Journal provides a chronological overview of Blogules belonging to a particular project.""",
                                    style: BodyB1().apply(
                                      const TextStyle(
                                          color: LPColor.gripperBlue_500),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  ViewportSize(
                    child: Container(
                      color: LPColor.inkBlue_500,
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: Multiplatform.currentPlatform ==
                                  const DesktopPlatform()
                              ? scaled(60, 30)
                              : scaled(20, 16),
                          top: Multiplatform.currentPlatform ==
                                  const DesktopPlatform()
                              ? scaled(60, 30)
                              : scaled(20, 16),
                          right: Multiplatform.currentPlatform ==
                                  const DesktopPlatform()
                              ? scaled(60, 30)
                              : scaled(24, 24),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Discover',
                              style: SectionTitle().apply(
                                const TextStyle(color: LPColor.rollerBlue_500),
                              ),
                            ),
                            const SizedBox(height: 40),
                            SizedBox(
                              width: 600,
                              child: Text(
                                "An illuminating set of posts, curated by hand.",
                                style: BodyB1().apply(
                                  const TextStyle(
                                      color: LPColor.gripperBlue_500),
                                ),
                              ),
                            ),
                            const SizedBox(height: 60),
                            SingleChildScrollView(
                              controller: postCarouselController,
                              clipBehavior: Clip.none,
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  PromoCard(
                                      size: SizeVariant.small,
                                      title: 'Some Cool Post',
                                      description:
                                          'Lorem ipsum dolor sit amet consectetur.',
                                      onTap: () {}),
                                  const SizedBox(width: 40),
                                  PromoCard(
                                      size: SizeVariant.small,
                                      title: 'Some Cool Post',
                                      description:
                                          'Lorem ipsum dolor sit amet consectetur.',
                                      onTap: () {}),
                                  const SizedBox(width: 40),
                                  PromoCard(
                                      size: SizeVariant.small,
                                      title: 'Some Cool Post',
                                      description:
                                          'Lorem ipsum dolor sit amet consectetur.',
                                      onTap: () {}),
                                  const SizedBox(width: 40),
                                  PromoCard(
                                      size: SizeVariant.small,
                                      title: 'Some Cool Post',
                                      description:
                                          'Lorem ipsum dolor sit amet consectetur.',
                                      onTap: () {}),
                                  const SizedBox(width: 40),
                                  PromoCard(
                                      size: SizeVariant.small,
                                      title: 'Some Cool Post',
                                      description:
                                          'Lorem ipsum dolor sit amet consectetur.',
                                      onTap: () {}),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  ViewportSize(
                    child: Container(
                      color: LPColor.inkBlue_500,
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: Multiplatform.currentPlatform ==
                                  const DesktopPlatform()
                              ? scaled(60, 30)
                              : scaled(20, 16),
                          top: Multiplatform.currentPlatform ==
                                  const DesktopPlatform()
                              ? scaled(60, 30)
                              : scaled(20, 16),
                          right: Multiplatform.currentPlatform ==
                                  const DesktopPlatform()
                              ? scaled(60, 30)
                              : scaled(24, 24),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Blogules',
                              style: SectionTitle().apply(
                                const TextStyle(color: LPColor.rollerBlue_500),
                              ),
                            ),
                            const SizedBox(height: 40),
                            SizedBox(
                              width: 600,
                              child: Text(
                                "The full repository of blogules available at your fingertips for querying.",
                                style: BodyB1().apply(
                                  const TextStyle(
                                      color: LPColor.gripperBlue_500),
                                ),
                              ),
                            ),
                            const SizedBox(height: 60),
                            SingleChildScrollView(
                              controller: bloguleCarouselController,
                              clipBehavior: Clip.none,
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  for (final blogule in LPStore.blogules) ...[
                                    PromoCard(
                                      size: SizeVariant.medium,
                                      title: blogule.title,
                                      description: blogule.publicationDate
                                          .toDateString(),
                                      onTap: () => Navigator.of(context).pushNamed(
                                          "${LPRoutes.lp_blogules}/${blogule.title.urlSafeSlug}"),
                                    ),
                                    const SizedBox(width: 40),
                                  ]
                                ], /* List<PromoCard>.generate(
                                  LPStore.blogules.length,
                                  (i) => PromoCard(
                                    size: SizeVariant.medium,
                                    title: LPStore.blogules[i].title,
                                    description: LPStore
                                        .blogules[i].publicationDate
                                        .toDateString(),
                                    onTap: () => Navigator.of(context).pushNamed(
                                        "${LPRoutes.lp_blogules}/${LPStore.blogules[i].title.urlSafeSlug}"),
                                  ),
                                ), */
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),

/*                     child: Stack(
                      children: [
                        Positioned.fill(
                          child: ,
                        ),
/*                         InnerShadow(
                          shadows: [
                            Shadow(
                              blurRadius: 50,
                              color: Colors.black,
                              offset: Offset(0, 60),
                            ),
                            Shadow(
                              blurRadius: 50,
                              color: Colors.black,
                              offset: Offset(0, -60),
                            ),
                          ],
                          child: Container(
                            color: Colors.transparent,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ), */
                      ],
                    ), */
                  /* ViewportDependent(
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 60,
                          right: 60,
                          top: 30,
                        ),
                        child: Column(
                          children: [
                            LPText.header1(content: 'Discover'),
                            const SizedBox(height: 60),
                            const SizedBox(height: 30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 200,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                        color: OctaneTheme.purple800),
                                  ),
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pushNamed(LPRoutes.lp_timelapse);
                                    },
                                    child: Center(
                                      child: Text(
                                        'Timelapse',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: LPFontFamily.body.name,
                                          fontSize: 26,
                                          fontWeight: FontWeight.w300,
                                          letterSpacing: 1,
                                          color: OctaneTheme.purple800,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 40),
                                Container(
                                  width: 200,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                        color: OctaneTheme.purple800),
                                  ),
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pushNamed(LPRoutes.lp_gallery);
                                    },
                                    style: TextButton.styleFrom(
                                      primary: OctaneTheme.purple800,
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Gallery',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: LPFontFamily.body.name,
                                          fontSize: 26,
                                          fontWeight: FontWeight.w300,
                                          letterSpacing: 1,
                                          color: OctaneTheme.purple800,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ), */
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
