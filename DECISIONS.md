# DECISIONS

## 23/05/26

- `DeletePath` is recursive for directories and may delete empty directories as well.
  Rationale: the file API needs a single delete operation that can remove directory subtrees without requiring callers to empty them first, and the control-plane docs should reflect the same recursive semantics for workspace path deletion.

- `WriteFile` defaults to auto-creating missing parent directories, while the API can expose an explicit opt-out that requires parents to already exist.
  Rationale: this keeps common editor-driven writes ergonomic while still allowing callers to request strict parent-exists behavior when they need it. The implementation detail remains intentionally abstracted at the documentation level.

- CodeMirror's Dart language remains a plain-text fallback rather than selecting a community-maintained Dart package by default.
  Rationale: the repo should avoid claiming a specific CodeMirror Dart integration that is not the canonical upstream path, and the editor bridge should continue to treat Dart as supported via fallback text rendering until a deliberate package choice is made.

- v0.1 uses Google Artifact Registry for container image distribution.
  Rationale: keep the image registry colocated with GKE in `us-central1` so workspace and control-plane image pulls stay in-region, reducing cross-region transfer risk and keeping GCP IAM-based access control for deploys. Terraform and deployment specs should reference `us-central1-docker.pkg.dev/...` image names.

- The Flutter package's web terminal integration expects consuming apps to add xterm.js script and stylesheet tags in their own `web/index.html`; the in-repo `demo_app` is the reference integration point for local testing.
  Rationale: `flutter/` is a package rather than a runnable app shell, so a package-local `web/index.html` would not be used by downstream consumers. Documenting the host-app requirement keeps the package integration explicit and avoids relying on package-local HTML that consumers never load.

- Terminal resize travels over the WebSocket mux as message type `0x05` with an 8-byte big-endian payload `[cols:uint32][rows:uint32]`.
  Rationale: the dedicated resize message keeps terminal control traffic distinct from data frames while reusing the same big-endian binary conventions as the mux header and the agent's `WindowSize` gRPC contract.

- v0.1 keeps the control plane on Cloud Run and uses Direct VPC egress plus GKE Cloud DNS additive VPC scope for workspace-agent reachability.
  Rationale: this preserves the current release/deployment spec while giving the Cloud Run control plane a supported path to resolve and connect to headless workspace Services over private Pod IPs.

- Browser terminal sessions negotiate the `cortado-v1` WebSocket subprotocol explicitly.
  Rationale: browser WebSocket clients send a non-empty `Sec-WebSocket-Protocol` header for the terminal transport, and the control plane must echo that exact protocol during upgrade or the handshake fails before any terminal traffic starts.

- Workspace PVCs use the `cortado-workspace` StorageClass by default.
  Rationale: Task 2.1.1 bootstraps that class via Terraform in both environments, and the control plane now defaults to the same name so dynamically created workspace PVCs bind without extra per-environment overrides.

- The Cloud Run control plane discovers the GKE API endpoint and cluster CA via the Container API when explicit kubeconfig data is unavailable.
  Rationale: local development can keep using `KUBECONFIG`, but deployed Cloud Run instances do not have a kubeconfig file. Passing cluster identity env vars and resolving endpoint/CA through the Container API gives the workspace CRUD control plane a deployable Kubernetes client path without requiring in-cluster execution.

- Workspace hibernation uses a 20-minute idle timeout by default, records terminal activity to Firestore at most once per minute, and applies a separate 30-minute stale-activity fallback scan.
  Rationale: this matches Task 2.1.2’s intended UX and cost controls while preventing Firestore write amplification and still catching agent-unreachable `RUNNING` workspaces that would otherwise leak.

- Frontend-facing Flutter package work should stay at the bare minimum needed for API/client integration, with minimal styling and widget polish.
  Rationale: this package is intended to be embedded by downstream products that provide their own polished frontends, so effort should focus on middleware/client correctness, input parsing and sanitization, low-bloat integration surfaces, and avoiding unnecessary UI dependencies.

## 24/05/26

- Workspace snapshot access may widen beyond `roles/storage.objectCreator`, but the effective permissions must stay scoped so each workspace agent can only access its own snapshot data.
  Rationale: restic's normal GCS backend flow needs object create/read/list/delete capabilities, but widening the bucket role is only acceptable when the final IAM or ACL model still prevents cross-workspace snapshot access.

- Dart SDK go-to-definition targets stay on the current read-only tab path without relaxing the workspace-root file API to read `/usr/local/dart-sdk/...` sources.
  Rationale: the user explicitly chose the lowest-change path. Keeping SDK definition tabs read-only without widening the file read surface avoids a new absolute-path exception in the agent/control-plane stack and stays closest to the existing blueprint and codebase behavior.

- Task 5.1.1 ships semantic tree-sitter chunking for Python, JavaScript, and Go, while Dart remains on the validated fallback window chunker for the first indexer cut.
  Rationale: the first verified grammar set is enough to close the semantic chunker milestone without introducing an unverified Dart grammar build path into the Docker image. The fallback contract is already part of the feature spec, so keeping Dart on that path minimizes moving parts while preserving correct indexing behavior.

- Task 5.1.2 uses Vertex AI as the first embedding provider, with `text-embedding-004` as the default model and a 768-dimensional output.
  Rationale: the user explicitly asked for the simpler Vertex AI path. Keeping the first embedding pipeline inside the existing GCP stack avoids a second provider credential flow, preserves the feature spec's 768-dimension Qdrant collection target, and keeps the first implementation closer to the rest of Cortado's runtime environment.

- Feature 5.3 (AI Chat Panel) is deferred beyond the core roadmap, and v0.6 plus v0.7 are treated as the remaining essential feature releases for now.
  Rationale: the user explicitly chose to skip the next feature for the current shipping sequence so work can continue from Feature 5.2 into the local-sync and port-forwarding milestones without planning Task 5.3 as the next core deliverable.

- The daemon-to-control-plane FileSync transport stays on the simple local-development path for now, while production hardening is deferred and explicitly tracked as follow-up work.
  Rationale: the user chose to keep the dev setup lightweight rather than forcing authenticated TLS/gRPC before the daemon bridge exists. The later production path should add daemon authentication plus TLS-capable transport and any associated deployment/runtime changes before the local-sync flow is treated as production-ready.

- Unresolved local-sync `ConflictNotice` messages on channel `0x0600` belong on the local daemon WebSocket bridge (`ws://127.0.0.1:9731`), not the control-plane workspace mux.
  Rationale: file-sync conflicts are a local-daemon concern and should surface through the same localhost bridge that Task 6.1.5 exposes to the Flutter package. Keeping conflict notices on the daemon bridge avoids mixing local-sync UI events into the workspace terminal/LSP mux and keeps the responsibility boundary aligned with the local daemon feature.

- Task 7.1.2 validates requested workspace ports through the agent `ListPorts` RPC, then proxies HTTP and WebSocket traffic directly to the workspace headless-Service DNS target instead of adding a separate agent HTTP port-proxy endpoint.
  Rationale: the agent already exposes the authoritative port list, while the control plane already knows how to resolve workspace service DNS names inside the cluster network. Reusing those two surfaces keeps the preview gateway smaller, avoids inventing a second proxy hop inside the agent, and stays compatible with the existing Cloud Run to GKE private-routing model.

## 25/05/26

- User-issued Cortado API keys are minted through Firebase-authenticated control-plane endpoints, and the tenant for each issued key comes from the Firebase ID token custom claim `tenant_id`.
  Rationale: the user explicitly chose the Firebase custom-claim model instead of a fixed tenant. This keeps tenant routing out of request bodies, makes the tenant decision verifiable at token-validation time, and avoids inventing a second tenant lookup system inside Cortado.

- API keys issued through the Firebase flow are bound to the Firebase UID that created them, and `POST /v1/sessions` rejects any `user_id` that does not match a bound key's stored owner.
  Rationale: without binding the key to the verified Firebase user, any holder of the raw key could choose an arbitrary `user_id` when creating a session. Persisting and caching both tenant and user identity closes that impersonation gap while staying compatible with older tenant-scoped keys that have no stored `userId`.

- Self-service Firebase tenant-claim assignment exists only on a dedicated development-only endpoint, with the assigned tenant defaulting to `CORTADO_FIREBASE_DEV_TENANT_ID` and falling back to `demo-tenant`.
  Rationale: the user wanted localhost demo bootstrap to be fully self-service, but broad claim assignment would be too permissive for production. Scoping the route to `CORTADO_ENV=development` keeps the convenience path local to dev/demo environments while letting the app recover brand-new Firebase users automatically before minting Cortado API keys.

- The direct browser OIDC exchange decision is superseded and no longer the mainline auth plan.
  Rationale: this preserves the historical note that the team briefly moved toward tenant-managed OIDC, but the later 26/05/26 decision replaced it with Cortado-managed first-party auth as the primary product direction.

## 26/05/26

- Cortado's primary product auth path is first-party Firebase-managed end-user authentication, not tenant-managed BYO OIDC.
  Rationale: the user explicitly wants frontend-package developers to add the Cortado package without building middleware or a tenant backend. Making Cortado own the browser login/register flow is the lowest-friction path for package adoption and supersedes the previous direct-browser OIDC exchange direction as the new mainline plan.

- After one-time authenticated bootstrap, long-lived Cortado API keys remain a supported auth mode for both personal headless use and backend/server integrations.
  Rationale: browser apps should prefer refreshable Cortado session tokens, but durable API keys are still valuable for CLI, automation, and developers who want to call Cortado APIs without repeating a headed login flow.

- SaaS/server API-key integrations authenticate an external platform as one Cortado entity, while that platform remains responsible for its own downstream user identities.
  Rationale: the user wants Cortado to manage end users only in the zero-backend first-party path. When a full SaaS already operates its own auth stack, Cortado should only need platform-level trust rather than becoming the identity source of truth for every downstream user in that product.
