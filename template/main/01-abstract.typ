#import "/local-lib/template-thesis.typ": *
#import "/metadata.typ": *
#pagebreak()
#heading(numbering:none)[#i18n("abstract-title", lang:option.lang)] <sec:abstract>

This thesis focuses on generation of game maps composed of hexagonal cells and explores whether a graph rewriting approach can provide a configurable framework for generating varied maps. Procedural generation can be a useful tool for any game, reducing reliance on manually created content and increasing replayability. However, generated content can become predictable when players begin to recognize repeated structures or generation patterns. Therefore, flexibility in generation setup can potentially provide game designers with more freedom of expression, leading to more variation in content.

The research includes comparison and evaluation of frameworks available on the market to understand available map generation capabilities using features such as grid-based and graph-based generation. The results of the comparison pointed towards a gap in current market offerings for a generation framework focusing on hexagonal cell maps.

Research led to the design and implmentation of a framework for the Unity game engine  that allows to procedurally generate graph of hexagonal cells by following a strictly user-defined set of rules. The resulting graph can be used as a game map.

The framework based on the research results is capable of generating hexagonal maps with meaningful terrain relationships and repeatable outputs from fixed settings and seeds. At the same time, the prototype remains limited to small and medium-sized maps, existing rule components, and conceptual validation through generated examples rather than a complete playable game or formal user study.

#linebreak();

//up to 10 key words (tags) e.g. procedural generation, graph rewriting, 
*Key words:*
