part of letterpress.ds;

class LPText extends LPPostComponent {
  final String content;
  final TextStyle lpFont;
  final bool isClickable;
  final bool isHeader;
  final int headingLevel;
  final bool isCodeStyle;
  final bool isInlineCode;
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
    this.headingLevel = 0,
    this.isCodeStyle = false,
    this.isInlineCode = false,
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
        isHeader = true,
        headingLevel = 1,
        isCodeStyle = false,
        isInlineCode = false;

  LPText.header1({
    super.leftSideNotes,
    super.rightSideNotes,
    required this.content,
    this.alignment = Alignment.topLeft,
    this.textAlign = TextAlign.left,
  })  : lpFont = header1.apply(),
        isClickable = false,
        isHeader = true,
        headingLevel = 1,
        isCodeStyle = false,
        isInlineCode = false;

  LPText.header2({
    super.leftSideNotes,
    super.rightSideNotes,
    required this.content,
    this.alignment = Alignment.topLeft,
    this.textAlign = TextAlign.left,
  })  : lpFont = header2.apply(),
        isClickable = false,
        isHeader = true,
        headingLevel = 2,
        isCodeStyle = false,
        isInlineCode = false;

  LPText.header3({
    super.leftSideNotes,
    super.rightSideNotes,
    required this.content,
    this.alignment = Alignment.topLeft,
    this.textAlign = TextAlign.left,
  })  : lpFont = header3.apply(),
        isClickable = false,
        isHeader = true,
        headingLevel = 3,
        isCodeStyle = false,
        isInlineCode = false;

  LPText.semanticTag1({
    super.leftSideNotes,
    super.rightSideNotes,
    required this.content,
    this.alignment = Alignment.topLeft,
    this.textAlign = TextAlign.left,
    bool isItalic = false,
  })  : lpFont = semanticTag.apply(),
        isClickable = false,
        isHeader = false,
        headingLevel = 0,
        isCodeStyle = false,
        isInlineCode = false;

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
  })  : lpFont = body.apply(
          TextStyle(
            color: (color ?? LPColor.rollerBlue_500).withOpacity(0.85),
            fontStyle: isItalic ? FontStyle.italic : null,
            fontWeight: isBold ? FontWeight.w600 : null,
            decoration: isStrikethrough ? TextDecoration.lineThrough : null,
          ),
        ),
        isClickable = false,
        isHeader = false,
        headingLevel = 0,
        isCodeStyle = false,
        isInlineCode = false;

  LPText.buttonText({
    super.leftSideNotes,
    super.rightSideNotes,
    required this.content,
    this.alignment = Alignment.topLeft,
    this.textAlign = TextAlign.left,
    bool isItalic = false,
  })  : lpFont = body.apply(
          TextStyle(color: LPColor.rollerBlue_500.withOpacity(0.85)),
        ),
        isClickable = false,
        isHeader = false,
        headingLevel = 0,
        isCodeStyle = false,
        isInlineCode = false;

  LPText.verse({
    super.leftSideNotes,
    super.rightSideNotes,
    required this.content,
    this.alignment = Alignment.topLeft,
    this.textAlign = TextAlign.center,
    bool isItalic = false,
  })  : lpFont = verseQuote.apply(
          isItalic ? const TextStyle(fontStyle: FontStyle.italic) : null,
        ),
        isClickable = false,
        isHeader = false,
        headingLevel = 0,
        isCodeStyle = false,
        isInlineCode = false;

  LPText.codeStyle({
    required bool inline,
    super.leftSideNotes,
    super.rightSideNotes,
    required this.content,
    this.alignment = Alignment.topLeft,
    this.textAlign = TextAlign.left,
  })  : lpFont = code.apply(
          TextStyle(
            color: inline
                ? LPColor.platenWhite_500.withOpacity(0.95)
                : LPColor.platenWhite_500.withOpacity(0.82),
            backgroundColor: inline
                ? LPColor.rollerBlue_500.withOpacity(0.18)
                : Colors.transparent,
            fontWeight: inline ? FontWeight.w500 : FontWeight.w400,
          ),
        ),
        isClickable = false,
        isHeader = false,
        headingLevel = 0,
        isCodeStyle = true,
        isInlineCode = inline;

  LPText.hyperlink({
    super.leftSideNotes,
    super.rightSideNotes,
    required this.content,
    this.alignment = Alignment.topLeft,
    this.textAlign = TextAlign.left,
    Function? action,
    String? url,
    String? route,
  })  : lpFont = body.apply(
          TextStyle(
            color: LPColor.gripperBlue_400.withOpacity(0.8),
            decoration: TextDecoration.underline,
            decorationColor: LPColor.rollerBlue_500,
          ),
        ),
        isClickable = true,
        isHeader = false,
        headingLevel = 0,
        isCodeStyle = false,
        isInlineCode = false {
    props.addAll({'url': url, 'action': action, 'route': route});
  }

  LPText.paragraphBreak()
      : content = '\n',
        lpFont = body.apply(
          TextStyle(color: LPColor.rollerBlue_500.withOpacity(0.85)),
        ),
        isClickable = false,
        isHeader = false,
        headingLevel = 0,
        isCodeStyle = false,
        isInlineCode = false,
        textAlign = TextAlign.left,
        alignment = Alignment.topLeft;

  String get headingLabel => content.replaceAll('\n', ' ').trim();

  void activate(BuildContext context) {
    if (props['route'] != null) {
      Navigator.of(context).pushNamed(props['route'] as String);
      return;
    }
    if (props['action'] != null) {
      (props['action'] as Function).call();
      return;
    }
    if (props['url'] != null) {
      openExternalUrl(props['url'] as String);
    }
  }

  TextSpan toInlineSpan(BuildContext context) {
    return TextSpan(
      text: content,
      style: lpFont,
      mouseCursor: isClickable ? SystemMouseCursors.click : null,
      recognizer: isClickable
          ? (TapGestureRecognizer()..onTap = () => activate(context))
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _LPSelectableRichText(
      alignment: alignment,
      textAlign: textAlign,
      spans: [toInlineSpan(context)],
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
    return _LPSelectableRichText(
      textAlign: TextAlign.left,
      spans: [
        for (final LPText lpText in lpTextComponents)
          lpText.toInlineSpan(context),
      ],
    );
  }
}

class _LPSelectableRichText extends StatelessWidget {
  final List<InlineSpan> spans;
  final Alignment alignment;
  final TextAlign textAlign;

  const _LPSelectableRichText({
    required this.spans,
    this.alignment = Alignment.topLeft,
    this.textAlign = TextAlign.left,
  });

  @override
  Widget build(BuildContext context) {
    final selectionRegistrar = SelectionContainer.maybeOf(context);

    return Align(
      alignment: alignment,
      child: RichText(
        textAlign: textAlign,
        selectionRegistrar: selectionRegistrar,
        selectionColor: selectionRegistrar == null
            ? null
            : OctaneTheme.obsidianB100.withOpacity(0.3),
        text: TextSpan(children: spans),
      ),
    );
  }
}
