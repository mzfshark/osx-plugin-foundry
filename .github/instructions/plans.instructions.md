---
description: Guidelines for organizing and creating plans in the osx-plugin-foundry repository
applyTo: "**"
---

# Plan Organization Guidelines — osx-plugin-foundry

This guide establishes the structure, hierarchy, and naming conventions for all plan documents in the osx-plugin-foundry repository.

## Directory Structure

All plan documents MUST be saved under `./docs/plans/`.

```
docs/plans/
├── PLAN.md                    # (Optional) High-level quarterly/release plan
├── PLAN_SPRINT_*.md          # Sprint-specific plans
├── SPRINT_*.md               # Sprint overviews
├── EPIC_*.md                 # Epics that span multiple sprints
├── FEATURE_*.md              # Individual features (smaller scope)
├── TASK_*.md                 # Standalone tasks
├── BUG_*.md                  # Bug fixes and patches
├── HOTFIX_*.md               # Emergency/urgent fixes
└── [ARCHIVE]/                # Closed/completed plans (optional)
```

## Hierarchy

The following hierarchy MUST be respected when organizing plans:

```
Level 1: PLAN or EPIC
  ├─ Level 2: SPRINT (optional; groups work within a sprint)
  │   ├─ Level 3: TASK
  │   ├─ Level 3: BUG
  │   ├─ Level 3: FEATURE
  │   └─ Level 3: HOTFIX
  └─ (Or directly Level 2: TASK/BUG/FEATURE/HOTFIX if not sprint-scoped)
```

**Examples:**

- `PLAN-001` (Level 1) → `SPRINT-001` (Level 2) → `TASK-001`, `FEATURE-001` (Level 3)
- `EPIC-001` (Level 1) → no sprint → `FEATURE-001`, `FEATURE-002` (Level 2)
- `HOTFIX-001` (Level 1) → standalone (no sprint/levels)

## Title Breadcrumb Format

Titles MUST follow a breadcrumb format that reflects the hierarchy. The breadcrumb clearly shows the document's position in the tree.

### Format

```
# [Parent Type] | [Intermediate Type] | [Current Type]-NNN - <Title>
```

### Examples

**Example 1: Task under a Sprint under a Plan**

```markdown
# PLAN-001 | SPRINT-001 | TASK-001 - Implement HIP plugin setup contract
```

**Example 2: Multiple features under an Epic**

```markdown
# EPIC-001 | FEATURE-001 - Add Band Oracle integration

# EPIC-001 | FEATURE-002 - Add delegation support

# EPIC-001 | FEATURE-003 - Add validator registry
```

**Example 3: Sprint with multiple items**

```markdown
# PLAN-001 | SPRINT-001 - Harmony Plugin Phase

# PLAN-001 | SPRINT-001 | TASK-001 - Set up Foundry environment

# PLAN-001 | SPRINT-001 | TASK-002 - Configure deployment scripts

# PLAN-001 | SPRINT-001 | FEATURE-001 - HIP plugin implementation
```

**Example 4: Hotfix (standalone)**

```markdown
# HOTFIX-001 - Fix storage layout collision in UUPS proxy
```

**Example 5: Bug under a Sprint under a Plan**

```markdown
# PLAN-001 | SPRINT-001 | BUG-001 - Fix permission delegation edge case
```

## Document Structure

Each plan document MUST follow this structure:

```markdown
# [Breadcrumb] - <Title>

**Repository:** osx-plugin-foundry(<OWNER>/<REPO>)  
**End Date Goal:** <date>  
**Priority:** [ LOW | MEDIUM | HIGH | URGENT ]  
**Estimative Hours:** <hours>  
**Status:** [ Backlog | TODO | In Progress | In Review | Done ]

---

## Executive Summary

Brief 1-2 sentence description of scope, objectives, and expected outcomes.

---

## Subtasks (Linked)

[Checklist with [key:<ULID>] and metadata tags]

---

## Milestones

[Timeline and key deliverables]
```

## Canonical Identity & Dedupe

Every actionable checklist item MUST include a canonical key tag to prevent duplicate GitHub issues:

```markdown
- [ ] <Task title> [key:<ULID>] [labels:type:task, area:<area>] [status:TODO] [priority:MEDIUM] [estimate:4h] [start:YYYY-MM-DD] [end:YYYY-MM-DD]
```

**Generating ULIDs:**

- Use `gitissuer rekey --repo mzfshark/osx-plugin-foundry --dry-run` to preview key injection.
- Use `gitissuer rekey --repo mzfshark/osx-plugin-foundry --confirm` to inject missing keys.

## GitHub Issue Title Format

When syncing to GitHub via `gitissuer`, issue titles are generated as breadcrumbs **without** the `-NNN` suffix:

```
[PLAN / SPRINT / TASK] - Implement HIP plugin setup contract
```

The `-NNN` numbering remains in Markdown to keep the document structured and searchable.

## Naming Conventions

- **File names:** `<TYPE>_<CONTEXT>.md`
  - Examples: `PLAN.md`, `SPRINT_1.md`, `FEATURE_hip.md`, `BUG_storage.md`
- **Heading IDs:** `<TYPE>-NNN`
  - Examples: `PLAN-001`, `SPRINT-001`, `TASK-001`, `FEATURE-001`
- **Keys:** ULID (26 chars, time-sortable)
  - Examples: `01KFRBTZSPJTN6GNH4YKG3DMJP`

## Workflow: Create → Sync → Update

1. **Draft locally** in `./docs/plans/` following the structure above.
2. **Inject keys** (if not already present):
   ```bash
   gitissuer rekey --repo mzfshark/osx-plugin-foundry --dry-run   # Preview
   gitissuer rekey --repo mzfshark/osx-plugin-foundry --confirm   # Apply
   ```
3. **Prepare engine input:**
   ```bash
   gitissuer prepare --repo mzfshark/osx-plugin-foundry
   ```
4. **Dry-run sync to GitHub:**
   ```bash
   gitissuer sync --repo mzfshark/osx-plugin-foundry --dry-run
   ```
5. **Confirm sync to GitHub** (after approval):
   ```bash
   gitissuer sync --repo mzfshark/osx-plugin-foundry --confirm
   ```

## Example: Complete Sprint Plan

```markdown
# PLAN-001 | SPRINT-001 - Harmony Plugin Implementation [key:01KFRBTZSPJTN6GNH4YKG3DMJP]

**Repository:** osx-plugin-foundry(mzfshark/osx-plugin-foundry)  
**End Date Goal:** 2026-02-07  
**Priority:** HIGH  
**Estimative Hours:** 80  
**Status:** In Progress

---

## Executive Summary

Build production-ready Harmony voting plugins (HIP, Delegation, Validator Opt-In) with comprehensive test coverage, deployment automation, and contract verification. This sprint covers plugin implementations, test scaffolding, and Harmony testnet deployment.

---

## Subtasks (Linked)

### PLAN-001 | SPRINT-001 | TASK-001: Set up Foundry environment [key:01KFRBTZSQ29H26YN4D4T1T1X7]

- [x] Configure foundry.toml for Harmony [labels:type:task, area:infra] [status:DONE] [priority:HIGH] [estimate:4h] [start:2026-01-20] [end:2026-01-21]
- [ ] Configure deployment scripts [labels:type:task, area:infra] [status:TODO] [priority:HIGH] [estimate:6h] [start:2026-01-21] [end:2026-01-22]

### PLAN-001 | SPRINT-001 | FEATURE-001: HIP plugin [key:01KFRBTZSQ29H26YN4D4T1T1X8]

- [ ] Implement core voting logic [labels:type:feature, area:contracts] [status:TODO] [priority:HIGH] [estimate:16h] [start:2026-01-21] [end:2026-01-23]
- [ ] Implement setup contract [labels:type:feature, area:contracts] [status:TODO] [priority:HIGH] [estimate:8h] [start:2026-01-23] [end:2026-01-24]
- [ ] Add permission definitions [labels:type:feature, area:contracts] [status:TODO] [priority:MEDIUM] [estimate:4h] [start:2026-01-24] [end:2026-01-25]

### PLAN-001 | SPRINT-001 | BUG-001: Fix storage collision [key:01KFRBTZSQ29H26YN4D4T1T1X9]

- [ ] Audit storage layout [labels:type:bug, area:contracts] [status:TODO] [priority:HIGH] [estimate:6h] [start:2026-01-21] [end:2026-01-22]

---

## Milestones

- **Milestone 1: Foundry Ready** — 2026-01-22 (environment + scripts)
- **Milestone 2: HIP Plugin Complete** — 2026-01-25 (core + setup + permissions)
- **Milestone 3: Storage Safety** — 2026-01-27 (BUG-001 resolved)
- **Sprint Complete** — 2026-02-07
```

## Tips & Best Practices

1. **Keep breadcrumbs readable:** Use `|` as a separator, not `:` or `→`, for consistency.
2. **Nest checklists logically:** Level 2 and Level 3 items should live under their parent headings.
3. **Use metadata tags:** Always include `[labels:...]`, `[status:...]`, `[priority:...]`, `[estimate:...]` for better tracking.
4. **Link across documents:** If a FEATURE-001 depends on TASK-001 in another sprint, reference it explicitly (e.g., "Depends on PLAN-001 | SPRINT-001 | TASK-001").
5. **Archive completed plans:** Move closed plans to `./docs/plans/[ARCHIVE]/` after sync and completion.
6. **Review before sync:** Always run `gitissuer sync --dry-run` and review the output before confirming.

---

**Version:** 1.0  
**Last Updated:** 2026-01-25  
**Maintainer:** Morpheus (Global Planning Agent)
