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
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LPText.verse(
                alignment: Alignment.topCenter,
                content: verses.join('\n'),
              ),
              const SizedBox(height: 30),
              LPText.hyperlink(
                alignment: Alignment.bottomCenter,
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
