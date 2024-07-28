part of letterpress.ds;

abstract class LPArticle {
  final String title;
  final String? coverImgName;
  final DateTime publicationDate;
  final DateTime lastUpdate;
  final List<LPPostComponent> components;

  const LPArticle({
    required this.title,
    this.coverImgName,
    required this.publicationDate,
    required this.lastUpdate,
    required this.components,
  });
}

class LPModule extends LPArticle {
  final bool includeTableOfContents;
  final List<String> tags;
  final String projectName;
  final bool renderWithPost;

  LPModule({
    required super.title,
    required super.publicationDate,
    required super.lastUpdate,
    required this.includeTableOfContents,
    required super.components,
    required this.tags,
    required this.projectName,
    required this.renderWithPost,
    super.coverImgName,
  });
}
