#import "/local-lib/template-thesis.typ": *
#import "/metadata.typ": *
#pagebreak()
= Validation <sec:validation>

=== Validation scenario

To validate the framework, an example for a game using this framework was created. The example game emphasises the infuence generation has on gameplay decisions made by players.

The validation scenario is a strategy game played on a procedurally generated hex grid map. The player must defend life towers while an expanding virus gradually spreads through the map. 

The example game also highlights the importance of integration of generated features into mechanics. The quality of the generated map directly affects the quality of the game, because terrain properties determine where the virus can spread and how fast the spread will be.

This example game for validation will be reffered to as "It consumes."

It consumes is a strategy game where the player needs to defend life tower cells from a spreading virus for a limited number of turns.

*Game loop description:*

+ At the start of each turn, expired defensive cells are removed from the map.

+ The player may place or replace a limited number of defensive cells on eligible terrain cells. Defensive cells are temporary and immune to the virus while active. The player can only maintain a limited number of active defensive cells at once.

+ After the player finishes placing defenses, the virus spread phase begins. Each virus cell checks neighboring cells and attempts to infect them according to #gls("cellular-automata") rules.

+ If the virus reaches a life tower, that tower becomes an infected tower and no longer counts as a surviving objective.

+ The game checks loss and survival conditions. The player loses if all life towers become infected. The player wins if at least one life tower remains uninfected after the required number of turns.

The virus spread is modeled as a simple #gls("cellular-automata") process. During each turn, infected cells evaluate their neighboring hexagonal cells. Whether a neighboring cell becomes infected depends on the target cell type and the number of infected neighbors around it. Vulnerable terrain such as spike fields is infected easily, standard terrain requires more infection pressure, and resistant terrain such as spire fields delay the spread. Barrier towers and active defensive cells are immune, so they interrupt the expansion path and create strategic chokepoints.

#figure(
  image("/resources/img/virus_spread.png", width: 100%),
  caption: "Visual depiction of virus spread over multiple turns."
)

Because of the limited availability of defensive cells, the player is forced to consider map features to use defensive cells most effectively. Different cell types from which the map grid is composed of influence gameplay with their individual characteristics.

Below are cell types present in It consumes:

#table(
  columns: (1.3fr, 2fr),
  inset: 6pt,
  align: (left, left),
  table.header([*Target cell*], [*Virus spread rule*]),

  [Spike field],
  [Low resistance. The cell can become infected when at least one neighboring cell contains the virus.],

  [Rocky ground],
  [Normal resistance. The cell becomes infected when enough neighboring cells contain the virus. In the example scenario, this requires stronger infection pressure than a spike field.],

  [Spire field],
  [High resistance. The cell requires more infected neighbors before it can become infected, making it slower for the virus to cross.],

  [Life tower],
  [The tower becomes infected if the virus reaches it from a neighboring cell and the tower is not protected by defensive cells.],

  [Barrier tower],
  [Immune. The virus cannot spread into or through this cell.],

  [Defensive cell],
  [Temporarily immune. The virus cannot spread into this cell while the defense is active.],

  [Infected life tower],
  [Already infected. It is treated as part of the infected region and can be considered an additional source for future spread.]
)

#figure(
  image("/resources/img/tile_types.png", width: 80%),
  caption: "Visual reference for all of the cell types."
)

Visual descriptions:
 - *Spike field* -- small, green spikes. Grey terrain.
 - *Rocky ground* -- Light grey terrain.
 - *Spire field* -- big, green spikes. Dark grey terrain.
 - *Life tower* -- tall, golden tower surrounded by spikes.
 - *Infected life tower* -- tall, pastel yellow tower wrapped in purple vines.
 - *Defensive cell* -- tall, dark tower. Blue base terrain.
 - *Virus cell* -- fairly tall, purple, curly vines. Purple terrain.

=== Generated example for validation

#figure(
  image("/resources/img/map_ex1.png", width: 100%),
  caption: "Generated example map."
)

This generated map is used as a validation example for It consumes. The virus originates from the center of the map and spreads outward each turn. The player's goal is to survive for a fixed number of turns while keeping at least one life tower uninfected.

The map contains several life tower regions placed in different parts of the map. Because these towers are separated, the player cannot protect every objective with one defensive line. The player must decide which tower is most threatened and which approach paths are worth blocking with temporary defensive cells.

The player's strategic decisions are directly influenced by how game mechanics choose to utilize generated features. For instance, two out of the three life towers have a spike field path leading almost directly to them. As spike fields allow for quicker virus spread, this leaves them more vulnerable than the third life tower, which happens to have a larger land buffer made of Spire fields which slow down virus progression.

It is possible to close off several different chokepoints to protect any of the three or multiple life towers, leaving the player with room to pick their strategy. While blocking off one chokepoint will slow virus progression locally, the virus will not stop propagating onto other cells in other unprotected regions. As a consequence, game strategies have exposed weak points, forcing the player to adapt their strategy throughout the game.

The scenario demonstrates that even a relatively simple generated map is capable of meaningfully influencing the player's strategic decisions. Different cell properties that make up the map are more than trivial visual variation. They determine how the virus spreads, where the player should defend, which towers are easiest to protect, and, most importantly, how the difficulty of the scenario develops over time. Cell types create natural paths for virus spread or, conversely, land barriers for the player to use defensively.

=== Satisfaction of requirements

The It consumes validation scenario demonstrates that the framework satisfies the main functional requirements defined in the design section. The validation does not attempt to prove that the game concept is production-ready or fully balanced. Instead, it shows that the generated map can support a concrete gameplay scenario where generated cell properties affect player decisions and interact with game mechanics.

#figure(
  table(
    columns: (auto, 1.4fr, 2fr),
    inset: 6pt,
    align: (left, left, left),
    table.header([*ID*], [*Requirement*], [*Validation evidence*]),

    [1],
    [Produce a game map as a #gls("graph") of #glspl("hex-cell").],
    [The generated map is composed of hexagonal cells with distinct properties such as spike fields, spire fields, life towers, barrier towers and virus cells.],

    [2],
    [Allow designers to define generation rules based on global or local cell patterns.],
    [The rulebook for generation of the validation example created local and global features based on defined rules. Rules define recognizable terrain features rather than randomly placed, isolated cells.],

    [3],
    [Allow designers to define valid candidates for rule transformations.],
    [The generated map shows controlled feature placement. Life towers appear in separated regions, barrier towers appear as defensive structures around life towers and terrain regions form paths and buffers that affect virus progression. This indicates that rules do not apply uniformly to arbitrary cells but are rather placed randomly according to defined generation rules.],

    [4],
    [Allow rules with valid matches to transform the grid.],
    [The final map contains multiple generated cell properties produced by rule transformations. The rulebook rewrites the abstract grid into terrain, tower and barrier cells that are later used by the example game mechanics.],

    [5],
    [Expose generation configuration inside the Unity editor Inspector window.],
    [The validation map was produced by configuring topology, properties, rulebook entries and materialization settings through Unity assets and Inspector fields.],

    [6],
    [Allow map generation without requiring designers to write code.],
    [The example map was generated from existing configured rule assets and materialization assets. Creating this validation scenario required configuring generation in the inspector.],

    [7],
    [Support repeatable generation from the same configuration and seed.],
    [The map can be regenerated from the same rulebook, topology settings and seed.],

    [8],
    [Provide visual feedback inside the Unity editor scene view.],
    [The generated cell properties are materialized into visible Unity scene objects. Examples were shown in screenshots above.]
  ),
  caption: [Functional requirement satisfaction demonstrated through the It consumes validation scenario],
) <tab:functional-validation>

=== Validation summary

The validation was successful as a proof-of-concept demonstration. The generated map can be interpreted as a playable level for It consumes, and its generated cell properties have clear gameplay meaning. Cell types influence how the virus spreads, where temporary defenses are most useful and which objectives are easiest or hardest to protect.

The scenario shows that generated features can interact with game mechanics instead of serving only as visual variation. Terrain resistance affects infection speed, barrier towers create chokepoints, and defensive cells let the player temporarily reshape the spread path. This supports the feasibility of using the framework to generate maps with meaningful gameplay implications.

However, the validation remains preliminary. The game scenario was analyzed through a generated example map, not through a completed playable prototype or formal user study. Therefore, it can show that the map appears suitable for the proposed mechanics, but it cannot prove that the resulting gameplay would be balanced, understandable or engaging for players. The scope of the validation scenario was narrowed due to the resources required for a completed playable game or a formal study.

== System limitations

The framework has several limitations that reflect its proof-of-concept scope. It demonstrates designer-configurable hex map generation, but it is not a complete production-ready procedural generation package.

The system is intended for small and medium sized maps. As a point of reference, the example map generated for validation is 30 by 50 cells, making it a medium map. Larger maps or more complex rulebooks may suffer from repeated full grid scans, expensive path and subgraph operations, and costly Unity prefab instantiation during materialization.

Current rule system is flexible but still requires technical work to add new rule behavior. Designers can configure existing match definitions and rewrite actions, but programmers are needed to implement new kinds of matches, prerequisites or actions.

The visual materialization layer serves demonstration and inspection purposes. It is not optimized for a shipped game.