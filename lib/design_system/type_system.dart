part of letterpress.ds;

final ResponsiveTypeface heroTitle = HeroTitle();
final ResponsiveTypeface sectionTitle = SectionTitle();
final ResponsiveTypeface pieceTitle = PieceTitle();
final ResponsiveTypeface bigFunky = BigFunky();
final ResponsiveTypeface mediumFunky = MediumFunky();
final ResponsiveTypeface body = BodyB1();

class HeroTitle extends ResponsiveTypeface {
  HeroTitle() {
    styleDelegates.addAll({
      const DesktopPlatform(): TextStyle(
        fontSize: scaled(340, 200),
        fontWeight: FontWeight.w900,
        height: 0.76,
      ),
      const MobilePlatform(): TextStyle(
        fontSize: scaled(70, 68),
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

class BodyB1 extends ResponsiveTypeface {
  BodyB1() {
    styleDelegates.addAll({
      const DesktopPlatform(): TextStyle(
        fontSize: scaled(24, 20),
        fontWeight: FontWeight.w400,
        fontVariations: const [ui.FontVariation.opticalSize(24)],
        height: 1.35,
      ),
      const MobilePlatform(): TextStyle(
        fontSize: scaled(24, 20),
        fontWeight: FontWeight.w400,
        fontVariations: const [
          ui.FontVariation.opticalSize(24),
        ],
        height: 1.35,
      ),
    });
  }
}
