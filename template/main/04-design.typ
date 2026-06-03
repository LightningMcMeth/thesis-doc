#import "/local-lib/template-thesis.typ": *
#import "/metadata.typ": *
#pagebreak()
= #i18n("design-title", lang:option.lang) <sec:design>

== Functional and non-functional requirements

The research section identified a gap for a focused Unity framework for designer-configurable hexagonal map generation. This section translates that gap into functional and non-functional requirements for the proposed proof-of-concept.

Functional requirements describe the behavior the framework must provide. They define the core capabilities needed for hexagonal map generation, graph rewriting, designer configuration and deterministic output. 

Non-functional requirements describe quality constraints that influence the design of the system, such as usability, maintainability, performance, extensibility and scope control.

Because the project is a proof of concept, the requirements prioritize configurability and demonstrability over production-ready completeness. The goal is not to build a universal procedural generation package, but to design a focused framework that proves the feasibility of designer-configurable hexagonal map generation in Unity.

#figure(
  table(
    columns: (auto, 1fr),
    inset: 6pt,
    align: (left, left),
    table.header([*ID*], [*Requirement*]),

    [1], [The framework shall produce a game map as a graph of hexagonal cells.],
    [2], [The framework shall allow designers to define map generation rules based on global or local cell patterns.],
    [3], [The framework shall allow designers to define which pattern matches are considered valid candidates for rule transformations.],
    [4], [The framework shall allow rules with valid matches to transform the grid during map generation.],
    [5], [The framework shall expose generation configuration inside the Unity editor Inspector window.],
    [6], [The framework shall allow map generation without requiring designers to write code.],
    [7], [The framework shall support repeatable generation by producing the same result from the same configuration and seed.],
    [8], [The framework shall provide visual feedback for generated hexagonal maps inside the Unity editor scene view.],
  ),
  caption: [Functional requirements for the proposed framework],
) <tab:functional-requirements>


#figure(
  table(
    columns: (auto, 1fr),
    inset: 6pt,
    align: (left, left),
    table.header([*ID*], [*Requirement*]),

    [1], [The framework should be understandable for users with limited programming knowledge.],
    [2], [The framework should keep generation configuration visible and editable through Unity editor interfaces where possible.],
    [3], [The framework should be modular enough to separate grid representation, rule definition, rule matching, rule application, and visualization.],
    [4], [The framework should be maintainable by keeping generation logic independent from presentation logic.],
    [5], [The framework should be extensible enough to support additional rule types, cell properties, or map features in future work.],
    [6], [The framework should generate small and medium-sized proof-of-concept maps within an acceptable time for interactive editor use.],
    [7], [The framework should make generated results reproducible for testing, debugging, and comparison.],
    [8], [The framework should remain focused on hexagonal grid-based map generation and avoid expanding into a general purpose procedural generation system.],
    [9], [The framework should rely on Unity native features where possible to reduce external dependencies and improve accessibility.],
  ),
  caption: [Non-functional requirements for the proposed framework],
) <tab:non-functional-requirements>

== Architecture

The functional and non-functional requirements led to an architecture centered on a modular Unity framework rather than a standalone application or external generation service. Since the goal of the project is to demonstrate designer-configurable hexagonal map generation inside Unity, the system was designed as a framework integrated into the editor, composed of:
 - Unity MonoBehaviour orchestration scripts.
 - ScriptableObject configuration assets.
 - Graph-based generation core.
 - Rule rewriting subsystem.
 - Materialization layer that converts abstract generated data into visible scene objects.

The requirements influenced the architecture in four main ways. 
First, the need to represent maps as hexagonal cell graphs required a dedicated graph core that stores grid structure, cell identity, adjacency and properties separately from visual objects. Second, designer-configurable generation required rule structure, definitions for how rules find valid matches for execution, prerequisite conditions for rule and rewrite actions that mutate the grid have a need to be represented as Unity assets editable in the Inspector. 
Third, the need for reproducible generation required a deterministic seed and random stream subsystem. 
Lastly, the need for visual feedback inside Unity required a separate materialization layer that translates the generated graph into prefab instances in the scene view.

=== Framework-specific terminology

Before discussing how the requirements influenced the architecture, it is useful to define several terms used throughout the framework. The system represents a generated map as an abstract grid of hexagonal cells. Each cell has a position in the grid and an associated property, such as a terrain or region type. The generation process modifies these properties over time, and the final grid is later converted into visible Unity objects.

*Rulebook:*

A rulebook is the main designer-facing generation configuration. It contains an ordered list of rule entries that are executed during generation. Each rule entry describes one possible transformation of the grid. A rule entry does not directly contain all generation logic itself. Instead it combines smaller configurable parts such as a match definition, prerequisite conditions, a match selection policy and a rewrite action.

*Match definition:*

A match definition describes the cell pattern that a rule is looking for. Pattern matching is the process of scanning the grid and finding cells or regions that satisfy this definition. For example, a match may require an anchor cell (cell that is being considered for a match) with a specific property, a cell adjacent to another property or a cell inside an active subgraph. The result of this process is a set of candidate matches.

*Match selection policy:*

A match selection policy determines which valid candidate matches are used by a rule entry. The framework supports policies such as selecting the first valid anchor, selecting a random valid anchor or applying the rule to all valid anchors. This makes rule behavior configurable without changing code and allows designers to choose between deterministic, random and expansive transformations.

*Prerequisite:*

A prerequisite is an additional condition that must be satisfied before a rule entry can apply its transformation. While a match definition usually describes a local or structural pattern, prerequisites can express broader conditions, such as counts for properties present on the grid, property grid coverage, adjacent property pairs or subgraph selection constraints. This separation allows the framework to distinguish between finding possible locations and deciding whether the rule should run at all.

*Rewrite action:*

A rewrite action performs the actual modification once a valid match has been selected. Actions can replace an anchor property, place a shapes at an anchor, draw a path between properties, flood fill a subgraph or modify a subgraph in other ways. Actions do not directly manipulate the grid data structure. They use a mutation gateway, which provides controlled operations for painting cells, shapes, paths and subgraph regions.

*Subgraph:*

A subgraph is a region of the grid used to scope generation. Some rules operate over the entire grid, while others operate only within an active subgraph which represents only a part of the whole grid. Subgraphs allow the framework to express higher-level map structures and then apply local transformations inside those structures.

*Materialization:*

Materialization is the process of converting the abstract generated grid into visible Unity scene objects. The rewrite system operates on cell properties rather than prefabs. After generation is complete, the materialization layer reads the grid and instantiates the appropriate tile prefabs based on the generated properties. This keeps procedural logic separate from visual presentation.

#text(size: 8.5pt)[
  #table(
    columns: (0.9fr, 1.15fr, 1.25fr),
    inset: 5pt,
    align: (left, left, left),
    table.header(
      [*Requirement driver*],
      [*Architectural response*],
      [*Reason*],
    ),

    [Maps must be represented as hexagonalcell graphs.],
    [A graph core stores grid dimensions, cells, adjacency and cell properties.],
    [This keeps generated maps independent from Unity scene objects.],

    [Designers must define generation rules based on patterns.],
    [Rulebooks contain rule entries composed of match definitions, prerequisites and rewrite actions.],
    [Generation behavior can be configured as data instead of being hard-coded.],

    [Designers must control which matches are valid.],
    [Matching, prerequisite condition for rule evaluation and match selection are separate stages.],
    [This makes candidate selection explicit and easier to extend.],

    [Rules must transform the grid.],
    [All changes pass through a mutation gateway and specialized grid mutation services.],
    [Centralized mutation prevents uncontrolled grid changes and gives actions a stable API.],

    [Configuration must be available in the Unity Inspector.],
    [Topology, properties, rulebooks, match definitions, actions and materialization settings are Unity assets.],
    [Unity native assets are familiar to designers and avoid custom external tools.],

    [Designers should not need to write code.],
    [Generation behavior is assembled from reusable rule, match, prerequisite and action assets.],
    [Designers can combine existing components through the Inspector.],

    [Output must be repeatable from the same seed.],
    [The framework uses deterministic seed normalization and separate random streams.],
    [This makes generated results reproducible for testing and debugging.],

    [Generated maps need visual feedback.],
    [A materialization layer converts the generated graph into prefab instances.],
    [The same abstract map can be inspected visually without coupling rules to rendering.],

    [The system should be understandable to non-programmers.],
    [The architecture favors visible assets, Inspector fields and named rule components.],
    [Users can reason about configured generation steps instead of source code.],

    [Generation logic should remain separate from presentation logic.],
    [The graph and rewrite layers are separate from the materialization layer.],
    [Rules operate on abstract properties while visualization remains replaceable.],

    [The framework should be extensible.],
    [Core behavior is split into match definitions, prerequisites, rewrite actions, contexts and mutation services.],
    [New rule types or map features can be added without rewriting the engine.],

    [Small and medium maps should generate interactively.],
    [Generation runs in-process using arrays, dictionaries and bounded rewrite counts.],
    [Simple data structures support acceptable proof-of-concept editor performance.],

    [The project should remain focused.],
    [The architecture targets hexagonal grid rewriting only.],
    [This avoids unnecessary complexity from a general-purpose procedural generation system.],

    [Unity native features should be used.],
    [The framework uses `C#`, MonoBehaviours, ScriptableObjects, prefabs, the Inspector and Unity logging.],
    [This reduces dependencies and keeps the workflow accessible inside Unity.],
  )
]


== System diagrams

#figure(
  image("/resources/img/C4_level1.png", width: 100%),
  caption: "C4 Level 1 system context."
)

#figure(
  image("/resources/img/C4_level2.png", width: 100%),
  caption: "C4 Level 2 container diagram."
)

#figure(
  image("/resources/img/C4_level3.png", width: 100%),
  caption: "C4 Level 3 component diagram."
)

== Technology stack

The framework is built as a Unity-native proof of concept. The main programming language is `C#`, and the system runs inside the Unity Editor and Unity Engine runtime. Unity MonoBehaviour scripts are used for scene-level orchestration, Unity ScriptableObject assets are used to store designer-editable configuration such as graph topology, cell properties, rulebooks, match definitions, rewrite actions and materialization settings.

The generated map is represented with custom in-memory data structures, mainly grid arrays, dictionaries and lightweight cell reference objects. The framework does not use an external database, server backend or messaging system. Visual output is produced through Unity prefabs, which are instantiated into the scene by the materialization layer. Deterministic generation is supported by a custom seed utility and PCG-based random number stream implementation.

== Security
Because the framework is a local Unity editor tool and does not expose a network API, store user accounts or process sensitive data, possible security threats are limited. The main relevant concern is supply-chain risk. The project depends on Unity and Unity packages imported into the project. A compromised package, asset, editor extension or dependency could introduce malicious code into the Unity project or affect generated outputs.

This risk can be reduced by keeping dependencies minimal, preferring Unity native functionality where possible, importing packages only from trusted sources, reviewing third-party code before use and keeping Unity/editor dependencies under version control where appropriate. Since the framework currently relies mostly on custom `C#` code and Unity native features, its supply-chain exposure is lower than a system that depends on many external libraries or services.