part of letterpress.ds;

class BloguleCard extends StatefulWidget {
  final LPModule blogule;

  const BloguleCard({
    required this.blogule,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => BloguleCardState();
}

class BloguleCardState extends State<BloguleCard>
    with CardStyling, HoverStyling, Clickable {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: hoverRegion(
        onTap: () => Navigator.of(context).pushNamed(
            "${LPRoutes.lp_blogules}/${widget.blogule.title.urlSafeSlug}"),
        child: Container(
          width: Multiplatform.currentPlatform == const DesktopPlatform()
              ? 400
              : 200,
          height: Multiplatform.currentPlatform == const DesktopPlatform()
              ? 220
              : 180,
          decoration: BoxDecoration(
            color: cardBackground,
            border: cardBorder,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 10,
                left: 10,
                child: Text(
                  widget.blogule.title,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
