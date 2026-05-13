# ZBBZ for AutoCAD for Mac Design

## Scope

Rebuild the Windows `ZBBZ.VLX` coordinate annotation plugin as an AutoCAD for Mac native plugin using `AutoLISP + DCL`.

This design follows these constraints:

- Rebuild only behavior that can be evidenced from:
  - the provided settings screenshot
  - extracted strings from `ZBBZ.VLX`
  - confirmed AutoCAD for Mac platform capabilities
- Do not guess undocumented Windows behavior
- Do not add fallback paths, workaround logic, or compatibility-driven overdesign
- Keep the implementation logic explicit and easy to understand

## Evidence Base

### Confirmed from the binary

- `LOAD((:protected . T) (:active-x . T) (:separate-namespace) (:load-file-list (:fas "bonus_128") (:fas "zbbz2.55")))`
- `DimCoord 2.55 Free by NetBeeTool`
- `SetDimZB : dialog`
- `Two Point Pick`
- `Source coordinate system`
- `Target coordinate system`
- `calculate scale`
- `reality scale`
- `Distance difference`
- `Coord prefix`
- `XY`
- `AB`
- `NE`
- `None`
- `DimLayer`
- `textStyle`
- `ArrowStyle`
- `Precision`
- `BasePtN=`
- `BasePtE=`
- `Rotation=`
- `GroupsON`
- `GroupSinglePoint`
- `AutoOrnt`
- `Export DAT file`

### Confirmed from the screenshot

- Coordinate mode area:
  - current coordinate system
  - world coordinate system
  - custom coordinate system
  - base N
  - base E
  - rotation
  - known base point and angle
  - known two-point pick
  - draw coordinate grid
- Annotation settings area:
  - annotation layer
  - arrow style
  - arrow size
  - text style
  - precision
  - bearing angle
  - bearing pick
  - annotation scale
  - text height
  - background mask
- Behavior area:
  - swap X/Y
  - group on
  - auto orient
- Prefix area:
  - XY
  - AB
  - NE
  - none
- Actions:
  - generate DAT file
  - OK
  - Help

### Confirmed from the platform

- AutoCAD for Mac supports AutoLISP and DCL dialogs
- AutoCAD for Mac does not support directly running Windows VLX in the same way as Windows
- AutoCAD for Mac does not support the Windows-only ActiveX Visual LISP APIs used by `vla-`, `vlax-`, and `vlr-`

## Product Goal

Build a Mac-native plugin that fully rebuilds the evidenced feature set of the coordinate annotation workflow:

- coordinate annotation
- coordinate mode switching
- custom coordinate system input
- two-point calibration
- angle picking
- annotation styling
- coordinate grid drawing
- DAT export

The plugin should match the original Windows plugin at the level of evidenced feature scope, while allowing implementation differences required by AutoCAD for Mac.

## High-Level Structure

The plugin is split into four modules.

### 1. Command entry module

Responsibilities:

- expose the main command `ZBBZ`
- open the main settings dialog
- dispatch user actions to:
  - coordinate annotation
  - angle picking
  - two-point calibration
  - coordinate grid drawing
  - DAT export

This module does not perform coordinate calculation or drawing logic.

### 2. Settings state module

Responsibilities:

- store and update all current plugin settings
- provide a single source of truth for dialog fields and drawing behavior

Managed fields:

- coordinate mode
- custom base N / base E / rotation
- annotation layer
- arrow style and size
- text style
- precision
- bearing angle
- annotation scale
- text height
- background mask
- swap X/Y
- group on
- auto orient
- prefix mode

### 3. Coordinate calculation module

Responsibilities:

- transform selected drawing points into output coordinate values
- apply:
  - current coordinate mode
  - world coordinate mode
  - custom coordinate mode
  - two-point calibration results
  - X/Y swap
  - prefix formatting
  - numeric precision formatting

This module only computes values and output text.

### 4. Drawing output module

Responsibilities:

- create coordinate annotation entities
- create coordinate grids
- export DAT records
- optionally group related entities

This module receives resolved coordinates and settings from the other modules and writes drawing entities.

## Command Set

Only commands required by evidenced behavior are defined.

### `ZBBZ`

Main command.

Responsibilities:

- open the settings dialog
- confirm settings
- start the main coordinate annotation workflow

### `ZBBZ_ANGLE_PICK`

Pick two points from the drawing and resolve a bearing angle for the settings dialog.

### `ZBBZ_2PT`

Run the two-point calibration flow and compute custom coordinate system parameters.

### `ZBBZ_BASE_ANGLE`

Accept user-entered base point and rotation values and commit them as the active custom coordinate system.

### `ZBBZ_GRID`

Draw a coordinate grid using the active coordinate system and current style settings.

### `ZBBZ_DAT`

Export annotation records into a DAT text file.

## Main Dialog Definition

The main DCL dialog is `SetDimZB`.

### Left section: coordinate system

#### Coordinate mode

- current coordinate system
- world coordinate system
- custom coordinate system

Behavior:

- current mode uses UCS coordinates
- world mode uses WCS coordinates
- custom mode uses `base_n`, `base_e`, and `rotation`

#### Custom coordinate fields

- `base_n`
- `base_e`
- `rotation`

Behavior:

- these fields are active inputs only in custom mode

#### Actions

- known base point and angle
- known two-point pick
- draw coordinate grid

### Middle section: preview area

The Windows dialog contains a graphic preview area.

Mac implementation rule:

- provide a dialog section that visually explains the annotation direction and prefix layout
- do not assume a feature-complete live preview unless DCL implementation proves it can be done clearly

This is a deliberate scope boundary, not a fallback behavior.

### Lower middle section: behavior flags

- swap X/Y
- group on
- auto orient

### Lower middle section: prefix options

- XY
- AB
- NE
- none

### Right section: style and output

- annotation layer
- arrow style
- arrow size
- text style
- precision
- bearing angle
- pick bearing
- annotation scale
- text height
- background mask
- generate DAT file

### Bottom actions

- OK
- Help

## Field Semantics

### Coordinate modes

#### Current coordinate system

- use the current UCS point coordinates directly for annotation output

#### World coordinate system

- use WCS coordinates directly for annotation output

#### Custom coordinate system

- transform drawing points using:
  - translation anchor
  - rotation
  - output base N / E

### Custom coordinate fields

#### Base N

- numeric value
- output northing offset of the custom system

#### Base E

- numeric value
- output easting offset of the custom system

#### Rotation

- angle value
- rotation from drawing coordinates into the custom coordinate system

### Behavior flags

#### Swap X/Y

- swap the order of the two output coordinate dimensions
- swap the corresponding labels at the same time

#### Group on

- group entities created by one annotation operation into one logical group

#### Auto orient

- automatically place leader/text orientation to keep the annotation readable

### Prefix modes

#### XY

- output labels are `X=` and `Y=`

#### AB

- output labels are `A=` and `B=`

#### NE

- output labels are `N=` and `E=`

#### None

- output values contain no coordinate labels

### Style fields

#### Annotation layer

- target drawing layer for created annotation entities

#### Arrow style

- selected from styles that can be enumerated and used in the active drawing environment
- do not assume Windows-only style inventories

#### Arrow size

- numeric size for arrow or point marker representation

#### Text style

- selected from text styles available in the active drawing

#### Precision

- numeric display precision used by coordinate formatting

#### Bearing angle

- angle used to drive annotation direction when not using pick-derived orientation

#### Annotation scale

- scale factor for the annotation graphics

#### Text height

- text height for annotation text output

#### Background mask

- enable text background mask when supported by the target AutoCAD for Mac version

## Core Workflows

### 1. Main coordinate annotation workflow

Entry:

- `ZBBZ`
- user confirms the settings dialog with `OK`

Flow:

1. read current settings
2. prompt the user to select an annotation point
3. resolve the point coordinates according to the selected coordinate mode
4. apply custom transform if custom mode is active
5. apply X/Y swap if enabled
6. format numeric output using the configured precision
7. build output text using the selected prefix mode
8. prompt for annotation placement or leader direction
9. create annotation entities
10. apply style settings
11. apply grouping if enabled
12. continue prompting for the next point until the user finishes

### 2. Auto orientation workflow

This is part of annotation placement.

Rules:

1. determine the relative direction between the anchor point and text placement
2. keep text horizontally readable
3. align leader direction with the text placement side
4. if auto orient is disabled, keep the user-specified direction without correction

### 3. Bearing pick workflow

Entry:

- pick button near the bearing angle field

Flow:

1. prompt the user to pick two points
2. compute the vector angle
3. convert it into the dialog angle representation
4. write it back to the bearing angle field

### 4. Known base point and angle workflow

Entry:

- known base point and angle button

Flow:

1. read `base_n`, `base_e`, and `rotation`
2. validate the values
3. store them as the active custom coordinate system
4. switch the coordinate mode to custom

### 5. Two-point calibration workflow

Entry:

- known two-point pick

This flow is defined only from evidenced strings and required geometry. No higher-order transformation is assumed.

Flow:

1. prompt the user to pick source points `P1` and `P2` in the drawing
2. prompt the user to enter or confirm destination coordinates for `P1` and `P2`
3. compute:
  - rotation from source direction to target direction
  - calculated scale from the two distances
  - distance difference
4. if a real scale value is provided, preserve it as the active scale input
5. resolve custom coordinate system parameters:
  - `base_n`
  - `base_e`
  - `rotation`
6. write the values back into the settings dialog
7. switch coordinate mode to custom

### 6. Coordinate grid workflow

Entry:

- draw coordinate grid

Flow:

1. read the active coordinate system and style settings
2. prompt the user for grid bounds
3. prompt the user for horizontal and vertical spacing
4. compute grid lines according to the active coordinate system
5. draw grid lines
6. add coordinate labels where required by the chosen layout

This workflow only defines a standard orthogonal coordinate grid.

### 7. DAT export workflow

Entry:

- generate DAT file
- or explicit `ZBBZ_DAT`

Confirmed fact:

- a DAT export capability exists

Unconfirmed fact:

- original DAT file structure

Therefore the Mac implementation must define its own explicit DAT schema and must not pretend to be byte-compatible with the Windows plugin.

Flow:

1. choose the annotation records to export
2. extract a record per annotation
3. write each record to one line in a text DAT file
4. save the file in UTF-8

Proposed DAT fields:

```text
id,point_x,point_y,out_1,out_2,prefix_mode,rotation,scale,text_height,layer,text
```

### 8. Help workflow

Entry:

- Help button

Content must include:

- coordinate mode definitions
- custom coordinate system explanation
- two-point calibration explanation
- behavior flag explanation
- DAT schema explanation
- known scope limitations

## Internal Data Model

The implementation should keep the data model explicit and small.

### Settings

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

### Calibration state

```lisp
src_p1
src_p2
dst_p1
dst_p2
calc_scale
real_scale
distance_diff
```

### Annotation record

```lisp
id
point_world
point_output_1
point_output_2
prefix_mode
text_line_1
text_line_2
rotation
dim_scale
text_height
layer
entities
```

### Session state

```lisp
last_settings
created_annotations
dialog_language
```

`dialog_language` is retained only as a placeholder because strings indicate a language concept exists, but there is not enough evidence to define a full language system.

## Drawing Entity Composition

One annotation operation creates a coherent set of entities:

1. anchor point
2. leader
3. arrow or marker
4. annotation text
5. optional group

No block-definition architecture is introduced at this stage.

## Text Output Rules

1. always output two coordinate dimensions
2. prefix mode affects labels only
3. `swap_xy` swaps both order and labels
4. all number formatting must go through one formatting path

## Explicit Non-Goals

The following items are intentionally not claimed or implemented beyond evidenced behavior:

1. full recovery of original Windows command inventory
2. compatibility with the original DAT binary or text format
3. exact replication of all Windows preview interactions
4. undocumented grouped-editing behavior after annotation creation
5. undocumented arrow style inventories
6. undocumented multi-language system behavior
7. undocumented advanced batch update or renumber workflows

## Recommended Implementation Order

1. state model and settings persistence
2. DCL main dialog
3. single-point and continuous annotation flow
4. coordinate transform logic
5. bearing pick
6. two-point calibration
7. coordinate grid drawing
8. DAT export
9. help content

## Delivery Boundary

The deliverable is a Mac-native AutoCAD plugin project that rebuilds the evidenced feature set cleanly and explicitly.

This design does not assume:

- direct conversion of the Windows VLX
- source-level recovery of the original plugin
- Windows-only API compatibility
