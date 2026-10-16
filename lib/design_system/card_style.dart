part of letterpress.ds;

// Card and hover styling, hoisted from Octane's design system so Letterpress
// no longer depends on the Octane package.

mixin CardStyling {
  bool hovering = false;
  bool pressing = false;

  BorderRadius get cardRadius => BorderRadius.circular(5);

  BoxBorder get cardBorder {
    return Border.all(
      color: pressing
          ? OctaneTheme.obsidianX150.withValues(alpha: 0.8)
          : OctaneTheme.obsidianB050.withValues(alpha: hovering ? 0.7 : 0.5),
      width: 0.5,
    );
  }

  Color get cardBackground =>
      OctaneTheme.obsidianD050.withValues(alpha: hovering ? 0.55 : 0.35);

  List<BoxShadow> get cardShadows => [
        BoxShadow(
          blurStyle: BlurStyle.outer,
          color: pressing
              ? OctaneTheme.obsidianX150.withValues(alpha: 0.45)
              : OctaneTheme.obsidianD150.withValues(alpha: 0.45),
          spreadRadius: 0,
          blurRadius: 16,
        ),
      ];

  Widget backgroundBlur({required Widget child}) {
    return ClipRect(
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 60, sigmaY: 60),
        child: child,
      ),
    );
  }
}

/// Exposes a [hovering] variable to monitor hover state. Works with
/// [CardStyling] to change the card border based on hover state.
mixin HoverStyling<T extends StatefulWidget> on State<T>, CardStyling {
  Widget hoverRegion({
    required Widget child,
    void Function(PointerEnterEvent)? onEnter,
    void Function(PointerExitEvent)? onExit,
    void Function()? onTap,
  }) {
    return MouseRegion(
      onEnter: (event) => setState(() {
        hovering = true;
        onEnter?.call(event);
      }),
      onExit: (event) => setState(() {
        hovering = false;
        onExit?.call(event);
      }),
      cursor: this is Clickable ? SystemMouseCursors.click : MouseCursor.defer,
      child: this is Clickable
          ? Listener(
              onPointerDown: (_) => setState(() {
                pressing = true;
              }),
              onPointerUp: (_) {
                setState(() {
                  pressing = false;
                });
                onTap?.call();
              },
              child: child,
            )
          : child,
    );
  }
}

mixin Clickable {
  Widget clickRegion({
    required Widget child,
    required void Function(TapDownDetails)? onTapDown,
  }) {
    return GestureDetector(
      onTapDown: onTapDown,
      child: child,
    );
  }
}
