part of letterpress.ds;

class LPPullQuote extends LPQuote {
  final String content;

  /// The original author/source of the quote.
  final String? attribution;

  /// If [attribution] is provided, a link should also be given so that the source can
  /// be hyperlinked to.
  final String? ref;

  const LPPullQuote({
    required this.content,
    this.attribution,
    this.ref,
    super.leftSideNotes,
    super.rightSideNotes,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              width: 4,
              color: LPColor.gripperBlue_500.withOpacity(0.3),
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            left: 50,
            top: 14,
            right: 14,
            bottom: 14,
          ),
          child: Column(
            children: [
              LPText.plainBody(
                color: LPColor.gripperBlue_500,
                content: content,
                isItalic: true,
              ),
              const SizedBox(height: 20),
              if (attribution != null)
                ref != null
                    ? LPText.hyperlink(
                        content: attribution!,
                        url: ref!,
                      )
                    : LPText.plainBody(content: attribution!),
            ],
          ),
        ),
      ),
    );
  }
}
