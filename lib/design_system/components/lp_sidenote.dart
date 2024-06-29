part of letterpress.ds;

abstract class LPSideNoteComponent extends StatelessWidget {
  const LPSideNoteComponent();
}

class LPSideNoteComment extends LPSideNoteComponent {
  final String text;

  const LPSideNoteComment({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: OctaneTheme.obsidianC150,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Align(
          alignment: Alignment.topLeft,
          child: Text(text),
        ),
      ),
    );
  }
}
