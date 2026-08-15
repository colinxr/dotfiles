---
name: acli
description:
  "Reference guide for the Atlassian CLI (acli) - a command-line tool for
  interacting with Jira Cloud and Atlassian organization administration. Use
  this skill when the user wants to perform Jira operations
  (create/edit/search/transition work items, manage projects, boards, sprints,
  filters, dashboards), administer Atlassian organizations (manage users,
  authentication), or automate Atlassian workflows from the terminal. Covers all
  acli commands including: jira workitem (create, edit, search, assign,
  transition, comment, clone, link, archive), jira project (create, list,
  update, archive), jira board/sprint, jira filter/dashboard, admin user
  management, and rovodev (Rovo Dev AI agent). Requires an authenticated acli
  binary already installed on the system."
required_tools:
  - acli
env_vars:
  - name: API_TOKEN
    description:
      "Atlassian API token for non-interactive Jira authentication (optional —
      only needed for CI/automation, not for interactive OAuth login)"
    required: false
  - name: API_KEY
    description:
      "Atlassian Admin API key for organization administration commands
      (optional — only needed for admin commands)"
    required: false
---

# Atlassian CLI (acli) Reference

## Prerequisites

This skill requires `acli` to be installed and authenticated. The binary is NOT
bundled with this skill.

If acli is not installed, guide the user to:
https://developer.atlassian.com/cloud/acli/guides/install-acli/

Verify availability:

```bash
acli --help
```

## Authentication

Check auth status before running commands:

```bash
acli jira auth status
acli admin auth status
```

If not authenticated, there are three methods:

**OAuth (interactive, recommended for users):**

```bash
acli jira auth login --web
```

**API Token (non-interactive, recommended for CI/automation):**

```bash
echo "$API_TOKEN" | acli jira auth login --site "mysite.atlassian.net" --email "user@atlassian.com" --token
```

**Admin API Key (for admin commands only):**

```bash
echo "$API_KEY" | acli admin auth login --email "admin@atlassian.com" --token
```

Switch between accounts:

```bash
acli jira auth switch --site mysite.atlassian.net --email user@atlassian.com
acli admin auth switch --org myorgname
```

## Security

### Secret Handling

- **Never hardcode tokens or API keys in commands.** Always use environment
  variables (`$API_TOKEN`, `$API_KEY`) or file-based input (`< token.txt`).
- **Never log, echo, or display tokens** in output. Avoid piping secrets through
  intermediate files that persist on disk.
- **Prefer OAuth (`--web`) for interactive use.** Only use token-based auth for
  CI/automation where OAuth is not feasible.
- **Do not store tokens in shell history.** If using
  `echo "$API_TOKEN" | acli ...`, ensure the variable is set in the environment
  rather than inlined as a literal value.

### Destructive Operations

The following commands are **destructive or irreversible** — always confirm with
the user before executing:

- `acli jira workitem delete` — permanently deletes work items
- `acli jira project delete` — permanently deletes a project and all its work
  items
- `acli admin user delete` — deletes managed user accounts
- `acli admin user deactivate` — deactivates user accounts
- `acli jira field delete` — moves custom fields to trash

These commands are **impactful but reversible**:

- `acli jira workitem archive` / `unarchive`
- `acli jira project archive` / `restore`
- `acli admin user cancel-delete` — cancels pending deletion
- `acli jira field cancel-delete` — restores field from trash

**Agent safety rules:**

1. Never run destructive commands without explicit user confirmation, even if
   `--yes` is available.
2. When bulk-targeting via `--jql` or `--filter`, first run a search with the
   same query to show the user what will be affected.
3. Prefer `--json` output to verify targets before applying destructive changes.
4. Do not combine `--yes` with destructive bulk operations unless the user
   explicitly requests unattended execution.

## Command Structure

```
acli <command> [<subcommand> ...] {MANDATORY FLAGS} [OPTIONAL FLAGS]
```

Four top-level command groups:

- `acli jira` - Jira Cloud operations (workitems, projects, boards, sprints,
  filters, dashboards, fields)
- `acli admin` - Organization administration (user management, auth)
- `acli rovodev` - Rovo Dev AI coding agent (Beta)
- `acli feedback` - Submit feedback/bug reports

## Common Patterns

### Output Formats

Most list/search commands support: `--json`, `--csv`, and default table output.

### Bulk Operations

Target multiple items via:

- `--key "KEY-1,KEY-2,KEY-3"` - comma-separated keys
- `--jql "project = TEAM AND status = 'To Do'"` - JQL query
- `--filter 10001` - saved filter ID
- `--from-file "items.txt"` - file with keys/IDs (comma/whitespace/newline
  separated)

Use `--ignore-errors` to continue past failures in bulk operations. Use `--yes`
/ `-y` to skip confirmation prompts (useful for automation).

### Pagination

- `--limit N` - max items to return (defaults vary: 30-50)
- `--paginate` - fetch all pages automatically (overrides --limit)

### JSON Templates

Many create/edit commands support `--generate-json` to produce a template, and
`--from-json` to consume it:

```bash
acli jira workitem create --generate-json > template.json
# edit template.json
acli jira workitem create --from-json template.json
```

## Writing Ticket Bodies (ADF — Atlassian Document Format)

### The problem with `--description` and wiki markup

When you pass plain text or wiki-markup-style strings (e.g., `h2. Heading\n*bold* text`) to `--description` or `--description-file`, Jira stores them as a **single escaped paragraph**. The wiki markup is NOT parsed — it renders as literal text in the UI. This is the most common failure mode when writing ticket descriptions programmatically.

**Wrong** (renders as one ugly paragraph with literal asterisks):
```bash
acli jira workitem edit --key EHQ-123 --description "h2. User Story

*As a* developer, *I want* a thing, *so that* reason.

h2. Acceptance Criteria
# AC1
# AC2"
```

**Right** (renders as structured headings, bold, ordered list): send a proper **Atlassian Document Format (ADF)** JSON document via `--description-file`.

### ADF structure basics

ADF is a JSON document with a fixed schema. Top-level is always:

```json
{
  "type": "doc",
  "version": 1,
  "content": [ ...nodes... ]
}
```

Each node in the `content` array is a block-level element (paragraph, heading, list, code block). Text inside paragraphs carries inline `marks` (bold, italic, code, links).

### Common block nodes

| Node type | Structure | Notes |
|---|---|---|
| `paragraph` | `{"type": "paragraph", "content": [{"type": "text", "text": "..."}]}` | Basic text block |
| `heading` | `{"type": "heading", "attrs": {"level": 2}, "content": [{"type": "text", "text": "Section Title"}]}` | Levels 1–6 |
| `bulletList` | `{"type": "bulletList", "content": [{"type": "listItem", "content": [{"type": "paragraph", "content": [...]}]}]}` | Unordered list |
| `orderedList` | `{"type": "orderedList", "attrs": {"order": 1}, "content": [{"type": "listItem", "content": [...]}]}` | Ordered list; `attrs.order` sets start number |
| `codeBlock` | `{"type": "codeBlock", "attrs": {"language": "typescript"}, "content": [{"type": "text", "text": "const x = 1;"}]}` | Code block with optional language |
| `rule` | `{"type": "rule"}` | Horizontal divider |

### Inline text marks

Marks are applied via the `marks` array on a text node:

```json
{
  "type": "text",
  "text": "bold and italic",
  "marks": [{"type": "strong"}, {"type": "em"}]
}
```

| Mark type | Effect | Example |
|---|---|---|
| `strong` | **bold** | `{"type": "strong"}` |
| `em` | *italic* | `{"type": "em"}` |
| `code` | `inline code` | `{"type": "code"}` |
| `link` | hyperlink | `{"type": "link", "attrs": {"href": "https://..."}}` |
| `strike` | ~~strikethrough~~ | `{"type": "strike"}` |
| `sub` | subscript | `{"type": "sub"}` |
| `sup` | superscript | `{"type": "sup"}` |

### The workflow pattern

1. Write the ADF JSON to a temporary file.
2. Call `acli jira workitem edit --key KEY-123 --description-file /tmp/desc.json` (or `create` with `--description-file`).
3. The file must contain valid JSON — verify with `jq . /tmp/desc.json` before sending.
4. Clean up the temp file after if desired (not required).

### Minimal example — a heading + paragraph + ordered list

```json
{
  "type": "doc",
  "version": 1,
  "content": [
    {
      "type": "heading",
      "attrs": {"level": 2},
      "content": [{"type": "text", "text": "User Story", "marks": [{"type": "strong"}]}]
    },
    {
      "type": "paragraph",
      "content": [
        {"type": "text", "text": "As a ", "marks": [{"type": "em"}]},
        {"type": "text", "text": "developer"},
        {"type": "text", "text": ", I want ", "marks": [{"type": "em"}]},
        {"type": "text", "text": "a feature", "marks": [{"type": "strong"}]},
        {"type": "text", "text": ", so that ", "marks": [{"type": "em"}]},
        {"type": "text", "text": "users can do X."}
      ]
    },
    {
      "type": "heading",
      "attrs": {"level": 3},
      "content": [{"type": "text", "text": "Acceptance Criteria"}]
    },
    {
      "type": "orderedList",
      "attrs": {"order": 1},
      "content": [
        {"type": "listItem", "content": [{"type": "paragraph", "content": [{"type": "text", "text": "AC1 — schema is defined"}]}]},
        {"type": "listItem", "content": [{"type": "paragraph", "content": [{"type": "text", "text": "AC2 — tests pass"}]}]}
      ]
    }
  ]
}
```

### Code block with syntax highlighting

```json
{
  "type": "codeBlock",
  "attrs": {"language": "typescript"},
  "content": [
    {
      "type": "text",
      "text": "export const SocraticState = new StateSchema({\n  messages: MessagesValue,\n  mode: z.enum([...]).default(\"diagnostic\"),\n});"
    }
  ]
}
```

### Bullet list with mixed formatting

```json
{
  "type": "bulletList",
  "content": [
    {
      "type": "listItem",
      "content": [
        {
          "type": "paragraph",
          "content": [
            {"type": "text", "text": "Does not add tools", "marks": [{"type": "strong"}]},
            {"type": "text", "text": " — that is A2 (EHQ-284)."}
          ]
        }
      ]
    },
    {
      "type": "listItem",
      "content": [
        {
          "type": "paragraph",
          "content": [
            {"type": "text", "text": "Does not change the prompt", "marks": [{"type": "strong"}]},
            {"type": "text", "text": " — that is A3 (EHQ-285). See "},
            {"type": "text", "text": "RFC-001", "marks": [{"type": "link", "attrs": {"href": "https://example.com/rfc-001"}}]}
          ]
        }
      ]
    }
  ]
}
```

### Critical: validate JSON before pushing

**The #1 failure mode** when writing ADF programmatically is producing JSON that looks right but has a structural error — most commonly a missing closing brace `}` on the last paragraph object. Jira silently accepts the malformed JSON as plain text, storing the entire JSON blob as a single escaped paragraph. The ticket then shows raw `{"type": "doc", ...}` text in the UI instead of rendered headings.

**Always validate before pushing:**

```bash
# Validate the file is parseable JSON
jq . /tmp/desc.json > /dev/null && echo "valid" || echo "INVALID"

# Or with Python (gives line/column on error)
python3 -c "import json; json.load(open('/tmp/desc.json'))" && echo "valid" || echo "INVALID"
```

If validation fails, **do not push**. Fix the JSON first. The most common structural error is a paragraph object whose `content` array closes with `]` but the paragraph's outer `}` is missing — producing `\n  ]\n}` instead of `\n  }]}\n  ]\n}` at the end of the file.

**After pushing, verify the ADF landed correctly** — don't trust the "successfully edited" message alone:

```bash
acli jira workitem view KEY-123 --json | python3 -c "
import sys, json
d = json.load(sys.stdin)
desc = d['fields'].get('description', {})
blocks = desc.get('content', []) if isinstance(desc, dict) else []
headings = sum(1 for b in blocks if b.get('type') == 'heading')
lists = sum(1 for b in blocks if b.get('type') in ('orderedList', 'bulletList'))
codes = sum(1 for b in blocks if b.get('type') == 'codeBlock')
print(f'{len(blocks)} blocks, {headings} headings, {lists} lists, {codes} code blocks')
# If you see '1 blocks, 0 headings, 0 lists, 0 code blocks' — the JSON
# was stored as escaped plain text, not parsed as ADF. Fix and re-push.
"
```

### Tips for generating ADF programmatically

- **Nesting is always: block → paragraph → text nodes with marks.** List items contain paragraphs; paragraphs contain text nodes. You cannot put a text node directly in a `listItem` — it must be wrapped in a `paragraph`.
- **Empty lines between sections** are separate `paragraph` nodes with empty `content` arrays, not whitespace inside other nodes.
- **Multi-line text** (newlines inside a code block) is a single text node with `\n` characters — not multiple text nodes.
- **Links go on the text node**, not as a standalone node. Use `{"type": "link", "attrs": {"href": "..."}}` inside `marks`.
- **Escaping**: JSON-escape all special characters. Backticks for inline code use the `code` mark, not literal backticks.
- **Size limits**: Jira accepts descriptions up to ~30,000 characters of JSON. For very long descriptions, consider linking to an external doc instead.
- **When in doubt**, use `acli jira workitem view KEY-123 --json` to inspect an existing ticket's ADF structure — copy the shape from a ticket that already renders correctly.
- **The last paragraph is the most error-prone.** When hand-writing JSON, the final block before the closing `]` of the doc's `content` array is the one most likely to miss its closing `}`. Always check the tail of the file: it should end with `}]}\n  ]\n}` (paragraph content `]`, paragraph object `}`, doc content `]`, doc object `}`). If it ends with `]\n  ]\n}`, a `}` is missing.
- **Python's `json.dump()` is more reliable than hand-writing.** If you build the ADF as a Python dict and serialize it, you cannot produce structural JSON errors. See the builder pattern below.

### Recommended ticket body structure for engineering tickets

For implementation tickets (stories, tasks), use this seven-section structure. Each section maps to a block type, making the ADF generation mechanical:

| Section | Block type | Content |
|---|---|---|
| **User Story** | H2 heading + paragraph | "As a _role_, I want _feature_, so that _benefit_." Use em marks on "As a", "I want", "so that". |
| **Acceptance Criteria** | H2 heading + orderedList | Numbered list. Each item is a paragraph with a bolded criterion name + description. |
| **Technical Approach** | H2 heading + H3 subsections + paragraphs + codeBlocks | Architecture summary, code sketches, "what changes / what doesn't" bullet lists. |
| **What this ticket does NOT do** | H3 heading + bulletList | Explicit out-of-scope items with bold headers. Prevents scope creep. |
| **Implementation Plan** | H2 heading + paragraph + orderedList | One sentence intro linking to commit-plan file, then ordered list of commit titles in code format. |
| **Source of Truth** | H2 heading + bulletList | Links to `.context/tickets/{id}/`, `.context/rfcs/`, vision docs. Bold headers + code-formatted paths. |
| **Definition of Done** | H2 heading + bulletList | Checklist items: tests green, typecheck green, lint green, docs updated, PR merged. |
| **Footer** | paragraph | "Epic: [link] | Depends on: X | Blocks: Y | Estimate: N days" — hyperlinked epic key. |

### Python ADF builder pattern (recommended for complex tickets)

Instead of hand-writing JSON (error-prone), build the ADF as a Python dictionary and serialize it. This eliminates structural JSON errors entirely:

```python
import json

def heading(text, level=2, bold=False):
    marks = [{"type": "strong"}] if bold else []
    return {"type": "heading", "attrs": {"level": level},
            "content": [{"type": "text", "text": text, "marks": marks}]}

def para(*parts):
    """parts: list of (text, [marks]) tuples or plain strings"""
    content = []
    for p in parts:
        if isinstance(p, str):
            content.append({"type": "text", "text": p})
        else:
            text, marks = p
            content.append({"type": "text", "text": text, "marks": marks or []})
    return {"type": "paragraph", "content": content}

def code_block(code, lang="typescript"):
    return {"type": "codeBlock", "attrs": {"language": lang},
            "content": [{"type": "text", "text": code}]}

def bullet_list(items):
    return {"type": "bulletList", "content": [
        {"type": "listItem", "content": [para(i) if isinstance(i, str) else i]}
        for i in items
    ]}

def ordered_list(items):
    return {"type": "orderedList", "attrs": {"order": 1}, "content": [
        {"type": "listItem", "content": [para(i) if isinstance(i, str) else i]}
        for i in items
    ]}

BOLD = [{"type": "strong"}]
EM = [{"type": "em"}]
CODE = [{"type": "code"}]

def link(text, href):
    return (text, [{"type": "link", "attrs": {"href": href}}])

# Build the document
doc = {
    "type": "doc",
    "version": 1,
    "content": [
        heading("User Story", bold=True),
        para(("As a ", EM), ("developer", ), (", I want ", EM), ("a feature", BOLD),
             (", so that ", EM), ("users can do X.")),
        heading("Acceptance Criteria", bold=True),
        ordered_list([
            para(("Schema is defined", BOLD), (" — new file ", ), ("src/agent/state.ts", CODE)),
            para(("Tests pass", BOLD), (" — ", ), ("npm run agent:test", CODE), (" green.")),
        ]),
        heading("Technical Approach", bold=True),
        heading("State Schema", level=3),
        code_block("export const SocraticState = new StateSchema({ ... });"),
        heading("What this ticket does NOT do", level=3),
        bullet_list([
            para(("No new tools", BOLD), (" — that is A2.")),
            para(("No frontend changes", BOLD), (" — that is A5.")),
        ]),
        heading("Implementation Plan", bold=True),
        ordered_list([
            para(("feat(agent): define SocraticState schema", CODE)),
            para(("refactor(agent): wrap createAgent in StateGraph", CODE)),
        ]),
        heading("Source of Truth", bold=True),
        bullet_list([
            para(("Implementation plan: ", BOLD), (".context/tickets/283/implementation-plan.md", CODE)),
        ]),
        heading("Definition of Done", bold=True),
        bullet_list([
            para("All acceptance criteria met"),
            para(("npm run agent:test", CODE), (" green")),
        ]),
        para("Epic: ", link("EHQ-282", "https://evelynhq.atlassian.net/browse/EHQ-282"),
             " | Estimate: 3 days"),
    ],
}

with open("/tmp/desc.json", "w") as f:
    json.dump(doc, f, indent=2)

# Validate
json.load(open("/tmp/desc.json"))
print("valid")
```

This pattern:
- **Cannot produce structural JSON errors** — `json.dump()` handles all escaping and bracket matching.
- **Is readable** — the Python dict mirrors the ADF structure visually.
- **Is reusable** — copy the helper functions (`heading`, `para`, `code_block`, `bullet_list`, `ordered_list`) into any ticket-writing script.
- **Produces consistent formatting** — every ticket body follows the same structure.

### Full workflow: write → validate → push → verify

```bash
# 1. Write the ADF (using the Python builder pattern above)
python3 build-desc.py > /tmp/desc.json

# 2. Validate JSON is parseable
jq . /tmp/desc.json > /dev/null && echo "valid" || echo "INVALID"

# 3. Push to Jira
acli jira workitem edit --key EHQ-123 --description-file /tmp/desc.json

# 4. Verify ADF landed as structured content (not escaped plain text)
acli jira workitem view EHQ-123 --json | python3 -c "
import sys, json
d = json.load(sys.stdin)
blocks = d['fields']['description'].get('content', [])
h = sum(1 for b in blocks if b.get('type') == 'heading')
l = sum(1 for b in blocks if b.get('type') in ('orderedList', 'bulletList'))
c = sum(1 for b in blocks if b.get('type') == 'codeBlock')
print(f'{len(blocks)} blocks, {h} headings, {l} lists, {c} code blocks')
# Expected: multiple blocks with headings + lists. If you see
# '1 blocks, 0 headings, 0 lists, 0 code blocks' — JSON was stored
# as plain text, not parsed. Fix the JSON and re-push.
"
```

## Quick Reference: Most Common Operations

### Work Items

```bash
# Create
acli jira workitem create --summary "Fix login bug" --project "TEAM" --type "Bug"
acli jira workitem create --summary "New feature" --project "TEAM" --type "Story" --assignee "@me" --label "frontend,p1"

# Search
acli jira workitem search --jql "project = TEAM AND assignee = currentUser()" --json
acli jira workitem search --jql "project = TEAM AND status = 'In Progress'" --fields "key,summary,assignee" --csv

# View
acli jira workitem view KEY-123
acli jira workitem view KEY-123 --json --fields "*all"

# Edit
acli jira workitem edit --key "KEY-123" --summary "Updated title" --assignee "user@atlassian.com"

# Transition
acli jira workitem transition --key "KEY-123" --status "Done"
acli jira workitem transition --jql "project = TEAM AND sprint in openSprints()" --status "In Progress"

# Assign
acli jira workitem assign --key "KEY-123" --assignee "@me"

# Comment
acli jira workitem comment create --key "KEY-123" --body "Work completed"

# Bulk create
acli jira workitem create-bulk --from-csv issues.csv
```

### Projects

```bash
acli jira project list --paginate --json
acli jira project view --key "TEAM" --json
acli jira project create --from-project "TEAM" --key "NEW" --name "New Project"
```

### Boards & Sprints

```bash
acli jira board search --project "TEAM"
acli jira board list-sprints --id 123 --state active
acli jira sprint list-workitems --sprint 1 --board 6
```

## Detailed Command Reference

For complete flag details, parameters, and examples for every command:

- **Jira work item commands** (create, edit, search, assign, transition,
  comment, clone, link, archive, attachment, watcher): See
  [references/jira-workitem-commands.md](references/jira-workitem-commands.md)
- **All other commands** (jira project/board/sprint/filter/dashboard/field,
  admin, rovodev, feedback): See
  [references/other-commands.md](references/other-commands.md)

## Epic/Parent Management

**Important**: The `--parent` flag is ONLY available on `workitem create`. You
CANNOT set or change a parent after creation via `edit`. To add stories to an
epic:

1. Create them with `--parent "EPIC-KEY"` from the start
2. Or use `workitem create-bulk --from-json` with `parentIssueId` field
3. Or move via Jira UI (no CLI alternative exists) To check if a work item has a
   parent: acli jira workitem view KEY-123 --json --fields "parent" Work item
   links (`link create`) are DIFFERENT from epic parent-child. Use `link create`
   for Blocks/Relates/Duplicate. Use `--parent` for epic hierarchy. And the
   workitem edit section should explicitly note: **Limitations**: The `edit`
   command cannot modify:

- Parent/epic linkage (use delete + recreate with `--parent`)
- Custom fields not exposed as flags (use `--from-json` with full field update)
