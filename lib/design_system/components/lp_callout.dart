part of letterpress.ds;

enum CalloutType {
  note(LPColor.gripperBlue_500),
  moderate(Color(0xFFdba40b)),
  critical(LPColor.chaseRed_500);

  final Color color;
  const CalloutType(this.color);
}

class LPCallout extends LPQuote {
  final String title;
  final String content;
  final CalloutType calloutType;

  const LPCallout({
    super.leftSideNotes,
    super.rightSideNotes,
    required this.title,
    required this.content,
    required this.calloutType,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: calloutType.color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: calloutType.color, width: 0.5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LPText.plainBody(
                color: calloutType.color,
                content: title,
                isItalic: true,
              ),
              const SizedBox(height: 5),
              LPText.plainBody(
                color: calloutType.color,
                content: content,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
