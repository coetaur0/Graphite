//
//  Graph+Matching.swift
//  Graphite
//
//  Created by Aurélien on 07.10.19.
//

public struct Matching<VertexLabel: Hashable, EdgeLabel: Hashable> {
  
  public let graphA: Graph<VertexLabel, EdgeLabel>
  public let graphB: Graph<VertexLabel, EdgeLabel>
  
  public private(set) var vertexMatches: [Graph<VertexLabel, EdgeLabel>.Vertex:
                                          Graph<VertexLabel, EdgeLabel>.Vertex] = [:]
  public private(set) var edgeMatches: [Graph<VertexLabel, EdgeLabel>.Edge:
                                        Graph<VertexLabel, EdgeLabel>.Edge] = [:]
  
  /// The score of the matching between two graphs. It is equal to the number of matched vertices
  /// and edges over the total number of vertices and edges in the matching's graph A.
  public var score: Double {
    return Double(vertexMatches.count + edgeMatches.count) /
      Double(graphA.vertices.count + graphA.edges.count)
  }
  
  /// Augment the matching between graphs A and B with a new correspondance between vertices, along
  /// with the associated edge matchings.
  ///
  /// - Parameter matching: A tuple containing a vertex from graph A and one from graph B.
  /// - Returns: A boolean indicating whether the match could be added. Augmenting a matching with
  ///   a new match can fail if the vertices being matched were already matched or if they have
  ///   different labels.
  public mutating func augment(
    with matching: (Graph<VertexLabel, EdgeLabel>.Vertex, Graph<VertexLabel, EdgeLabel>.Vertex)
  ) -> Bool {
    if vertexMatches[matching.0] != nil ||
      vertexMatches.values.contains(matching.1) ||
      matching.0.label != matching.1.label {
      return false
    }
    vertexMatches[matching.0] = matching.1
    
    for edge0 in matching.0.incomingEdges {
      if edgeMatches[edge0] == nil, let source = vertexMatches[edge0.source] {
        for edge1 in matching.1.incomingEdges {
          if edge1.label == edge0.label && edge1.source == source {
            edgeMatches[edge0] = edge1
          }
        }
      }
    }
    
    for edge0 in matching.0.outgoingEdges {
      if edgeMatches[edge0] == nil, let target = vertexMatches[edge0.target] {
        for edge1 in matching.1.outgoingEdges {
          if edge1.label == edge0.label && edge1.target == target {
            edgeMatches[edge0] = edge1
          }
        }
      }
    }
    
    return true
  }
  
}

public extension Graph {
  
  /// Perform an exhaustive depth-first search through the graph to find the best possible matching
  /// between its vertices and edges and those of some other graph.
  ///
  /// - Parameters:
  ///   - toMatch: The vertices left to match in the graph.
  ///   - toMatchInOther: The vertices left to match in the other graph.
  ///   - currentMatching: The current matching between the two graphs.
  /// - Returns: The best possible matching between the vertices and edges of the two graphs.
  private func exactBestMatch(
    toMatch: Set<Vertex>,
    toMatchInOther: [VertexLabel: Set<Vertex>],
    currentMatching: Matching<VertexLabel, EdgeLabel>
  ) -> Matching<VertexLabel, EdgeLabel> {
    // End of recursion.
    if toMatch.isEmpty {
      return currentMatching
    }
    
    var leftToMatch = toMatch
    let currentVertex = leftToMatch.popFirst()!
    var bestMatching = currentMatching

    // Cover cases where there are less nodes left to match in the other graph than in the one being
    // matched.
    bestMatching = exactBestMatch(
      toMatch: leftToMatch,
      toMatchInOther: toMatchInOther,
      currentMatching: currentMatching
    )
    
    // Recursively try to match the current vertex with those in the other graph that have the same
    // label, and return the match that offers the best final matching.
    if let othersWithSameLabel = toMatchInOther[currentVertex.label], !othersWithSameLabel.isEmpty {
      for otherVertex in othersWithSameLabel {
        var newMatching = currentMatching
        _ = newMatching.augment(with: (currentVertex, otherVertex))
        
        var leftToMatchInOther: [VertexLabel: Set<Vertex>]
        // When the first match between vertices is set in the matching, the search space in the
        // other graph is reduced to the neighbourhood of the vertex being matched, up to a distance
        // equal to the calling graph's size.
        if currentMatching.vertexMatches.count == 0 {
          leftToMatchInOther = [:]
          let neighbours = otherVertex.neighbourhood(upTo: toMatch.count - 1)
          neighbours.forEach() {
            if leftToMatchInOther[$0.label] == nil {
              leftToMatchInOther[$0.label] = []
            }
            leftToMatchInOther[$0.label]!.insert($0)
          }
        } else {
          leftToMatchInOther = toMatchInOther
        }
        if leftToMatchInOther[currentVertex.label] != nil {
          leftToMatchInOther[currentVertex.label]!.remove(otherVertex)
        }
        
        let nextMatching = exactBestMatch(
          toMatch: leftToMatch,
          toMatchInOther: leftToMatchInOther,
          currentMatching: newMatching
        )
        
        if nextMatching.score > bestMatching.score {
          bestMatching = nextMatching
        }
      }
    }
    
    return bestMatching
  }
  
  /// Find a matching between the vertices and edges of the graph and those of another one.
  ///
  /// - Parameter otherGraph: Another graph with which a matching must be found.
  /// - Returns: A matching between the vertices and edges of the graph and those of the one passed
  ///   as argument.
  func match(with otherGraph: Graph) -> Matching<VertexLabel, EdgeLabel> {
    var toMatchInOther: [VertexLabel: Set<Vertex>] = [:]
    otherGraph.vertices.forEach() {
      if toMatchInOther[$0.label] == nil {
        toMatchInOther[$0.label] = []
      }
      toMatchInOther[$0.label]!.insert($0)
    }
    
    return exactBestMatch(
      toMatch: vertices,
      toMatchInOther: toMatchInOther,
      currentMatching: Matching<VertexLabel, EdgeLabel>(graphA: self, graphB: otherGraph)
    )
  }
  
}
