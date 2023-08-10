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
                      'An illuminating set of posts, curated by hand from the modules.',
                ),
                const SizedBox(height: 40),
                GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 4,
                  children: List<Widget>.generate(
                    LPStore.posts.length,
                    (i) {
                      return Align(
                        alignment: Alignment.topLeft,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed(
                                LPRoutes.postUrls[LPStore.posts[i]]!);
                          },
                          child: SelectionContainer.disabled(
                            child: Container(
                              width: 600,
                              height: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: LPTheme.grey600,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    LPStore.posts[i].postConfigs.title,
                                    style: TextStyle(
                                      color: LPTheme.grey800,
                                      fontSize: 30,
                                      fontFamily: LPFontFamily.headers.name,
                                    ),
                                  ),
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
