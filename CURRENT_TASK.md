# CURRENT TASK

## Release · Feature · Task
Letterpress polish pass → "Minor improvements" (see `PROMPT.md`)

## Status
COMPLETE — one item needs your verification, one needs a decision (see below).

## What was done this session
Worked through the `PROMPT.md` minor-improvements list.

**Breakpoints and responsiveness.** `main.dart`'s `platformSelector` only recognised
1200–1600 × 750–1000 as desktop and 400–590 × 600–1000 as mobile; every other viewport —
a 1920px monitor, a 390px iPhone, any resized window — fell through to `UnknownPlatform`
and rendered an "unsupported viewport" error page. Replaced with width-only breakpoints
(`LPBreakpoints`, split at 900px) and retired `UnknownPlatform` entirely.

**Making responsiveness actually work.** Two latent problems surfaced from that change:
- `ResponsiveTypeface` evaluates `scaled()` in its constructor, and `LPStore` is a
  `static final`, so every article's type was frozen at whatever viewport loaded first.
  Type-system entries are now getters and `LPText` holds a `TextStyle Function()` recipe.
- `scaled()` multiplies by `viewportWidth / baseWidth` unbounded. Harmless in narrow
  bands, broken once the bands became open-ended. Added `lpScaled`, which clamps the
  factor to 0.9–1.15.
- `Navigator` caches the current page widget, so a root-level `setState` never reaches
  into it. Added `LPViewport`, an inherited scope that widgets depend on directly.

**Selection.** Views are wrapped in a single `LPSelectionArea`, and `LPText` renders plain
`Text`, so a drag now carries a selection across paragraph boundaries. Verified in Chrome.

**Code blocks.** Rebuilt on `re_highlight` with a `LPColor`-mapped theme, a fixed
line-number gutter, horizontal scroll, copy button, and language/provenance header. Added
`LPInlineCode` for inline spans.

**Sticky header.** Added the leftmost square icon button opening a page-navigation menu
(currently just Home) and a centred section breadcrumb with a depth-indented dropdown that
jumps to any heading. Verified in Chrome.

**Home page.** `Newsletters` and `Discover` shared one `ViewportSize`, so a heading, two
long quotes and a 520px carousel competed for a single viewport height and the cards fell
off the bottom. Sections were split so each gets its own band, then reordered to About,
Discover, Blogules, Newsletters, with every section a full viewport wide and tall. The
carousels take the height the heading and blurb leave behind rather than a fixed height,
which is what keeps the cards inside their section instead of clipping again.

**Mobile.** Retuned the mobile type scale — `Header1` was 74px on a 390px screen and broke
headings mid-word. `PromoCard` now clamps to the viewport width.

**Incidental fixes.** Cover images were referenced as `images/covers/…` but live at
`assets/images/covers/` and were not declared in `pubspec.yaml`, so they never loaded.
Browser swipe-back disabled via `overscroll-behavior-x`. Hover state in `card_widget.dart`
was tracked and animated for but never reached the decoration.

## Definition of done
- [x] Sticky header has a leftmost square icon button with a page-navigation menu
- [x] Selection works across paragraphs, and other text in the app is selectable
- [x] Code blocks have line numbers, selection, syntax highlighting; inline code improved
- [x] Sticky header shows the current section, clickable, with a jump-to dropdown
- [x] Browser swipe-right navigation disabled
- [x] Discover area spacing fixed; no content cut off
- [x] Home sections ordered About, Discover, Blogules, Newsletters
- [x] Every home section fills the viewport width and height
- [x] Mobile experience verified at 320/390/834px
- [x] Tests added — 32 passing via `flutter test --platform chrome`
- [ ] Right-click context-menu behaviour confirmed by a real right-click (see below)

## Blocked on / decisions needed
See `DECISIONS_NEEDED.md` — the right-click selection behaviour needs a real human
right-click to verify, and there is a product decision behind it.

## Next task after this one
TBD.
