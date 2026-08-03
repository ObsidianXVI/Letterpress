# DECISIONS

## 03/08/26

- Letterpress renders exactly two layouts, mobile and desktop, split on **width alone** at
  900px. There is no "unsupported viewport" state.
  Rationale: the previous selector only accepted 1200–1600 × 750–1000 and 400–590 × 600–1000,
  so ordinary viewports — a 1920px monitor, a 390px phone, any resized window — hit an error
  page instead of the site. Height is not a usable signal because browser chrome, on-screen
  keyboards and desktop window shapes vary far too much. 900px sits above tablets in
  portrait and below a comfortable desktop window, and is roughly where the desktop
  layout's side-note gutters stop being usable.

- Viewport-driven font scaling is **clamped** to a 0.9–1.15 factor, via `lpScaled` in the
  design system rather than redline's `scaled`.
  Rationale: `scaled` multiplies by `viewportWidth / platformBaseWidth` with no bound. That
  was survivable while each platform matched a narrow band of widths, but with open-ended
  bands it renders body text at 47px on a 900px window and 43px on a 2560px monitor. The
  clamp keeps type responsive across a band without letting it run away at the extremes.
  Implemented locally instead of changing `project_redline`, which is shared with Octane.

- Typefaces are exposed as **getters**, and `LPText` stores a `TextStyle Function()` rather
  than a resolved `TextStyle`.
  Rationale: `ResponsiveTypeface` evaluates `scaled()` inside its constructor, and `LPStore`
  is a `static final` built once on first access. Caching either the typeface or the
  resolved style pinned the entire site's typography to whatever viewport happened to load
  first, with no way to recover on resize. Rebuilding a two-entry map per read is cheap.

- Widgets that vary with the viewport depend on **`LPViewport`**, an `InheritedWidget`,
  rather than reading `Multiplatform.currentPlatform` directly.
  Rationale: the static registers no dependency, and `Navigator` caches the widget for the
  current route, so rebuilding an ancestor never reaches into the page. Inherited-widget
  dependents are marked dirty directly, regardless of where they sit relative to the
  navigator. `LPViewport` also keeps the static in step so `scaled()` and the type system,
  which read it, agree with what the scope publishes.

- Selection is owned by **one `SelectionArea` per view** (`LPSelectionArea`), and article
  text is plain `Text`.
  Rationale: `SelectableText` owns a selection that ends at its own boundary, which is why
  a drag could not previously carry from one paragraph into the next. A single region
  spanning the view is what makes inter-paragraph selection possible.

- Code blocks use **`re_highlight`**, re-themed onto `LPColor` rather than using one of its
  bundled themes, and only the languages articles actually use are registered.
  Rationale: the user chose a maintained package over hand-rolling a tokenizer. The bundled
  themes are built for other people's palettes and would drop unrelated hues into the
  middle of an article. Registering the full grammar set would pull every language into the
  web bundle; unknown languages fall through to unstyled text, which still gets line
  numbers and selection.

- The MD2LP tools under `lib/letterpress-engine/tools/` are **excluded from analysis**.
  Rationale: they are self-contained packages with their own pubspecs that happen to live
  inside `lib/`. Analysing them as part of the site reported issues against code this
  project neither builds nor ships, which made the "zero warnings" rule unmeetable without
  editing tooling the project instructions say to leave alone.

- Tests run under **`flutter test --platform chrome`**, not the Dart VM.
  Rationale: the design system imports `package:web`, which is web-only, so the VM cannot
  even load it. This is a Flutter web site with no other target, so a browser test platform
  matches what ships.
