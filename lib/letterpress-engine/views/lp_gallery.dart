part of letterpress.views;

class LetterpressGallery extends StatelessWidget {
  const LetterpressGallery({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Container(
          width: DimensionTools.getWidth(context),
          height: DimensionTools.getHeight(context),
          color: OctaneTheme.obsidianD150,
          child: Padding(
            padding: const EdgeInsets.all(60),
            child: Column(
              children: [
                LPText.mainTitle(content: 'Gallery'),
                const SizedBox(height: 10),
                LPText.plainBody(
                  content:
                      'An illuminating set of posts, curated by hand from the collection of blogules.',
                ),
                const SizedBox(height: 40),
                GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 3,
                  crossAxisSpacing: 40,
                  childAspectRatio: 1,
                  children: List<Widget>.generate(
                    LPStore.posts.length,
                    (i) {
                      final LPPost post = LPStore.posts[i];
                      return LPHoverableCardWidget(
                        width: double.infinity,
                        height: double.infinity,
                        clickable: true,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed(
                                "posts/${LPStore.posts[i].postConfigs.title.urlSafeSlug}");
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Stack(
                              children: [
                                Flex(
                                  direction: Axis.vertical,
                                  children: [
                                    Flexible(
                                        child: LPText(
                                      content: post.postConfigs.title,
                                      lpFont: LPFont.header4(
                                        styleOverride: const TextStyle(
                                            color: OctaneTheme.obsidianA150),
                                      ),
                                      isClickable: false,
                                      isHeader: true,
                                    )),
                                    const SizedBox(height: 20),
                                    Flexible(
                                      child: LPText.plainBody(
                                          content:
                                              post.postConfigs.description),
                                    ),
                                  ],
                                ),
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  child: SizedBox(
                                    height: 40,
                                    width: 760,
                                    child: ListView.separated(
                                      scrollDirection: Axis.horizontal,
                                      itemCount:
                                          post.postConfigs.allTags.length,
                                      itemBuilder: (context, i) => LPMetaTag(
                                        label: post.postConfigs.allTags[i],
                                        primaryColor: OctaneTheme.obsidianC050,
                                      ),
                                      separatorBuilder: (context, _) =>
                                          const SizedBox(width: 10),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
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

/**
 * Align(
                        alignment: Alignment.topLeft,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed(
                                LPRoutes.postUrls[LPStore.posts[i]]!);
                          },
                          child: SelectionContainer.disabled(
                            child: Container(
                              width: 800,
                              height: 300,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: OctaneTheme.obsidianC150,
                              ),
                              child: 
                            ),
                          ),
                        ),
                      )
 */