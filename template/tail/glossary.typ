#import "/local-lib/template-thesis.typ": *
#import "/metadata.typ": *

#let entry-list = (
  (
    key: "pcg",
    short: "PCG",
    long: "Procedural Content Generation",
    description: "Algorithmic creation or placement of game content, such as maps, terrain, objects, rooms, or levels.",
    group: "General"
  ),
  (
    key: "poc",
    short: "Proof of concept",
    long: "Proof of concept",
    description: "An implementation built to demonstrate feasibility rather than production readiness.",
    group: "General"
  ),
  (
    key: "hex-cell",
    short: "Hexagonal cell",
    long: "Hexagonal cell",
    description: "A single hexagon-shaped tile in the generated map. In this thesis, each cell is represented as a graph vertex.",
    group: "Map representation"
  ),
  (
    key: "hex-grid",
    short: "Hex grid",
    long: "Hexagonal grid",
    description: "A map structure composed of connected hexagonal cells.",
    group: "Map representation"
  ),
  (
    key: "graph",
    short: "Graph",
    long: "Graph",
    description: "A structure made of vertices and edges. In this thesis, vertices represent hexagonal cells and edges represent neighbor relationships.",
    group: "Map representation"
  ),
  (
    key: "vertex",
    short: "Vertex",
    long: "Vertex",
    description: "A node in a graph. In this thesis, a vertex corresponds to one hexagonal map cell.",
    group: "Map representation"
  ),
  (
    key: "edge",
    short: "Edge",
    long: "Edge",
    description: "A connection between two vertices. In this thesis, an edge connection means that two hexagonal cells are neighbors.",
    group: "Map representation"
  ),
  (
    key: "graph-rewriting",
    short: "Graph rewriting",
    long: "Graph rewriting",
    description: "A rule-based process where parts of a graph are matched and transformed. In this thesis, graph rewriting changes properties of hexagonal map cells.",
    group: "Generation model"
  ),
  (
    key: "rulebook",
    short: "Rulebook",
    long: "Rulebook",
    description: "The main designer-facing generation configuration. It contains ordered rule entries used during map generation.",
    group: "Generation model"
  ),
  (
    key: "rule-entry",
    short: "Rule entry",
    long: "Rule entry",
    description: "One generation step inside a rulebook. It combines a match definition, prerequisites, match selection, and a rewrite action.",
    group: "Generation model"
  ),
  (
    key: "match-definition",
    short: "Match definition",
    long: "Match definition",
    description: "A configurable rule component that describes what cell pattern or region a rule searches for.",
    group: "Generation model"
  ),
  (
    key: "anchor-cell",
    short: "Anchor cell",
    long: "Anchor cell",
    description: "The cell currently being considered as the starting point or reference point for a rule match.",
    group: "Generation model"
  ),
  (
    key: "prerequisite",
    short: "Prerequisite",
    long: "Prerequisite",
    description: "A condition that must be satisfied before a rule entry can apply its transformation.",
    group: "Generation model"
  ),
  (
    key: "rewrite-action",
    short: "Rewrite action",
    long: "Rewrite action",
    description: "The component that performs the actual grid transformation after a valid match has been selected.",
    group: "Generation Mmdel"
  ),
  (
    key: "subgraph",
    short: "Subgraph",
    long: "Subgraph",
    description: "A selected region of the map graph used to restrict or guide generation.",
    group: "Generation model"
  ),
  (
    key: "materialization",
    short: "Materialization",
    long: "Materialization",
    description: "The process of converting the abstract generated grid into visible Unity scene objects.",
    group: "Unity implementation"
  ),
  (
    key: "seed",
    short: "Seed",
    long: "Seed",
    description: "A value used to initialize random generation so that the same configuration can produce repeatable results.",
    group: "Generation model"
  ),
  (
    key: "deterministic-generation",
    short: "Deterministic generation",
    long: "Deterministic generation",
    description: "Generation where the same input configuration and seed produce the same result.",
    group: "Generation model"
  ),
  (
    key: "scriptable-object",
    short: "ScriptableObject",
    long: "Unity ScriptableObject",
    description: "A Unity asset type used to store reusable data and configuration outside scene objects.",
    group: "Unity implementation"
  ),
  (
    key: "inspector",
    short: "Inspector",
    long: "Unity Inspector",
    description: "The Unity editor panel used to view and edit component or asset properties.",
    group: "Unity implementation"
  ),
  (
    key: "prefab",
    short: "Prefab",
    long: "Unity prefab",
    description: "A reusable Unity asset that stores a configured GameObject hierarchy.",
    group: "Unity implementation"
  ),
  (
    key: "upm",
    short: "UPM",
    long: "Unity Package Manager",
    description: "Unity's package system for installing and managing reusable Unity packages.",
    group: "Unity implementation"
  ),
  (
    key: "dcc",
    short: "DCC",
    long: "Digital Content Creation",
    description: "Professional software used to create digital assets for games, animation, film, or visualization.",
    group: "External tools"
  ),
  (
    key: "hda",
    short: "HDA",
    long: "Houdini Digital Asset",
    description: "A packaged Houdini procedural asset that exposes selected parameters for reuse in other workflows or tools.",
    group: "External tools"
  ),
  (
    key: "cellular-automata",
    short: "Cellular automata",
    long: "Cellular automata",
    description: "A rule based simulation model where cell states change over time based on neighboring cell states.",
    group: "Validation"
  ),
)

#let make_glossary(
  gloss:true,
  title: i18n("gloss-title", lang: option.lang),
) = {[
  #if gloss == true {[
    #pagebreak()
    #set heading(numbering: none)
    = #title <sec:glossary>
    #print-glossary(
      entry-list,
      // show all term even if they are not referenced, default to true
      show-all: false,
      // disable the back ref at the end of the descriptions
      disable-back-references: false,
    )
  ]} else{[
    #set text(size: 0pt)
    #title <sec:glossary>
    #print-glossary(
      entry-list,
      // show all term even if they are not referenced, default to true
      show-all: false,
      // disable the back ref at the end of the descriptions
      disable-back-references: false,
    )
  ]}
]}
