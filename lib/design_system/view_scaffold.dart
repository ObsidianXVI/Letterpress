part of letterpress.ds;

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
  ScrollPhysics scrollPhysics = const NeverScrollableScrollPhysics();

  @override
  Widget build(BuildContext context) {
    Future.microtask(() {
      Multiplatform.currentPlatform = Multiplatform.platformSelector(
          document.body!.clientWidth, document.body!.clientHeight);
      if (Multiplatform.currentPlatform == const UnknownPlatform()) {
        Navigator.of(context).pushNamed(LPRoutes.unknownPlatform);
      }
    });
    return Material(
      child: widget.child,
    );
  }
}
