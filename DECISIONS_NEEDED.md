# Decisions Needed

## Right-click on a selection: native browser menu vs. keeping the selection

**Context.** `PROMPT.md` asked for the native context menu on right-click, without the
selection jumping to another word first. Those two turn out to be in tension on Flutter
web, and the reason is in the framework rather than in our code.

There are two independent paths that react to a right-click:

1. `SelectableRegion._handleRightClickDown` (`selectable_region.dart:1041`). Its `macOS`
   branch calls `_selectWordAt` unconditionally, unlike the Windows and Linux branches
   which preserve an active selection. **Suppressed** — `_SecondaryPointerClaim` in
   `lp_selection_area.dart` claims the arena on pointer-down, which rejects the framework's
   recognizer before `acceptGesture` can fire it.

2. `_platform_selectable_region_context_menu_web.dart:98`. Flutter stretches a transparent
   `<div>` over every selectable region and listens for a DOM `mousedown`. On the right
   button it dispatches `SelectWordSelectionEvent` — collapsing the selection to one word —
   and *then* writes the result into that div and selects it, which is the only reason the
   browser's native Copy has anything to act on.

Path 2 is the one that actually fires in a browser, and the word-selection is not
incidental: it is how the framework feeds the native menu. So "native menu, selection
untouched" is not reachable through the supported API.

**What is currently in the tree.** A capture-phase `mousedown` listener on `document`
(`_RightClickSelectionGuard`) that, when a selection already exists, stops the event before
Flutter's overlay listener sees it, and publishes the *existing* selection to the browser
through our own hidden proxy element. In principle this gives native menu + intact
selection + correct Copy.

**Why it is unverified.** Synthetic `MouseEvent`s cannot set `offsetX`/`offsetY` — they
arrive as 0,0 — so a scripted right-click sends the framework's word-selection to the wrong
coordinates and does not reproduce real behaviour. Verifying this needs a genuine
right-click in a real browser. The guard is inert unless a selection exists, so it is safe
to leave in place meanwhile.

**Decision needed — pick one:**

- **A. Keep the guard** (current state). Native menu, selection preserved, Copy correct.
  Depends on the framework's listener being cancellable from document-capture, so it wants
  a re-check on Flutter upgrades. Needs a real right-click to confirm it works.
- **B. Drop the guard.** Accept that right-click collapses the selection to a word, as
  stock Flutter web does. Simplest, no framework coupling, but does not fix the complaint.
- **C. Disable the browser menu** (`BrowserContextMenu.disableContextMenu()`) and draw
  Flutter's own toolbar. Fully under our control and the selection is safe, but the menu is
  Flutter-drawn rather than the browser's, so no Search / translate / extension entries.
