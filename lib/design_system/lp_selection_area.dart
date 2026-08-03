part of letterpress.ds;

/// Claims secondary (right) button gestures the instant they arrive, so that
/// nothing else can act on them.
///
/// [SelectableRegion] answers a secondary tap by running `_selectWordAt` on
/// macOS and iOS, which on a desktop browser means every right-click throws
/// away the reader's selection and replaces it with whichever single word sits
/// under the cursor.
///
/// `SelectableRegion` fires that callback from `acceptGesture`, so rejecting
/// its recognizer before it wins the arena suppresses the behaviour entirely.
/// Resolving during `addAllowedPointer` claims the arena on pointer down rather
/// than on pointer up, which also beats the 100ms tap deadline that would
/// otherwise let the callback through on a slow click.
///
/// This covers only the framework's own gesture path. On web there is a second,
/// independent path through the DOM — see [_RightClickSelectionGuard].
class _SecondaryPointerClaim extends OneSequenceGestureRecognizer {
  _SecondaryPointerClaim({super.debugOwner})
      : super(allowedButtonsFilter: _onlySecondaryButton);

  static bool _onlySecondaryButton(int buttons) => buttons == kSecondaryButton;

  @override
  void addAllowedPointer(PointerDownEvent event) {
    startTrackingPointer(event.pointer, event.transform);
    resolve(GestureDisposition.accepted);
  }

  @override
  void handleEvent(PointerEvent event) {
    if (event is PointerUpEvent || event is PointerCancelEvent) {
      stopTrackingPointer(event.pointer);
    }
  }

  @override
  void didStopTrackingLastPointer(int pointer) {}

  @override
  String get debugDescription => 'letterpress secondary pointer claim';
}

/// Keeps a right-click from destroying the reader's selection, while still
/// letting the browser's own context menu copy it.
///
/// Flutter's web build stretches a transparent `<div>` over every
/// [SelectableRegion] and listens for a DOM `mousedown`. On the right button it
/// dispatches a `SelectWordSelectionEvent` — collapsing whatever was selected
/// down to one word — then writes the result into that div and selects it, so
/// that the browser's native Copy has something to act on. The word selection
/// is unconditional: it happens even when the click lands inside an existing
/// selection, which is precisely the case where the reader wanted to keep it.
///
/// That listener lives on the div itself, so a capture-phase listener on the
/// document runs first and can stop the event before it ever arrives. This
/// guard does that whenever there is already a selection, and then performs the
/// useful half of the framework's work itself: it publishes the *existing*
/// selection into a proxy element and hands that to the browser. The reader
/// keeps their selection, the native menu still appears, and Copy still copies
/// the right thing.
class _RightClickSelectionGuard {
  _RightClickSelectionGuard._();

  static const String _proxyId = 'lp-selection-copy-proxy';

  /// Mirrors the framework's own styling for its hidden element: the text has
  /// to be genuinely selectable for the browser to offer Copy, so it is made
  /// invisible rather than hidden.
  static const String _proxyCss = '''
#$_proxyId {
  position: fixed;
  left: 0;
  top: 0;
  width: 1px;
  height: 1px;
  overflow: hidden;
  opacity: 0;
  color: transparent;
  white-space: pre-wrap;
  pointer-events: none;
  user-select: text;
  -webkit-user-select: text;
  -moz-user-select: text;
}
#$_proxyId::selection { background: transparent; }
''';

  static web.HTMLElement? _proxy;

  static web.HTMLElement _ensureProxy() {
    final web.HTMLElement? existing = _proxy;
    if (existing != null) return existing;

    final web.HTMLStyleElement style =
        web.document.createElement('style') as web.HTMLStyleElement;
    style.textContent = _proxyCss;
    web.document.head!.append(style);

    final web.HTMLElement created =
        web.document.createElement('div') as web.HTMLElement;
    created.id = _proxyId;
    web.document.body!.append(created);
    return _proxy = created;
  }

  /// Hands [text] to the browser as the current DOM selection.
  static void publishToBrowser(String text) {
    final web.HTMLElement proxy = _ensureProxy()..innerText = text;
    final web.Range range = web.document.createRange()
      ..selectNodeContents(proxy);
    web.window.getSelection()
      ?..removeAllRanges()
      ..addRange(range);
  }
}

/// The site's standard selection behaviour.
///
/// A single [SelectionArea] spanning a whole view is what lets a drag run from
/// one paragraph into the next; per-widget [SelectableText] cannot do that,
/// because each one owns a selection that ends at its own boundary. Text inside
/// here should therefore be plain [Text] — it becomes selectable by virtue of
/// sitting in the region.
class LPSelectionArea extends StatefulWidget {
  final Widget child;

  const LPSelectionArea({
    required this.child,
    super.key,
  });

  @override
  State<LPSelectionArea> createState() => LPSelectionAreaState();
}

class LPSelectionAreaState extends State<LPSelectionArea> {
  /// The reader's current selection, kept so the right-click guard can republish
  /// it without asking the framework (whose own accessor is private).
  String _selectedText = '';

  JSFunction? _mouseDownListener;

  @override
  void initState() {
    super.initState();
    final JSFunction listener = _handleDomMouseDown.toJS;
    _mouseDownListener = listener;
    // Capture phase, so this runs before the framework's listener on the
    // overlay div further down the tree.
    web.document.addEventListener('mousedown', listener, true.toJS);
  }

  @override
  void dispose() {
    final JSFunction? listener = _mouseDownListener;
    if (listener != null) {
      web.document.removeEventListener('mousedown', listener, true.toJS);
    }
    super.dispose();
  }

  void _handleDomMouseDown(web.Event event) {
    if (event is! web.MouseEvent) return;
    // 2 is the secondary button.
    if (event.button != 2) return;
    if (_selectedText.isEmpty) return;

    // Keep the event away from the framework's overlay listener, which would
    // otherwise collapse the selection to the word under the cursor.
    event.stopPropagation();
    _RightClickSelectionGuard.publishToBrowser(_selectedText);
  }

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      onSelectionChanged: (SelectedContent? content) {
        _selectedText = content?.plainText ?? '';
      },
      child: RawGestureDetector(
        behavior: HitTestBehavior.translucent,
        gestures: <Type, GestureRecognizerFactory>{
          _SecondaryPointerClaim:
              GestureRecognizerFactoryWithHandlers<_SecondaryPointerClaim>(
            () => _SecondaryPointerClaim(debugOwner: this),
            (_) {},
          ),
        },
        child: widget.child,
      ),
    );
  }
}
