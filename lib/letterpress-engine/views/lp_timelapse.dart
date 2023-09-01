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
          color: OctaneTheme.obsidian800,
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
    return SizedBox(
      width: DimensionTools.getWidth(context) * 0.4,
      height: DimensionTools.getHeight(context) * 0.9,
      child: ListWheelScrollView(
        itemExtent: 200,
        offAxisFraction: 0.8,
        diameterRatio: 4,
        perspective: 0.005,
        squeeze: 0.9,
        children: List<Widget>.generate(LPStore.modules.length, (int i) {
          final LPModule module = LPStore.modules[i];
          return Center(
            child: Container(
              width: 400,
              height: 200,
              decoration: BoxDecoration(
                color: OctaneTheme.obsidian700,
                borderRadius: BorderRadius.circular(5),
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .pushNamed(LPRoutes.postUrls[LPStore.posts[i]]!);
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
                                    fontFamily: LPFontFamily.body.name,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Flexible(
                                child: Text(
                                  module.projectName,
                                  maxLines: 3,
                                  style: TextStyle(
                                    color: OctaneTheme.obsidian200,
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
                                itemCount: module.tags.length,
                                itemBuilder: (context, i) => Chip(
                                  backgroundColor: OctaneTheme.obsidian400,
                                  label: Text(
                                    module.tags[i],
                                    style: TextStyle(
                                      color: OctaneTheme.obsidian600,
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
    );
  }
}
