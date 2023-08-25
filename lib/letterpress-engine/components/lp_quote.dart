part of letterpress.ds;

abstract class LPQuote extends LPPostComponent {
  const LPQuote({
    super.leftSideNotes,
    super.rightSideNotes,
    super.key,
  });
}

class LPVerseQuote extends LPQuote {
  final List<String> verses;
  final String reference;
  final String url;

  const LPVerseQuote({
    super.leftSideNotes,
    super.rightSideNotes,
    required this.verses,
    required this.reference,
    required this.url,
    super.key,
  });

  @override
  Widget render(BuildContext context) {
    return Center(
      child: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LPText.verse(content: verses.join('\n')),
              LPText.hyperlink(
                content: reference,
                url: reference,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
