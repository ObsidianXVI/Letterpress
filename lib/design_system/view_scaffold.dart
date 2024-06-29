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
      color: OctaneTheme.obsidianD150,
      child: GestureDetector(
        onLongPress: () async => await showHotboxDialog(context),
        child: KeyboardListener(
          focusNode: widget.focusNode,
          autofocus: true,
          onKeyEvent: (KeyEvent event) async {
            if (event.logicalKey == LogicalKeyboardKey.space) {
              await showHotboxDialog(context);
            }
          },
          child: widget.child,
        ),
      ),
    );
  }

  Future<void> showHotboxDialog(BuildContext context) async => await showDialog(
        context: context,
        barrierColor: Colors.black.withOpacity(0.7),
        barrierDismissible: true,
        builder: (context) => OctaneHotbox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          showReleaseToClickLine: true,
          hotboxData: HotboxData.none(),
        ),
      );
}
