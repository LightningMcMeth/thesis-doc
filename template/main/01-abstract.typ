#import "/local-lib/template-thesis.typ": *
#import "/metadata.typ": *
#pagebreak()
#heading(numbering:none)[#i18n("abstract-title", lang:option.lang)] <sec:abstract>

Procedural generation is widely used in games to reduce reliance on manually created content and to increase replayability. However, generated content can become predictable when players begin to recognize repeated structures or generation patterns. This thesis focuses on procedural generation of game maps composed of hexagonal cells and explores whether a graph rewriting approach can provide a configurable framework for generating varied maps.

The objective of the thesis is to design and implement a proof-of-concept framework that represents a map as a graph of hexagonal cells and allows generation rules to transform this graph. The research phase explores existing procedural generation tools and selected game examples to identify available capabilities in solutions and gaps.

The framework is capable of generating hexagonal maps with meaningful terrain relationships and repeatable outputs from fixed settings and seeds. At the same time, the prototype remains limited to small and medium-sized maps, existing rule components, and conceptual validation through generated examples rather than a complete playable game or formal user study.