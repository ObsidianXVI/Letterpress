part of letterpress.ds;

class LPGroup extends LPPostComponent {
  final List<LPPostComponent> postComponents;

  const LPGroup.vertical({
    required this.postComponents,
  });

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [];
    for (LPPostComponent postComponent in postComponents) {
      children.add(postComponent);
      children.add(LPPost.componentDivider);
    }
    children.removeLast();
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }
}
