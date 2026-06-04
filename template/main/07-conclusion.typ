#import "/local-lib/template-thesis.typ": *
#import "/metadata.typ": *
#pagebreak()
= #i18n("conclusion-title", lang:option.lang) <sec:conclusion>


== Thesis summary

This thesis explored procedural generation as a way to create varied game maps while reducing reliance on manually created, static content. The work focused on a specific problem: 
procedural generation can become predictable when players recognize repeated structures or generation patterns. To keep the project concrete, the thesis narrowed the topic to hexagonal game maps generated inside Unity through a graph rewriting approach.

The research phase reviewed existing procedural generation tools, Unity Asset Store packages, Unreal PCG, Houdini, and game examples using procedural or hexagonal maps. This comparison showed that existing solutions provide useful procedural workflows. They are usually focused on prefab based dungeons, broad procedural content pipelines, or tools outside Unity. Based on these findings, functional and non-functional requirements were defined for a proof-of-concept Unity framework.

The final prototype represents a map as a graph of hexagonal cells, exposes generation configuration through Unity assets and Inspector workflows, and uses rulebooks, match definitions, prerequisites, match selection policies, and rewrite actions to transform the grid. The framework was validated through the It consumes scenario, where generated 30 by 30 maps were analyzed as playable levels for a strategy game. The validation showed that generated terrain properties can influence player decisions, tower defensibility, sand spread routes, and overall map difficulty.

== Alignment with objectives

Thesis objectives were met through the research, design, implementation, and validation stages. The research chapter identified that many available tools either operate on prefab rooms, provide broad procedural suites, or require workflows outside Unity. This supported the need for a narrower Unity native framework focused on hexagonal map generation.

The design chapter translated this gap into functional and non-functional requirements. The implementation then addressed these requirements through a modular architecture with a graph core, rule rewriting subsystem, deterministic seed handling, Unity asset based configuration, and a materialization layer for visual feedback.

The validation chapter depicted that the generated maps satisfy the main requirements: 
- Maps are composed of hexagonal cells.
- Maps are produced through configurable rules.
- Maps can be generated from repeatable settings and seeds.
- Maps are visible inside the Unity editor.

== Challenges
~
One major challenge was controlling the scope of procedural generation. Procedural generation can include terrain, dungeons, object scattering, simulations, large worlds, or full content pipelines. Limiting the thesis to hexagonal map generation made the project more focused and allowed the framework to be evaluated through concrete examples.

Another challenge was balancing designer-friendliness with generation flexibility. The framework needed to expose rule configuration through Unity assets and Inspector fields, while still supporting meaningful map transformations. This led to a modular rule structure where rulebooks combine match definitions, prerequisites, match selection policies, and rewrite actions.
The implementation also introduced technical challenges that become a problem when using larger maps or a lot of generation rules.

== Limitations

The framework remains a proof of concept rather than a production ready procedural generation package. It focuses on small and medium sized hexagonal maps and does not attempt to replace broad tools such as Dungeon Architect, Unreal PCG, or Houdini.

The current implementation favors configurability and editor usability over heavy optimization. Larger maps or complex rulebooks can suffer from repeated full grid scans, expensive path and subgraph operations, and costly Unity prefab instantiation during materialization. The validation examples used 30 by 30 maps that generated quickly, while larger maps such as 80 by 80 can take significantly longer.

The rule system is configurable, but not fully designer-extensible. Designers can configure existing match definitions, prerequisites, rewrite actions, rulebooks, seeds, and materialization settings, but programmers are still needed to implement new kinds of rule behavior. 
The validation is also limited in some ways. The It consumes game scenario was analyzed through generated examples, not through a completed playable prototype or formal user study.

== Future work

Future work should improve usability, tesing and validation. The editor workflow could be extended with richer rule editing tools, clearer visualization of pattern matches, step by step generation debugging, and better feedback when configurations are invalid. These additions would make the framework easier for designers to understand and to adjust generation according to their needs.

The framework could also be optimized for larger maps and more complex rulebooks. Possible improvements include caching property counts, limiting search spaces to affected regions, batching rule applications.

Further development could expand the rule system with additional match definitions, prerequisites, rewrite actions, and support for other map structures such as square grids or irregular graphs. Validation could also be strengthened by implementing It consumes as a playable prototype and testing generated maps with developers or players. This would make it possible to evaluate not only whether the maps appear structurally suitable, but also whether they are balanced, understandable, and engaging in actual play.