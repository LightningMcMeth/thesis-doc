#import "/local-lib/template-thesis.typ": *
#import "/metadata.typ": *
#pagebreak()
= Implementation <sec:impl>

== Methodology

The implementation followed an iterative sprint-based development process. The work was divided into four month long sprints.

== Prototyping

Prototyping was used to gradually test the main ideas behind the framework before expanding them into the final implementation. The process began with finding a practical way to represent hexagonal cells and store them in memory. This led to the use of a two-dimensional grid structure with stable cell identifiers and a separate tracker for cell properties.
This was followed by another prototype focused on applying changes to them. Simple transformations were tested first, such as replacing the property of a selected cell. After that, sequential changes to the grid were possible.

The following prototypes tested different kinds of generation rules. The first rules were simple and made trivial local changes, while later rules introduced match definitions, candidate selection and rewrite actions as separate concepts that together compose rules. As the rule system became more stable, additional complexity was added through features that operate on parts of the grid rather than only individual cells.

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

The component design is implemented through small extension points. The most important extension points are match definitions and rewrite actions. Match definitions decide whether a rule can target a cell or region. Rewrite actions perform the transformation once a match has been selected.

The grid component stores the hexagonal map in a two-dimensional array. Although a hex grid is not geometrically square, the framework uses offset coordinates so that each cell can still be addressed with an `(x, y)` pair and stored in a regular matrix. In this representation, every other row is horizontally shifted when the grid is materialized, producing the visual hex layout while preserving simple array-based storage.

This approach follows the implementation ideas described in Red Blob Games' hexagonal grid articles, especially the use of offset coordinates for map storage and cube-coordinate conversion for algorithms such as range and distance calculations @redBlobHexGrids. The framework uses offset coordinates for storage because they map naturally to a rectangular two-dimensional array, while helper methods can convert to cube coordinates when hex-specific calculations are needed.

In the implementation, `GridRepository` owns the matrix of cells:

```csharp
private Hex[,] _grid;

public Hex GetNode(int x, int y)
{
    EnsureInBounds(x, y);
    return _grid[x, y];
}

public void SetNode(int x, int y, Hex node)
{
    EnsureInBounds(x, y);
    _grid[x, y] = node;
}
```

Each cell also receives a stable node identifier derived from its matrix position:
```csharp
public int GetNodeId(int x, int y)
{
    EnsureInBounds(x, y);
    return x + y * Width;
}
```

Neighbor lookup accounts for the row offset. Even and odd rows use different neighbor offsets because adjacent cells are shifted differently depending on the row:
```csharp
public Vector2Int[] GetNeighborOffsets(int x, int y, int distance)
{
    bool isEven = (y & 1) == 0;

    if (isEven)
    {
        return new Vector2Int[]
        {
            new Vector2Int(-1, -1) * distance,
            new Vector2Int(0, -1) * distance,
            new Vector2Int(-1, 0) * distance,
            new Vector2Int(1, 0) * distance,
            new Vector2Int(-1, 1) * distance,
            new Vector2Int(0, 1) * distance
        };
    }

    return new Vector2Int[]
    {
        new Vector2Int(0, -1) * distance,
        new Vector2Int(1, -1) * distance,
        new Vector2Int(-1, 0) * distance,
        new Vector2Int(1, 0) * distance,
        new Vector2Int(0, 1) * distance,
        new Vector2Int(1, 1) * distance
    };
}
```

#table(
  columns: (1fr, 1.5fr, 1.5fr),
  inset: 6pt,
  align: (left, left, left),
  table.header([*Component*], [*Implementation role*], [*Extension mechanism*]),

  [Match definition],
  [Finds valid rule candidates in the grid.],
  [New match types inherit from `MatchDefinition` and implement `TryMatch`.],

  [Rewrite action],
  [Applies a transformation to a selected match.],
  [New actions inherit from `RewriteAction` and implement `Apply`.],

  [Mutation gateway],
  [Provides controlled write operations to the grid.],
  [Actions call mutation methods instead of directly editing grid storage.],

  [Rule entry],
  [Combines match, prerequisite, selection and action configuration.],
  [Designers assemble rule behavior through serialized Unity assets.]
)

The base match definition exposes a small contract. Given a query context and an anchor cell, it either produces a valid `RuleMatch` or rejects the anchor. The default `FindMatches` implementation scans the provided anchor search space and calls `TryMatch` for each possible anchor.

```csharp
public abstract class MatchDefinition : ScriptableObject, IMatchDefinition
{
    public virtual string MatchKind => GetType().Name;

    public abstract bool TryMatch(
        IMatchQueryContext context,
        HexCellRef anchor,
        out RuleMatch match);

    public virtual List<RuleMatch> FindMatches(
        IMatchQueryContext context,
        AnchorSearchSpace anchorSearchSpace)
    {
        var matches = new List<RuleMatch>();

        foreach (HexCellRef anchor in anchorSearchSpace.EnumerateAnchors())
        {
            if (TryMatch(context, anchor, out RuleMatch match))
            {
                matches.Add(match);
            }
        }

        return matches;
    }
}
```

This structure makes pattern matching extensible. A new local or global pattern can be added by creating another `ScriptableObject` match definition without changing the rulebook executor.

Rewrite actions use a similar pattern. Each action receives a rule action context, the rule entry that invoked it and the selected match. The action returns whether it actually changed the grid.

```csharp
public abstract class RewriteAction : ScriptableObject, IRewriteAction
{
    public virtual string ActionKind => GetType().Name;

    public abstract bool Apply(
        RuleActionContext context,
        RuleEntry entry,
        RuleMatch match);
}
```

Actions do not directly modify the grid repository. Instead, they use the mutation gateway exposed by the action context. Because of this approach low-level grid updates are centralized and gives all actions the same controlled API for modifying cells.

The following action shows how an individual rule action is implemented. It resolves the output property from the rule entry, then delegates the actual grid modification to the mutation gateway.

```csharp
[CreateAssetMenu(
    menuName = "ProcGen/Rewriting/Actions/Draw Path Between Properties",
    fileName = "DrawPathBetweenPropertiesAction")]
public sealed class DrawPathBetweenPropertiesAction : RewriteAction
{
    [SerializeField]
    private PathBetweenPropertiesSettings _settings = new();

    public override bool Apply(
        RuleActionContext context,
        RuleEntry entry,
        RuleMatch match)
    {
        if (!context.Values.TryResolveOutputProperty(
            entry,
            context.ActionRng,
            out HexProperty pathProperty))
        {
            return false;
        }

        return context.Mutation.PaintPathBetweenProperties(
            _settings,
            pathProperty,
            entry.OutputProperties,
            entry.OutputPropertySelectionMode,
            entry.MatchSelectionPolicy);
    }
}
```

This implementation style keeps the rule system open for extension. New actions can be added as new assets, while the executor, rulebook structure and grid storage remain unchanged.

== Testing

=== Manual testing

Testing for the proof of concept was performed manually inside the Unity editor. This approach was suitable for the project because the framework is primarily editor-facing and many of its requirements involve designer configuration, visual feedback and interaction with Unity assets. The goal of testing was to confirm that the implemented components worked together correctly across the full generation pipeline. Manual testing focused on feature validation rather than automated coverage metrics. Test cases were created by preparing different topology, property, rulebook and materialization configurations, running generation in the editor and checking both the abstract generation result and the materialized scene output.

Visual inspection was an important part of testing because one of the framework requirements is to provide feedback inside the Unity editor scene view. After generation, the materialized map was inspected to confirm that tile placement, prefab selection, paths, shapes and larger generated regions appeared as intended.

Repeatable seeds were also used as a manual quality assurance tool. By keeping the seed and configuration fixed, the same generated output could be reproduced between runs. This made it easier to compare the effect of individual rule or parameter changes and to confirm that unrelated edits did not unexpectedly change the generation result.

=== Recommended testing strategy

A more complete version of the framework should include automated unit and integration tests. Below is an explanation for the testing strategy for more complete version of the framework.

#table(
  columns: (1fr, 1.4fr, 1.4fr),
  inset: 6pt,
  align: (left, left, left),
  table.header([*Test level*], [*Purpose*], [*Examples*]),

  [Unit tests],
  [Verify individual classes and algorithms in isolation.],
  [Hex neighbor lookup, seed hashing, random stream reproducibility, property tracking, value resolution, prerequisite comparisons.],

  [Integration tests],
  [Verify that multiple components work together correctly.],
  [Run a fixed topology and rulebook with a fixed seed, then compare the generated grid properties against an expected result.],

  [Editor tests],
  [Verify Unity-specific asset and Inspector workflows.],
  [Check that ScriptableObject assets can be created, serialized, assigned and used by the generation runner.],

  [Play mode tests],
  [Verify runtime behavior inside Unity scene execution.],
  [Run generation in a test scene and confirm that the materialized grid contains the expected number of tile objects.],

  [Regression tests],
  [Protect previously validated generation behavior from accidental changes.],
  [Store known seeds and rulebooks as test fixtures and compare later outputs to approved snapshots.]
)

A useful testing technique for this framework is direct grid-state comparison. Since the generated map is stored as a two-dimensional grid with a separate property tracker, tests can compare expected and actual grid states cell by cell. A test fixture can define an expected matrix of property keys, run generation with a fixed topology, rulebook and seed, and then assert that each coordinate contains the expected property.
For example, a small expected grid can be represented conceptually as:

```text
water water land  land
water land  land  hill
land  land  hill  hill
```

The most important unit tests should target deterministic and algorithmic behavior. Hexagonal grid neighbor lookup should be tested for even rows, odd rows, corners, edges and interior cells. Seed handling should be tested to confirm that the same normalized seed produces the same random sequence and that different salt values produce independent streams. Prerequisites should be tested with controlled grid states to verify property counts, coverage thresholds, distinct property counts and adjacency checks.

Rule matching should also be covered by unit tests. Each match definition should be tested with small hand-built grids where the expected anchors are known. This would confirm that local pattern matching, neighbor-based matching, subgraph matching and global matching return the correct candidates.

Integration tests should cover the full rewriting pipeline. A test should create a topology, initialize a grid, run a small rulebook with a fixed seed and then compare the final property layout against an expected grid. This would verify that the rulebook executor, match resolver, prerequisite evaluator, match selector, rewrite action and mutation gateway interact correctly with one another.

Coverage targets should prioritize the framework core rather than Unity boilerplate. The graph model, seed subsystem, rule execution pipeline, match definitions, prerequisites and mutation services should receive the highest coverage. MonoBehaviour orchestration and purely editor-facing code can be covered with lighter editor or play mode tests.

== Performance bottlenecks and optimizations

The framework is intended for small and medium-sized maps, so its implementation favors clarity, configurability and editor usability over heavy optimization. For this scope, direct array access, dictionary-based property tracking and bounded rewrite counts are sufficient. However, several parts of the system would become bottlenecks if the framework were used for larger maps, more complex rulebooks or frequent runtime regeneration.

*small maps -- * approximately 30 by 30 cells
*medium maps -- * approximately 50 by 50 cells

#table(
  columns: (1fr, 1.4fr, 1.4fr),
  inset: 6pt,
  align: (left, left, left),
  table.header([*Bottleneck*], [*Cause*], [*Possible optimization*]),

  [Repeated full-grid scans],
  [Many match definitions, prerequisite checks and property counts iterate over all valid cells.],
  [Maintain indexes of cells by property, cache frequently used counts, or restrict search spaces to affected regions.],

  [Rulebook complexity],
  [Each rule entry may perform matching, prerequisite evaluation and action application. Large rulebooks multiply the number of grid scans.],
  [Group related rules, short-circuit earlier, cache match results where valid.],

  [Apply all valid anchor rules],
  [Rules that apply to every valid match can produce many mutations in one pass.],
  [Limit the number of selected matches, process matches in batches, or add stronger candidate filters.],

  [Path generation],
  [Path drawing may inspect neighbors repeatedly and use fallback breadth-first search when direct path construction fails.],
  [Use reusable pathfinding buffers, cap path attempts, or precompute distance fields for repeated path queries.],

  [Subgraph operations],
  [Subgraph growth, shrinkage and boundary calculations use sets, neighbor checks and bounds recalculation.],
  [Batch subgraph changes, reuse collections, and update boundary data incrementally.],

  [Materialization],
  [The materializer destroys and recreates the generated scene hierarchy when rebuilding the map.],
  [Use object pooling, update changed tiles only, or separate generation preview from final scene construction.],

  [Prefab instantiation],
  [Instantiating many Unity GameObjects is expensive compared with updating data structures.],
  [Use pooled prefabs, Unity Tilemap-style rendering, GPU instancing, or mesh batching for larger maps.],
)

The most important bottleneck is repeated grid traversal. The current implementation often favors simple iteration over the full grid because this is easy to understand and reliable for small maps. For example, property counts, coverage checks, match finding and candidate searches can all scan the grid. This is acceptable for proof-of-concept usage.


== Deployment

=== CI and configuration management

=== Deployment and CI

The project includes a GitHub Actions release pipeline for packaging the framework as a Unity Package Manager package. The workflow runs when a version tag is pushed, using either the `*.*.*` or `*.*.*` format. It can also be started manually through GitHub Actions.

#table(
  columns: (1fr, 2fr),
  inset: 6pt,
  align: (left, left),
  table.header([*Stage*], [*Purpose*]),

  [Trigger],
  [Runs on pushed version tags such as `v0.1.0` or `0.1.0`, and through manual workflow dispatch.],

  [Checkout],
  [Downloads the repository contents into the CI runner.],

  [Package validation],
  [Runs the PowerShell packaging script and validates the UPM package manifest.],

  [Package assembly],
  [Copies runtime scripts, demo assets, sample scene and package metadata into a clean UPM folder structure.],

  [Assembly definition],
  [Generates a `ProcGen.asmdef` file for the runtime package.],

  [Artifact upload],
  [Creates and uploads a zipped package artifact.],

  [UPM branch publication],
  [Force-pushes the generated package contents to the `upm-release` branch.],

  [GitHub Release],
  [Attaches the generated zip file to the GitHub Release for the pushed tag.]
)

The package can be added through the Unity Asset Store.
Alternatively, users can add the package inside the Unity editor with the project github url:
```
Window -> Package Management -> Package Manager -> Install package from git url
```

== Documentation

 The documentation for this framework explains how to set up:
 - hex grid generator
 - configure topology
 - properties, rulebooks
 - rules
 - matches
 - actions
 - prerequisites
 - subgraphs
 - path drawing
 - repeat modes
 - materialization

 It also includes common troubleshooting cases.

The documentation also covers extension points for developers. In particular, it explains how custom behavior can be added by implementing new match definitions, prerequisites or rewrite actions in code.
