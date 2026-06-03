#import "/local-lib/template-thesis.typ": *
#import "/metadata.typ": *
#pagebreak()
= Implementation <sec:impl>

== Methodology

The implementation followed an iterative prototype-driven methodology. Because the project is a proof-of-concept, the goal was not to deliver a production-ready package, but to incrementally validate whether designer-configurable graph rewriting could produce usable hexagonal maps inside Unity.

== Prototyping

More technical details on the implementations of the features named in the prototypes can be found in the core component implementation subsection. The prototyping subsection serves as a short overview of the prototyping process.

Development began with the core map representation and then expanded outward toward rule execution and scene materialization. Each major component was implemented as a small vertical slice, beginning with the grid data model, then moving on to property tracking, then rule matching, rule application and finally prefab-based visualization.

The implementation also followed the architectural separation defined in the design section. Grid representation, rule definition, rule matching, rule mutation, seeded random generation and materialization were implemented as separate components.

The first prototype focused on representing the map as a two dimensional hexagonal grid. This staged helped establish grid dimensions, node identifiers, cell references. Once the graph representation was working, cell properties were separated from the cell objects through a dedicated cell property tracker.

The second prototype introduced rule-based rewriting. Initial rules were limited to simple property replacement. After a basic implementation proved viable, the rule system was expanded with match definitions, prerequisites, match selection policies and rewrite actions. This allowed generation behavior to be assembled from smaller reusable parts.

The third prototype focused on materialization. At this stage, the abstract generated grid was converted into visible Unity prefab instances. This confirmed that the generated graph could remain independent from scene presentation while still producing immediate visual output inside the Unity editor.

== Project standards

The implementation follows Unity-oriented `C#` project standards. The codebase is organized around clear component responsibilities, Unity serialization conventions and a modular rule execution architecture. These standards make the framework easier to inspect in the Unity editor, easier to extend with new rule types, and easier to maintain as the proof of concept grows.

=== Code organization

#table(
  columns: (1fr, 1.5fr, 1.5fr),
  inset: 6pt,
  align: (left, left, left),
  table.header([*Area*], [*Namespace*], [*Responsibility*]),

  [Graph core],
  [`ProcGen.Graph.Core`],
  [Stores the abstract hex grid, cell references, topology data and cell properties.],

  [Generation orchestration],
  [`ProcGen.Graph.Run`],
  [Creates the generation context, starts generation, materializes results and connects the framework to Unity scene execution.],

  [Rule rewriting],
  [`ProcGen.Graph.Rewriting`],
  [Contains rulebooks, rule entries, match definitions, prerequisites, rewrite actions, rule execution and mutation services.],

  [Materialization],
  [`ProcGen.Materialization`],
  [Converts the generated abstract grid into Unity prefab instances and computes tile placement.],

  [Seed handling],
  [`ProcGen.Seed`],
  [Normalizes user seeds and creates deterministic random number streams.]
)

=== Naming conventions

#table(
  columns: (1fr, 1.5fr, 1.5fr),
  inset: 6pt,
  align: (left, left, left),
  table.header([*Element*], [*Convention*], [*Example*]),

  [Classes and structs],
  [PascalCase names that describe the component responsibility.],
  [`GridRepository`, `RulebookExecutor`, #linebreak() `MaterializationSpatialResolver`],

  [Interfaces],
  [PascalCase names with the `I` prefix.],
  [`IRngStream`, `IGridQuery`, `IRuleMutationGateway`],

  [Methods and properties],
  [PascalCase names describing the operation or exposed value.],
  [`TryGetCell()`, `Materialize()`, `Generate()`],

  [Private serialized fields],
  [Private fields marked with `SerializeField`, commonly using a leading underscore.],
  [`_rulebook`, `_topology`, `_numOfRewrites`],

  [Boolean values],
  [Names indicate state or intent.],
  [`HasSubgraphs`, `HasActiveSubgraph`],

  [Try-pattern methods],
  [Methods returning success use the `Try` prefix and output resolved values through `out` parameters.],
  [`TryGetProperty`, `TryResolveOutputProperty`, `TryMatch`],

  [Unity asset classes],
  [ScriptableObject classes use names that describe the asset role.],
  [`GraphTopology`, `HexProperty`, `Rulebook`, `RewriteAction`]
)

=== Architectural patterns

#table(
  columns: (1fr, 1.6fr),
  inset: 6pt,
  align: (left, left),
  table.header([*Pattern*], [*Implementation in the framework*]),

  [Repository pattern],
  [`GridRepository` stores the hex cell grid, while `PropertyTracker` stores generated properties.],

  [Query and mutation separation],
  [`GridQuery` exposes read access, while `RuleMutationGateway` controls write operations.],

  [Pipeline pattern],
  [Rule execution proceeds through matching, prerequisite evaluation, match selection and action application.],

  [Factory-style initialization],
  [`Initializer` and `RewriteContextFactory` assemble repositories, contexts, random streams, rule services and mutation gateways.],

  [Strategy-style extension],
  [Different match definitions, prerequisites and rewrite actions are implemented as separate components.],

  [Facade pattern],
  [`GridModifierFacade` and `RuleMutationGateway` expose simplified mutation APIs over lower-level painter services.],

  [Separation of generation and presentation],
  [The rewrite system modifies abstract cell properties, while `MapSceneBuilder` handles prefab instantiation.],
)


=== Implementation style

The implementation prefers small components with explicit responsibilities over large procedural scripts. Runtime state is passed through context objects such, containing the necessary data for each respective operation. This makes dependencies visible and reduces direct coupling between rule components.

The code also uses checks around missing Unity assets and invalid configuration. Components log errors or warnings when required assets, properties, rule definitions, random streams or materialization settings are missing.

The public extension points of the framework are mainly interfaces and abstract base classes. Examples include:
 - match definitions
 - prerequisites
 - rewrite actions
 - grid queries
 - mutation gateways and random streams.

This supports future expansion while keeping the current proof-of-concept implementation focused on hexagonal grid rewriting.

=== Core component implementation



== Testing



== Performance bottlenecks and optimizations



== Deployment



== Documentation

 