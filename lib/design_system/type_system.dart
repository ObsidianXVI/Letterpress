part of letterpress.ds;

/// The site's typefaces.
///
/// These are getters, not `final` fields, on purpose. A [ResponsiveTypeface]
/// evaluates `scaled()` — and therefore the current viewport width — inside its
/// constructor, so a cached instance keeps handing out the font sizes that were
/// correct when it was first touched. Since [LPStore] is itself a `static
/// final`, caching here would freeze every article's typography at whatever
/// size the very first page load happened to use. Rebuilding the typeface on
/// each read costs a two-entry map and keeps the sizes truthful.
ResponsiveTypeface get heroTitle => HeroTitle();
ResponsiveTypeface get sectionTitle => SectionTitle();
ResponsiveTypeface get pieceTitle => PieceTitle();
ResponsiveTypeface get bigFunky => BigFunky();
ResponsiveTypeface get mediumFunky => MediumFunky();
ResponsiveTypeface get body => BodyB1();
ResponsiveTypeface get body2 => BodyB2();
ResponsiveTypeface get header1 => Header1();
ResponsiveTypeface get header2 => Header2();
ResponsiveTypeface get header3 => Header3();
ResponsiveTypeface get verseQuote => VerseQuote();
ResponsiveTypeface get semanticTag => body;
ResponsiveTypeface get code => Code();

/// Font size scaled to the viewport, with the scale factor clamped.
///
/// Redline's `scaled` multiplies by `viewportWidth / platformBaseWidth` with no
/// bound. That was survivable while each platform matched a narrow band of
/// widths, but the mobile layout now covers everything below 900px and the
/// desktop layout everything above it, so an unclamped ratio would render body
/// text at 47px on a 900px window and at 43px on a 2560px monitor.
///
/// Clamping keeps type responsive across a band without letting it run away at
/// the extremes. [min] is a floor on the resulting size, matching the second
/// argument of `scaled`.
double lpScaled(double baseSize, {double min = 0}) {
  const double minRatio = 0.9;
  const double maxRatio = 1.15;
  final double ratio =
      Multiplatform.currentPlatform.widthRatio.clamp(minRatio, maxRatio);
  return math.max(baseSize * ratio, min);
}


class HeroTitle extends ResponsiveTypeface {
  HeroTitle() {
    styleDelegates.addAll({
      const DesktopPlatform(): TextStyle(
        color: LPColor.inkBlue_500,
        fontSize: lpScaled(340, min: 200),
        fontWeight: FontWeight.w900,
        height: 0.76,
      ),
      const MobilePlatform(): TextStyle(
        color: LPColor.inkBlue_500,
        fontSize: lpScaled(130, min: 80),
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
        fontSize: lpScaled(160, min: 130),
        fontWeight: FontWeight.w300,
        height: 0.76,
      ),
      const MobilePlatform(): TextStyle(
        fontSize: lpScaled(60, min: 44),
        fontWeight: FontWeight.w300,
        height: 0.76,
      ),
    });
  }
}

class DialogTitle extends ResponsiveTypeface {
  DialogTitle() {
    styleDelegates.addAll({
      const DesktopPlatform(): TextStyle(
        fontSize: lpScaled(100, min: 80),
        fontWeight: FontWeight.w300,
        height: 0.76,
      ),
      const MobilePlatform(): TextStyle(
        fontSize: lpScaled(40, min: 32),
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
        fontSize: lpScaled(100, min: 80),
        fontWeight: FontWeight.w900,
        height: 0.76,
      ),
      const MobilePlatform(): TextStyle(
        fontSize: lpScaled(46, min: 36),
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
        fontSize: lpScaled(120, min: 90),
        fontWeight: FontWeight.w900,
        height: 0.76,
      ),
      const MobilePlatform(): TextStyle(
        fontSize: lpScaled(52, min: 40),
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
        fontSize: lpScaled(90, min: 70),
        fontWeight: FontWeight.w600,
        height: 0.76,
        color: LPColor.gripperBlue_400,
      ),
      const MobilePlatform(): TextStyle(
        fontSize: lpScaled(40, min: 30),
        fontWeight: FontWeight.w600,
        height: 0.76,
        color: LPColor.gripperBlue_400,
      ),
    });
  }
}

class Header1 extends ResponsiveTypeface {
  Header1() {
    styleDelegates.addAll({
      const DesktopPlatform(): TextStyle(
        fontSize: lpScaled(120, min: 100),
        fontWeight: FontWeight.w900,
        height: 1.2,
        color: LPColor.gripperBlue_500,
      ),
      const MobilePlatform(): TextStyle(
        fontSize: lpScaled(44, min: 34),
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
        fontSize: lpScaled(80, min: 60),
        fontWeight: FontWeight.w600,
        height: 1.2,
        color: LPColor.gripperBlue_400,
      ),
      const MobilePlatform(): TextStyle(
        fontSize: lpScaled(34, min: 26),
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
        fontSize: lpScaled(50, min: 40),
        fontWeight: FontWeight.w400,
        height: 0.9,
        color: LPColor.rollerBlue_500,
        fontStyle: FontStyle.italic,
      ),
      const MobilePlatform(): TextStyle(
        fontSize: lpScaled(24, min: 18),
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
        fontSize: lpScaled(26, min: 20),
        fontWeight: FontWeight.w400,
        fontVariations: const [ui.FontVariation.opticalSize(24)],
        height: 1.35,
        color: LPColor.chaseRed_500,
        fontFamily: 'Fraunces_Soft',
      ),
      const MobilePlatform(): TextStyle(
        fontSize: lpScaled(22, min: 18),
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
        fontSize: lpScaled(24, min: 20),
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        fontVariations: const [ui.FontVariation.opticalSize(24)],
        height: 1.4,
        fontFamily: 'Fraunces_Soft',
      ),
      const MobilePlatform(): TextStyle(
        letterSpacing: 0.5,
        fontSize: lpScaled(19, min: 16),
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

class BodyB2 extends ResponsiveTypeface {
  BodyB2() {
    styleDelegates.addAll({
      const DesktopPlatform(): TextStyle(
        fontSize: lpScaled(20, min: 16),
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        fontVariations: const [ui.FontVariation.opticalSize(24)],
        height: 1.4,
        fontFamily: 'Fraunces_Soft',
      ),
      const MobilePlatform(): TextStyle(
        letterSpacing: 0.5,
        fontSize: lpScaled(16, min: 13),
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

class Code extends ResponsiveTypeface {
  Code() {
    styleDelegates.addAll({
      const DesktopPlatform(): TextStyle(
        fontSize: lpScaled(20, min: 18),
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        fontVariations: const [ui.FontVariation.opticalSize(24)],
        height: 1.4,
        fontFamily: 'IBM_Plex_Mono',
      ),
      const MobilePlatform(): TextStyle(
        letterSpacing: 0.5,
        fontSize: lpScaled(16, min: 13),
        fontWeight: FontWeight.w400,
        fontVariations: const [
          ui.FontVariation.opticalSize(24),
        ],
        height: 1.37,
        fontFamily: 'IBM_Plex_Mono',
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