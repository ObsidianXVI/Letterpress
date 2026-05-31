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
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            width: 1,
            color: LPColor.rollerBlue_500.withOpacity(0.65),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SelectionContainer.disabled(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: LPColor.inkBlue_500,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(10),
                  ),
                  border: Border(
                    bottom: BorderSide(
                      color: LPColor.rollerBlue_500.withOpacity(0.4),
                    ),
                  ),
                ),
                child: Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  runSpacing: 8,
                  spacing: 12,
                  children: [
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 10,
                      runSpacing: 8,
                      children: [
                        _CodeBlockChip(label: lang.toUpperCase()),
                        if (provenance != null && provenance!.trim().isNotEmpty)
                          Text(
                            provenance!,
                            style: body2.apply(
                              TextStyle(
                                color: LPColor.rollerBlue_500.withOpacity(0.78),
                              ),
                            ),
                          ),
                      ],
                    ),
                    TextButton.icon(
                      onPressed: () async {
                        await Clipboard.setData(ClipboardData(text: content));
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Code copied')),
                          );
                        }
                      },
                      icon: const Icon(Icons.content_copy, size: 16),
                      label: const Text('Copy'),
                      style: TextButton.styleFrom(
                        foregroundColor: LPColor.gripperBlue_400,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(16, 16, 20, 18),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SelectionContainer.disabled(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          for (int i = 0; i < lines.length; i++)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Text(
                                '${i + 1}'.padLeft(2, '0'),
                                style: code.apply(
                                  TextStyle(
                                    color: LPColor.rollerBlue_500.withOpacity(
                                      0.5,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final String line in lines)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: _LPSelectableRichText(
                            spans: [
                              LPText.codeStyle(
                                content: line.isEmpty ? ' ' : line,
                                inline: false,
                              ).toInlineSpan(context),
                            ],
                          ),
                        ),
                    ],
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

class _CodeBlockChip extends StatelessWidget {
  final String label;

  const _CodeBlockChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: LPColor.rollerBlue_500.withOpacity(0.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: LPColor.rollerBlue_500.withOpacity(0.35)),
      ),
      child: Text(
        label,
        style: code.apply(
          const TextStyle(
            color: LPColor.gripperBlue_500,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
