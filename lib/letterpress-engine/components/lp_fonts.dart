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

  LPFont.mainTitle({this.textColor})
      : textStyle = TextStyle(
          fontFamily: LPFontFamily.headers.name,
          color: textColor ?? LPColorTheme.standard_grey.color,
          fontSize: 130,
          fontWeight: FontWeight.w300,
          height: 0.75,
        ),
        headerLevel = 0;

  LPFont.subTitle({this.textColor})
      : textStyle = TextStyle(
          fontFamily: LPFontFamily.headers.name,
          color: textColor ?? LPColorTheme.standard_grey.color,
          fontSize: 100,
          fontWeight: FontWeight.w600,
          height: 0.75,
        ),
        headerLevel = -1;

  LPFont.header1({this.textColor})
      : textStyle = TextStyle(
          fontFamily: LPFontFamily.headers.name,
          color: textColor ?? LPColorTheme.header1_grey.color,
          fontSize: 120,
          fontWeight: FontWeight.w900,
          height: 0.75,
        ),
        headerLevel = 1;

  LPFont.header2({this.textColor})
      : textStyle = TextStyle(
          fontFamily: LPFontFamily.headers.name,
          color: textColor ?? LPColorTheme.header2_grey.color,
          fontSize: 100,
          fontWeight: FontWeight.w900,
          height: 0.75,
        ),
        headerLevel = 2;

  LPFont.header3({this.textColor})
      : textStyle = TextStyle(
          fontFamily: LPFontFamily.headers.name,
          color: textColor ?? LPColorTheme.header3_grey.color,
          fontSize: 80,
          fontWeight: FontWeight.w600,
          height: 0.75,
        ),
        headerLevel = 3;

  LPFont.header4({this.textColor})
      : textStyle = TextStyle(
          fontFamily: LPFontFamily.body.name,
          color: textColor ?? LPColorTheme.header4_grey.color,
          fontSize: 50,
          fontWeight: FontWeight.w500,
          height: 0.75,
        ),
        headerLevel = 3;

  LPFont.body({this.textColor})
      : textStyle = TextStyle(
          fontFamily: LPFontFamily.body.name,
          color: textColor ?? LPColorTheme.standard_grey.color,
          fontSize: 24,
          fontWeight: FontWeight.w300,
          letterSpacing: 1,
          height: 1.4,
        ),
        headerLevel = 0;

  LPFont.bodyItalic({this.textColor})
      : textStyle = TextStyle(
          fontFamily: LPFontFamily.body.name,
          color: textColor ?? LPColorTheme.standard_grey.color,
          fontSize: 24,
          fontWeight: FontWeight.w300,
          fontStyle: FontStyle.italic,
          letterSpacing: 1,
          height: 1.4,
        ),
        headerLevel = 0;

  LPFont.buttonText({this.textColor})
      : textStyle = TextStyle(
          fontFamily: LPFontFamily.body.name,
          color: textColor ?? LPColorTheme.hyperlink_purple.color,
          fontSize: 20,
          fontWeight: FontWeight.w500,
          letterSpacing: 1,
          overflow: TextOverflow.fade,
          height: 1.4,
        ),
        headerLevel = 0;

  LPFont.verseQuote({this.textColor})
      : textStyle = TextStyle(
          fontFamily: LPFontFamily.body.name,
          color: textColor ?? LPColorTheme.lyrics_quote_red.color,
          fontSize: 34,
          fontWeight: FontWeight.w400,
          letterSpacing: 1,
        ),
        headerLevel = 0;

  LPFont.verseQuoteItalic({this.textColor})
      : textStyle = TextStyle(
          fontFamily: LPFontFamily.body.name,
          color: textColor ?? LPColorTheme.lyrics_quote_red.color,
          fontSize: 34,
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.italic,
          letterSpacing: 1,
        ),
        headerLevel = 0;

  LPFont.hyperlink({this.textColor})
      : textStyle = TextStyle(
          fontFamily: LPFontFamily.body.name,
          color: textColor ?? LPColorTheme.hyperlink_purple.color,
          fontSize: 26,
          fontWeight: FontWeight.w300,
          letterSpacing: 1,
        ),
        headerLevel = 0;
}
