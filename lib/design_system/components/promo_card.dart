part of letterpress.ds;

enum SizeVariant { small, medium, large }

class PromoCard extends StatefulWidget {
  final LPArticle article;
  final String description;
  final SizeVariant size;
  final void Function() onTap;
  final Key? surfaceKey;

  const PromoCard({
    required this.size,
    required this.article,
    required this.description,
    required this.onTap,
    this.surfaceKey,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => PromoCardState();
}

class PromoCardState extends State<PromoCard> {
  bool hovering = false;
  bool pressing = false;

  @override
  Widget build(BuildContext context) {
    final double width = _cardWidth(context);
    final double height = _cardHeight(width);
    final double padding = width < 360
        ? 18
        : width < 520
            ? 24
            : 30;

    return Center(
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => hovering = true),
        onExit: (_) => setState(() => hovering = false),
        child: GestureDetector(
          onTapDown: (_) => setState(() {
            if (!widget.article.isPreviewMode) {
              pressing = true;
            }
          }),
          onTapUp: (_) => setState(() {
            if (!widget.article.isPreviewMode) {
              pressing = false;
              widget.onTap();
            }
          }),
          child: Container(
            key: widget.surfaceKey,
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: LPColor.inkBlue_500,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: pressing ? LPColor.chaseRed_500 : LPColor.rollerBlue_500,
              ),
              boxShadow: hovering
                  ? [
                      BoxShadow(
                        offset: const Offset(0, 10),
                        color: (pressing ? LPColor.chaseRed_500 : Colors.black)
                            .withOpacity(0.3),
                        blurRadius: 13,
                        spreadRadius: 4,
                      ),
                    ]
                  : null,
            ),
            child: SelectionContainer.disabled(
              child: Padding(
                padding: EdgeInsets.all(padding),
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    final double contentWidth = constraints.maxWidth;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              widget.article.title,
                              textAlign: TextAlign.left,
                              maxLines: _titleMaxLines(contentWidth),
                              overflow: TextOverflow.ellipsis,
                              style: _titleStyle(context, contentWidth),
                            ),
                          ),
                        ),
                        SizedBox(height: contentWidth < 420 ? 14 : 20),
                        Text(
                          widget.description,
                          maxLines: _descriptionMaxLines(contentWidth),
                          overflow: TextOverflow.ellipsis,
                          style: _descriptionStyle(context, contentWidth),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  double _cardWidth(BuildContext context) {
    final double viewportWidth = MediaQuery.sizeOf(context).width;
    final double availableWidth =
        (viewportWidth - (viewportWidth >= 900 ? 180 : 40))
            .clamp(260, 780)
            .toDouble();

    return switch (widget.size) {
      SizeVariant.small => availableWidth.clamp(260, 420).toDouble(),
      SizeVariant.medium => availableWidth.clamp(300, 560).toDouble(),
      SizeVariant.large => availableWidth.clamp(340, 760).toDouble(),
    };
  }

  double _cardHeight(double width) {
    return switch (widget.size) {
      SizeVariant.small => width * 1.04,
      SizeVariant.medium => width * 0.78,
      SizeVariant.large => width * 0.68,
    };
  }

  int _titleMaxLines(double width) {
    return switch (widget.size) {
      SizeVariant.small => width < 320 ? 4 : 5,
      SizeVariant.medium => width < 420 ? 4 : 5,
      SizeVariant.large => width < 520 ? 4 : 5,
    };
  }

  int _descriptionMaxLines(double width) {
    return switch (widget.size) {
      SizeVariant.small => width < 320 ? 3 : 4,
      SizeVariant.medium => width < 420 ? 3 : 4,
      SizeVariant.large => width < 520 ? 4 : 5,
    };
  }

  TextStyle _titleStyle(BuildContext context, double width) {
    final double fontSize = switch (widget.size) {
      SizeVariant.small => context.fluid(
          min: width < 320 ? 26 : 30,
          max: 48,
          minWidth: 260,
          maxWidth: 760,
        ),
      SizeVariant.medium => context.fluid(
          min: width < 420 ? 30 : 34,
          max: 56,
          minWidth: 300,
          maxWidth: 760,
        ),
      SizeVariant.large => context.fluid(
          min: width < 520 ? 34 : 40,
          max: 64,
          minWidth: 340,
          maxWidth: 760,
        ),
    };

    return TextStyle(
      color: LPColor.gripperBlue_500,
      fontFamily: LPFontFamily.headers.name,
      fontSize: fontSize,
      fontWeight: FontWeight.w900,
      height: 0.84,
    );
  }

  TextStyle _descriptionStyle(BuildContext context, double width) {
    return body.apply(
      TextStyle(
        color: LPColor.rollerBlue_500,
        fontSize: context.fluid(
          min: width < 360 ? 16 : 18,
          max: widget.size == SizeVariant.large ? 22 : 20,
          minWidth: 260,
          maxWidth: 760,
        ),
        height: 1.32,
      ),
    );
  }
}
