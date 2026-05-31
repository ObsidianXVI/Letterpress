# Interim Task

This task is a small task i want you to work on in the middle of the system's development. Follow the same workflows defined previously but dont update CURRENT_TASK.md, because that is for the actual system-development tasks.

Dont update DECISIONS_NEEDED.md, DECISIONS.md, or the `_dev` folder, except for session_logs.md. All context for this task is to be stored in this file, under the `Context` section at the bottom.

## Task Objectives

The goal is to develop, using the current version of the system, a few demo Flutter Web applications that use Flutter Pub packages for the frontend, and link them up to our Cortado backend.

The point is to have a few demo apps that show our backend in play, and to show something tangible with real frontends that devs and end-users work with.

It will also be a form of advertising to the actual package developers themselves to entice them to mention our package on their package's homepage.

## Task Outline

1. Work on only ONE flutter web app, in the `demo_app` folder, creating a separate standalone page for each package that we will use for the frontend
2. Keep it simple: demonstrate all of the features of Cortado purely via the package-provided editor interface and shell/terminal. If no terminal provided, we will implement our own Terminal widget and re-use that for each page. Dont create any extra unnecessary widgets — workspace tabs, file tabs, etc. NO BELLS AND WHISTLES. Just text editor and terminal. If the package provides additional functionality that we can use to demonstrate Cortado, we use it. Otherwise, we will demonstrate all the features via Shell commands.
3. The app will be linked to one demo workspace. That means the editor in each page will be linked to the same workspace data. This will keep our costs low and infra simple.
4. Show the full lifecycle of user/project/workspace provisioning, development with Cortado, resource scaling, etc. and de-provisioning.
5. Demonstrate using the following packages:
	a. Flutter Monaco: https://pub.dev/packages/flutter_monaco
	b. Flutter COde Editor: https://pub.dev/packages/flutter_code_editor
	c. Code Forge: https://pub.dev/packages/code_forge
	d. Lite Code Editor: https://pub.dev/packages/lite_code_editor
	e. If you can find more *popular* Flutter packages that provide a code editing or IDE interface, you may bring those in as well.
6. If a package becomes too hard to integrate with or you encounter difficulties or doubts, ask me. Dont guess or assume.
7. Include some simple documentation for each package and how it can demonstrate the Cortado features (for my own reference).
8. You may refer to the Cortado docs in `/docs`. Ensure infra provisioned doesnt get too expensive. For resource scale-out, maybe consider simulating it rather than actually provisoning exrta resources.

## Assessment

### 25/05/26

Current repo state:
- `demo_app` is still a single-purpose terminal smoke harness. It is not yet structured as a multi-page showcase app.
- The existing app already proves the browser terminal path using `CortadoTerminal`, but it does not yet demonstrate editor/file workflows, workspace lifecycle controls, or package-specific editor integrations.
- The exported Flutter package surface is sufficient for a demo app without changing the Cortado package first: `CortadoTerminal`, `CortadoCodeEditor`, `WorkspaceManager`, `CortadoClient`, `CortadoAuthSession`, `CortadoWorkspaceProvider`, and the file tree/VFS pieces are already available.
- Based on the current repo, the first implementation pass should stay entirely inside `demo_app/` unless one of the target editor packages exposes a hard integration gap that the Cortado package cannot currently bridge.

## Changes Needed Before Implementation

1. Refactor `demo_app` from a single terminal screen into a small Flutter Web showcase app with one standalone page per editor package.
2. Introduce a shared demo shell in `demo_app` for common state: base URL, real session bootstrap inputs, workspace image, shared workspace ID, shell command, selected demo file, and workspace lifecycle status.
3. Reuse one shared terminal panel across all pages using `CortadoTerminal` as the fallback terminal experience when a package does not ship its own terminal UI.
4. Add one editor integration page per target package:
   - `flutter_monaco`
   - `flutter_code_editor`
   - `code_forge`
   - `lite_code_editor`
5. Keep each page minimal:
   - one editor area
   - one terminal area
   - a short package note describing what Cortado features that package page demonstrates
   - no workspace tabs, file tabs, or extra IDE chrome unless the package itself requires it
6. Add a shared workspace/demo control strip that demonstrates:
   - workspace status polling
   - create/provision workspace
   - start/resume
   - stop/hibernate
   - delete/de-provision
7. Add a shared file-loading/saving flow so every page opens content from the same Cortado workspace and writes back through `WorkspaceManager`, targeting the generated Flutter app's `lib/main.dart`.
8. Decide package-by-package how much Cortado functionality each editor can realistically demonstrate:
   - best case: load/save, syntax highlighting, maybe LSP or diagnostics hooks
   - minimum acceptable: load/save plus terminal-driven edits and shell commands that demonstrate the backend
9. Expand `demo_app/README.md` so it explains:
   - how to run the showcase
   - how the single shared workspace is configured
   - what each package page demonstrates
   - what is real backend behavior versus simulated demo behavior
10. Add/adjust `demo_app` tests only after the app structure is settled. The current widget test is for the old smoke harness and will need replacement rather than incremental edits.

## Expected File-Level Work

Likely future changes, once implementation begins:
- `demo_app/lib/main.dart`
- new route/page/state files under `demo_app/lib/src/`
- `demo_app/pubspec.yaml`
- `demo_app/README.md`
- `demo_app/test/widget_test.dart`
- `demo_app/web/index.html` only if one of the chosen editor packages needs host-page JS/CSS includes similar to the existing terminal/editor bridge

Files that should stay untouched for the first pass unless a real integration gap is proven:
- `flutter/`
- `agent/`
- `control-plane/`
- `terraform/`

## Required Backend / Environment Prerequisites

These are not changes I am allowed to implement in this task, but they are prerequisites or gaps that affect the requested real-resource demo:

1. Real session flow in Flutter Web currently means the browser must call `POST /v1/sessions` with a raw `api_key` and `user_id`.
   - Practical caveat: if `demo_app` does this directly in the browser, the bootstrap API key is exposed to the user.
   - Storing the key in a `.env` file that is not checked into version control keeps it out of git, but does not hide it from the browser at runtime because Flutter Web bundles client-side configuration into assets/JS delivered to the user.
   - For the currently intended localhost-only recording workflow, the user explicitly accepts this tradeoff.
   - Even so, the key should still be a deliberately low-scope demo credential and must stay out of version control.
2. Real workspace creation already exists, but it requires a workspace image value.
   - The demo app will use a fixed approved image: Docker Official Image `ubuntu:24.04`.
3. The requested "create a Flutter web app in the workspace and open `main.dart`" flow now assumes the workspace starts as a lightweight Linux environment and Flutter is installed manually through shell commands during the demo.
   - That means the demo app should not assume Flutter tooling is preinstalled in the workspace image.
   - The terminal flow should make room for manual setup commands before the editor pages expect `lib/main.dart` to exist.
4. There is still one path-level implementation assumption to settle for the generated app:
   - if the app is created at workspace root with `flutter create --platforms=web .`, the file to open is `lib/main.dart`
   - if the app is created in a named subdirectory, the file to open is `<subdir>/lib/main.dart`
   - unless told otherwise, implementation should assume the app is created at workspace root and open `lib/main.dart`

## Work You Should Do First

Before I implement the demo app, you should handle or confirm these prerequisites first:

1. Provision and share the demo auth bootstrap approach:
   - current user direction is a browser-exposed demo API key stored outside version control
   - this is explicitly accepted for localhost-only recording use, but the key still needs to be a deliberately low-scope demo credential
2. Confirm the exact lightweight Linux workspace image the demo app should create.
   - current implementation assumption: Docker Official Image `ubuntu:24.04`
3. Confirm the generated app location if workspace-root creation is not desired.
   - current implementation assumption: run `flutter create --platforms=web .` in the workspace root and then open `lib/main.dart`

# Context

## Current Task
- 25/05/26: reviewed `CURRENT_TASK.md`, `DECISIONS.md`, `docs/flutter-package.md`, `demo_app/README.md`, `demo_app/pubspec.yaml`, `demo_app/lib/main.dart`, and the current exported Flutter package API surface.
- 25/05/26: confirmed `demo_app` currently serves as a terminal smoke harness only; it does not yet implement the multi-page editor showcase required by this interim task.
- 25/05/26: created and switched to the `demos` git branch for this interim work.
- 25/05/26: no Cortado source code was modified; this pass only records the required demo-app work and the prerequisite decisions.
- 25/05/26: user confirmed the fixed package list, requested real resource-backed actions, chose real session flow unless caveats make that inappropriate, requested generating a Flutter web app in the workspace and opening `main.dart`, and declined extra package research.
- 25/05/26: verified from local docs/code that real session bootstrap currently requires browser-side submission of `api_key` and `user_id` to `POST /v1/sessions`, workspace CRUD exists in the control-plane API, and no separate project-provisioning API surface was found.
- 25/05/26: user clarified that the demo should use a browser-side API key kept in a non-versioned `.env` file, provision a lightweight Ubuntu/Linux workspace, rely on shell commands during the demo to install Flutter and dependencies, and that "provisioning" refers to user-tied workspace provisioning rather than a separate project resource concept.
- 25/05/26: user confirmed the demo app will only be run on localhost for UI recording, so browser exposure of the demo API key is accepted for this workflow.
- 25/05/26: user chose an Ubuntu base image from Docker for the workspace image; implementation should treat this as the Docker Official Ubuntu image pinned to `ubuntu:24.04` unless overridden later.
- 25/05/26: implemented the first `demo_app` showcase pass: optional `.env` bootstrap config loading, shared session/workspace shell, real workspace create/start/stop/delete/load/save flows, shared Cortado terminal attachment, package selector pages for Monaco / Flutter Code Editor / CodeForge Web / Lite Code Editor, updated README/test coverage, and local `.env` handling via `.env.example` plus `.gitignore`.
- 25/05/26: used `code_forge_web` for the CodeForge page because upstream `code_forge` does not support Flutter Web and explicitly points web users to the companion package.
- 25/05/26: the demo app currently assumes `flutter create --platforms=web .` is run at workspace root and then loads `lib/main.dart`.
- 25/05/26: validated the current `demo_app` implementation with `/home/OBSiDIAN/tools/flutter/bin/flutter analyze` and `/home/OBSiDIAN/tools/flutter/bin/flutter test`; both passed and the branch is ready for an implementation commit on `demos`.
- 25/05/26: implemented the missing Cortado Flutter package workspace helpers (`listWorkspaces`, `getWorkspace`, `deleteWorkspace`), aligned the package to `freezed_annotation/freezed ^3.1.0`, removed the demo-local dependency override and direct workspace HTTP workaround, and fixed the demo refresh path so authenticate/start/stop flows now refresh workspace state inside the same action.

## Decisions
- 25/05/26: keep this interim effort scoped to `demo_app/` first and avoid touching the main Cortado package/backend unless a concrete integration gap is proven during demo implementation.
- 25/05/26: treat the existing `CortadoTerminal` widget as the common terminal fallback across all package pages, since the interim brief explicitly allows a shared custom terminal when packages do not provide one.
- 25/05/26: the demo package list is fixed to `flutter_monaco`, `flutter_code_editor`, `code_forge`, and `lite_code_editor`.
- 25/05/26: the demo should use real resource-backed actions rather than simulated lifecycle actions.
- 25/05/26: the preferred auth path is a real session flow using a browser-side demo API key kept outside version control, with the caveat that this still exposes the key to the browser at runtime and therefore requires a deliberately low-scope demo credential.
- 25/05/26: localhost-only demo recording makes the browser-exposed demo API key acceptable for this interim task, provided it remains out of version control and scoped narrowly.
- 25/05/26: the demo should provision a lightweight Linux workspace and rely on terminal-driven installation of Flutter/tooling rather than assuming a prebuilt Flutter-ready image.
- 25/05/26: the workspace image should be the Docker Official Ubuntu image pinned to `ubuntu:24.04` rather than an unpinned `latest` tag.
- 25/05/26: "provisioning" in this interim task refers to user-tied workspace provisioning on the Cortado backend, not to a separate project resource.
- 25/05/26: unless the user overrides it later, implementation should assume the Flutter app is created in the workspace root and the target editor file is `lib/main.dart`.
- 25/05/26: no extra editor packages should be researched for this interim demo.
- 25/05/26: the CodeForge showcase page should use `code_forge_web` in the web demo app, while the README should clearly note that the upstream `code_forge` package itself is non-web.

## Cortado Changes Completed
- 25/05/26: `WorkspaceManager` now exposes public `listWorkspaces`, `getWorkspace`, and `deleteWorkspace` helpers, so the demo app no longer calls the workspace collection/item endpoints directly.
- 25/05/26: the Cortado Flutter package now aligns on `freezed_annotation/freezed ^3.1.0`, so current `flutter_monaco` releases no longer require a demo-local `dependency_overrides` entry.
