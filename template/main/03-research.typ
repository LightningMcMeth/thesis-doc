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

*DunGen*



== Candidate evaluation



== Video game examples

=== Games with hexagonal maps

*Age of Wonders series*

== Gaps and missing features



//core argument I'm trying to make:
//The reviewed tools show that procedural generation support is available, but existing solutions tend to fall into two groups. Unity Asset Store tools are often accessible but focused on dungeon or prefab-room generation. Broader systems such as Unreal PCG and Houdini provide extensive procedural workflows, but they introduce higher complexity and are not focused on map generation in general, let alone on hexagonal grid-based map generation. This creates a gap for a focused, designer-friendly Unity framework for configurable hexagonal map generation.