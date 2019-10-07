//
//  GraphTests.swift
//  Graphite
//
//  Created by Aurélien on 07.10.19.
//

import XCTest
@testable import Graphite

class GraphTests: XCTestCase {
  
  enum VertexLabel {
    case A
  }
  
  enum EdgeLabel {
    case a
  }
  
  func testAddNewVertex() {
    let graph = Graph<VertexLabel, EdgeLabel>(named: "TestGraph")
    let newVertex = graph.addVertex(named: "TestVertex", labelledWith: .A)
    XCTAssert(graph.vertices.contains(newVertex))
  }
  
  func testAddExistingVertex() {
    let graph = Graph<VertexLabel, EdgeLabel>(named: "TestGraph")
    let existingVertex = graph.addVertex(named: "TestVertex", labelledWith: .A)
    let newVertex = graph.addVertex(named: "TestVertex", labelledWith: .A)
    XCTAssert(graph.vertices.contains(newVertex))
    XCTAssertEqual(graph.vertices.count, 1)
    XCTAssertEqual(existingVertex, newVertex)
    XCTAssert(newVertex === existingVertex)
  }
  
  func testAddNewEdge() {
    let graph = Graph<VertexLabel, EdgeLabel>(named: "TestGraph")
    let vertex1 = graph.addVertex(named: "1", labelledWith: .A)
    let vertex2 = graph.addVertex(named: "2", labelledWith: .A)
    let edge = graph.addEdge(named: "TestEdge", labelledWith: .a, from: vertex1, to: vertex2)
    XCTAssert(graph.edges.contains(edge))
  }
  
  func testAddExistingEdge() {
    let graph = Graph<VertexLabel, EdgeLabel>(named: "TestGraph")
    let vertex1 = graph.addVertex(named: "1", labelledWith: .A)
    let vertex2 = graph.addVertex(named: "2", labelledWith: .A)
    let exisitingEdge = graph.addEdge(named: "a", labelledWith: .a, from: vertex1, to: vertex2)
    let newEdge = graph.addEdge(named: "a", labelledWith: .a, from: vertex1, to: vertex2)
    XCTAssert(graph.edges.contains(newEdge))
    XCTAssertEqual(graph.edges.count, 1)
    XCTAssertEqual(exisitingEdge, newEdge)
    XCTAssert(exisitingEdge === newEdge)
  }
  
  static var allTests = [
    ("testAddNewVertex", testAddNewVertex),
    ("testAddExistingVertex", testAddExistingVertex),
    ("testAddNewEdge", testAddNewEdge),
    ("testAddExistingEdge", testAddExistingEdge)
  ]
  
}
