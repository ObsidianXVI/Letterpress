part of letterpress.ds;

class BlogulesTimeline extends StatefulWidget {
  const BlogulesTimeline({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => BlogulesTimelineState();
}

class BlogulesTimelineState extends State<BlogulesTimeline>
    with VisibilityDetection {
  bool inView = false;
  @override
  Widget build(BuildContext context) {
    return ViewScaffold(
      child: withVisibilityCallback(
        key: Key('value'),
        onVisibilityChanged: (info) {
          if (info.visibleFraction == 1) {
            setState(() {
              inView = true;
            });
          } else {
            setState(() {
              inView = false;
            });
          }
        },
        child: ViewportSize(
          child: Center(
            child: ListWheelScrollView(
              renderChildrenOutsideViewport: true,
              clipBehavior: Clip.none,
              diameterRatio: 8,
              offAxisFraction: 0.7,
              perspective: 0.005,
              itemExtent: 270,
              physics: inView
                  ? const FixedExtentScrollPhysics()
                  : const NeverScrollableScrollPhysics(),
              children: [
                for (final blogule in LPStore.blogules
                  ..sort(
                      (a, b) => a.publicationDate.compareTo(b.publicationDate)))
                  BloguleCard(blogule: blogule)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
