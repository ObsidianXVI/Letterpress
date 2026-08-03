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

  /// On a phone the artwork rides up over the copy before anything else
  /// happens. Desktop has no such beat — the painting is already beside the
  /// copy, so the zoom starts immediately.
  static const double mobileSlideEnd = 0.34;

  static const double washStart = 0.30;
  static const double washEnd = 0.78;

  static const double titleStart = 0.60;
  static const double titleEnd = 0.88;

  static const double contentStart = 0.86;
  static const double contentEnd = 1.0;
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

  /// How much scrolling the transition consumes, in viewports. Mobile needs
  /// more because it has the artwork's climb to get through first.
  static double pinnedViewports(LPViewportData vp) =>
      vp.pick(mobile: 1.5, desktop: 1.0);

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

  /// Magnification needed for the bright opening to fill the width.
  ///
  /// The opening is roughly 80px across in the 588px-wide box the design draws
  /// the painting in, so the factor falls out of how large that box is rendered
  /// here. On desktop it works out constant; on a phone the painting is scaled
  /// to the viewport height instead, so it depends on the aspect.
  double _maxScale(LPViewportData vp) {
    final Size size = vp.size;
    final double renderedArtworkWidth = vp.isDesktop
        ? size.width * _AboutMetrics.imageWidth
        : size.height * _AboutMetrics.artworkAspect;
    final double openingWidth = (80 / 588) * renderedArtworkWidth;
    return (size.width / openingWidth).clamp(6.0, 26.0);
  }

  @override
  Widget build(BuildContext context) {
    final LPViewportData vp = LPViewport.of(context);
    final Size size = vp.size;

    final double slideEnd = vp.isMobile ? _Beat.mobileSlideEnd : 0.0;
    final double slide =
        vp.isMobile ? _segment(progress, 0.0, _Beat.mobileSlideEnd) : 0.0;

    // Everything after the climb runs on its own clock, so the beats below can
    // be written against a clean 0..1 regardless of platform.
    final double t = _segment(progress, slideEnd, 1.0);

    // Geometric, so the magnification feels like a constant rate of approach
    // rather than easing off as the numbers get large.
    final double zoom =
        math.pow(_maxScale(vp), Curves.easeInCubic.transform(t)).toDouble();

    final double wash = Curves.easeInOut
        .transform(_segment(t, _Beat.washStart, _Beat.washEnd));
    final double titleRise = 1 -
        Curves.easeOutCubic
            .transform(_segment(t, _Beat.titleStart, _Beat.titleEnd));
    final double content = Curves.easeIn
        .transform(_segment(t, _Beat.contentStart, _Beat.contentEnd));

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
