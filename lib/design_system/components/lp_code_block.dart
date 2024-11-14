part of letterpress.ds;

class LPCodeBlock extends LPPostComponent {
  final String lang;
  final String content;
  final String? provenance;

  const LPCodeBlock({
    required this.content,
    this.lang = 'plain',
    this.provenance,
    super.leftSideNotes,
    super.rightSideNotes,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> lines = content.split('\n');
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: LPColor.inkBlue_700,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            width: 1,
            color: LPColor.rollerBlue_500,
          ),
        ),
        child: Column(
          children: [
            if (provenance != null) Text(provenance!),
            const SizedBox(height: 5),
            ...List.generate(
              lines.length,
              (i) => Row(
                children: [
                  const SizedBox(width: 5),
                  LPText.codeStyle(
                    content: i.toString().padLeft(2, '0'),
                    inline: false,
                  ),
                  const SizedBox(width: 8),
                  LPText.codeStyle(
                    content: lines[i],
                    inline: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
