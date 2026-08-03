part of letterpress.views;

/// One newsletter cover on the ring, resolved for a given rotation.
class _Orbiter {
  /// Where its centre sits in the band.
  final Offset centre;

  /// Depth, -1 at the far side of the ring and +1 at the near side. Decides
  /// scale, opacity, whether it passes in front of the word, and paint order
  /// within its own group.
  final double depth;

  /// How far the cover has turned away from the reader, in radians.
  final double turn;

  const _Orbiter({
    required this.centre,
    required this.depth,
    required this.turn,
  });
}

/// The Newsletters band: covers orbiting the word itself.
///
/// The sketch reads as a ring seen almost edge-on — covers running left to
/// right across the top, dropping away at the right, and coming back along the
/// bottom — with the word sitting on the ring's axis so that the near half of
/// the ring passes in front of it and the far half behind. Scrolling turns the
/// ring anti-clockwise, so covers rise on one side and sink on the other rather
/// than merely sliding past.
///
/// Depth does all the work: it sets each cover's size, its opacity, the amount
/// it is turned away from the reader, and — the part that sells it — which side
/// of the word it is painted on.
class NewslettersSpiral extends StatelessWidget {
  final ScrollController pageController;

  /// Scroll offset at which this band's top reaches the top of the viewport.
  final double startOffset;

  /// Placeholder covers, until real cover artwork exists.
  final int coverCount;

  const NewslettersSpiral({
    required this.pageController,
    required this.startOffset,
    this.coverCount = 9,
    super.key,
  });

  /// How much scrolling the band consumes beyond its own height.
  static const double pinnedViewports = 1.4;

  /// Fraction of a full revolution the ring makes across that scroll. Less than
  /// one, so no cover returns to where it started and the movement stays
  /// legible as rotation rather than looping.
  static const double revolutions = 0.8;

  @override
  Widget build(BuildContext context) {
    return ScrollPinnedBand(
      pageController: pageController,
      startOffset: startOffset,
      pinnedViewports: pinnedViewports,
      builder: (BuildContext context, double progress) =>
          _SpiralStage(progress: progress, coverCount: coverCount),
    );
  }
}

class _SpiralStage extends StatelessWidget {
  final double progress;
  final int coverCount;

  const _SpiralStage({required this.progress, required this.coverCount});

  /// Newsletter covers are US Letter, as the templates in the Figma file are.
  static const double coverAspect = 612 / 792;

  @override
  Widget build(BuildContext context) {
    final LPViewportData vp = LPViewport.of(context);
    final Size size = vp.size;

    final Offset centre = Offset(size.width * 0.5, size.height * 0.5);
    final double radiusX = size.width * vp.pick(mobile: 0.40, desktop: 0.34);
    final double radiusY = size.height * vp.pick(mobile: 0.26, desktop: 0.30);

    // Screen y runs downwards, so a plain increasing angle would sweep
    // clockwise. Subtracting the rotation turns the ring the other way.
    final double rotation = progress * 2 * math.pi * NewslettersSpiral.revolutions;

    final List<_Orbiter> orbiters = List<_Orbiter>.generate(coverCount, (int i) {
      final double theta = (2 * math.pi * i / coverCount) - rotation;
      return _Orbiter(
        centre: Offset(
          centre.dx + radiusX * math.cos(theta),
          centre.dy + radiusY * math.sin(theta),
        ),
        // Bottom of the ellipse is the near side, so sin is the depth.
        depth: math.sin(theta),
        // Most turned away at the sides, square-on at front and back.
        turn: -0.6 * math.cos(theta),
      );
    });

    // Painter's algorithm: far covers first, then the word, then near covers.
    final List<_Orbiter> behind = orbiters.where((o) => o.depth < 0).toList()
      ..sort((a, b) => a.depth.compareTo(b.depth));
    final List<_Orbiter> inFront = orbiters.where((o) => o.depth >= 0).toList()
      ..sort((a, b) => a.depth.compareTo(b.depth));

    final double baseWidth =
        size.width * vp.pick(mobile: 0.30, desktop: 0.15);

    Widget cover(_Orbiter o) => _CoverThumbnail(
          orbiter: o,
          baseWidth: baseWidth,
          aspect: coverAspect,
        );

    return ColoredBox(
      color: LPColor.inkBlue_500,
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          ...behind.map(cover),
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: size.width * _AboutMetrics.padLeft,
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'Newsletters',
                  maxLines: 1,
                  style: sectionTitle.apply(
                    const TextStyle(color: LPColor.rollerBlue_500),
                  ),
                ),
              ),
            ),
          ),
          ...inFront.map(cover),
        ],
      ),
    );
  }
}

/// A single orbiting cover.
///
/// A flat fill for now — these stand in for real cover artwork, so the shape,
/// depth and movement are what matter here rather than what is printed on them.
class _CoverThumbnail extends StatelessWidget {
  final _Orbiter orbiter;
  final double baseWidth;
  final double aspect;

  const _CoverThumbnail({
    required this.orbiter,
    required this.baseWidth,
    required this.aspect,
  });

  @override
  Widget build(BuildContext context) {
    final double near = (orbiter.depth + 1) / 2;
    final double scale = 0.70 + 0.42 * near;
    final double width = baseWidth * scale;
    final double height = width / aspect;

    return Positioned(
      left: orbiter.centre.dx - width / 2,
      top: orbiter.centre.dy - height / 2,
      width: width,
      height: height,
      child: Opacity(
        opacity: 0.45 + 0.55 * near,
        child: Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            // Mild perspective, so a cover turning away foreshortens rather
            // than merely squashing.
            ..setEntry(3, 2, 0.0014)
            ..rotateY(orbiter.turn),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: LPColor.rollerBlue_500,
              borderRadius: BorderRadius.circular(3),
              border: Border.all(
                color: LPColor.gripperBlue_500.withOpacity(0.45),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
