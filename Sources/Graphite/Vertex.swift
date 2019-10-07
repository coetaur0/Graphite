//
//  Vertex.swift
//  Graphite
//
//  Created by Aurélien on 07.10.19.
//

public extension Graph.Vertex {
  
  /// Get the vertex's neighbours up to a given distance.
  ///
  /// - Parameter distance: The distance up to which neighbours must be retrieved.
  /// - Returns: The set of the vertex's neighbours at most 'n' edges away, where 'n' is the
  ///   distance passed as argument.
  func neighbourhood(upTo distance: Int) -> Set<Graph.Vertex> {
    var neighbours: Set<Graph.Vertex> = []
    var verticesToVisit: [Graph.Vertex: Int] = [self: distance]
    
    while !verticesToVisit.isEmpty {
      let (nextVertex, distanceLeft) = verticesToVisit.popFirst()!
      
      if distanceLeft > 0 {
        for edge in nextVertex.incomingEdges {
          let neighbour = edge.source
          neighbours.insert(neighbour)
          
          if verticesToVisit[neighbour] == nil || verticesToVisit[neighbour]! < distanceLeft - 1 {
            verticesToVisit[neighbour] = distanceLeft - 1
          }
        }
        
        for edge in nextVertex.outgoingEdges {
          let neighbour = edge.target
          neighbours.insert(neighbour)
          
          if verticesToVisit[neighbour] == nil || verticesToVisit[neighbour]! < distanceLeft - 1 {
            verticesToVisit[neighbour] = distanceLeft - 1
          }
        }
      }
    }
    
    return neighbours
  }
  
}
