#import "/local-lib/template-thesis.typ": *
#import "/metadata.typ": *
#pagebreak()
= #i18n("analysis-title", lang:option.lang) <sec:analysis>

== Research questions and functional requirements

In this chapter, existing procedural generation tools, frameworks, and game examples will be examined in order to identify existing capabilities and which gaps are left open. The research focuses on map generation workflows, designer control, tool accessibility, and support for hexagonal grid-based generation. Observations from the research will be used to derive requirements for the prototype framework.

Research questions:
+ What existing procedural generation tools and frameworks are available for game map generation, especially in Unity?
+ How do existing tools balance designer control, ease of use, flexibility, and technical complexity?
+ To what extent do existing tools support hexagonal grid-based map generation?
+ What gaps in existing tools justify the development of a focused Unity framework for hexagonal map generation using graph rewriting?
+ How do existing video games use procedural generation for map variety and feature-richness and what generation options are exposed to players or designers?
Based on the thesis scope defined in @sec:intro, the framework should satisfy the following functional requirements:

#figure(
  table(
    columns: (auto, 1fr),
    inset: 6pt,
    align: (left, left),
    table.header([*ID*], [*Requirement*]),

    [1], [The framework shall produce a game map as a graph of hexagonal cells.],
    [2], [The framework shall allow designers to define map generation rules based on global or local cell patterns.],
    [3], [The framework shall allow designers to define what pattern matches are considered valid candidates for rule transformations.],
    [4], [The framework shall allow rules with matches that are considered valid to transform the grid during map generation.],
    [5], [The framework shall expose generation configuration inside the Unity editor Inspector window.],
    [6], [The framework shall allow map generation without requiring designers to write little to no code.],
    [7], [The framework shall support repeatable and stable generation through configurable parameters and seeds, which will guarantee a deterministic result across configurations.],
    [8], [The framework shall provide visual feedback for generated hexagonal maps inside the Unity editor scene view.],
  ),
  caption: [Functional requirements for the proposed framework],
) <tab:functional-requirements>

#linebreak()

*Important note:* Although hexagonal grids are common in strategy/tactical, puzzle games, the proof-of-concept framework is not limited strictly to these genres. Genre compatibility serves us in the context of the defined strategy-centric scope rather than being a strict requirement.

== Candidate solutions

The following items will be inspected in the reviewed solutions:
- Flexibility in generation setup and settings.
- Designer-frendliness/code use for setup.
- Unity integration.
- Cost and accessibility.
- Learning curve.
- How wide or narrow the scope of existing solutions is.

#linebreak()

Since the framework will be developed using the Unity engine, soultion exploration will begin with the Unity Asset Store.

Packages were found by searching "procedural generation", "procedural map generation", "procedural world generation" and other search terms with minimal changes.
Most of the reviewed packages were categorized under *Tools/Terrain*, *Tools/Level Design* or *Tools/Utilities* 

Valid candidates for evaluation found in the asset store:
+ DunGen
+ RoomGen - Procedural Generator
+ Edgar Pro - Procedural Dungeon Generator
+ Dungeon Architect
+ Procedural Generation Grid

=== Unity Asset Store map generators

*Important note:* Unity Asset store provides fairly limited ways to aqcuaint yourself with package functionality. Documentation is often unavailable unless the package is purchased, leaving store descriptions, reviews and posts on github/reddit/unity forums as primary sources of information. Most packages do not have expansive manuals, guides and documentation coverage, especially from third parties.

#linebreak()

The 5 listed candidates can be categorized into 2 categories:

#figure(
  table(
    columns: (1fr, 1fr),
    inset: 6pt,
    align: (left, left),
    table.header([*Category*], [*Reviewed solutions*]),

    [Room/prefab-based dungeon generators],
    [DunGen, RoomGen, Edgar Pro],

    [Broad procedural generation frameworks],
    [Dungeon Architect, Procedural Generation Grid],
  ),
  caption: [Categories of reviewed procedural generation solutions],
) <tab:solution-categories>

- Flexibility in generation setup and settings.
- Designer-frendliness/code use for setup.
- Unity integration.
- Cost and accessibility.
- Learning curve.
- How wide or narrow the scope of existing solutions is.

To make the comparison easier to follow, candidates will be compared together by category.
First, candidates will be reviewed according to categories listed in the previous subsection.
Then, in the Candidate evaluation subsection, packages will be compared to one another. 

*Room/prefab-based dungeon generators:*
//add source page, documentation link
*1. DunGen:*

#figure(
  image("/resources/img/DunGen_map_example.png", width: 80%),
  caption: "DunGen map view during the generation process"
)

+ Flexibility in setup and settings:
  - Node-based room relationship setup allows for easy generation customization. User defines dungeon flows, tile sets, branching paths, locks, keys, object placement rules.
  - Setup focuses on dungeon-style layouts composed of room prefabs.
  - Uses a visual dungeon flow graph.
  - Archetypes consist of one or more tile sets and are used to define behavior for dungeon sections (branching, path straightening, branch caps and branch pruning and so on).

+ Designer-friendliness:
  - The package is designed around Unity editor assets and visual configuration. Little to no coding is required for basic use.
  - Coding is required when the user wants behavior that cannot be expressed through its inspector assets and built-in rules.

+ Unity integration:
  - The package is developed via and for Unity.

+ Cost and accessibility:
  - Cost: listed for `$79.99`.
  - Listed as a paid Asset Store package.
  - More accessible than large professional tools, which will be considered later, but still commercial.

+ Learning curve:
  - Basic setup is approachable, however dungeon flow concepts and tile rules require some learning.

+ Scope of the solution:
  - The package primarily focuses on procedural dungeon generation using connected rooms/tile prefabs.
  - The scope is relatively narrow. The package aims to provide designers with a flexible dungeon generator, but it also includes assets for generation.
  - Markets itself as a one-stop-shop for dungeon generation since it includes a generation framework and assets for map generation.

//add source page, documentation link
*2. RoomGen:*

  + Flexibility in setup and settings:
  - RoomGen focuses on generating rooms, buildings, modular enteriors, dungeons and dense landscapes from moduler tiles and presets which the user provides.
  - Setup is based around configurable presets. For setup, a designer creates a preset, assigns tiles and decorative objects, adjusts generation settings. Then the result is generated inside the Unity editor.

+ Designer-friendliness:
  -

+ Unity integration:
  - The package is developed via and for Unity.

+ Cost and accessibility:
  - Cost: `$39.99`.
  - Listed as a paid Asset Store package.

+ Learning curve:
  - 

+ Scope of the solution:
  -

//add source page, documentation link
*3. EdgarPro:*

  + Flexibility in setup and settings:
  - 

+ Designer-friendliness:
  -

+ Unity integration:
  - The package is developed via and for Unity.

+ Cost and accessibility:
  - Cost: `$79.99`
  - 

+ Learning curve:
  - 

+ Scope of the solution:
  -

== Candidate evaluation



== Video game examples

=== Games with hexagonal maps

*Age of Wonders series*

== Gaps and missing features



//core argument I'm trying to make:
//The reviewed tools show that procedural generation support is available, but existing solutions tend to fall into two groups. Unity Asset Store tools are often accessible but focused on dungeon or prefab-room generation. Broader systems such as Unreal PCG and Houdini provide extensive procedural workflows, but they introduce higher complexity and are not focused on map generation in general, let alone on hexagonal grid-based map generation. This creates a gap for a focused, designer-friendly Unity framework for configurable hexagonal map generation.