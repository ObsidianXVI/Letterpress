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
          color: LPTheme.grey800,
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              children: [
                LPText.header1(content: 'Gallery'),
                const SizedBox(height: 10),
                LPText.plainBody(
                  content:
                      'An illuminating set of posts, curated by hand from the collection of modules.',
                ),
                const SizedBox(height: 40),
                GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 4,
                  children: List<Widget>.generate(
                    LPStore.posts.length,
                    (i) {
                      final LPPost post = LPStore.posts[i];
                      return Align(
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
                                color: LPTheme.grey600,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Stack(
                                  children: [
                                    Flex(
                                      direction: Axis.vertical,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            post.postConfigs.title,
                                            maxLines: 3,
                                            style: TextStyle(
                                              color: LPTheme.grey200,
                                              fontSize: 30,
                                              fontFamily:
                                                  LPFontFamily.body.name,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      left: 0,
                                      child: SizedBox(
                                        height: 40,
                                        width: 660,
                                        child: ListView.separated(
                                          scrollDirection: Axis.horizontal,
                                          itemCount:
                                              post.postConfigs.allTags.length,
                                          itemBuilder: (context, i) => Chip(
                                            label: Text(
                                                post.postConfigs.allTags[i]),
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
