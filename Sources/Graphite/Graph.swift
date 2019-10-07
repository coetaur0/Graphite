//
//  Graph.swift
//  Graphite
//
//  Created by Aurélien on 07.10.19.
//

public final class Graph<VertexLabel: Hashable, EdgeLabel: Hashable> {
  
  public final class Vertex: Hashable {
    
    public let name: String
    public let label: VertexLabel
    
    public internal(set) var incomingEdges: Set<Edge> = []
    public internal(set) var outgoingEdges: Set<Edge> = []
    
    public init(named name: String, labelledWith label: VertexLabel) {
      self.name = name
      self.label = label
    }
    
    public static func == (lhs: Vertex, rhs: Vertex) -> Bool {
      return lhs.name == rhs.name && lhs.label == rhs.label
    }
    
    public func hash(into hasher: inout Hasher) {
      hasher.combine(name)
      hasher.combine(label)
    }
    
  }
  
  public final class Edge: Hashable {
    
    public let name: String
    public let label: EdgeLabel
    
    public let source: Vertex
    public let target: Vertex
    
    public init(
      named name: String,
      labelledWith label: EdgeLabel,
      from source: Vertex,
      to target: Vertex
    ) {
      self.name = name
      self.label = label
      self.source = source
      self.target = target
    }
    
    public static func == (lhs: Edge, rhs: Edge) -> Bool {
      return lhs.name == rhs.name &&
        lhs.label == rhs.label &&
        lhs.source == rhs.source &&
        lhs.target == rhs.target
    }
    
    public func hash(into hasher: inout Hasher) {
      hasher.combine(name)
      hasher.combine(label)
      hasher.combine(source)
      hasher.combine(target)
    }
    
  }
  
  public let name: String
  
  public private(set) var vertices: Set<Vertex> = []
  public private(set) var edges: Set<Edge> = []
  
  public init(named name: String) {
    self.name = name
  }
  
  /// Add a new vertex to the graph and return a reference to it. If a vertex with the same name and
  /// label already exists in the graph, no new vertex is added and a reference to it is returned
  /// instead.
  ///
  /// - Parameters:
  ///   - name: The name of the vertex to add to the graph.
  ///   - label: The label associated with the vertex.
  /// - Returns: A reference to the new vertex if the graph didn't contain it already, or a
  ///   reference to the existing one otherwise.
  public func addVertex(named name: String, labelledWith label: VertexLabel) -> Vertex {
    let (_, result) = vertices.insert(Vertex(named: name, labelledWith: label))
    return result
  }
  
  /// Add a new edge to the graph and return a reference to it. If an edge with the same name,
  /// label, source and target already exists in the graph, no new edge is added and a reference to
  /// it is returned instead.
  ///
  /// - Parameters:
  ///   - name: The name of the edge to add to the graph.
  ///   - label: The label associated to the edge.
  ///   - source: The source vertex of the edge.
  ///   - target: The target vertex of the edge.
  /// - Returns: A reference to the new edge if the graph didn't contain it already, or a reference
  ///   to the existing one otherwise.
  public func addEdge(
    named name: String,
    labelledWith label: EdgeLabel,
    from source: Vertex,
    to target: Vertex
  ) -> Edge {
    let (isNew, result) = edges.insert(
      Edge(named: name, labelledWith: label, from: source, to: target)
    )
    
    if isNew {
      result.source.outgoingEdges.insert(result)
      result.target.incomingEdges.insert(result)
    }
    
    return result
  }
  
}
