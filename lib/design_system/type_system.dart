part of letterpress.ds;

final ResponsiveTypeface heroTitle = HeroTitle();
final ResponsiveTypeface sectionTitle = SectionTitle();
final ResponsiveTypeface pieceTitle = PieceTitle();
final ResponsiveTypeface bigFunky = BigFunky();
final ResponsiveTypeface mediumFunky = MediumFunky();
final ResponsiveTypeface body = BodyB1();
final ResponsiveTypeface header1 = Header1();
final ResponsiveTypeface header2 = Header2();
final ResponsiveTypeface header3 = Header3();
final ResponsiveTypeface verseQuote = VerseQuote();
final ResponsiveTypeface semanticTag = body;

class HeroTitle extends ResponsiveTypeface {
  HeroTitle() {
    styleDelegates.addAll({
      const DesktopPlatform(): TextStyle(
        color: LPColor.inkBlue_500,
        fontSize: scaled(340, 200),
        fontWeight: FontWeight.w900,
        height: 0.76,
      ),
      const MobilePlatform(): TextStyle(
        color: LPColor.inkBlue_500,
        fontSize: scaled(200, 68),
        fontWeight: FontWeight.w900,
        height: 0.76,
      ),
    });
  }
}

class SectionTitle extends ResponsiveTypeface {
  SectionTitle() {
    styleDelegates.addAll({
      const DesktopPlatform(): TextStyle(
        fontSize: scaled(160, 130),
        fontWeight: FontWeight.w300,
        height: 0.76,
      ),
      const MobilePlatform(): TextStyle(
        fontSize: scaled(80, 68),
        fontWeight: FontWeight.w300,
        height: 0.76,
      ),
    });
  }
}

class BigFunky extends ResponsiveTypeface {
  BigFunky() {
    styleDelegates.addAll({
      const DesktopPlatform(): TextStyle(
        fontSize: scaled(100, 80),
        fontWeight: FontWeight.w900,
        height: 0.76,
      ),
      const MobilePlatform(): TextStyle(
        fontSize: scaled(70, 65),
        fontWeight: FontWeight.w900,
        height: 0.76,
      ),
    });
  }
}

class MediumFunky extends ResponsiveTypeface {
  MediumFunky() {
    styleDelegates.addAll({
      const DesktopPlatform(): TextStyle(
        fontSize: scaled(120, 90),
        fontWeight: FontWeight.w900,
        height: 0.76,
      ),
      const MobilePlatform(): TextStyle(
        fontSize: scaled(90, 84),
        fontWeight: FontWeight.w900,
        height: 0.76,
      ),
    });
  }
}

class PieceTitle extends ResponsiveTypeface {
  PieceTitle() {
    styleDelegates.addAll({
      const DesktopPlatform(): TextStyle(
        fontSize: scaled(90, 70),
        fontWeight: FontWeight.w600,
        height: 0.76,
      ),
      const MobilePlatform(): TextStyle(
        fontSize: scaled(50, 36),
        fontWeight: FontWeight.w600,
        height: 0.76,
      ),
    });
  }
}

class Header1 extends ResponsiveTypeface {
  Header1() {
    styleDelegates.addAll({
      const DesktopPlatform(): TextStyle(
        fontSize: scaled(120, 100),
        fontWeight: FontWeight.w900,
        height: 1.2,
        color: LPColor.gripperBlue_500,
      ),
      const MobilePlatform(): TextStyle(
        fontSize: scaled(80, 70),
        fontWeight: FontWeight.w900,
        height: 1.2,
        color: LPColor.gripperBlue_500,
      ),
    });
  }
}

class Header2 extends ResponsiveTypeface {
  Header2() {
    styleDelegates.addAll({
      const DesktopPlatform(): TextStyle(
        fontSize: scaled(80, 60),
        fontWeight: FontWeight.w600,
        height: 1.2,
        color: LPColor.gripperBlue_400,
      ),
      const MobilePlatform(): TextStyle(
        fontSize: scaled(50, 40),
        fontWeight: FontWeight.w600,
        height: 1.2,
        color: LPColor.gripperBlue_400,
      ),
    });
  }
}

class Header3 extends ResponsiveTypeface {
  Header3() {
    styleDelegates.addAll({
      const DesktopPlatform(): TextStyle(
        fontSize: scaled(50, 40),
        fontWeight: FontWeight.w400,
        height: 0.9,
        color: LPColor.rollerBlue_500,
        fontStyle: FontStyle.italic,
      ),
      const MobilePlatform(): TextStyle(
        fontSize: scaled(30, 20),
        fontWeight: FontWeight.w400,
        height: 0.9,
        color: LPColor.rollerBlue_500,
        fontStyle: FontStyle.italic,
      ),
    });
  }
}

class VerseQuote extends ResponsiveTypeface {
  VerseQuote() {
    styleDelegates.addAll({
      const DesktopPlatform(): TextStyle(
        fontSize: scaled(26, 20),
        fontWeight: FontWeight.w400,
        fontVariations: const [ui.FontVariation.opticalSize(24)],
        height: 1.35,
        color: LPColor.chaseRed_500,
        fontFamily: 'Fraunces_Soft',
      ),
      const MobilePlatform(): TextStyle(
        fontSize: scaled(26, 20),
        fontWeight: FontWeight.w400,
        fontVariations: const [
          ui.FontVariation.opticalSize(24),
        ],
        color: LPColor.chaseRed_500,
        height: 1.35,
        fontFamily: 'Fraunces_Soft',
      ),
    });
  }
}

class BodyB1 extends ResponsiveTypeface {
  BodyB1() {
    styleDelegates.addAll({
      const DesktopPlatform(): TextStyle(
        fontSize: scaled(24, 20),
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        fontVariations: const [ui.FontVariation.opticalSize(24)],
        height: 1.4,
        fontFamily: 'Fraunces_Soft',
      ),
      const MobilePlatform(): TextStyle(
        letterSpacing: 0.5,
        fontSize: scaled(22, 20),
        fontWeight: FontWeight.w400,
        fontVariations: const [
          ui.FontVariation.opticalSize(24),
        ],
        height: 1.37,
        fontFamily: 'Fraunces_Soft',
      ),
    });
  }
}



/**
 * class LPFont {
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

 */