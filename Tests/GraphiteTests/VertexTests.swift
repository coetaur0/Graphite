//
//  VertexTests.swift
//  Graphite
//
//  Created by Aurélien on 07.10.19.
//

import XCTest
@testable import Graphite

class VertexTests: XCTestCase {
  
  enum VertexLabel {
    case A
    case B
    case C
    case D
    case E
    case F
  }

  enum EdgeLabel {
    case a
    case b
    case c
    case d
    case e
    case f
  }

  func testNeighbourhood() {
    let graph = Graph<VertexLabel, EdgeLabel>(named: "TestGraph")

    let vertexA = graph.addVertex(named: "A", labelledWith: .A)
    let vertexB = graph.addVertex(named: "B", labelledWith: .B)
    let vertexC = graph.addVertex(named: "C", labelledWith: .C)
    let vertexD = graph.addVertex(named: "D", labelledWith: .D)
    let vertexE = graph.addVertex(named: "E", labelledWith: .E)
    let vertexF = graph.addVertex(named: "F", labelledWith: .F)

    _ = graph.addEdge(named: "a", labelledWith: .a, from: vertexA, to: vertexB)
    _ = graph.addEdge(named: "b", labelledWith: .b, from: vertexB, to: vertexC)
    _ = graph.addEdge(named: "c", labelledWith: .c, from: vertexC, to: vertexD)
    _ = graph.addEdge(named: "d", labelledWith: .d, from: vertexB, to: vertexE)
    _ = graph.addEdge(named: "e", labelledWith: .e, from: vertexA, to: vertexE)
    _ = graph.addEdge(named: "f", labelledWith: .f, from: vertexE, to: vertexF)

    let neighbours = vertexA.neighbourhood(upTo: 2)
    var expectedNeighbours = graph.vertices
    expectedNeighbours.remove(vertexD)

    XCTAssertEqual(neighbours, expectedNeighbours)
  }
  
  static var allTests = [
    ("testNeighbourhood", testNeighbourhood),
  ]
  
}
