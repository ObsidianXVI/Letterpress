part of letterpress.ds;

class LPImage extends LPPostComponent {
  final Image image;
  final double width;
  final double height;

  LPImage.url({
    super.leftSideNotes,
    super.rightSideNotes,
    required String url,
    required this.width,
    required this.height,
    super.key,
  }) : image = Image.network(url, fit: BoxFit.contain);

  LPImage.asset({
    super.leftSideNotes,
    super.rightSideNotes,
    required String assetPath,
    required this.width,
    required this.height,
    super.key,
  }) : image = Image.asset(assetPath, fit: BoxFit.contain);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double resolvedWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth.clamp(0.0, width).toDouble()
            : width;

        return Center(
          child: SizedBox(
            width: resolvedWidth,
            child: AspectRatio(
              aspectRatio: width / height,
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: image,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
