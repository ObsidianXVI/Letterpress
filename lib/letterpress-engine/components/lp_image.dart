part of letterpress.ds;

class LPImage extends LPPostComponent {
  final String url;
  final double width;
  final double height;

  const LPImage({
    super.leftSideNotes,
    super.rightSideNotes,
    required this.url,
    required this.width,
    required this.height,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: width,
        height: height,
        child: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Image.network(url),
          ),
        ),
      ),
    );
  }
}
