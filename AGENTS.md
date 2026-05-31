# Cortado Project Context

## Project Description
Letterpress is my personal blogging site, where I post short articles (blogules) for small day-to-day topics, experiences, opinions, explanations, etc. Sometimes I even write longer form articles (posts) that may be written from scratch or be built from a string of blogules sequenced together. Letterpress keeps it simple and handcrafted.

## Repo layout
```
lib/
├── design_system/        Standard components used across the site and in article, especially standard Markdown blocks
├── views/                The code for different pages in Lighthouse.
├── letterpress-engine/   All GCP infrastructure; never use gcloud for resource creation
│   ├── store/            In `md_sources` i keep the raw MD files for articles, and in `modules` i keep the articles themselves, written in Flutter. The `lp_store.dart` imports all these and also contains the code for declaring the visible posts.
│   └── tools/            Can be ignored for now. I experiment with different tools to help parse MD to Letterpress Flutter widgets and stuff
└── utils/                Utility scripts
```


## Workflows and Memory

The project is set up with a few Markdown files for long-horizon planning, situation tracking, efficient context management and surgical-precision code changes. Adhere to the following workflows, conventions, and routines.

### Context Layers

The overall picture is that state/memory is managed in three layers:

```
Layer 1 — Always loaded (cheap)
  AGENTS.md             project brief, hard rules, layout
  CURRENT_TASK.md      exactly where we are right now with the active milestone and task

Layer 2 — Loaded for the active feature (~3-5K tokens)
  _dev/features/feature-code.md   focused spec for the current/specific work unit
  DECISIONS.md         settled architectural decisions

```

### Workflow Each Turn

1. Read CURRENT_TASK.md first. This tells you exactly what to do.
2. Read DECISIONS.md if you hit an architecture question — it may already be answered. Likewise, if a decision has been answered by the user, document it properly in DECISIONS.md for future refrence.
3. Work through the task. When done:
- Verify every checkbox in the 'Definition of done' section of CURRENT_TASK.md
- Update CURRENT_TASK.md: mark done items, write what you did, set next task
- Append a one-paragraph summary to `_dev/session_log.md` with timestamp in the format:
```
DD/MM/YY HH:mm [FEAT/FIX] (<short commit hash if any commits made>) `<agent name or "dev-pro-large" if own self>` Concise but all-encompassing description/summary
... a list of core file changes (not tests or other minor stuff) in the form:
- <"A"/"M"/"D"> <filepath>
where "A" is for addition, "M" is for modification and "D" is for deletion
```
- Update _dev/test_status.md if any test status changed
- Commit working code only. Do not commit if build or tests fail.
4. If you need more context, refer to the `docs` folder for the technical blueprint of the system. Or search for documentation online. Never use third-party APIs in the codebase without grounding evidence of its actual existence. Prompt the user for guidance when not confident. Provide enough context in the prompt to the user so the user does not have to search through the logs, feature file, diffs, etc to answer.
5. If you cannot complete the task despite user prompts for guidance, write why in CURRENT_TASK.md and stop cleanly, with enough context to pick up later on without having to re-analyse for context gathering later.

Do not invent architecture. If you hit a decision the spec doesn't cover, write it to DECISIONS_NEEDED.md and continue with unblocked work.


### Sub-Agents

In order to prevent the clouding of your own context window, you will be the main orchestrator planning the feature/fix, and commanding sub-agents to perform/work through the nitty-gritty of the actual implementation, so that token costs are lower too. You will settle only key/complex details and let the sub-agents handle the rest. The sub-agents are based on increasing orders of intelligence:
- Use the `dev-light` agent For extremely brain-dead, labour-intensive work or tasks with back-and-forths or trial-and-errors. Cheap tokens.
- Use the `dev-moderate` agent For simple-to-moderate difficulty tasks or those which require average SWE skill and reasoning. Especially UI related work and design-to-code tasks once the groundwork has been laid and some refinement is needed.
- Use the `dev-high` agent For complex, critical, or wide-scoped work which require lots of reasoning and have small room for error.
- Use the `dev-pro` For the highest level of critical thinking power, reasoning, and accuracy. For truly large-scale, complex and wide-spanning problems. Use sparingly.

Ensure the sub-agents are given enough context about the plans and approach to implement such that they don't go around in circles. Also ensure they follow all the context- and project-tracking guidelines/workflows and technical guidelines outlined in this document.

# Development/Technical Guidelines

## Hard rules — always follow these
3. `flutter analyze` must return zero warnings before committing Dart code.
6. Never add API keys or secrets to any file. They live in the `.env` and GCP Secret Manager (in prod).
7. Generated files (gen/, lib/src/gen/) and build files are in .gitignore — never commit them.

## Language notes
- Dart: use freezed for all data classes, Riverpod for state management. Use MCP for static analysis

## GCP project
- Project ID: obsivision
- Default zone: us-central1-a
- Default region: us-central1

## Before finishing any task
1. Run the relevant build/lint check (see rule #1–4 above)
2. Write or update the test for the code you changed
3. `git add -p` to review your own diff before committing
4. Commit with message format: `feat(component): description` or `fix(component): description`
5. Update CURRENT_RELEASE.md with the next task to work on
6. Log into `_dev/session_log.md`

## If you hit an architecture decision the task spec doesn't cover
Stop, write the question to DECISIONS_NEEDED.md, and continue with
the next unblocked task. Do not invent architecture — flag it. At the end, prompt the user with the particular decisions needed.
