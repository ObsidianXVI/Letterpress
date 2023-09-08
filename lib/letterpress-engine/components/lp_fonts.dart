part of letterpress.ds;

enum LPFontFamily {
  headers('Fraunces_Standard'),
  body('Fraunces_Soft');

  final String name;
  const LPFontFamily(this.name);
}

enum LPColorTheme {
  background_grey(OctaneTheme.obsidianD150),
  standard_grey(OctaneTheme.obsidianA150),
  header1_grey(OctaneTheme.obsidianB000),
  header2_grey(OctaneTheme.obsidianB050),
  header3_grey(OctaneTheme.obsidianB100),
  header4_grey(OctaneTheme.obsidianB150),
  hyperlink_purple(OctaneTheme.purple800),
  inline_code_cyan(OctaneTheme.blue800),
  lyrics_quote_red(OctaneTheme.red800),
  ;

  final Color color;
  const LPColorTheme(this.color);
}

class LPFont {
  final TextStyle textStyle;
  final int headerLevel;
  final Color? textColor;

  LPFont.mainTitle({this.textColor, TextStyle? styleOverride})
      : textStyle = TextStyle(
          fontFamily: styleOverride?.fontFamily ?? LPFontFamily.headers.name,
          color: styleOverride?.color ?? LPColorTheme.standard_grey.color,
          fontSize: styleOverride?.fontSize ?? 130,
          fontWeight: styleOverride?.fontWeight ?? FontWeight.w300,
          height: styleOverride?.height ?? 0.75,
        ),
        headerLevel = 0;

  LPFont.subTitle({this.textColor, TextStyle? styleOverride})
      : textStyle = TextStyle(
          fontFamily: styleOverride?.fontFamily ?? LPFontFamily.headers.name,
          color: styleOverride?.color ?? LPColorTheme.standard_grey.color,
          fontSize: styleOverride?.fontSize ?? 100,
          fontWeight: styleOverride?.fontWeight ?? FontWeight.w600,
          height: styleOverride?.height ?? 0.75,
        ),
        headerLevel = -1;

  LPFont.header1({this.textColor, TextStyle? styleOverride})
      : textStyle = TextStyle(
          fontFamily: styleOverride?.fontFamily ?? LPFontFamily.headers.name,
          color: styleOverride?.color ?? LPColorTheme.header1_grey.color,
          fontSize: styleOverride?.fontSize ?? 120,
          fontWeight: styleOverride?.fontWeight ?? FontWeight.w900,
          height: styleOverride?.height ?? 1.2,
        ),
        headerLevel = 1;

  LPFont.header2({this.textColor, TextStyle? styleOverride})
      : textStyle = TextStyle(
          fontFamily: styleOverride?.fontFamily ?? LPFontFamily.headers.name,
          color: styleOverride?.color ?? LPColorTheme.header2_grey.color,
          fontSize: styleOverride?.fontSize ?? 100,
          fontWeight: styleOverride?.fontWeight ?? FontWeight.w900,
          height: styleOverride?.height ?? 1.2,
        ),
        headerLevel = 2;

  LPFont.header3({this.textColor, TextStyle? styleOverride})
      : textStyle = TextStyle(
          fontFamily: styleOverride?.fontFamily ?? LPFontFamily.headers.name,
          color: styleOverride?.color ?? LPColorTheme.header3_grey.color,
          fontSize: styleOverride?.fontSize ?? 80,
          fontWeight: styleOverride?.fontWeight ?? FontWeight.w600,
          height: styleOverride?.height ?? 1.2,
        ),
        headerLevel = 3;

  LPFont.header4({this.textColor, TextStyle? styleOverride})
      : textStyle = TextStyle(
          fontFamily: styleOverride?.fontFamily ?? LPFontFamily.body.name,
          color: styleOverride?.color ?? LPColorTheme.header4_grey.color,
          fontSize: styleOverride?.fontSize ?? 50,
          fontWeight: styleOverride?.fontWeight ?? FontWeight.w500,
          height: styleOverride?.height ?? 1.2,
        ),
        headerLevel = 3;

  LPFont.semanticTag1({this.textColor, TextStyle? styleOverride})
      : textStyle = TextStyle(
          fontFamily: styleOverride?.fontFamily ?? LPFontFamily.body.name,
          color: styleOverride?.color ?? LPColorTheme.standard_grey.color,
          fontSize: styleOverride?.fontSize ?? 20,
          fontWeight: styleOverride?.fontWeight ?? FontWeight.w300,
          letterSpacing: styleOverride?.letterSpacing ?? 1,
          height: styleOverride?.height ?? 1.4,
        ),
        headerLevel = 0;

  LPFont.body({this.textColor, TextStyle? styleOverride})
      : textStyle = TextStyle(
          fontFamily: styleOverride?.fontFamily ?? LPFontFamily.body.name,
          color: styleOverride?.color ?? LPColorTheme.standard_grey.color,
          fontSize: styleOverride?.fontSize ?? 24,
          fontWeight: styleOverride?.fontWeight ?? FontWeight.w300,
          letterSpacing: styleOverride?.letterSpacing ?? 1,
          height: styleOverride?.height ?? 1.4,
        ),
        headerLevel = 0;

  LPFont.bodyItalic({this.textColor, TextStyle? styleOverride})
      : textStyle = TextStyle(
          fontFamily: styleOverride?.fontFamily ?? LPFontFamily.body.name,
          color: styleOverride?.color ?? LPColorTheme.standard_grey.color,
          fontSize: styleOverride?.fontSize ?? 24,
          fontWeight: styleOverride?.fontWeight ?? FontWeight.w300,
          fontStyle: FontStyle.italic,
          letterSpacing: styleOverride?.letterSpacing ?? 1,
          height: styleOverride?.height ?? 1.4,
        ),
        headerLevel = 0;

  LPFont.buttonText({this.textColor, TextStyle? styleOverride})
      : textStyle = TextStyle(
          fontFamily: styleOverride?.fontFamily ?? LPFontFamily.body.name,
          color: styleOverride?.color ?? LPColorTheme.hyperlink_purple.color,
          fontSize: styleOverride?.fontSize ?? 20,
          fontWeight: styleOverride?.fontWeight ?? FontWeight.w500,
          letterSpacing: styleOverride?.letterSpacing ?? 1,
          overflow: TextOverflow.fade,
          height: styleOverride?.height ?? 1.4,
        ),
        headerLevel = 0;

  LPFont.verseQuote({this.textColor, TextStyle? styleOverride})
      : textStyle = TextStyle(
          fontFamily: styleOverride?.fontFamily ?? LPFontFamily.body.name,
          color: styleOverride?.color ?? LPColorTheme.lyrics_quote_red.color,
          fontSize: styleOverride?.fontSize ?? 34,
          fontWeight: styleOverride?.fontWeight ?? FontWeight.w400,
          letterSpacing: styleOverride?.letterSpacing ?? 1,
        ),
        headerLevel = 0;

  LPFont.verseQuoteItalic({this.textColor, TextStyle? styleOverride})
      : textStyle = TextStyle(
          fontFamily: styleOverride?.fontFamily ?? LPFontFamily.body.name,
          color: styleOverride?.color ?? LPColorTheme.lyrics_quote_red.color,
          fontSize: styleOverride?.fontSize ?? 34,
          fontWeight: styleOverride?.fontWeight ?? FontWeight.w400,
          fontStyle: FontStyle.italic,
          letterSpacing: styleOverride?.letterSpacing ?? 1,
        ),
        headerLevel = 0;

  LPFont.hyperlink({this.textColor, TextStyle? styleOverride})
      : textStyle = TextStyle(
          fontFamily: styleOverride?.fontFamily ?? LPFontFamily.body.name,
          color: styleOverride?.color ?? LPColorTheme.hyperlink_purple.color,
          fontSize: styleOverride?.fontSize ?? 26,
          fontWeight: styleOverride?.fontWeight ?? FontWeight.w300,
          letterSpacing: styleOverride?.letterSpacing ?? 1,
        ),
        headerLevel = 0;
}
