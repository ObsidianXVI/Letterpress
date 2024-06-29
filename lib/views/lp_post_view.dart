part of letterpress.views;

class LetterpressPostView extends StatelessWidget {
  final LPPost child;
  const LetterpressPostView({
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ViewScaffold(
      child: Center(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: LPColor.inkBlue_500,
          child: child,
        ),
      ),
    );
  }
}
