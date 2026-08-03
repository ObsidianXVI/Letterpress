part of letterpress.ds;

class LPText extends LPPostComponent {
  final String content;

  /// Resolved on every read rather than stored.
  ///
  /// Articles live in [LPStore], a `static final`, so every [LPText] in the
  /// site is constructed exactly once — during the first page load. Baking a
  /// [TextStyle] in at that moment would pin the whole site's typography to the
  /// viewport that happened to be open then, and no amount of resizing or
  /// rebuilding would shift it. Holding the recipe instead of the result keeps
  /// the type responsive.
  final TextStyle Function() _resolveStyle;

  final bool isClickable;
  final bool isHeader;

  /// Depth of this heading in the article outline, 0 for ordinary text.
  ///
  /// 1 is a piece title, descending to 4 for the smallest heading. The sticky
  /// header's section breadcrumb walks these to work out which section, and
  /// which subsection within it, the reader is currently in.
  final int headerLevel;

  final TextAlign textAlign;
  final Alignment alignment;
  final Map<String, dynamic> props = {};

  TextStyle get lpFont => _resolveStyle();

  LPText({
    super.leftSideNotes,
    super.rightSideNotes,
    required this.content,
    required TextStyle lpFont,
    required this.isClickable,
    required this.isHeader,
    this.alignment = Alignment.topLeft,
    this.textAlign = TextAlign.left,
    super.key,
  })  : _resolveStyle = (() => lpFont),
        headerLevel = isHeader ? 1 : 0;

  LPText.mainTitle({
    super.leftSideNotes,
    super.rightSideNotes,
    required this.content,
    this.alignment = Alignment.topLeft,
    this.textAlign = TextAlign.left,
  })  : _resolveStyle = (() => pieceTitle.apply()),
        isClickable = false,
        isHeader = true,
        headerLevel = 1;

  LPText.header1({
    super.leftSideNotes,
    super.rightSideNotes,
    required this.content,
    this.alignment = Alignment.topLeft,
    this.textAlign = TextAlign.left,
  })  : _resolveStyle = (() => header1.apply()),
        isClickable = false,
        isHeader = true,
        headerLevel = 2;

  LPText.header2({
    super.leftSideNotes,
    super.rightSideNotes,
    required this.content,
    this.alignment = Alignment.topLeft,
    this.textAlign = TextAlign.left,
  })  : _resolveStyle = (() => header2.apply()),
        isClickable = false,
        isHeader = true,
        headerLevel = 3;

  LPText.header3({
    super.leftSideNotes,
    super.rightSideNotes,
    required this.content,
    this.alignment = Alignment.topLeft,
    this.textAlign = TextAlign.left,
  })  : _resolveStyle = (() => header3.apply()),
        isClickable = false,
        isHeader = true,
        headerLevel = 4;

  LPText.semanticTag1({
    super.leftSideNotes,
    super.rightSideNotes,
    required this.content,
    this.alignment = Alignment.topLeft,
    this.textAlign = TextAlign.left,
    bool isItalic = false,
  })  : _resolveStyle = (() => semanticTag.apply()),
        isClickable = false,
        isHeader = false,
        headerLevel = 0;

  LPText.plainBody({
    super.leftSideNotes,
    super.rightSideNotes,
    required this.content,
    this.alignment = Alignment.topLeft,
    this.textAlign = TextAlign.left,
    Color? color,
    bool isItalic = false,
    bool isBold = false,
    bool isStrikethrough = false,
  })  : _resolveStyle = (() => body.apply(
              TextStyle(
                color: (color ?? LPColor.rollerBlue_500).withOpacity(0.85),
                fontStyle: isItalic ? FontStyle.italic : null,
                fontWeight: isBold ? FontWeight.w600 : null,
                decoration: isStrikethrough ? TextDecoration.lineThrough : null,
              ),
            )),
        isClickable = false,
        isHeader = false,
        headerLevel = 0;

  LPText.buttonText({
    super.leftSideNotes,
    super.rightSideNotes,
    required this.content,
    this.alignment = Alignment.topLeft,
    this.textAlign = TextAlign.left,
    bool isItalic = false,
  })  : _resolveStyle = (() => body.apply(
            TextStyle(color: LPColor.rollerBlue_500.withOpacity(0.85)))),
        isClickable = false,
        isHeader = false,
        headerLevel = 0;

  LPText.verse({
    super.leftSideNotes,
    super.rightSideNotes,
    required this.content,
    this.alignment = Alignment.topLeft,
    this.textAlign = TextAlign.center,
    bool isItalic = false,
  })  : _resolveStyle = (() => verseQuote.apply(
            isItalic ? const TextStyle(fontStyle: FontStyle.italic) : null)),
        isClickable = false,
        isHeader = false,
        headerLevel = 0;

  LPText.codeStyle({
    required bool inline,
    super.leftSideNotes,
    super.rightSideNotes,
    required this.content,
    this.alignment = Alignment.topLeft,
    this.textAlign = TextAlign.left,
  })  : _resolveStyle = (() => code.apply(
              TextStyle(
                color: (inline ? LPColor.chaseRed_500 : LPColor.platenWhite_500)
                    .withOpacity(inline ? 0.95 : 0.7),
                backgroundColor:
                    LPColor.rollerBlue_500.withOpacity(inline ? 0.2 : 0),
              ),
            )),
        isClickable = false,
        isHeader = false,
        headerLevel = 0;

  LPText.hyperlink({
    super.leftSideNotes,
    super.rightSideNotes,
    required this.content,
    this.alignment = Alignment.topLeft,
    this.textAlign = TextAlign.left,
    Function? action,
    String? url,
    String? route,
  })  : _resolveStyle = (() => body.apply(TextStyle(
              color: LPColor.gripperBlue_400.withOpacity(0.8),
              decoration: TextDecoration.underline,
              decorationColor: LPColor.rollerBlue_500,
            ))),
        isClickable = true,
        isHeader = false,
        headerLevel = 0 {
    props.addAll({
      'url': url,
      'action': action,
      'route': route,
    });
  }

  LPText.paragraphBreak()
      : content = '\n',
        _resolveStyle = (() => body
            .apply(TextStyle(color: LPColor.rollerBlue_500.withOpacity(0.85)))),
        isClickable = false,
        textAlign = TextAlign.left,
        isHeader = false,
        headerLevel = 0,
        alignment = Alignment.topLeft;

  @override
  Widget build(BuildContext context) {
    // Registers this widget for viewport changes. Article components are
    // created once and reused, so an ancestor rebuild never reaches them —
    // without this dependency the text would never re-scale on a resize.
    LPViewport.of(context);

    return Align(
      alignment: alignment,
      child: isClickable
          ? MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  if (props['route'] != null) {
                    Navigator.of(context).pushNamed(props['route']);
                  } else if (props['action'] != null) {
                    (props['action'] as Function).call();
                  } else if (props['url'] != null) {
                    web.window.open(props['url'], 'launching...');
                  }
                },
                child: Text(
                  content,
                  style: lpFont,
                  textAlign: textAlign,
                ),
              ),
            )
          // Plain [Text], not [SelectableText]: the enclosing [LPSelectionArea]
          // owns selection for the whole view, which is what allows a drag to
          // continue from one paragraph into the next.
          : Text(
              content,
              style: lpFont,
              textAlign: textAlign,
            ),
    );
  }
}

class LPTextSpan extends LPPostComponent {
  final List<LPText> lpTextComponents;

  LPTextSpan({
    required this.lpTextComponents,
    super.leftSideNotes,
    super.rightSideNotes,
  });

  @override
  Widget build(BuildContext context) {
    LPViewport.of(context);

    TapGestureRecognizer? gestureRecog(LPText lpText) {
      if (lpText.isClickable) {
        return TapGestureRecognizer()
          ..onTap = () {
            if (lpText.props.containsKey('action') &&
                lpText.props['action'] != null) {
              (lpText.props['action'] as Function).call();
            }
            if (lpText.props.containsKey('url') &&
                lpText.props['url'] != null) {
              web.window.open(lpText.props['url'] as String, '');
            }
            if (lpText.props.containsKey('route') &&
                lpText.props['route'] != null) {
              Navigator.of(context).pushNamed(lpText.props['route'] as String);
            }
          };
      } else {
        return null;
      }
    }

    return Text.rich(
      TextSpan(
        children: List<TextSpan>.generate(
          lpTextComponents.length,
          (int i) => TextSpan(
            text: lpTextComponents[i].content,
            style: lpTextComponents[i].lpFont,
            recognizer: gestureRecog(lpTextComponents[i]),
          ),
        ),
      ),
    );
  }
}
