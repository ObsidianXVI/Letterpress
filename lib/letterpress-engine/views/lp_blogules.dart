part of letterpress.views;

class LetterpressBlogulesView extends StatelessWidget {
  const LetterpressBlogulesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Container(
          width: DimensionTools.getWidth(context),
          height: DimensionTools.getHeight(context),
          color: OctaneTheme.obsidian800,
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              children: [
                LPText.header1(content: 'Blogules'),
                const SizedBox(height: 10),
                LPText.plainBody(
                  content:
                      'The entire repository of blogules at your fingertips, available for querying.',
                ),
                const SizedBox(height: 40),
                GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 4,
                  children: List<Widget>.generate(
                    LPStore.modules.length,
                    (i) {
                      final LPModule module = LPStore.modules[i];
                      return Align(
                        alignment: Alignment.topLeft,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed(LPRoutes.bloguleUrls[module]!);
                          },
                          child: SelectionContainer.disabled(
                            child: Container(
                              width: 800,
                              height: 300,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: OctaneTheme.obsidian600,
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
                                            module.title,
                                            maxLines: 3,
                                            style: TextStyle(
                                              color: OctaneTheme.obsidian200,
                                              fontSize: 30,
                                              fontFamily:
                                                  LPFontFamily.body.name,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 20),
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
                                          itemCount: module.tags.length,
                                          itemBuilder: (context, i) => Chip(
                                            backgroundColor:
                                                OctaneTheme.obsidian400,
                                            label: Text(
                                              module.tags[i],
                                              style: TextStyle(
                                                color: OctaneTheme.obsidian600,
                                                fontSize: 16,
                                                fontFamily:
                                                    LPFontFamily.body.name,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
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
