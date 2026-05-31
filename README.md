# Letterpress

## Remote Content Bucket

Letterpress can now pull article Markdown and newsletter PDFs from a public GCS
bucket at runtime.

Build the web app with:

```bash
flutter build web --release --dart-define=LP_PUBLIC_CONTENT_BASE_URL=https://storage.googleapis.com/<bucket-name>
```

Expected object layout inside the bucket:

```text
posts/<post-slug>.md
blogules/<blogule-slug>.md
newsletters/<newsletter-slug>.pdf
newsletters/<newsletter-slug>.png   # optional cover image path reserved for later use
```

Behavior:

- Post and blogule detail routes will try the public Markdown URL first.
- If the remote Markdown fetch fails, Letterpress falls back to the embedded
  local article content so the site keeps rendering while content is migrated.
- Newsletter cards use public PDF URLs when entries are added to
  `LPStoreRemoteContent.newsletters`.

Because the app fetches content directly from the browser, the bucket must be
publicly readable and CORS-enabled for the deployed site origin.
