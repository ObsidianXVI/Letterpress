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

---

## Should `.mcp.json` be committed?

`.gitignore` deliberately excludes every agent-config directory — `.gemini/`, `.codex/`,
`.agents/`, `.claude/` — so the whole agent setup is local-only. But `.mcp.json` is neither
ignored nor tracked; it currently shows as an untracked file. It is the one piece of agent
config that has to sit at the repository root, because Claude Code only reads project-scoped
MCP definitions from there.

**Decision needed — pick one:**

- **A. Commit `.mcp.json`.** The MCP server list is project-shaped, not machine-shaped (it
  pins the Firebase scope to this repo's `hosting`-only surface), so it is reproducible on
  any checkout. Inconsistent with the "agent config is local" stance, but useful.
- **B. Add `.mcp.json` to `.gitignore`.** Consistent with the other four directories, and
  keeps the repo free of tool-specific config. Costs re-creating the file per machine.

---

## Which email provider sends the notifications?

Needed before the CLI can send anything. Subscriptions are stored in Firestore
either way, so this only decides the send adapter — one class behind
`LPSubscriptions`/the CLI, swappable later.

Requirements: low volume, transactional-style sends with a PDF attachment for
newsletter issues, a real unsubscribe link, and DKIM/SPF on the Porkbun domain
so mail is not binned. **Verify current pricing before choosing — these change.**

| | Free tier | Then | Attachments | Notes |
|---|---|---|---|---|
| **Resend** | ~3k/mo, 100/day | ~$20/mo | yes | Cleanest API, good Dart-from-HTTP story, built for developers. Easiest to start. |
| **Brevo** | ~300/day | pay-as-you-go | yes | Higher daily allowance on free. Console is marketing-oriented; more to ignore. |
| **Amazon SES** | none really | ~$0.10/1k | yes | Far cheapest at any volume. Requires domain verification and a sandbox-exit request, and you assemble MIME yourself. Most setup, least ongoing cost. |
| **MailerSend** | ~3k/mo | ~$24/mo | yes | Comparable to Resend; templating is nicer, API slightly more involved. |
| **Postmark** | none (trial) | ~$15/mo | yes | Best deliverability reputation. No free tier, so hard to justify at this size. |

**Not viable: Porkbun webmail ($10/mo).** That is mailbox hosting, not a sending
API — no programmatic send, no bounce handling, no unsubscribe tooling, and
sending bulk from a personal mailbox is how domains get blocklisted. Keep
Porkbun for the domain and point DKIM/SPF records at whichever provider is
chosen.

**Recommendation: Resend to start**, on the free tier, and move to SES only if
volume ever makes the cost matter. The adapter boundary means that switch is one
class.

---

## Single or double opt-in?

This one has a security consequence, not just a UX one — see the note in
`docs/subscriptions.md`. Double opt-in requires something server-side to send the
confirmation, because the sending API key cannot live in the web bundle. Single
opt-in with client-side Firestore writes needs no server, but lets anyone
subscribe somebody else's address.
