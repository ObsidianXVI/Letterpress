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

class LPPost extends StatelessWidget {
  final LPPostConfigs postConfigs;
  static const SizedBox componentDivider = SizedBox(height: 30);

  const LPPost({
    required this.postConfigs,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgets = []..addAll([
        Center(
          child: Container(
            width: DimensionTools.getWidth(context),
            height: DimensionTools.getHeight(context),
            child: Center(
              child: SelectableText.rich(
                TextSpan(children: [
                  TextSpan(
                    text: postConfigs.title,
                    style: LPFont.title().textStyle,
                  ),
                ]),
              ),
            ),
          ),
        ),
        ...postConfigs.modules,
      ]);

    final LPTableOfContents tableOfContents = LPTableOfContents(
      postComponents: widgets
          .whereType<LPText>()
          .where(((LPText text) => (text.isHeader)))
          .toList(),
    );

    widgets.insert(1, tableOfContents);

    widgets.addAll([
      const LPDivider(),
      Text(
        "Published: ${postConfigs.publicationDate.toDateString()}",
        style: LPFont.bodyItalic().textStyle,
      ),
      Text(
        "Updated: ${postConfigs.lastUpdate.toDateString()}",
        style: LPFont.bodyItalic().textStyle,
      ),
    ]);

    return Center(
      child: Theme(
        data: ThemeData(
          textSelectionTheme: TextSelectionThemeData(
            selectionColor: LPTheme.grey400.withOpacity(0.3),
            selectionHandleColor: LPTheme.grey400,
          ),
        ),
        child: SelectionArea(
          selectionControls: materialTextSelectionControls,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: postConfigs.modules,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
