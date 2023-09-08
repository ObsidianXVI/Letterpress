part of letterpress.ds;

class LPText extends LPPostComponent {
  final String content;
  final LPFont lpFont;
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
  })  : lpFont = LPFont.mainTitle(),
        isClickable = false,
        isHeader = true;

  LPText.subTitle({
    super.leftSideNotes,
    super.rightSideNotes,
    required this.content,
    this.alignment = Alignment.topLeft,
    this.textAlign = TextAlign.left,
  })  : lpFont = LPFont.subTitle(),
        isClickable = false,
        isHeader = true;

  LPText.header1({
    super.leftSideNotes,
    super.rightSideNotes,
    required this.content,
    this.alignment = Alignment.topLeft,
    this.textAlign = TextAlign.left,
  })  : lpFont = LPFont.header1(),
        isClickable = false,
        isHeader = true;

  LPText.header2({
    super.leftSideNotes,
    super.rightSideNotes,
    required this.content,
    this.alignment = Alignment.topLeft,
    this.textAlign = TextAlign.left,
  })  : lpFont = LPFont.header2(),
        isClickable = false,
        isHeader = true;

  LPText.header3({
    super.leftSideNotes,
    super.rightSideNotes,
    required this.content,
    this.alignment = Alignment.topLeft,
    this.textAlign = TextAlign.left,
  })  : lpFont = LPFont.header3(),
        isClickable = false,
        isHeader = true;

  LPText.header4({
    super.leftSideNotes,
    super.rightSideNotes,
    required this.content,
    this.alignment = Alignment.topLeft,
    this.textAlign = TextAlign.left,
  })  : lpFont = LPFont.header4(),
        isClickable = false,
        isHeader = true;

  LPText.semanticTag1({
    super.leftSideNotes,
    super.rightSideNotes,
    required this.content,
    this.alignment = Alignment.topLeft,
    this.textAlign = TextAlign.left,
    bool isItalic = false,
  })  : lpFont = LPFont.semanticTag1(),
        isClickable = false,
        isHeader = false;

  LPText.plainBody({
    super.leftSideNotes,
    super.rightSideNotes,
    required this.content,
    this.alignment = Alignment.topLeft,
    this.textAlign = TextAlign.left,
    bool isItalic = false,
  })  : lpFont = isItalic ? LPFont.bodyItalic() : LPFont.body(),
        isClickable = false,
        isHeader = false;

  LPText.buttonText({
    super.leftSideNotes,
    super.rightSideNotes,
    required this.content,
    this.alignment = Alignment.topLeft,
    this.textAlign = TextAlign.left,
    bool isItalic = false,
  })  : lpFont = LPFont.buttonText(),
        isClickable = false,
        isHeader = false;

  LPText.verse({
    super.leftSideNotes,
    super.rightSideNotes,
    required this.content,
    this.alignment = Alignment.topLeft,
    this.textAlign = TextAlign.center,
    bool isItalic = false,
  })  : lpFont = isItalic ? LPFont.verseQuoteItalic() : LPFont.verseQuote(),
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
  })  : lpFont = LPFont.hyperlink(),
        isClickable = true,
        isHeader = false {
    props.addAll({'url': url, 'action': action});
  }

  LPText.paragraphBreak()
      : content = '\n',
        lpFont = LPFont.body(),
        isClickable = false,
        textAlign = TextAlign.left,
        isHeader = false,
        alignment = Alignment.topLeft;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Text(
        content,
        style: lpFont.textStyle,
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
            style: lpTextComponents[i].lpFont.textStyle,
            recognizer: gestureRecog(lpTextComponents[i]),
          ),
        ),
      ),
    );
  }
}
