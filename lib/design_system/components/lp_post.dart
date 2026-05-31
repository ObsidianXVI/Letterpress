part of letterpress.ds;

class LPPostConfigs {
  final String title;
  final String description;
  final DateTime publicationDate;
  final DateTime lastUpdate;
  final bool includeTableOfContents;
  final List<LPModule> modules;

  const LPPostConfigs({
    required this.title,
    required this.description,
    required this.publicationDate,
    required this.lastUpdate,
    required this.includeTableOfContents,
    required this.modules,
  });

  List<String> get allTags => [for (LPModule module in modules) ...module.tags];
}

abstract class LPPostComponent extends StatelessWidget {
  final List<LPSideNoteComponent> leftSideNotes;
  final List<LPSideNoteComponent> rightSideNotes;

  const LPPostComponent({
    this.leftSideNotes = const [],
    this.rightSideNotes = const [],
    super.key,
  });
}

class LPPost extends LPArticle {
  final String description;
  static const SizedBox componentDivider = SizedBox(height: 30);
  final List<LPModule> blogules;

  LPPost({
    required this.blogules,
    required super.lastUpdate,
    required super.publicationDate,
    required super.title,
    required this.description,
    super.isPreviewMode,
  }) : super(
          coverImgName: blogules.first.coverImgName,
          components: [
            for (final blogule in blogules) ...[
              LPText.mainTitle(content: blogule.title),
              ...blogule.components,
              const LPDivider(),
            ],
          ]..removeLast(),
        );

  LPPost.fromComponents({
    required this.blogules,
    required super.lastUpdate,
    required super.publicationDate,
    required super.title,
    required this.description,
    required List<LPPostComponent> components,
    super.isPreviewMode,
  }) : super(
          coverImgName:
              blogules.isNotEmpty ? blogules.first.coverImgName : null,
          components: components,
        );
}
