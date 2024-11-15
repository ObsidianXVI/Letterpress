part of letterpress.ds;

class LPText extends LPPostComponent {
  final String content;
  final TextStyle lpFont;
  final bool isClickable;
  final bool isHeader;
  final TextAlign textAlign;
  final Alignment alignment;
  final Map<String, dynamic> props = {};

  LPText({
    super.leftSideNotes,
    super.rightSideNotes,
    required this.content,
    required this.lpFont,
    required this.isClickable,
    required this.isHeader,
    this.alignment = Alignment.topLeft,
    this.textAlign = TextAlign.left,
    super.key,
  });

  LPText.mainTitle({
    super.leftSideNotes,
    super.rightSideNotes,
    required this.content,
    this.alignment = Alignment.topLeft,
    this.textAlign = TextAlign.left,
  })  : lpFont = pieceTitle.apply(),
        isClickable = false,
        isHeader = true;

  LPText.header1({
    super.leftSideNotes,
    super.rightSideNotes,
    required this.content,
    this.alignment = Alignment.topLeft,
    this.textAlign = TextAlign.left,
  })  : lpFont = header1.apply(),
        isClickable = false,
        isHeader = true;

  LPText.header2({
    super.leftSideNotes,
    super.rightSideNotes,
    required this.content,
    this.alignment = Alignment.topLeft,
    this.textAlign = TextAlign.left,
  })  : lpFont = header2.apply(),
        isClickable = false,
        isHeader = true;

  LPText.header3({
    super.leftSideNotes,
    super.rightSideNotes,
    required this.content,
    this.alignment = Alignment.topLeft,
    this.textAlign = TextAlign.left,
  })  : lpFont = header3.apply(),
        isClickable = false,
        isHeader = true;

  LPText.semanticTag1({
    super.leftSideNotes,
    super.rightSideNotes,
    required this.content,
    this.alignment = Alignment.topLeft,
    this.textAlign = TextAlign.left,
    bool isItalic = false,
  })  : lpFont = semanticTag.apply(),
        isClickable = false,
        isHeader = false;

  LPText.plainBody({
    super.leftSideNotes,
    super.rightSideNotes,
    required this.content,
    this.alignment = Alignment.topLeft,
    this.textAlign = TextAlign.left,
    Color? color,
    bool isItalic = false,
    bool isBold = false,
  })  : lpFont = body.apply(
          TextStyle(
            color: (color ?? LPColor.rollerBlue_500).withOpacity(0.85),
            fontStyle: isItalic ? FontStyle.italic : null,
            fontWeight: isBold ? FontWeight.w600 : null,
          ),
        ),
        isClickable = false,
        isHeader = false;

  LPText.buttonText({
    super.leftSideNotes,
    super.rightSideNotes,
    required this.content,
    this.alignment = Alignment.topLeft,
    this.textAlign = TextAlign.left,
    bool isItalic = false,
  })  : lpFont = body
            .apply(TextStyle(color: LPColor.rollerBlue_500.withOpacity(0.85))),
        isClickable = false,
        isHeader = false;

  LPText.verse({
    super.leftSideNotes,
    super.rightSideNotes,
    required this.content,
    this.alignment = Alignment.topLeft,
    this.textAlign = TextAlign.center,
    bool isItalic = false,
  })  : lpFont = verseQuote.apply(
            isItalic ? const TextStyle(fontStyle: FontStyle.italic) : null),
        isClickable = false,
        isHeader = false;

  LPText.codeStyle({
    required bool inline,
    super.leftSideNotes,
    super.rightSideNotes,
    required this.content,
    this.alignment = Alignment.topLeft,
    this.textAlign = TextAlign.left,
  })  : lpFont = code.apply(
          TextStyle(
            color: (inline ? LPColor.chaseRed_500 : LPColor.platenWhite_500)
                .withOpacity(0.7),
            backgroundColor:
                LPColor.rollerBlue_500.withOpacity(inline ? 0.2 : 0),
          ),
        ),
        isClickable = false,
        isHeader = false;

  LPText.hyperlink({
    super.leftSideNotes,
    super.rightSideNotes,
    required this.content,
    this.alignment = Alignment.topLeft,
    this.textAlign = TextAlign.left,
    Function? action,
    String? url,
    String? route,
  })  : lpFont = body.apply(TextStyle(
          color: LPColor.gripperBlue_400.withOpacity(0.8),
          decoration: TextDecoration.underline,
          decorationColor: LPColor.rollerBlue_500,
        )),
        isClickable = true,
        isHeader = false {
    props.addAll({
      'url': url,
      'action': action,
      'route': route,
    });
  }

  LPText.paragraphBreak()
      : content = '\n',
        lpFont = body
            .apply(TextStyle(color: LPColor.rollerBlue_500.withOpacity(0.85))),
        isClickable = false,
        textAlign = TextAlign.left,
        isHeader = false,
        alignment = Alignment.topLeft;

  @override
  Widget build(BuildContext context) {
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
                    window.open(props['url'], 'launching...');
                  }
                },
                child: Text(
                  content,
                  style: lpFont,
                  textAlign: textAlign,
                ),
              ),
            )
          : SelectableText(
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
              window.open(lpText.props['url'] as String, '');
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
