part of letterpress.views;

/// A full-viewport band that holds still while the reader scrolls past it.
///
/// The band reserves `1 + pinnedViewports` viewports of scroll extent and then
/// counteracts the scroll on its child, so the child stays put under the
/// reader's finger while [builder] is handed a progress value running 0..1.
/// Once that completes the child stops being held and scrolls away like any
/// other content, which is what keeps the page feeling like one continuous
/// scroll rather than a sequence of trapped screens.
///
/// The scroll offset is read straight off the controller rather than through a
/// notification, because a band that lags the scroll by even one frame reads as
/// broken.
class ScrollPinnedBand extends StatelessWidget {
  final ScrollController pageController;

  /// Scroll offset at which this band's top reaches the top of the viewport.
  final double startOffset;

  /// How much scrolling the band consumes beyond its own height.
  final double pinnedViewports;

  final Widget Function(BuildContext context, double progress) builder;

  /// Fires the first time progress reaches 1.
  final VoidCallback? onCompleted;

  const ScrollPinnedBand({
    required this.pageController,
    required this.startOffset,
    required this.pinnedViewports,
    required this.builder,
    this.onCompleted,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final LPViewportData vp = LPViewport.of(context);
    final Size size = vp.size;
    final double pinned = size.height * pinnedViewports;

    return SizedBox(
      width: size.width,
      height: size.height + pinned,
      child: AnimatedBuilder(
        animation: pageController,
        builder: (BuildContext context, Widget? _) {
          final double offset =
              pageController.hasClients ? pageController.offset : 0.0;
          final double held = (offset - startOffset).clamp(0.0, pinned);
          final double progress = pinned == 0 ? 0 : held / pinned;

          if (progress >= 1.0 && onCompleted != null) {
            // Deferred: this runs during build.
            WidgetsBinding.instance
                .addPostFrameCallback((_) => onCompleted!.call());
          }

          return Stack(
            clipBehavior: Clip.hardEdge,
            children: [
              Positioned(
                top: held,
                left: 0,
                right: 0,
                height: size.height,
                child: ClipRect(
                  child: SizedBox(
                    width: size.width,
                    height: size.height,
                    child: builder(context, progress),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
