#import "/local-lib/template-thesis.typ": *
#import "/metadata.typ": *
#pagebreak()
= Validation <sec:validation>

== Validation test

=== Validation scenario

To validate the framework, an example for a game using this framework was created. The example game emphasises the infuence generation has on gameplay decisions made by players.

The validation scenario is a strategy game played on a procedurally generated hex grid map. The player must defend ancient towers while an expanding desert gradually spreads from existing sand regions. The quality of the generated map directly affects the quality of the game, because terrain properties determine where sand can spread, where the player can move, where resources can be collected, and how defensible each tower is.

This example game for validation will be reffered to as "It consumes."

*Game loop description:*

+ At the start of each turn, the player may place a limited number of defensive cells on eligible map cells. While a defensive cell is active, sand cannot spread onto that cell. Defensive cells are temporary and expire after a small number of turns. The player may place new defensive cells each turn, but the total number of active defensive cells cannot exceed a predefined limit.

+ After the player has placed all available defensive cells or chooses to advance the turn early, the sand spread simulation progresses. Sand expands according to #gls("cellular-automata") rules that depend on neighboring sand cells and the type of target cell. Different terrain types therefore affect how quickly the threat spreads, which routes it can take, and which towers are easiest or hardest to defend.

+ The objective is to keep at least one tower uncorrupted for a defined number of turns. The game is lost if all towers are corrupted. The game is also lost if sand covers more than a defined percentage of the map.

#linebreak()

Because of the limited availability of defensive cells, the player is forced to consider map features to use defensive cells most effectively.

Different cell types from which the map grid is composed influence gameplay with their individual characteristics.

Below are cell types present in It consumes:
#table(
  columns: (1.4fr, 2fr),
  inset: 6pt,
  align: ( left, left),
  table.header([*Game cell type*], [*Basic description*]),

  [Grass],
  [Vulnerable to sand spread. Supports player defensive cell placement.],

  [Dark grass],
  [Less vulnerable to sand spread than grass. Supports player defensive cell placement.],

  [Forest],
  [Slows sand spread more than dark grass, can be cleared or protected.],

  [Frozen land],
  [Naturally resistant terrain. Sand spreads into frozen land slowly, making it a defensive buffer. Supports player defensive cell placement.],

  [Mountain barrier],
  [Blocks sand spread. Creates natural chokepoints.],

  [Desert / active threat],
  [Starting source of the spreading threat. Consumes livable terrain if not contained.],

  [Shallow water],
  [Sand spreads slower than on dark grass. Supports player defensive cell placement.],

  [Deep water],
  [Blocks direct sand spread. Defensive cells cannot be placed on it. It creates permanent natural channels that shape sand routes and tower defensibility.],

  [Defense objective / tower],
  [Primary structure the player must defend. Losing all towers represent a loss.],
)

In the following images, cell types that were described in the table above can be seen.

#figure(
  image("/resources/img/cell_example1.png", width: 60%),
  caption: "Screenshot of a generated map containing grass, dark grass, a mountain and a forest cell."
)

#figure(
  image("/resources/img/cell_example2.png", width: 60%),
  caption: "Screenshot of a generated map containing sand cells, shallow and deep water, grass."
)

#figure(
  image("/resources/img/cell_example3.png", width: 60%),
  caption: "Screenshot of a generated map containing a tower, regular and dark grass, a few mountains and snow."
)

The towers that need to be defended by players have a distinct visual appearance, being the only man-made structure in the generated map.
#figure(
  image("/resources/img/tower_example.png", width: 60%),
  caption: "Screenshot of a tower from two angles."
)

=== Generated examples for validation

The validation is not based only on whether the generated maps look visually varied. The important question is whether the generated terrain creates meaningful gameplay conditions for the Desert tower defense scenario.

A useful generated map should contain sand sources that threaten the playable land, towers that can be defended through different terrain strategies, resistant regions that slow the spread, and barriers or channels that shape the direction of expansion.

The following generated map examples are evaluated with these criteria in mind. Each example is treated as a potential level for the game. The analysis focuses on how the generated cell properties influence tower defensibility, sand spread routes, use of defensive cells and overall difficulty.

*Example game rules:*
- Defensive cells last 7 turns
- Player can have 13 defensive cells active at once
- Player loses if 60% of the map is covered in sand
- Player has to keep lose conditions from triggering for 80 turns

*Map size -- * 30 by 30 cells

All provided example maps were generated within 1-2 seconds. Execution timer starts when the generation engine begins processing rule entries and ends when materialization is complete.

All examples were generated with the same generation settings.

*Example 1 analysis:*

#figure(
  image("/resources/img/map_example1.png", width: 100%),
  caption: "Screenshot of the generated map example 1 produced by the prototype."
)

The first generated map contains multiple tower objectives distributed across separate land regions. The initial sand region is located in the lower left part of the map, away from most towers but close enough to connected land that it can become a long term threat.

A notable feature of this map is the placement of mountains around several tower areas. These mountain cells create partial barriers that can slow sand expansion and produce natural chokepoints. Because defensive cells are limited and temporary, the player does not need to protect every neighboring cell equally. Instead, the player can identify narrow routes where a small number of defensive cells can delay sand for several turns.

The shallow water and deep water regions also influence the defensive problem. Sand cannot expand through the map uniformly. It must follow available land routes or spread slowly through more resistant and therefore less ideal terrain. This creates a juggling act between closing a chokepoint early, allowing sand to advance temporarily, or saving defensive cells for tower adjacent positions.

This map successfully demonstrates terrain properties can create meaningful defensive decisions. The player is not only reacting to the sand source, but also interpreting the generated terrain structure.

*Example 2 analysis:*

#figure(
  image("/resources/img/map_example2.png", width: 100%),
  caption: "Screenshot of the generated map example 2 produced by the prototype."
)


The second generated map contains fewer tower objectives than the first example, and the towers are positioned farther apart from one another. Instead of forming one dense defensive region, the towers in separate parts of the map. This changes the defensive problem since the player cannot protect all towers through one shared defensive front.

The map also contains fewer mountain barriers near the main tower areas. As a result there are fewer reliable natural chokepoints that completely block or strongly restrict sand spread. The player must rely more heavily on temporary defensive cells and must choose carefully where to place them each turn.

Snow and forest regions still provide partial defensive value. Snow slows sand spread and can function as a resistant buffer, while forested or dark grass regions can delay expansion more than ordinary grass. These terrain types are still less reliable than mountains because they slow the threat rather than fully blocking it, therefore putting the player in a more precarious position than in example 1. This creates a more dynamic defensive situation where the player can delay sand, but cannot depend on permanent barriers.

The initial sand region begins in the lower left part of the map. From there, it can move toward nearby land routes and eventually threaten separated tower areas if not contained early enough. Because the towers are spread out, the player must decide whether to contain the sand near its source, reinforce the most exposed tower, or use defensive cells to preserve important terrain chokepoints.

Unlike the first map, which offers many natural chokepoints this map creates pressure through openness and distance between objectives. Despite having been generated with the exact same rules as the first example, the current example demonstrates varied topology while still satisfying the same rules.

*Example 3 analysis:*

#figure(
  image("/resources/img/map_example3.png", width: 100%),
  caption: "Screenshot of the generated map example 3 produced by the prototype."
)

The third generated map contains four tower objectives in a closer arrangement than in example 2. Several towers can potentially be protected through overlapping defensive choices instead of being treated as completely separate parts of the map.

The initial sand region is located in the lower right part of the map. It starts far from the main tower cluster, giving the player time to respond. Deep water creates a natural barries for sand progression. However land paths for spand spreading still remain opened.

Compared with example 1, mountains are less consistently useful as defensive barriers. Some mountain cells appear near tower regions, but they do not form reliable chokepoints, thus the player cannot rely solely on mountains. Mountains can be used in conjunction with forests and snow cells to create chokepoints and slow sand spread.

=== Satisfaction of requirements

The It consumes validation scenario shows how the framework satisfies the functional and non-functional requirements defined in the design section. The validation does not claim that the framework is a complete production-ready game system. Instead, it demonstrates that the generated maps can support a concrete gameplay scenario where generated cell properties affect player decisions.

#figure(
  table(
    columns: (auto, 1.4fr, 2fr),
    inset: 6pt,
    align: (left, left, left),
    table.header([*ID*], [*Requirement*], [*Validation evidence*]),

    [1],
    [Produce a game map as a graph of hexagonal cells.],
    [The generated 30 by 30 maps are composed of hexagonal cells with distinct terrain and objective properties. These cells form the playable space for It consumes.],

    [2],
    [Allow designers to define generation rules based on global or local cell patterns.],
    [The examples contain structured terrain relationships. For example, mountain barrier spawn rate is directly tied to number of towers successfully added. Forest formations rely on the shape and size of grass land regions.],

    [3],
    [Allow designers to define valid candidates for rule transformations.],
    [The generated maps show controlled placement of features such as towers, sand regions and terrain clusters rather than purely uniform random placement. This indicates that rule matches and candidate selection influence where transformations occur.],

    [4],
    [Allow rules with valid matches to transform the grid.],
    [The resulting maps contain transformed cell properties which depend on one another in various ways. For example, dark grass appears inside of grass regions, given the region has enough grass cells and forest cells.],

    [5],
    [Expose generation configuration inside the Unity editor Inspector window.],
    [The validation maps were produced by configuring generation assets and materialization settings in Unity, then running the generator inside the editor.],

    [6],
    [Allow map generation without requiring designers to write code.],
    [The It consumes examples use existing configured properties, rule assets and materialization assets. The validation scenario relies entirely on generated outputs rather than scripted, static content.],

    [7],
    [Support repeatable generation from the same configuration and seed.],
    [The example maps were generated from fixed generation settings. This allows specific maps to be regenerated and compared when validating the same gameplay scenario.],

    [8],
    [Provide visual feedback inside the Unity editor scene view.],
    [The tile examples and full map screenshots show that generated cell properties are materialized into visible Unity scene objects that can be inspected directly.]
  ),
  caption: [Functional requirement satisfaction demonstrated through the It consumes validation scenario],
) <tab:functional-validation>

=== Validation summary

The validation was successful as a proof-of-concept demonstration. The generated maps could be interpreted as playable levels for It consumes, and the generated cell properties had clear gameplay meaning. Towers, sand, water, forests, snow and mountains created different defensive situations, showing that the framework can produce maps where generation affects player decisions rather than only visual appearance. Reviewed examples also outline how properties can be dependant on one another and how they create different gameplay interactions.

But this validation methodology is limited. The game scenario was analyzed conceptually through generated examples, not through a completed playable prototype or formal user study. Because of this, the validation can show that the maps appear suitable for the proposed mechanics, but it cannot fully prove that the gameplay would be balanced, fun or understandable to players.

A stronger validation method involves implementing the game rules as a playable prototype and testing generated maps with developers or players.
The validation supports the feasibility of the framework, but should be treated as preliminary.

== System limitations

The framework has several limitations that reflect its proof-of-concept scope. It demonstrates designer-configurable hex map generation, but it is not a complete production-ready procedural generation package.

The system is intended for small and medium sized maps. Larger maps or more complex rulebooks may suffer from repeated full grid scans, expensive path and subgraph operations, and costly Unity prefab instantiation during materialization.

Examples reviewed in this section took 1-2 seconds to generate.
The time it takes to generate larger maps scales fast.
The same examples generated on a larger map size, 80 by 80 for instance, with a larger number of rewrites take around 50 seconds.

Current rule system is flexible but still requires technical work to add new rule behavior. Designers can configure existing match definitions and rewrite actions, but programmers are needed to implement new kinds of matches, prerequisites or actions.

The visual materialization layer serves demonstration and inspection purposes. It is not optimized for a shipped game.