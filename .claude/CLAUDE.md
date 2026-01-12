# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is an Obsidian-based personal knowledge management system (vault) designed for managing tasks, projects, goals, notes, and reviews through:
- **Markdown files** with wiki-style links `[[...]]` for connecting entities
- **Git version control** for history tracking and review
- **AI agent workflows** with role-based commands (Router, Assistant, Coach, Repo-Maintainer)
- **Automated processing** of incoming materials (DOCX, PPTX, audio files)

The vault is organized into two main domains:
- `Personal/` - personal tasks, projects, notes, goals, reviews
- `Work/` - work-related tasks, projects, notes, goals, reviews

## Core Architecture

### Folder Structure
Each domain (`Personal/`, `Work/`) follows the same structure:
- `00_Inbox/` - incoming items awaiting triage
- `10_Daily/` - daily notes and logs
- `20_Tasks/` - one file per task with checkboxes
- `30_Projects/` - project files with outcomes and linked tasks
- `40_Areas/` - areas of responsibility
- `50_Notes/` - knowledge notes with wiki links
- `60_Goals/` - goals with metrics and time horizons
- `70_Reviews/` - periodic reviews (weekly, monthly, quarterly)
- `90_Assets/` - attached files and media
- `99_Archive/` - archived items (never delete, always archive)

### Entity Linking System
- Tasks link to projects/goals using `[[W-PROJ-...]]` or `[[P-PROJ-...]]` in task lines
- Projects and goals use Dataview/Tasks queries to automatically pull related items
- All links use `[[...]]` syntax for Obsidian compatibility
- Task properties use emoji annotations: `📅` (due), `⏳` (scheduled), `🛫` (start), `✅` (done)

### Frontmatter Convention
YAML frontmatter fields:
- `type`: task | project | area | goal | review | note
- `status`: todo | doing | waiting | active | paused | done | canceled
- `created`, `updated`: YYYY-MM-DD
- `area`, `project`, `goal`: `[[...]]` links
- `tags`: list of tags

## Development Commands

### Setup and Linking
```bash
# Create convenient symlinks in HOME (~/.life, ~/life, etc.)
make link
just link

# Create hardlinks (files only)
make hardlink
just hardlink

# Remove created links
make unlink
just unlink

# Install bash tooling (bats, shellcheck, yq, etc.)
make tools-install
just tools-install
```

### Testing
```bash
# Run all tests (internal + external)
make test
just test

# Run in-file self-tests only
make test-internal
just test-internal

# Run Bats tests only (requires bats-core)
make test-external
just test-external

# Run shellcheck on scripts
make shellcheck
just shellcheck
```

### Environment Management
```bash
# Generate/update .env file (interactive for passwords)
make env-generate
just env-generate
./scripts/.env-generator.sh

# Show loaded environment
make env
just env

# Allow direnv for this directory
make direnv-allow
just direnv-allow
```

### Health and Validation
```bash
# Run repository healthcheck
make healthcheck
just healthcheck

# Lint .env file
make dotenv-lint
just dotenv-lint
```

## Key Scripts and Tools

### Document Processing Scripts
All scripts located in `scripts/`:

**DOCX Processing:**
```bash
# Convert DOCX to Markdown (for reading/analysis)
scripts/docx2md.sh "/path/to/input.docx" "Work/50_Notes/<name>.md"

# Convert DOCX to note (with Summary section)
scripts/docx2note.sh "/path/to/input.docx"

# Convert DOCX to note + create task (requires user confirmation first)
scripts/docx2note.sh "/path/to/input.docx" --create-task --project [[W-PROJ-...]]

# Convert Markdown back to DOCX
scripts/md2docx.sh "Work/50_Notes/<name>.md" "/path/to/output.docx"
```

**Audio Processing:**
```bash
# Transcribe audio to note with Summary
scripts/audio2note.sh "/path/to/audio.ogg"

# Transcribe audio + create task (after confirmation)
scripts/audio2note.sh "/path/to/audio.ogg" --create-task --project [[W-PROJ-...]]
```

**Incoming Materials:**
```bash
# Process all incoming files in Inbox
scripts/process-incoming.sh
```

**Setup Tools:**
```bash
# Install pandoc locally (if not in PATH)
scripts/setup-pandoc.sh 3.1.11

# Load docx tools environment
source scripts/env-docx-tools.sh
```

### Main CLI: life.sh
```bash
# Create links
scripts/life.sh links create --mode symlink --force \
  --home-life "$HOME/life" \
  --home-life-dir "$HOME/.life" \
  --home-make "$HOME/Makefile.life" \
  --home-just "$HOME/Justfile.life"

# Remove links
scripts/life.sh links remove [same options as create]

# Run self-tests
bash -c 'source scripts/life.sh; life::selftest'
```

## Agent Workflow and Roles

### Key Documents
- `00_System/Agent-Runbook.md` - main agent runbook and protocols
- `00_System/Agent-Commands.md` - list of agent commands and roles
- `00_System/Bootstrap.md` - first-time agent setup
- `00_System/Conventions.md` - naming and linking conventions
- `00_System/Routines.md` - periodic routines and reviews

### Agent Roles (in `00_System/Prompts/`)
- **Router** - selects appropriate role and decomposes mixed requests
- **Assistant** - converts incoming materials to artifacts (tasks/projects/notes), maintains links
- **Coach** - helps formulate goals, metrics, focus, and next actions
- **Repo-Maintainer** - maintains system health, structure, minimal diffs, archiving

### Workflow Modes

**A) Capture (quick intake)**
- Create file in `*/00_Inbox/` with brief title
- Don't optimize structure, just capture
- Optionally add 1-3 clarifying questions

**B) Triage (process Inbox)**
- Review new files in `*/00_Inbox/`
- Decide outcome: task, project, note, goal, or archive
- Leave `[[...]]` link to canonical file or move content

**C) Plan (planning)**
- Create/update goals (direction) in `*/60_Goals/`
- Create/update projects (outcomes) in `*/30_Projects/`
- Create/update tasks (actions) in `*/20_Tasks/`
- Link tasks to projects/goals with `[[...]]` references

**D) Coach (goal coaching)**
- Help clarify goals with metrics and timeframes
- Suggest next actions and focus areas

**E) Maintain (repo health)**
- Run healthcheck scripts
- Archive inactive items
- Maintain clean Git history with minimal diffs

## Critical Protocols

### Processing Incoming Documents (DOCX/PPTX/Audio)
**IMPORTANT**: When processing incoming materials:
1. **First** create a note in `*/50_Notes/` with `## Summary` section
2. Ask 1-3 clarifying questions
3. **Only after user confirmation** create tasks/projects and link them to the note

Never create tasks/projects directly from incoming materials without user approval.

### Git and Archiving
- **Never delete** files - always move to `*/99_Archive/` instead
- Keep minimal diffs - avoid mass renames or restructuring
- Don't commit `.pandoc_local/` (in `.gitignore`)
- No secrets in repo - use separate secrets manager

### Task Management
- One task = one file in `*/20_Tasks/`
- Tasks must have at least one checkbox `- [ ]`
- Add project/goal links directly in task line: `[[W-PROJ-...]] [[W-GOAL-...]]`
- Use Tasks plugin emoji properties: `📅` (due), `⏳` (scheduled), `🛫` (start), `✅` (done)

### Obsidian Plugins Required
- **Dataview** - for dynamic queries
- **Tasks** - for task management with emoji properties
- **Templates** - set template folder to `00_System/Templates`

## Environment and Dependencies

### Required Tools
- `bash` 4.0+ with `set -euo pipefail`
- `pandoc` - for DOCX ↔ Markdown conversion
- `git` - version control

### Optional Tools (installed via `make tools-install`)
- `bats-core` - for running external tests
- `shellcheck` - for linting bash scripts
- `yq` - for YAML processing
- `dotenv-linter` - for .env validation
- `direnv` - for automatic environment loading
- `shdotenv` - for loading .env files

### Environment Files
- `.env` - generated from `.env.example` via `scripts/.env-generator.sh`
- `.envrc` - direnv configuration (loads .env and adds scripts/ to PATH)
- `.env.example` - template for environment variables

## Common Utilities

Shared bash utilities in `scripts/lib/bash-utils.sh`:
- `bu::log` - structured logging
- `bu::die` - fatal error with message
- Additional logging and assertion helpers

Scripts source this library for consistent error handling and logging.

## Development Notes

- Shell scripts use `set -euo pipefail` for safety
- Scripts determine repo root via `$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)`
- The `life.sh` script can be symlinked to `~/bin/life` for global access
- All scripts support `--help` flag for usage information