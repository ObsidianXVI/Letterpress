library letterpress.remote_content;

import 'package:http/http.dart' as http;
import 'package:letterpress/design_system/design_system.dart';
import 'package:letterpress/letterpress-engine/store/lp_store.dart';

import 'remote_markdown_parser.dart';

typedef LPRemoteTextFetcher = Future<String> Function(Uri uri);

class LPContentBucket {
  static const String publicBaseUrl = String.fromEnvironment(
    'LP_PUBLIC_CONTENT_BASE_URL',
  );

  static bool get isConfigured => publicBaseUrl.trim().isNotEmpty;

  static String? postMarkdownUrl(String slug) => _objectUrl('posts/$slug.md');

  static String? bloguleMarkdownUrl(String slug) =>
      _objectUrl('blogules/$slug.md');

  static String? newsletterPdfUrl(String slug) =>
      _objectUrl('newsletters/$slug.pdf');

  static String? newsletterCoverUrl(String slug) =>
      _objectUrl('newsletters/$slug.png');

  static String? _objectUrl(String objectPath) {
    final String base = publicBaseUrl.trim();
    if (base.isEmpty) {
      return null;
    }

    final String normalizedBase = base.replaceFirst(RegExp(r'/+$'), '');
    final String normalizedPath = objectPath.replaceFirst(RegExp(r'^/+'), '');
    return '$normalizedBase/$normalizedPath';
  }
}

class LPNewsletter {
  final String title;
  final String description;
  final DateTime publicationDate;
  final String slug;
  final bool isPreviewMode;

  const LPNewsletter({
    required this.title,
    required this.description,
    required this.publicationDate,
    required this.slug,
    this.isPreviewMode = false,
  });

  String? get pdfUrl => LPContentBucket.newsletterPdfUrl(slug);

  String? get coverUrl => LPContentBucket.newsletterCoverUrl(slug);
}

class LPResolvedArticlePayload {
  final LPArticle article;
  final bool loadedFromRemote;
  final String? markdownSourceUrl;
  final String? pdfUrl;
  final Object? error;

  const LPResolvedArticlePayload({
    required this.article,
    required this.loadedFromRemote,
    this.markdownSourceUrl,
    this.pdfUrl,
    this.error,
  });
}

class LPRemoteContentResolver {
  static final Map<String, Future<LPResolvedArticlePayload>> _cache =
      <String, Future<LPResolvedArticlePayload>>{};

  static Future<LPResolvedArticlePayload> resolveArticle({
    required LPArticle article,
    String? markdownSourceUrl,
    String? pdfUrl,
    LPRemoteTextFetcher? fetcher,
    bool useCache = true,
  }) {
    if (markdownSourceUrl == null || markdownSourceUrl.trim().isEmpty) {
      return Future<LPResolvedArticlePayload>.value(
        LPResolvedArticlePayload(
          article: article,
          loadedFromRemote: false,
          pdfUrl: pdfUrl,
        ),
      );
    }

    final Uri uri = Uri.parse(markdownSourceUrl);
    if (!useCache) {
      return _resolve(
        article: article,
        uri: uri,
        markdownSourceUrl: markdownSourceUrl,
        pdfUrl: pdfUrl,
        fetcher: fetcher,
      );
    }

    return _cache.putIfAbsent(
      markdownSourceUrl,
      () => _resolve(
        article: article,
        uri: uri,
        markdownSourceUrl: markdownSourceUrl,
        pdfUrl: pdfUrl,
        fetcher: fetcher,
      ),
    );
  }

  static Future<LPResolvedArticlePayload> _resolve({
    required LPArticle article,
    required Uri uri,
    required String markdownSourceUrl,
    required String? pdfUrl,
    LPRemoteTextFetcher? fetcher,
  }) async {
    try {
      final String markdown = await (fetcher ?? _defaultFetch)(uri);
      final List<LPPostComponent> components =
          LPRemoteMarkdownParser.parse(markdown);

      if (components.isEmpty && article.components.isNotEmpty) {
        return LPResolvedArticlePayload(
          article: article,
          loadedFromRemote: false,
          markdownSourceUrl: markdownSourceUrl,
          pdfUrl: pdfUrl,
        );
      }

      return LPResolvedArticlePayload(
        article: _cloneArticleWithComponents(article, components),
        loadedFromRemote: true,
        markdownSourceUrl: markdownSourceUrl,
        pdfUrl: pdfUrl,
      );
    } catch (error) {
      if (article.components.isNotEmpty) {
        return LPResolvedArticlePayload(
          article: article,
          loadedFromRemote: false,
          markdownSourceUrl: markdownSourceUrl,
          pdfUrl: pdfUrl,
          error: error,
        );
      }

      return LPResolvedArticlePayload(
        article: article,
        loadedFromRemote: false,
        markdownSourceUrl: markdownSourceUrl,
        pdfUrl: pdfUrl,
        error: error,
      );
    }
  }

  static Future<String> _defaultFetch(Uri uri) async {
    final http.Response response = await http.get(uri);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw StateError(
        'Unexpected status ${response.statusCode} while fetching $uri',
      );
    }
    return response.body;
  }

  static LPArticle _cloneArticleWithComponents(
    LPArticle article,
    List<LPPostComponent> components,
  ) {
    if (article is LPPost) {
      return LPPost.fromComponents(
        title: article.title,
        description: article.description,
        publicationDate: article.publicationDate,
        lastUpdate: article.lastUpdate,
        components: components,
        blogules: article.blogules,
        isPreviewMode: article.isPreviewMode,
      );
    }

    if (article is LPModule) {
      return LPModule(
        title: article.title,
        publicationDate: article.publicationDate,
        lastUpdate: article.lastUpdate,
        includeTableOfContents: article.includeTableOfContents,
        components: components,
        tags: article.tags,
        projectName: article.projectName,
        renderWithPost: article.renderWithPost,
        coverImgName: article.coverImgName,
        isPreviewMode: article.isPreviewMode,
      );
    }

    return article;
  }
}

class LPStoreRemoteContent {
  static final List<LPNewsletter> newsletters = <LPNewsletter>[];

  static final Map<LPArticle, String> _markdownUrlsByArticle =
      <LPArticle, String>{
    for (final LPPost post in LPStore.posts)
      if (LPContentBucket.postMarkdownUrl(post.slug) case final String url)
        post: url,
    for (final LPModule blogule in LPStore.blogules)
      if (LPContentBucket.bloguleMarkdownUrl(blogule.slug)
          case final String url)
        blogule: url,
  };

  static String? markdownUrlForArticle(LPArticle article) =>
      _markdownUrlsByArticle[article];
}
