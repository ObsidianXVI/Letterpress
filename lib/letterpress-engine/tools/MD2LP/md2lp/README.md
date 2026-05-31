# md2lp

`md2lp` converts Letterpress markdown sources into Dart declarations that use
the site's `LPModule`, `LPPost`, and `LPPostComponent` APIs.

## Commands

### Generate a blogule/module

```bash
dart run bin/md2lp.dart module \
  --input ../../../store/md_sources/tgif-week1_complex_calendar_widget_flutter.md \
  --publication-date 2023-03-10 \
  --last-update 2023-06-02 \
  --project-name turbocal \
  --class-name TurbocalModuleA \
  --declaration-name turbocalModuleA \
  --output /tmp/turbocal_module.dart
```

This emits:

- a `part of letterpress.store;` module class
- a top-level `final LPModule ... = ...` declaration

Supported markdown/custom blocks:

- headings
- paragraphs with links, bold, italics, strikethrough, and inline code
- ordered and unordered lists
- fenced code blocks
- blockquotes
- `@img { ... }`
- `@div`
- `@versequote { ... }`
- `@note { ... }`
- `<TOC>` marker to infer `includeTableOfContents: true`

### Generate a post declaration

```bash
dart run bin/md2lp.dart post \
  --title "Build-In-Public: Developing a complex BaaS from scratch" \
  --description "Cortado is a plug-and-play backend-as-a-service." \
  --publication-date 2026-05-02 \
  --last-update 2026-05-03 \
  --blogules cortado_initial_post,openly_open_source
```

This emits a top-level `final LPPost ... = LPPost(...)` declaration that you
can paste into `lp_store.dart`.
