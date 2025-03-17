part of letterpress.ds;

class LPButton extends StatefulWidget {
  final Widget child;
  final void Function() callback;
  final double width;
  final double height;
  final ButtonState initialState;

  const LPButton({
    required this.width,
    required this.height,
    required this.child,
    required this.callback,
    this.initialState = ButtonState.enabled,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => LPButtonState();
}

enum ButtonState { disabled, enabled, hovered, pressed }

class LPButtonState extends State<LPButton> {
  late ButtonState buttonState;

  @override
  void initState() {
    buttonState = widget.initialState;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: buttonState == ButtonState.disabled ? null : widget.callback,
      onTapDown: (_) => setState(() {
        if (!(buttonState == ButtonState.disabled)) {
          buttonState = ButtonState.pressed;
        }
      }),
      onTapUp: (_) => setState(() {
        if (!(buttonState == ButtonState.disabled)) {
          buttonState = ButtonState.hovered;
        }
      }),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() {
          if (!(buttonState == ButtonState.disabled)) {
            buttonState = ButtonState.hovered;
          }
        }),
        onExit: (_) => setState(() {
          if (!(buttonState == ButtonState.disabled)) {
            buttonState = ButtonState.enabled;
          }
        }),
        child: Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: LPColor.rollerBlue_500.withOpacity(switch (buttonState) {
              ButtonState.enabled => 0.1,
              ButtonState.disabled => 0.05,
              ButtonState.hovered => 0.2,
              ButtonState.pressed => 0.3,
            }),
            border: Border.all(
              color: LPColor.rollerBlue_500.withOpacity(switch (buttonState) {
                ButtonState.enabled => 0.2,
                ButtonState.disabled => 0.1,
                ButtonState.hovered => 0.4,
                ButtonState.pressed => 0.5,
              }),
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
