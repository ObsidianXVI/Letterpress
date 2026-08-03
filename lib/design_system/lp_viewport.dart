part of letterpress.ds;

/// The viewport facts every responsive widget in the site is allowed to read.
class LPViewportData {
  final Size size;
  final DetectedPlatform platform;

  const LPViewportData({
    required this.size,
    required this.platform,
  });

  bool get isMobile => platform == const MobilePlatform();
  bool get isDesktop => platform == const DesktopPlatform();

  /// Picks between two values without every call site having to spell out a
  /// platform comparison.
  T pick<T>({required T mobile, required T desktop}) =>
      isMobile ? mobile : desktop;

  @override
  bool operator ==(Object other) =>
      other is LPViewportData &&
      size == other.size &&
      platform == other.platform;

  @override
  int get hashCode => Object.hash(size, platform);
}

/// Publishes the live viewport to the whole app.
///
/// The type system and `scaled()` read `Multiplatform.currentPlatform`, a
/// static, so a widget that consults them registers no dependency on the
/// viewport and keeps rendering at whatever size the app happened to start at.
/// Worse, `Navigator` caches the widget for the current route, so rebuilding an
/// ancestor does not reach into the page at all.
///
/// Depending on an [InheritedWidget] sidesteps both problems: dependents are
/// marked dirty directly, regardless of where they sit relative to the
/// navigator. Any widget whose layout or typography varies with the viewport
/// should therefore call [LPViewport.of] rather than reading the static.
class LPViewport extends StatelessWidget {
  final Widget child;

  const LPViewport({
    required this.child,
    super.key,
  });

  /// The current viewport, registering the caller for rebuilds when it changes.
  static LPViewportData of(BuildContext context) {
    final _LPViewportScope? scope =
        context.dependOnInheritedWidgetOfExactType<_LPViewportScope>();
    assert(
      scope != null,
      'No LPViewport found. Wrap the app (or the widget under test) in an '
      'LPViewport so responsive widgets can observe the viewport.',
    );
    return scope!.data;
  }

  /// The current viewport without registering a dependency. Use only where a
  /// rebuild is already guaranteed by other means.
  static LPViewportData? maybeOf(BuildContext context) => context
      .getInheritedWidgetOfExactType<_LPViewportScope>()
      ?.data;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final DetectedPlatform platform =
        Multiplatform.platformSelector(size.width, size.height);

    // The static is the contract the type system and `scaled()` already speak,
    // so it is kept in step here rather than rewriting every typeface to take a
    // platform argument. Assigning it during build is safe because the value is
    // derived purely from the size we were just handed, and writing the same
    // value twice is a no-op.
    Multiplatform.currentPlatform = platform;

    return _LPViewportScope(
      data: LPViewportData(size: size, platform: platform),
      child: child,
    );
  }
}

class _LPViewportScope extends InheritedWidget {
  final LPViewportData data;

  const _LPViewportScope({
    required this.data,
    required super.child,
  });

  @override
  bool updateShouldNotify(_LPViewportScope oldWidget) => data != oldWidget.data;
}
