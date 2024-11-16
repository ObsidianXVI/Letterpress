part of letterpress.ds;

abstract class LPSideNoteComponent extends StatelessWidget {
  final bool leftSide;
  const LPSideNoteComponent({
    required this.leftSide,
    super.key,
  });
}

class LPSideNoteComment extends LPSideNoteComponent {
  final String text;

  const LPSideNoteComment({
    required this.text,
    required super.leftSide,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      //color: LPColor.inkBlue_500.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Align(
          alignment: leftSide ? Alignment.topRight : Alignment.topLeft,
          child: LPText.plainBody(
            color: LPColor.rollerBlue_500.withOpacity(0.2),
            alignment: leftSide ? Alignment.topRight : Alignment.topLeft,
            content: text,
          ),
        ),
      ),
    );
  }
}
