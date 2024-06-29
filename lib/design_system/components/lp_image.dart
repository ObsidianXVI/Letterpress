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
  }) : image = Image.network(url);

  LPImage.asset({
    super.leftSideNotes,
    super.rightSideNotes,
    required String assetPath,
    required this.width,
    required this.height,
    super.key,
  }) : image = Image.asset(assetPath);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: width,
        height: height,
        child: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: image,
          ),
        ),
      ),
    );
  }
}
