part of letterpress.ds;

/// Common shell for every top-level view.
///
/// Wraps its child in a [SelectionArea] so that a drag can carry a selection
/// across paragraphs and across separate widgets, rather than each block of
/// text owning an isolated selection of its own.
class ViewScaffold extends StatefulWidget {
  final FocusNode focusNode;
  final Widget child;

  ViewScaffold({
    required this.child,
    FocusNode? focusNode,
    super.key,
  }) : focusNode = focusNode ?? FocusNode();

  @override
  State<StatefulWidget> createState() => ViewScaffoldState();
}

class ViewScaffoldState extends State<ViewScaffold> {
  @override
  Widget build(BuildContext context) {
    // Establishes the viewport dependency for the whole view, so a resize
    // rebuilds this subtree even though the navigator caches the page widget.
    LPViewport.of(context);

    return Material(
      child: LPSelectionArea(child: widget.child),
    );
  }
}
