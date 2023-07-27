part of letterpress.ds;

enum LPFontFamily {
  headers('Fraunces_Standard'),
  body('Fraunces_Soft');

  final String name;
  const LPFontFamily(this.name);
}

enum LPColorTheme {
  background_grey(LPTheme.grey800),
  standard_grey(LPTheme.grey200),
  header1_grey(LPTheme.grey400),
  header2_grey(LPTheme.grey500),
  header3_grey(LPTheme.grey600),
  hyperlink_purple(LPTheme.purple800),
  inline_code_cyan(LPTheme.blue800),
  lyrics_quote_red(LPTheme.red800),
  ;

  final Color color;
  const LPColorTheme(this.color);
}

class LPFont {
  final TextStyle textStyle;
  final int headerLevel;

  LPFont.postClassTitle()
      : textStyle = TextStyle(
          fontFamily: LPFontFamily.headers.name,
          color: LPColorTheme.standard_grey.color,
          fontSize: 100,
          fontWeight: FontWeight.w400,
          height: 1.2,
        ),
        headerLevel = -1;

  LPFont.title()
      : textStyle = TextStyle(
          fontFamily: LPFontFamily.headers.name,
          color: LPColorTheme.standard_grey.color,
          fontSize: 130,
          fontWeight: FontWeight.w200,
          height: 1.2,
        ),
        headerLevel = 0;

  LPFont.header1()
      : textStyle = TextStyle(
          fontFamily: LPFontFamily.headers.name,
          color: LPColorTheme.header1_grey.color,
          fontSize: 120,
          fontWeight: FontWeight.w600,
        ),
        headerLevel = 1;

  LPFont.header2()
      : textStyle = TextStyle(
          fontFamily: LPFontFamily.headers.name,
          color: Color.fromARGB(255, 85, 85, 85),
          fontSize: 100,
          fontWeight: FontWeight.w500,
        ),
        headerLevel = 2;

  LPFont.header3()
      : textStyle = TextStyle(
          fontFamily: LPFontFamily.headers.name,
          color: Color.fromARGB(255, 65, 65, 65),
          fontSize: 80,
          fontWeight: FontWeight.w400,
        ),
        headerLevel = 3;

  LPFont.body()
      : textStyle = TextStyle(
          fontFamily: LPFontFamily.body.name,
          color: LPColorTheme.standard_grey.color,
          fontSize: 26,
          fontWeight: FontWeight.w300,
          letterSpacing: 1,
        ),
        headerLevel = 0;

  LPFont.bodyItalic()
      : textStyle = TextStyle(
          fontFamily: LPFontFamily.body.name,
          color: LPColorTheme.standard_grey.color,
          fontSize: 26,
          fontWeight: FontWeight.w300,
          fontStyle: FontStyle.italic,
          letterSpacing: 1,
        ),
        headerLevel = 0;

  LPFont.buttonText()
      : textStyle = TextStyle(
          fontFamily: LPFontFamily.body.name,
          color: LPColorTheme.standard_grey.color,
          fontSize: 26,
          fontWeight: FontWeight.w300,
          letterSpacing: 1,
          overflow: TextOverflow.fade,
        ),
        headerLevel = 0;

  LPFont.verseQuote()
      : textStyle = TextStyle(
          fontFamily: LPFontFamily.body.name,
          color: LPColorTheme.lyrics_quote_red.color,
          fontSize: 34,
          fontWeight: FontWeight.w400,
          letterSpacing: 1,
        ),
        headerLevel = 0;

  LPFont.verseQuoteItalic()
      : textStyle = TextStyle(
          fontFamily: LPFontFamily.body.name,
          color: LPColorTheme.lyrics_quote_red.color,
          fontSize: 34,
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.italic,
          letterSpacing: 1,
        ),
        headerLevel = 0;

  LPFont.hyperlink()
      : textStyle = TextStyle(
          fontFamily: LPFontFamily.body.name,
          color: LPColorTheme.hyperlink_purple.color,
          fontSize: 26,
          fontWeight: FontWeight.w300,
          letterSpacing: 1,
        ),
        headerLevel = 0;
}
