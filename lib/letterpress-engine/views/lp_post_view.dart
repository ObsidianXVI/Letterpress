part of letterpress.views;

class LetterpressPostView extends StatelessWidget {
  final LPPost child;
  const LetterpressPostView({
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
