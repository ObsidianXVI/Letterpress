part of letterpress.ds;

/// Credit line for the artwork used on the home page.
///
/// Lives in the design system rather than in the view because it appears in
/// two places: beside the painting in the About band, and again in Discover,
/// which the transition zooms into out of that same painting. The two are the
/// same mark, so they share one definition.
///
/// Both lines are the gripper blue held well back — 54% for the title, 30% for
/// the italic attribution — as specified in the `About - new` frame (node
/// 90:10). It is a credit, not a caption to be read.
class LPArtworkCaption extends StatelessWidget {
  final String title;
  final String artist;
  final String year;

  const LPArtworkCaption({
    this.title = 'Woman at a Window',
    this.artist = 'Caspar David Friedrich',
    this.year = '1822',
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    LPViewport.of(context);

    final TextStyle base = body2.apply(
      const TextStyle(height: 1.35, letterSpacing: 0.18),
    );

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '$title\n',
            style: base.copyWith(
              color: LPColor.gripperBlue_500.withOpacity(0.54),
            ),
          ),
          TextSpan(
            text: '$artist, $year',
            style: base.copyWith(
              color: LPColor.gripperBlue_500.withOpacity(0.30),
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
      textAlign: TextAlign.right,
    );
  }
}
