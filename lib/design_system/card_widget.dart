part of letterpress.ds;

class LPCardWidget extends StatelessWidget {
  final double width;
  final double height;
  final Widget child;

  const LPCardWidget({
    required this.width,
    required this.height,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: LPColor.inkBlue_500,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: LPColor.rollerBlue_500),
      ),
      child: child,
    );
  }
}

class LPHoverableCardWidget extends StatefulWidget {
  final double width;
  final double height;
  final Widget child;
  final bool clickable;

  const LPHoverableCardWidget({
    required this.width,
    required this.height,
    required this.child,
    required this.clickable,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => LPHoverableCardWidgetState();
}

class LPHoverableCardWidgetState extends State<LPHoverableCardWidget> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.clickable ? SystemMouseCursors.click : MouseCursor.defer,
      onEnter: (_) => setState(() {
        _hovered = true;
      }),
      onExit: (_) => setState(() {
        _hovered = false;
      }),
      child: AnimatedContainer(
        width: widget.width,
        height: widget.height,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: LPColor.inkBlue_500,
          borderRadius: BorderRadius.circular(5),
          // The hover state was already being tracked and animated for, but
          // never actually reached the decoration.
          border: Border.all(
            color: LPColor.rollerBlue_500.withOpacity(_hovered ? 1 : 0.5),
          ),
        ),
        child: widget.child,
      ),
    );
  }
}
