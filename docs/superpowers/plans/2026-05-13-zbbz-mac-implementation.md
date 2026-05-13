# ZBBZ for AutoCAD for Mac Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a Mac-native AutoCAD plugin that rebuilds the evidenced coordinate annotation feature set of `ZBBZ.VLX` using AutoLISP and DCL.

**Architecture:** The plugin is split into a small command entry layer, an explicit settings/state layer, a pure coordinate calculation layer, and a drawing/output layer. DCL owns the settings UI, while AutoLISP modules own command dispatch, geometry, formatting, and entity creation.

**Tech Stack:** AutoLISP, DCL, AutoCAD for Mac 2024/2025/2026, git

---

## File Structure

### Planned project files

- Create: `plugin/zbbz-mac.lsp`
  - Main load file and command registration
- Create: `plugin/zbbz-state.lsp`
  - Settings state defaults, getters, setters, validation helpers
- Create: `plugin/zbbz-format.lsp`
  - Number formatting, prefix formatting, output text assembly
- Create: `plugin/zbbz-transform.lsp`
  - UCS/WCS/custom coordinate transforms and two-point calibration math
- Create: `plugin/zbbz-annotate.lsp`
  - Main annotation workflow and entity creation
- Create: `plugin/zbbz-grid.lsp`
  - Coordinate grid generation and drawing
- Create: `plugin/zbbz-dat.lsp`
  - DAT export logic
- Create: `plugin/zbbz-dialog.lsp`
  - DCL binding logic, tile synchronization, action handlers
- Create: `plugin/zbbz-help.lsp`
  - Help text content and help dialog command
- Create: `plugin/zbbz.dcl`
  - Main `SetDimZB` dialog and supporting dialog definitions
- Create: `plugin/README.md`
  - Load instructions, command list, scope notes
- Create: `samples/manual-test-checklist.md`
  - Manual verification checklist for AutoCAD for Mac
- Create: `.gitignore`
  - Ignore `.DS_Store`

### Documentation files

- Modify: `docs/superpowers/specs/2026-05-13-zbbz-mac-design.md`
  - Only if implementation uncovers a spec contradiction
- Create: `docs/superpowers/plans/2026-05-13-zbbz-mac-implementation.md`
  - This plan file

## Task 1: Clean repository metadata and lock project skeleton

**Files:**
- Create: `.gitignore`
- Create: `plugin/README.md`
- Modify: repository root by adding `plugin/` and `samples/`

- [ ] **Step 1: Write `.gitignore` with macOS junk exclusions**

```gitignore
.DS_Store
```

- [ ] **Step 2: Create the plugin folder structure**

Create:

```text
plugin/
samples/
```

- [ ] **Step 3: Add `plugin/README.md` with exact scope**

Content must include:

- supported target: AutoCAD for Mac current versions
- load file: `plugin/zbbz-mac.lsp`
- main command: `ZBBZ`
- non-goals:
  - no Windows VLX compatibility
  - no claimed DAT compatibility with the original Windows plugin

- [ ] **Step 4: Verify repository layout**

Run: `find . -maxdepth 2 -type f | sort`
Expected: includes `.gitignore`, `plugin/README.md`, the spec, and the plan

- [ ] **Step 5: Commit**

```bash
git add .gitignore plugin/README.md docs/superpowers/plans/2026-05-13-zbbz-mac-implementation.md
git commit -m "chore: add zbbz mac project skeleton"
```

## Task 2: Build the settings state layer

**Files:**
- Create: `plugin/zbbz-state.lsp`
- Test: `samples/manual-test-checklist.md`

- [ ] **Step 1: Write the state defaults in `plugin/zbbz-state.lsp`**

Define one explicit settings structure containing:

```lisp
coord_mode
base_n
base_e
rotation
dim_layer
arrow_style
arrow_size
text_style
precision
bearing_angle
dim_scale
text_height
background_mask
swap_xy
group_on
auto_orient
prefix_mode
```

- [ ] **Step 2: Add simple getter/setter helpers**

Create small functions for:

- reset defaults
- read one key
- update one key
- update many keys

- [ ] **Step 3: Add validation helpers**

Implement minimal validation for:

- coordinate mode values
- numeric fields
- angle fields
- prefix mode values

- [ ] **Step 4: Add manual test checklist entries for state expectations**

Add checklist items covering:

- defaults load correctly
- custom mode accepts base values
- invalid mode values are rejected

- [ ] **Step 5: Commit**

```bash
git add plugin/zbbz-state.lsp samples/manual-test-checklist.md
git commit -m "feat: add zbbz settings state layer"
```

## Task 3: Build formatting and output text assembly

**Files:**
- Create: `plugin/zbbz-format.lsp`
- Modify: `samples/manual-test-checklist.md`

- [ ] **Step 1: Implement precision-based number formatting**

Add one formatting function that accepts:

- numeric value
- precision setting

And returns the display string.

- [ ] **Step 2: Implement prefix label resolution**

Support exactly:

- `xy`
- `ab`
- `ne`
- `none`

- [ ] **Step 3: Implement coordinate output assembly**

Create one function that accepts:

- first value
- second value
- prefix mode
- swap flag
- precision

And returns both output lines.

- [ ] **Step 4: Add manual checklist coverage**

Cover:

- XY output
- AB output
- NE output
- no-prefix output
- swap X/Y behavior

- [ ] **Step 5: Commit**

```bash
git add plugin/zbbz-format.lsp samples/manual-test-checklist.md
git commit -m "feat: add zbbz output formatting"
```

## Task 4: Build coordinate transformation and calibration math

**Files:**
- Create: `plugin/zbbz-transform.lsp`
- Modify: `samples/manual-test-checklist.md`

- [ ] **Step 1: Implement UCS and WCS point resolution helpers**

Provide clear functions for:

- resolve current coordinate point
- resolve world coordinate point

- [ ] **Step 2: Implement custom coordinate transform**

Given:

- drawing point
- base N
- base E
- rotation

Return transformed output coordinates.

- [ ] **Step 3: Implement two-point calibration math**

Given:

- source P1/P2
- destination P1/P2

Compute:

- rotation
- calculated scale
- distance difference
- resolved base N / base E

- [ ] **Step 4: Document exact formulas inline where needed**

Add brief comments only above the core transform/calibration functions.

- [ ] **Step 5: Add manual checklist coverage**

Cover:

- current mode output
- world mode output
- custom mode output
- two-point calibration writes expected values

- [ ] **Step 6: Commit**

```bash
git add plugin/zbbz-transform.lsp samples/manual-test-checklist.md
git commit -m "feat: add zbbz coordinate transforms"
```

## Task 5: Build the DCL dialog and binding layer

**Files:**
- Create: `plugin/zbbz.dcl`
- Create: `plugin/zbbz-dialog.lsp`
- Modify: `samples/manual-test-checklist.md`

- [ ] **Step 1: Write `SetDimZB` dialog in `plugin/zbbz.dcl`**

Include sections for:

- coordinate mode
- custom fields
- coordinate actions
- behavior toggles
- prefix mode
- style settings
- DAT button
- OK
- Help

- [ ] **Step 2: Bind tiles in `plugin/zbbz-dialog.lsp`**

Implement:

- initial tile population from settings state
- saving values back into settings state
- enabling/disabling custom coordinate inputs by mode

- [ ] **Step 3: Bind dialog action buttons**

Wire handlers for:

- angle pick
- known base point and angle
- known two-point pick
- draw coordinate grid
- generate DAT file
- help

- [ ] **Step 4: Keep the preview area intentionally simple**

If a preview tile is added, ensure it is static or minimally descriptive only.

- [ ] **Step 5: Add manual checklist coverage**

Cover:

- dialog opens
- dialog fields load defaults
- mode switch enables/disables the right fields
- all buttons are wired

- [ ] **Step 6: Commit**

```bash
git add plugin/zbbz.dcl plugin/zbbz-dialog.lsp samples/manual-test-checklist.md
git commit -m "feat: add zbbz settings dialog"
```

## Task 6: Build the main annotation workflow

**Files:**
- Create: `plugin/zbbz-annotate.lsp`
- Modify: `plugin/zbbz-format.lsp`
- Modify: `plugin/zbbz-transform.lsp`
- Modify: `samples/manual-test-checklist.md`

- [ ] **Step 1: Implement one-point annotation flow**

Flow:

- prompt for target point
- resolve output coordinates
- format text
- prompt for annotation placement
- create entities

- [ ] **Step 2: Implement continuous annotation loop**

Repeat point selection until user exits.

- [ ] **Step 3: Implement auto-orient behavior**

Keep the rule simple:

- maintain readable text
- align leader/text side with placement direction

- [ ] **Step 4: Implement grouping behavior**

If `group_on` is enabled:

- group the entities created by one annotation action

- [ ] **Step 5: Add manual checklist coverage**

Cover:

- single-point annotation
- multiple-point annotation
- auto-orient on/off
- group on/off

- [ ] **Step 6: Commit**

```bash
git add plugin/zbbz-annotate.lsp plugin/zbbz-format.lsp plugin/zbbz-transform.lsp samples/manual-test-checklist.md
git commit -m "feat: add zbbz annotation workflow"
```

## Task 7: Build coordinate grid drawing

**Files:**
- Create: `plugin/zbbz-grid.lsp`
- Modify: `plugin/zbbz-dialog.lsp`
- Modify: `samples/manual-test-checklist.md`

- [ ] **Step 1: Implement grid bounds prompt**

Prompt the user for:

- bounds
- X spacing
- Y spacing

- [ ] **Step 2: Implement orthogonal grid generation**

Generate:

- horizontal lines
- vertical lines
- optional labels

- [ ] **Step 3: Support current/world/custom coordinate systems**

Ensure grid placement respects the active coordinate mode.

- [ ] **Step 4: Add manual checklist coverage**

Cover:

- grid in current mode
- grid in custom mode
- spacing obeyed

- [ ] **Step 5: Commit**

```bash
git add plugin/zbbz-grid.lsp plugin/zbbz-dialog.lsp samples/manual-test-checklist.md
git commit -m "feat: add zbbz coordinate grid"
```

## Task 8: Build DAT export

**Files:**
- Create: `plugin/zbbz-dat.lsp`
- Modify: `plugin/zbbz-annotate.lsp`
- Modify: `plugin/README.md`
- Modify: `samples/manual-test-checklist.md`

- [ ] **Step 1: Define the DAT schema in code and docs**

Use exactly:

```text
id,point_x,point_y,out_1,out_2,prefix_mode,rotation,scale,text_height,layer,text
```

- [ ] **Step 2: Record created annotation metadata**

Ensure each annotation stores enough data to export one record later.

- [ ] **Step 3: Implement DAT file writing**

Write UTF-8 text lines, one annotation per line.

- [ ] **Step 4: Document DAT behavior in `plugin/README.md`**

State explicitly:

- this is the Mac plugin DAT schema
- no compatibility claim with the Windows plugin DAT format

- [ ] **Step 5: Add manual checklist coverage**

Cover:

- file created
- rows match created annotations
- schema order is correct

- [ ] **Step 6: Commit**

```bash
git add plugin/zbbz-dat.lsp plugin/zbbz-annotate.lsp plugin/README.md samples/manual-test-checklist.md
git commit -m "feat: add zbbz dat export"
```

## Task 9: Build help content and load entry point

**Files:**
- Create: `plugin/zbbz-help.lsp`
- Create: `plugin/zbbz-mac.lsp`
- Modify: `plugin/README.md`
- Modify: `samples/manual-test-checklist.md`

- [ ] **Step 1: Implement help content**

Include:

- coordinate mode definitions
- custom coordinate explanation
- two-point calibration explanation
- behavior flag explanation
- DAT schema explanation
- scope limitations

- [ ] **Step 2: Implement the top-level load file**

`plugin/zbbz-mac.lsp` must:

- load all required modules
- register `ZBBZ`
- register supporting commands

- [ ] **Step 3: Document load steps in `plugin/README.md`**

Include:

- how to load the plugin
- command list
- supported scope

- [ ] **Step 4: Add manual checklist coverage**

Cover:

- load file loads without missing dependencies
- `ZBBZ` command exists
- help is reachable

- [ ] **Step 5: Commit**

```bash
git add plugin/zbbz-help.lsp plugin/zbbz-mac.lsp plugin/README.md samples/manual-test-checklist.md
git commit -m "feat: add zbbz load entry and help"
```

## Task 10: Final manual verification pass

**Files:**
- Modify: `samples/manual-test-checklist.md`
- Modify: `plugin/README.md`

- [ ] **Step 1: Run the full manual checklist in AutoCAD for Mac**

Validate:

- dialog
- point annotation
- custom coordinates
- angle pick
- two-point calibration
- auto orient
- grouping
- grid
- DAT export
- help

- [ ] **Step 2: Fix any verified defects only**

Do not add new features during this pass.

- [ ] **Step 3: Update `plugin/README.md` with verified notes**

Include any real constraints discovered during validation.

- [ ] **Step 4: Commit**

```bash
git add plugin/README.md samples/manual-test-checklist.md
git commit -m "docs: finalize zbbz mac verification notes"
```

