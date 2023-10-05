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
          color: OctaneTheme.obsidianD150,
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              children: [
                LPText.mainTitle(content: 'Blogules'),
                const SizedBox(height: 10),
                LPText.plainBody(
                  content:
                      'The entire repository of blogules at your fingertips, available for querying.',
                ),
                LPText.hyperlink(content: "What is a blogule?", action: () {}),
                const SizedBox(height: 40),
                GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 4,
                  mainAxisSpacing: 40,
                  crossAxisSpacing: 40,
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
                                color: OctaneTheme.obsidianC150,
                              ),
                              child: LPHoverableCardWidget(
                                width: 800,
                                height: 300,
                                clickable: true,
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
                                                color: OctaneTheme.obsidianB000,
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
                                                  OctaneTheme.obsidianB050,
                                              label: Text(
                                                module.tags[i],
                                                style: TextStyle(
                                                  color:
                                                      OctaneTheme.obsidianC150,
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
