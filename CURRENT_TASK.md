# CURRENT TASK

## Release · Feature · Task
v0.1 → Feature 1.3 (Remote Content Bucket) → Task 1.3.1

## Status
DONE

## Objective
Implement public-GCS-backed content loading for Letterpress:
- fetch post and blogule Markdown from public URLs at runtime
- support public PDF newsletter assets with the same bucket contract
- keep the app resilient while content is migrated by falling back to embedded local article modules

## What was done last session
Feature 1.2 completed the reading-experience refresh and removed the old sibling package dependencies.

## What was done this session
Added a new remote content layer with a build-time public bucket base URL (`LP_PUBLIC_CONTENT_BASE_URL`), runtime Markdown fetching through `http`, a parser for the existing Letterpress markdown dialect (`@img`, `@div`, `@versequote`, headings, lists, code, links), detail-page rendering that prefers remote Markdown but falls back to embedded local modules when the fetch fails, source-link metadata in the article renderer, newsletter/PDF scaffolding on the homepage, a README section documenting the bucket layout, and regression tests for the parser plus remote fetch/fallback behavior.

## Remaining work this session
- upload actual Markdown and PDF objects to the public bucket
- add newsletter metadata entries once the first PDFs exist
- build/deploy with `--dart-define=LP_PUBLIC_CONTENT_BASE_URL=https://storage.googleapis.com/<bucket-name>`

## Definition of done
- [x] post and blogule detail routes can resolve content from public Markdown URLs
- [x] the app falls back to embedded local article content when remote Markdown is unavailable
- [x] the content bucket contract for Markdown/PDF objects is documented
- [x] newsletter/PDF support is scaffolded behind public URL metadata
- [x] tests and analysis pass

## Next task after this one
Populate the first real bucket objects and build the richer newsletter experience (thumbnail/first-page preview instead of placeholder PDF cards).

## Blocked on / decisions needed
None.
