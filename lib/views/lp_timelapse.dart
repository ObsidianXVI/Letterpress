part of letterpress.views;

class LetterpressTimelapse extends StatelessWidget {
  const LetterpressTimelapse({
    super.key,
  });

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
            child: Align(
              alignment: Alignment.topLeft,
              child: Row(
                children: [
                  LetterpressTimelineComponent(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LetterpressTimelineComponent extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LetterpressTimelineComponentState();
}

class LetterpressTimelineComponentState
    extends State<LetterpressTimelineComponent> {
  @override
  Widget build(BuildContext context) {
    return ViewScaffold(
      child: SizedBox(
        width: DimensionTools.getWidth(context) * 0.4,
        height: DimensionTools.getHeight(context) * 0.9,
        child: ListWheelScrollView(
          itemExtent: 200,
          offAxisFraction: 0.8,
          diameterRatio: 4,
          perspective: 0.005,
          squeeze: 0.9,
          children: List<Widget>.generate(LPStore.blogules.length, (int i) {
            final LPModule blogule = LPStore.blogules[i];
            return Center(
              child: Container(
                width: 400,
                height: 200,
                decoration: BoxDecoration(
                  color: OctaneTheme.obsidianC150,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(
                        "${LPRoutes.lp_blogules}/${LPStore.blogules[i].title.urlSafeSlug}");
                  },
                  child: SelectionContainer.disabled(
                    child: Container(
                      width: 800,
                      height: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: OctaneTheme.obsidianB150,
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
                                    blogule.title,
                                    maxLines: 3,
                                    style: TextStyle(
                                      color: OctaneTheme.obsidianA100,
                                      fontSize: 30,
                                      fontFamily: LPFontFamily.body.name,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Flexible(
                                  child: Text(
                                    blogule.projectName,
                                    maxLines: 3,
                                    style: TextStyle(
                                      color: OctaneTheme.obsidianA000,
                                      fontSize: 18,
                                      fontFamily: LPFontFamily.body.name,
                                      fontWeight: FontWeight.w300,
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
                                  itemCount: blogule.tags.length,
                                  itemBuilder: (context, i) => Chip(
                                    backgroundColor: OctaneTheme.obsidianB000,
                                    label: Text(
                                      blogule.tags[i],
                                      style: TextStyle(
                                        color: OctaneTheme.obsidianC000,
                                        fontSize: 16,
                                        fontFamily: LPFontFamily.body.name,
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
          }),
        ),
      ),
    );
  }
}
