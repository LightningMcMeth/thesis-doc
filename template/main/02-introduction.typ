#import "@preview/hei-synd-thesis:0.1.1": *
#import "/metadata.typ": *
#pagebreak()
= #i18n("introduction-title", lang:option.lang) <sec:intro>

== Background and motivation

Game studios face a persistent challenge: manually created content is expensive, time-consuming, and finite, while the casual player base expects large, expansive worlds and replayability.

#linebreak()

Although, game developers have found a way to compensate for this problem. Procedural generation addresses this issue by allowing developers to create content via algorithms rather than relying solely on asset designers.
Most obvious cases are generated game worlds.

A few prominent examples:
#linebreak()

- No Man's Sky
- Minecraft
- Civilization series
- Heroes of Might and Magic series (HoMM)
- Age of Wonders
- Borderlands series
- Deep Rock Galactic
- Don't Starve Together

== Problem statement

In practice, #gls("pcg") has solved only part of the problem. After repeated play, players may begin to recognize generation patterns.
The moment the player gains a working understanding of the generation system is pivotal to their perception of the game. The interest that draws the players in weakens as the sense of novelty fades.

#linebreak()

Procedural generation increases replayability, but it does not guarantee meaningful variety.
Problems leading to predictable generation can be succinctly summarized into two:
#table(
  columns: 1,
  stroke: none,
  [ #warningbox()[*Flatness:* lack of depth, interactions, and connectivity between features.] ],
  [ #warningbox()[*Monotony:* insufficient variance in generation caused by weak randomization or a limited set of statically-made features.]],
  )

== Research objective and scope

The scope of this thesis was deliberately limited to procedural generation of maps using grids made of  #glspl("hex-grid"). This limitation exists to provide a well-defined area of practical application for procedural generation.
As mentioned above, procedural generation covers many possible applications, therefore attempting to support all of them would make the project difficult to explain, design, and evaluate.

#linebreak()

This thesis narrows procedural generation to a specific technical setting -- hexagonal game maps generated inside Unity using graph rewriting. The detailed reasoning behind these choices is discussed later in this section and other chapters, but they are introduced here because they define the object of research and the boundaries of the prototype.

Object of research -- procedural generation of game maps composed of hexagonal cells, implemented in Unity through graph rewriting.

In this  #gls("poc") a  #gls("graph") is defined as:
- *#gls("vertex") --* hexagonal cell.
- *Neighbors --* vertices connected via #gls("edge").
- *Graph structure --* grid gapless hexagonal tiles.

Generation process:
+ Generation rules look for patterns defined by designers
+ If pattern matches, the graph is rewritten according to the designer-defined active rule

Reasoning behind #glspl("hex-cell"):
+ Enough examples exist for evaluation in strategy/tactical/puzzle games.
+ Map type restriction keeps the topic from becoming too broad.
+ Hexagon-shaped cells allow for more complexity than square cells, which are more common in video games.
+ Player cell-to-cell movement is equidistant in all directions to neighboring cells, creating more even movement than square cells.
+ Hexagonal cells require a more complex implementation than square cells, making future support for square or other cell types simpler than implementing a new framework from the ground up.

#linebreak()

In addition, this limited scope gives clear scenarios to benchmark against. Maps made up of hexagons are not that common in video games, mostly appearing in strategy/tactical, puzzle genres of games. For the most part, strategy games will be used as benchmarks.

== Aim and Objectives

The aim of this thesis is to design and implement a proof-of-concept procedural generation framework for hexagonal game maps in Unity.

Objectives:
+ Analyze existing uses of procedural generation in games.
+ Identify causes of predictable or repetitive map generation.
+ Define requirements for a designer-friendly generation framework.
+ Design a configurable model for hexagonal map generation.
+ Implement the framework as a Unity prototype.
+ Validate the prototype through generated map examples for example game concepts.


The framework aims to expose designers to features enabling them to configure generation in a flexible way. Generation set up should happen entirely within the engine editor, requiring no code. As a result, designers should be empowered to create more meaningful and varied generation without the prerequisite of having a lot of technical knowledge. 

#figure(
  image("/resources/img/hex_grid_img_1.png", width: 40%),
  caption: "Sample square hexagonal grid"
)

#table(
  columns: 1,
  stroke: none,
  [ #infobox([Framework uses a hexagonal cell grid to build game worlds])],
  [ #infobox([Aim: proof-of-concept Unity framework thatprovides game designers with flexibility in generationdesign])],
  [ #infobox([Main context for benchmarking -- strategy games])],
)

== Methodology

This thesis follows an applied engineering approach.

At first, existing procedural generation approaches and relevant game examples are reviewed.
Following that, requirements are defined for a configurable proof-of-concept framework.
After requirements are defined, the system is designed and built in Unity.
Lastly, the prototype is evaluated using example game concepts and comparison against existing games.

== Structure of the thesis

- *Chapter 2* -- Research of related work and approaches to procedural generation. 
- *Chapter 3* -- design of the proposed framework. 
- *Chapter 4* -- implementation in Unity. 
- *Chapter 5* -- validation of the framework through selected generation scenarios.
- *Chapter 6* -- summary of the results and thesis.