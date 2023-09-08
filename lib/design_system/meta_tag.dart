part of letterpress.ds;

class LPMetaTag extends StatelessWidget {
  final String label;
  final Color primaryColor;

  const LPMetaTag({
    required this.label,
    required this.primaryColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: primaryColor.withOpacity(0.6),
        border: Border.all(color: primaryColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Center(
          child: LPText.semanticTag1(content: label),
        ),
      ),
    );
  }
}
