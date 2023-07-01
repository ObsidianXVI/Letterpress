part of letterpress.ds;

enum LPPostClass {
  tgif_challenge('TGIF Challenge');

  final String name;
  const LPPostClass(this.name);
}

class LPPostConfigs {
  final String title;
  final LPPostClass postClass;
  final DateTime publicationDate;
  final DateTime lastUpdate;
  final bool includeTableOfContents;

  const LPPostConfigs({
    required this.title,
    required this.postClass,
    required this.publicationDate,
    required this.lastUpdate,
    required this.includeTableOfContents,
  });
}

abstract class LPPostComponent extends StatelessWidget {
  const LPPostComponent({super.key});
}

class LPPost extends StatelessWidget {
  final LPPostConfigs postConfigs;
  final List<LPPostComponent> components;
  static const SizedBox componentDivider = SizedBox(height: 30);

  const LPPost({
    required this.postConfigs,
    required this.components,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgets = [];
    widgets.addAll([
      const SizedBox(height: 20),
      Center(
        child: Container(
          width: DimensionTools.getWidth(context),
          height: DimensionTools.getHeight(context),
          child: Center(
            child: SelectableText.rich(
              TextSpan(children: [
                TextSpan(
                  text: '${postConfigs.postClass.name}\n',
                  style: LPFont.postClassTitle().textStyle,
                ),
                TextSpan(
                  text: postConfigs.title,
                  style: LPFont.title().textStyle,
                ),
              ]),
            ),
          ),
        ),
      ),
      const LPDivider(),
    ]);

    final int tocIndex = widgets.length - 1;

    for (LPPostComponent postComponent in components) {
      widgets.addAll([
        componentDivider,
        postComponent,
      ]);
    }

    final LPTableOfContents tableOfContents = LPTableOfContents(
      postComponents: widgets
          .whereType<LPText>()
          .where(((LPText text) => (text.isHeader)))
          .toList(),
    );

    widgets.insert(tocIndex, tableOfContents);

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
      child: Padding(
        padding: const EdgeInsets.only(left: 120, right: 120),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: widgets,
            ),
          ),
        ),
      ),
    );
  }
}

extension LPPostComponentUtils on List<LPPostComponent> {
  void insertTableOfContents(int index) {
    /* final LPTableOfContents tableOfContents = LPTableOfContents(
      postComponents: whereType<LPText>()
          .where(((LPText text) => (text.isHeader)))
          .cast<LPText>()
          .toList(),
    );
    print('start');
    insert(
      index,
      tableOfContents,
    ); */
  }
}

extension DateUtils on DateTime {
  static const List<String> monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  String toDateString() {
    final List<String> chunks = [];
    chunks.addAll([
      day.toString().padLeft(2, '0'),
      monthNames[month],
      year.toString(),
    ]);
    return chunks.join(' ');
  }
}
