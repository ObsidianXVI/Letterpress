part of letterpress.views;

/// Where each beat of the transition begins and ends, as a fraction of the
/// pinned scroll distance.
///
/// They overlap on purpose. The wash is already coming up while the zoom is
/// still accelerating, so the magnified brushwork never gets a chance to look
/// like a magnified image; the heading starts its climb before the wash has
/// finished, so the two read as one movement rather than two.
class _Beat {
  const _Beat._();

  /// Nothing moves for the first stretch. The reader has just arrived at the
  /// About band and should get to read it, rather than have it start dissolving
  /// the moment they touch the wheel.
  static const double holdEnd = 0.12;

  /// On a phone the artwork rides up over the copy before anything else
  /// happens. Desktop has no such beat — the painting is already beside the
  /// copy, so the zoom follows the hold directly.
  static const double mobileSlideEnd = 0.30;

  /// The zoom runs to completion — the bright opening ends up filling the
  /// frame on its own, before any paint is laid over it.
  static const double zoomEnd = 0.58;

  /// Which is why the wash only starts near the end of the zoom: by then most
  /// of the viewport is already the window's light, and the wash is finishing
  /// a job the zoom has almost done rather than hiding it.
  static const double washStart = 0.50;
  static const double washEnd = 0.62;

  /// The heading only begins once the frame is genuinely white.
  static const double titleStart = 0.64;
  static const double titleEnd = 0.84;

  static const double contentStart = 0.84;

  /// Everything is in place well before the end, and the remaining scroll is a
  /// deliberate tail: Discover stays assembled and pinned so the section can be
  /// taken in, and only then does the page start moving again.
  static const double contentEnd = 0.94;
}

/// Maps [t] onto 0..1 across the window [start]..[end].
double _segment(double t, double start, double end) =>
    ((t - start) / (end - start)).clamp(0.0, 1.0);

/// The scroll-driven passage from the About band into Discover.
///
/// The band is pinned for a stretch of scrolling rather than sliding past. The
/// widget reserves `1 + pinnedViewports` viewports of scroll extent and then
/// counteracts the scroll on its child, so the child holds still under the
/// reader's finger while the progress runs 0..1; once it completes, the child
/// stops being held and scrolls away like anything else.
///
/// The conceit is that the reader falls through the painting's open window: the
/// viewport magnifies towards the bright opening beside her head until that
/// light is all there is, and the light turns out to be Discover's ground.
/// That is why the wash is the painting's own white rather than a flat fill
/// laid over the top, and why the artwork credit is the one thing that never
/// moves.
class AboutDiscoverTransition extends StatelessWidget {
  /// Drives everything. The transition reads its offset directly rather than
  /// using a notification, because it has to stay exactly in step with the
  /// scroll and cannot afford to lag a frame behind.
  final ScrollController pageController;

  /// Scroll offset at which this band's top reaches the top of the viewport.
  final double startOffset;

  final ScrollController carouselController;
  final List<Widget> Function(double? maxHeight) discoverItems;

  /// Fires the first time the transition completes, so the carousel's drift
  /// starts when the reader can actually see it.
  final VoidCallback? onRevealed;

  const AboutDiscoverTransition({
    required this.pageController,
    required this.startOffset,
    required this.carouselController,
    required this.discoverItems,
    this.onRevealed,
    super.key,
  });

  /// How much scrolling the transition consumes, in viewports.
  ///
  /// Generous on purpose: the sequence has a hold at each end and four beats in
  /// between, and each one needs enough scroll that it reads as a movement
  /// rather than a jump. Mobile gets more again because it has the artwork's
  /// climb to get through first.
  static double pinnedViewports(LPViewportData vp) =>
      vp.pick(mobile: 3.2, desktop: 2.4);

  @override
  Widget build(BuildContext context) {
    return ScrollPinnedBand(
      pageController: pageController,
      startOffset: startOffset,
      pinnedViewports: pinnedViewports(LPViewport.of(context)),
      onCompleted: onRevealed,
      builder: (BuildContext context, double progress) => _TransitionStage(
        progress: progress,
        carouselController: carouselController,
        discoverItems: discoverItems,
      ),
    );
  }
}

class _TransitionStage extends StatelessWidget {
  final double progress;
  final ScrollController carouselController;
  final List<Widget> Function(double? maxHeight) discoverItems;

  const _TransitionStage({
    required this.progress,
    required this.carouselController,
    required this.discoverItems,
  });

  /// Where the focal point sits within the band, as an [Alignment].
  ///
  /// Desktop puts the painting in the right-hand column, so the point has to be
  /// mapped through that column's position. On a phone the painting is
  /// full-bleed and cover crops its sides, so the horizontal mapping has to
  /// account for the part of the image hanging off either edge.
  Alignment _focal(LPViewportData vp) {
    final Size size = vp.size;
    final double fy = _AboutMetrics.focalY;

    if (vp.isDesktop) {
      final double fx = (1 - _AboutMetrics.imageWidth) +
          _AboutMetrics.imageWidth * _AboutMetrics.focalX;
      return Alignment(fx * 2 - 1, fy * 2 - 1);
    }

    final double renderedWidth = size.height * _AboutMetrics.artworkAspect;
    final double fx =
        0.5 + (_AboutMetrics.focalX - 0.5) * (renderedWidth / size.width);
    return Alignment(fx * 2 - 1, fy * 2 - 1);
  }

  /// Magnification needed for the bright opening to fill the frame entirely.
  ///
  /// The opening — the lit pane beside her head — measures roughly 70x170 in
  /// the 588x832 box the design draws the painting in. Both dimensions have to
  /// be satisfied, not just the width, or the zoom stops with the window frame
  /// still showing down the sides on a tall viewport.
  double _maxScale(LPViewportData vp) {
    final Size size = vp.size;

    // On desktop the painting occupies the right-hand column; on a phone it is
    // scaled to the viewport height and cropped at the sides.
    final double artworkWidth = vp.isDesktop
        ? size.width * _AboutMetrics.imageWidth
        : size.height * _AboutMetrics.artworkAspect;
    final double artworkHeight = size.height;

    final double openingWidth = (70 / 588) * artworkWidth;
    final double openingHeight = (170 / 832) * artworkHeight;

    return math
        .max(size.width / openingWidth, size.height / openingHeight)
        .clamp(6.0, 40.0);
  }

  @override
  Widget build(BuildContext context) {
    final LPViewportData vp = LPViewport.of(context);
    final Size size = vp.size;

    // The artwork's climb, on a phone, sits between the opening hold and the
    // zoom. On desktop that beat does not exist.
    final double slide = vp.isMobile
        ? Curves.easeInOut.transform(
            _segment(progress, _Beat.holdEnd, _Beat.mobileSlideEnd))
        : 0.0;

    final double zoomStart =
        vp.isMobile ? _Beat.mobileSlideEnd : _Beat.holdEnd;

    // The exponent runs linearly, so the magnification advances at a constant
    // perceived rate. Easing it made the zoom back-loaded — by the point the
    // wash began, the image had barely moved, and the effect read as a plain
    // cross-fade rather than an approach.
    final double zoom = math
        .pow(_maxScale(vp), _segment(progress, zoomStart, _Beat.zoomEnd))
        .toDouble();

    final double wash = Curves.easeInOut
        .transform(_segment(progress, _Beat.washStart, _Beat.washEnd));
    final double titleRise = 1 -
        Curves.easeOutCubic
            .transform(_segment(progress, _Beat.titleStart, _Beat.titleEnd));
    final double content = Curves.easeIn
        .transform(_segment(progress, _Beat.contentStart, _Beat.contentEnd));

    return SizedBox(
        width: size.width,
        height: size.height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // The painting, magnified towards the window.
            RepaintBoundary(
              child: Transform.scale(
                scale: zoom,
                alignment: _focal(vp),
                filterQuality: FilterQuality.medium,
                child: _AboutSection(artworkSlide: slide),
              ),
            ),

            // The light coming through the window, taking over the frame.
            if (wash > 0)
              IgnorePointer(
                child: ColoredBox(
                  color: LPColor.platenWhite_500.withOpacity(wash),
                  child: const SizedBox.expand(),
                ),
              ),

            // Discover assembling on top of that light. Its own background is
            // suppressed — the wash beneath is already the right colour, and
            // painting it again would cut the zoom off early.
            if (titleRise < 1 || content > 0)
              _DiscoverSection(
                controller: carouselController,
                itemBuilder: discoverItems,
                titleRise: titleRise,
                contentOpacity: content,
                paintBackground: false,
              ),
          ],
        ));
  }
}
