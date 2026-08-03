# Media and hosting

How Letterpress serves its media, why it is set up this way, and what to do when
adding or replacing an image.

## The decision

The original plan was to move media into a Cloud Storage bucket, put Cloud CDN
in front of it, and keep the app on Firebase Hosting — decoupling content
management from app deploys.

We did not do that, on purpose. **Firebase Hosting is already a global CDN.**
Serving media from a GCS bucket behind an external load balancer would not have
made anything faster; it would have added a second origin, a second TLS cert, a
DNS record, CORS configuration, and roughly US$18/month for the load balancer's
forwarding rule before a single byte of egress. The only thing it would have
bought is decoupling, which is not currently worth that.

What actually made pages fast was fixing the payload. See the numbers below.

If content-vs-deploy decoupling becomes the priority later — say, publishing
images without a rebuild — revisit this. The sketch is at the bottom.

## What the payload looks like now

| | before | after |
|---|---|---|
| `assets/images/covers/` | 19 MB (5 × 4096×2304 PNG) | 1.4 MB (2560×1440 JPEG q78) |
| `WomanAtAWindow.jpg` | 8.1 MB | 1.5 MB |
| `letterpress_1.png` | 1.8 MB, bundled, never referenced | removed from the bundle |
| bundled app assets | ~26 MB | 6.1 MB |

The single worst offender was `Serendipity.png` at **14 MB** — a photographic
artwork stored as PNG. Re-encoded to JPEG at 2560px it is 551 KB, and at display
size the two are indistinguishable.

## Rules for adding media

1. **Never commit a PNG of a photograph or painting.** PNG is lossless and has
   no business encoding continuous tone. Use JPEG. Covers are full-bleed
   backgrounds, so 2560px on the long edge at quality 78 is plenty:

   ```sh
   sips -Z 2560 --setProperty format jpeg --setProperty formatOptions 78 \
     --out out.jpg in.png
   ```

   Keep PNG only for diagrams, screenshots and anything with flat colour and
   hard edges, where JPEG's ringing would show.

2. **WebP is not automatically smaller.** It was measured here and came out
   ~3× *larger* than JPEG on the covers, because it faithfully preserves the
   film grain that JPEG discards. Measure before assuming.

3. **Changing an image means changing its filename.** `assets/assets/images/**`
   is served with a 30-day browser cache and the paths are not content-hashed,
   so replacing a file in place leaves returning readers on the old bytes for up
   to a month. Renaming sidesteps the whole problem.

4. **Asset paths start with `assets/`.** Flutter asset keys are the pubspec path,
   so `assets/images/foo.png` — not `/images/foo.png`. Every article image in
   the repo was written the second way and silently rendered nothing. There is
   no build-time error for this; the image just does not appear.

5. **Declare only what is referenced.** `pubspec.yaml`'s `assets:` list ships
   whatever it names, referenced or not.

## Cache policy

Two facts drive this, both verified against the build output rather than assumed:

- `flutter_bootstrap.js` pins an `engineRevision`, but references `main.dart.js`
  and `canvaskit/` at **unversioned paths**. Long-caching either of them risks a
  browser pairing fresh app code with a stale engine after a Flutter upgrade.
- Flutter's service worker is now a self-unregistering no-op — SW asset caching
  has been removed. **HTTP cache headers are the only caching mechanism there
  is**, which is why `firebase.json` now sets them explicitly. Without them
  Firebase's default of one hour applied to everything, including `index.html`.

| Path | Cache-Control | Why |
|---|---|---|
| `index.html`, `flutter_bootstrap.js`, `flutter.js`, `main.dart.js` | `no-cache` | Unhashed app code. Revalidation returns a ~200-byte 304 when unchanged, so this is cheap and always correct. |
| `version.json`, `manifest.json`, `flutter_service_worker.js` | `no-cache` | Must match the deployed build. |
| `assets/AssetManifest**`, `assets/FontManifest.json`, `assets/NOTICES` | `no-cache` | A stale manifest breaks every asset lookup. |
| `assets/shaders/**`, `canvaskit/**` | `no-cache` | Tied to the engine revision at an unversioned path. |
| `assets/fonts/**`, `assets/assets/fonts/**` | 1 year, `immutable` | A font file never changes under the same name. |
| `assets/assets/images/**`, `assets/packages/**`, `icons/**`, `favicon.png` | 30 days | Bulk of transfer; rename on change (rule 3). |

`no-cache` does not mean "do not store" — the browser keeps the file and
revalidates it, so repeat visits pay one round trip and no body transfer.
Firebase Hosting also purges its own edge cache on every deploy, so the CDN
never serves stale content regardless of these values.

## Deploying

Use the script, which does a clean build:

```sh
./scripts/deploy.sh
```

`flutter build web` does **not** clean `build/web` first, and Firebase deploys
that directory wholesale. Before this was noticed, production was serving
`index copy.html`, `404 copy.html`, and an entire orphaned `assets/images/` tree
containing the old 14 MB `Serendipity.png` — files that no longer existed in the
source. Always build clean before deploying.

`**/*.symbols` is excluded in `firebase.json`; those are wasm debug symbols for
canvaskit, 8.2 MB of them, and are not needed to run the app.

## Custom domain

Firebase console → Hosting → Add custom domain, then add the two A records it
gives you at your DNS provider. The managed certificate provisions within a few
hours. Nothing in the app needs to change: routing is hash-based, so there is no
server-side rewrite to configure.

## Known limitation: no wasm build

`flutter build web --wasm` produces a smaller, faster payload, and is currently
blocked:

```
package:project_redline/dimensions/dimensions.dart - dart:html unsupported
package:project_redline/multi_platform/multi_platform.dart - dart:html unsupported
```

`project_redline` is a local path package shared with Octane. Migrating those two
files from `dart:html` to `package:web` + `dart:js_interop` would unblock it.
That is the largest remaining performance lever — first load currently ships
~3.1 MB of `main.dart.js` plus a canvaskit engine.

## If decoupling becomes worth it later

The shape, for reference:

1. Bucket `letterpress-media` in `letterpress-project`, uniform bucket-level
   access, public read via `allUsers:objectViewer`.
2. Backend bucket with Cloud CDN enabled → external Application Load Balancer →
   `media.<domain>` with a Google-managed cert.
3. Bucket CORS allowing the Hosting origin — required, because CanvasKit fetches
   images via XHR and a missing `Access-Control-Allow-Origin` fails the load.
4. `LPImage.url` already exists, so article images need only a base-URL prefix.
   Covers and the artwork would move from `Image.asset` to `Image.network`.
5. Set `Cache-Control` at upload time; objects are not versioned, so keep rule 3.

Per `AGENTS.md`, GCP infrastructure is not to be created with imperative
`gcloud` commands — that would want Terraform, which this repo does not yet have.

Note also that `AGENTS.md` records the GCP project as `obsivision`; the live
Firebase project for this site is **`letterpress-project`**.
