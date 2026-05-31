part of letterpress.views;

class LetterpressRenderView extends StatelessWidget {
  final LPArticle child;
  final String? markdownSourceUrl;
  final String? pdfUrl;

  const LetterpressRenderView({
    required this.child,
    this.markdownSourceUrl,
    this.pdfUrl,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bool includeTableOfContents =
        child is LPModule && (child as LPModule).includeTableOfContents;

    if (markdownSourceUrl == null) {
      return _RenderFrame(
        article: child,
        includeTableOfContents: includeTableOfContents,
        pdfUrl: pdfUrl,
      );
    }

    return FutureBuilder<LPResolvedArticlePayload>(
      future: LPRemoteContentResolver.resolveArticle(
        article: child,
        markdownSourceUrl: markdownSourceUrl,
        pdfUrl: pdfUrl,
      ),
      builder: (
        BuildContext context,
        AsyncSnapshot<LPResolvedArticlePayload> snapshot,
      ) {
        if (snapshot.connectionState != ConnectionState.done) {
          return ViewScaffold(
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final LPResolvedArticlePayload? payload = snapshot.data;
        if (payload == null) {
          return ViewScaffold(
            child: Center(child: Text('Could not load this article.')),
          );
        }

        if (payload.error != null && payload.article.components.isEmpty) {
          return ViewScaffold(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 620),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Could not load this article from its public source.',
                      style: body.apply(
                        const TextStyle(color: LPColor.gripperBlue_500),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (payload.markdownSourceUrl != null) ...[
                      const SizedBox(height: 20),
                      LPText.hyperlink(
                        content: 'Open source Markdown',
                        url: payload.markdownSourceUrl,
                        textAlign: TextAlign.center,
                        alignment: Alignment.center,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        }

        return _RenderFrame(
          article: payload.article,
          includeTableOfContents: includeTableOfContents,
          markdownSourceUrl: payload.markdownSourceUrl,
          pdfUrl: payload.pdfUrl,
        );
      },
    );
  }
}

class _RenderFrame extends StatelessWidget {
  final LPArticle article;
  final bool includeTableOfContents;
  final String? markdownSourceUrl;
  final String? pdfUrl;

  const _RenderFrame({
    required this.article,
    required this.includeTableOfContents,
    this.markdownSourceUrl,
    this.pdfUrl,
  });

  @override
  Widget build(BuildContext context) {
    return ViewScaffold(
      child: Center(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: LPColor.inkBlue_700,
          child: LPRenderer(
            article: article,
            includeTableOfContents: includeTableOfContents,
            markdownSourceUrl: markdownSourceUrl,
            pdfUrl: pdfUrl,
          ),
        ),
      ),
    );
  }
}
