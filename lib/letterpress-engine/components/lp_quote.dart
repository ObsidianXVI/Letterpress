part of letterpress.ds;

abstract class LPQuote extends LPPostComponent {
  const LPQuote({
    super.key,
  });
}

class LPVerseQuote extends LPQuote {
  final List<String> verses;
  final String reference;
  final String url;

  const LPVerseQuote({
    required this.verses,
    required this.reference,
    required this.url,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity,
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
