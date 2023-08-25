part of letterpress.ds;

class LPDivider extends LPPostComponent {
  const LPDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 30,
      thickness: 0.5,
      color: OctaneTheme.obsidian200,
    );
  }
}
