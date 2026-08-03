part of letterpress.views;

/// Proportions from the `Newsletters` Figma frame (node 102:12), drawn on the
/// same 1280-wide canvas as the rest of the home page.
class _NewsletterIndexMetrics {
  const _NewsletterIndexMetrics._();

  static const double frameWidth = 1280;

  /// Issue covers are 248x321 at 60 apart, which is the same US Letter aspect
  /// the ring uses.
  static const double coverWidth = 248 / frameWidth;
  static const double coverGap = 60 / frameWidth;

  /// Subheading baseline to the top of its row of covers.
  static const double headingToCovers = 78 / frameWidth;

  /// Bottom of a row of covers to the next subheading.
  static const double coversToNextHeading = 118 / frameWidth;
}

/// The list of newsletters beneath the rotating ring.
///
/// One block per masthead: its name, a mail button to subscribe to it, and a
/// row of its issue covers. Unlike the ring above, this scrolls with the page —
/// it is a directory, and pinning it would only get in the way of reading it.
class NewslettersIndex extends StatelessWidget {
  final List<LPNewsletter> newsletters;

  const NewslettersIndex({
    this.newsletters = ContentConfig.newsletters,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final LPViewportData vp = LPViewport.of(context);
    final Size size = vp.size;
    final double padLeft = size.width * _AboutMetrics.padLeft;

    return Container(
      width: size.width,
      color: LPColor.inkBlue_500,
      padding: EdgeInsets.only(
        top: size.width * _NewsletterIndexMetrics.coversToNextHeading,
        bottom: size.height * 0.12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final LPNewsletter newsletter in newsletters)
            _NewsletterBlock(newsletter: newsletter, padLeft: padLeft),
        ],
      ),
    );
  }
}

class _NewsletterBlock extends StatelessWidget {
  final LPNewsletter newsletter;
  final double padLeft;

  const _NewsletterBlock({required this.newsletter, required this.padLeft});

  @override
  Widget build(BuildContext context) {
    final LPViewportData vp = LPViewport.of(context);
    final Size size = vp.size;

    final double coverWidth =
        size.width * _NewsletterIndexMetrics.coverWidth * vp.pick(
              // A phone cannot show four covers across, so they are drawn
              // larger and scrolled instead of shrunk to illegibility.
              mobile: 1.5,
              desktop: 1.0,
            );

    return Padding(
      padding: EdgeInsets.only(
        bottom: size.width * _NewsletterIndexMetrics.coversToNextHeading,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: padLeft, right: padLeft),
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    newsletter.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: header2.apply(
                      const TextStyle(color: LPColor.gripperBlue_500),
                    ),
                  ),
                ),
                SizedBox(width: vp.pick(mobile: 12, desktop: 20)),
                LPSubscribeButton(
                  size: vp.pick(mobile: 34, desktop: 40),
                  target: LPSubscriptionTarget(
                    kind: LPSubscriptionKind.newsletter,
                    slug: newsletter.slug,
                    label: newsletter.name,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: size.width * _NewsletterIndexMetrics.headingToCovers,
          ),
          // No right padding: the row runs off the edge, so it reads as
          // continuing rather than as a set that happens to fit.
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.only(left: padLeft),
            child: Row(
              children: [
                for (int i = 0; i < newsletter.issueCount; i++) ...[
                  _IssueCover(newsletter: newsletter, width: coverWidth),
                  if (i != newsletter.issueCount - 1)
                    SizedBox(
                      width:
                          size.width * _NewsletterIndexMetrics.coverGap,
                    ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// A single issue cover.
///
/// A stand-in: no issues have been published yet, so there is nothing to put on
/// one. It carries the masthead on the platen white ground the cover templates
/// use, at the right size and aspect, so the row's rhythm is correct now and
/// real covers can drop in later without the layout moving.
class _IssueCover extends StatelessWidget {
  final LPNewsletter newsletter;
  final double width;

  const _IssueCover({required this.newsletter, required this.width});

  @override
  Widget build(BuildContext context) {
    final double height = width / _SpiralStage.coverAspect;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: LPColor.platenWhite_500,
        borderRadius: BorderRadius.circular(2),
      ),
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: width * 0.1),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          newsletter.name,
          maxLines: 1,
          style: header2.apply(
            const TextStyle(
              color: LPColor.rollerBlue_500,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ),
    );
  }
}
