# CURRENT TASK

## Release · Feature · Task
v0.1 → Feature 1.4 (MD2LP Generator) → Task 1.4.1

## Status
DONE

## Objective
Complete the in-repo `md2lp` tool so it can convert Letterpress markdown into:
- full `LPModule` classes
- top-level blogule declarations
- `LPPost` declarations
- proper `LPPostComponent` trees for the current custom markdown dialect

## What was done last session
Feature 1.3 completed public-GCS-backed runtime content loading with Markdown fetch/fallback behavior.

## What was done this session
Replaced the old hardcoded `md2lp` prototype with a real CLI package structure, added generator logic for Letterpress markdown sources, implemented `module` and `post` commands, supported the current custom markdown blocks (`@img`, `@div`, `@versequote`, `@note`) alongside headings/lists/links/code, emitted complete `LPModule` classes plus top-level blogule declarations and `LPPost` declarations, documented command usage in the package README, and added CLI tests that execute the command surface end-to-end.

## Remaining work this session
- use the completed generator against real markdown sources and replace/refresh hand-written module files as needed
- decide whether the tool should also emit `part` entries or store-registration snippets automatically

## Definition of done
- [x] `md2lp module` emits a complete `LPModule` class and top-level blogule declaration
- [x] `md2lp post` emits a valid `LPPost` declaration
- [x] the generator understands the current Letterpress markdown dialect
- [x] package-level tests and analysis pass

## Next task after this one
Run the tool against actual `md_sources` content and decide how much of the existing hand-written store/module layer should be regenerated versus kept custom.

## Blocked on / decisions needed
None.
