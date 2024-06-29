part of letterpress.ds;

enum SizeVariant { small, medium, large }

class PromoCard extends StatefulWidget {
  final String title;
  final String description;
  final SizeVariant size;
  final void Function() onTap;

  const PromoCard({
    required this.size,
    required this.title,
    required this.description,
    required this.onTap,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => PromoCardState();
}

class PromoCardState extends State<PromoCard> {
  bool hovering = false;
  bool pressing = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => hovering = true),
        onExit: (_) => setState(() => hovering = false),
        child: GestureDetector(
          onTapDown: (_) => setState(() => pressing = true),
          onTapUp: (_) => setState(() {
            pressing = false;
            widget.onTap();
          }),
          child: Container(
            width: switch (widget.size) {
              SizeVariant.small => 438,
              SizeVariant.medium => 776,
              SizeVariant.large => 776,
            },
            height: 438,
            decoration: BoxDecoration(
              color: LPColor.inkBlue_500,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: pressing ? LPColor.chaseRed_500 : LPColor.rollerBlue_500,
              ),
              boxShadow: hovering
                  ? [
                      BoxShadow(
                        offset: const Offset(0, 10),
                        color: (pressing ? LPColor.chaseRed_500 : Colors.black)
                            .withOpacity(0.3),
                        blurRadius: 13,
                        spreadRadius: 4,
                      )
                    ]
                  : null,
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 30, right: 30, top: 30),
              child: Column(
                children: [
                  Text(
                    widget.title,
                    style: (switch (widget.size) {
                      SizeVariant.small => mediumFunky,
                      SizeVariant.medium => bigFunky,
                      SizeVariant.large => bigFunky,
                    })
                        .apply(const TextStyle(color: LPColor.gripperBlue_500)),
                  ),
                  const SizedBox(height: 40),
                  Text(
                    widget.description,
                    style: body
                        .apply(const TextStyle(color: LPColor.rollerBlue_500)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
