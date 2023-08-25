part of letterpress.views;

class LetterpressBloguleView extends StatelessWidget {
  final LPModule child;
  const LetterpressBloguleView({
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: LPTheme.grey800,
        child: child,
      ),
    );
  }
}
