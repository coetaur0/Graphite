//
//  MatchingTests.swift
//  GraphiteTests
//
//  Created by Aurélien on 07.10.19.
//

import XCTest
@testable import Graphite

class MatchingTests: XCTestCase {
  
  func testAugment() {
    enum NodeLabel {
      case A
      case B
    }
    
    enum EdgeLabel {
      case a
      case b
    }
    
    let graph1 = Graph<NodeLabel, EdgeLabel>(named: "Graph1")
    let graph2 = Graph<NodeLabel, EdgeLabel>(named: "Graph2")
    
    let vertex11 = graph1.addVertex(named: "1", labelledWith: .A)
    let vertex12 = graph1.addVertex(named: "2", labelledWith: .A)
    let vertex13 = graph1.addVertex(named: "3", labelledWith: .B)
    let vertex14 = graph1.addVertex(named: "4", labelledWith: .B)
    let vertex15 = graph1.addVertex(named: "5", labelledWith: .A)
    
    let vertex21 = graph2.addVertex(named: "1", labelledWith: .A)
    let vertex22 = graph2.addVertex(named: "2", labelledWith: .A)
    let vertex23 = graph2.addVertex(named: "3", labelledWith: .A)
    let vertex24 = graph2.addVertex(named: "4", labelledWith: .B)
    let vertex25 = graph2.addVertex(named: "5", labelledWith: .A)
    
    let e11_12 = graph1.addEdge(named: "11-12", labelledWith: .a, from: vertex11, to: vertex12)
    let e11_13 = graph1.addEdge(named: "11-13", labelledWith: .b, from: vertex11, to: vertex13)
    let e11_15 = graph1.addEdge(named: "11-15", labelledWith: .a, from: vertex11, to: vertex15)
    let e14_11 = graph1.addEdge(named: "14-11", labelledWith: .b, from: vertex14, to: vertex11)
    
    let e21_22 = graph2.addEdge(named: "21-22", labelledWith: .a, from: vertex21, to: vertex22)
    _ = graph2.addEdge(named: "21-23", labelledWith: .b, from: vertex21, to: vertex23)
    _ = graph2.addEdge(named: "21-25", labelledWith: .b, from: vertex21, to: vertex25)
    let e24_21 = graph2.addEdge(named: "24-21", labelledWith: .b, from: vertex24, to: vertex21)
    
    var matching = Matching<NodeLabel, EdgeLabel>(graphA: graph1, graphB: graph2)
    _ = matching.augment(with: (vertex11, vertex21))
    _ = matching.augment(with: (vertex12, vertex22))
    let success = matching.augment(with: (vertex13, vertex23))
    _ = matching.augment(with: (vertex14, vertex24))
    _ = matching.augment(with: (vertex15, vertex25))
    
    XCTAssertEqual(matching.vertexMatches[vertex11], vertex21)
    XCTAssertEqual(matching.vertexMatches[vertex12], vertex22)
    XCTAssertFalse(success)
    XCTAssertNil(matching.vertexMatches[vertex13])
    XCTAssertEqual(matching.vertexMatches[vertex14], vertex24)
    XCTAssertEqual(matching.vertexMatches[vertex15], vertex25)
    
    XCTAssertEqual(matching.edgeMatches[e11_12], e21_22)
    XCTAssertEqual(matching.edgeMatches[e14_11], e24_21)
    XCTAssertNil(matching.edgeMatches[e11_13])
    XCTAssertNil(matching.edgeMatches[e11_15])
  }
  
  func testMatch() {
    // Define the labels of nodes and edges.
    enum VertexType {
      case abstractTypeDef
      case typeDef
    }
    
    enum EdgeType {
      case extends
      case methodParameter
      case methodReturn
    }
    
    // Build a pattern graph to match with the graph of some source code.
    let patternGraph = Graph<VertexType, EdgeType>(named: "pattern")
    
    // The pattern graph contains the visitor pattern.
    let visitor = patternGraph.addVertex(named: "Visitor", labelledWith: .abstractTypeDef)
    let element = patternGraph.addVertex(named: "Element", labelledWith: .abstractTypeDef)
    let concreteVisitor = patternGraph.addVertex(named: "ConcreteVisitor",
                                                 labelledWith: .typeDef)
    let concreteElement = patternGraph.addVertex(named: "ConcreteElement",
                                                 labelledWith: .typeDef)
    
    let patternExtends1 = patternGraph.addEdge(named: "extends1",
                                               labelledWith: .extends,
                                               from: concreteVisitor,
                                               to: visitor)
    let patternExtends2 = patternGraph.addEdge(named: "extends2",
                                               labelledWith: .extends,
                                               from: concreteElement,
                                               to: element)
    let patternAccept1 = patternGraph.addEdge(named: "accept",
                                              labelledWith: .methodParameter,
                                              from: element,
                                              to: visitor)
    let patternAccept2 = patternGraph.addEdge(named: "accept",
                                              labelledWith: .methodParameter,
                                              from: concreteElement,
                                              to: concreteVisitor)
    let patternVisit1 = patternGraph.addEdge(named: "visit",
                                             labelledWith: .methodParameter,
                                             from: visitor,
                                             to: concreteElement)
    _ = patternGraph.addEdge(named: "visit",
                             labelledWith: .methodParameter,
                             from: concreteVisitor,
                             to: concreteElement)
    
    // Define the graph of some source code containing the visitor pattern partially implemented.
    let codeGraph = Graph<VertexType, EdgeType>(named: "code")
    
    let walker = codeGraph.addVertex(named: "Walker", labelledWith: .abstractTypeDef)
    let piece = codeGraph.addVertex(named: "Piece", labelledWith: .abstractTypeDef)
    let concreteWalker1 = codeGraph.addVertex(named: "ConcreteWalker1", labelledWith: .typeDef)
    let concreteWalker2 = codeGraph.addVertex(named: "ConcreteWalker2", labelledWith: .typeDef)
    let concretePiece = codeGraph.addVertex(named: "ConcretePiece", labelledWith: .typeDef)
    let int = codeGraph.addVertex(named: "Int", labelledWith: .typeDef)
    
    _ = codeGraph.addEdge(named: "extends1",
                          labelledWith: .extends,
                          from: concreteWalker1,
                          to: walker)
    let codeExtends2 = codeGraph.addEdge(named: "extends2",
                                         labelledWith: .extends,
                                         from: concreteWalker2,
                                         to: walker)
    let codeExtends3 = codeGraph.addEdge(named: "extends3",
                                         labelledWith: .extends,
                                         from: concretePiece,
                                         to: piece)
    let codeAccept1 = codeGraph.addEdge(named: "accept",
                                        labelledWith: .methodParameter,
                                        from: piece,
                                        to: walker)
    let codeAccept2 = codeGraph.addEdge(named: "accept",
                                        labelledWith: .methodParameter,
                                        from: concretePiece,
                                        to: concreteWalker2)
    let codeVisit = codeGraph.addEdge(named: "visit",
                                      labelledWith: .methodParameter,
                                      from: walker,
                                      to: concretePiece)
    _ = codeGraph.addEdge(named: "doSomething",
                          labelledWith: .methodParameter,
                          from: concretePiece,
                          to: int)
    
    // Compute the best possible AGM between the pattern and code graph.
    let matching = patternGraph.match(with: codeGraph)
    
    XCTAssertEqual(matching.score, 0.9)
    
    XCTAssertEqual(matching.vertexMatches[visitor], walker)
    XCTAssertEqual(matching.vertexMatches[element], piece)
    XCTAssertEqual(matching.vertexMatches[concreteVisitor], concreteWalker2)
    XCTAssertEqual(matching.vertexMatches[concreteElement], concretePiece)
    
    XCTAssertEqual(matching.edgeMatches[patternExtends1], codeExtends2)
    XCTAssertEqual(matching.edgeMatches[patternExtends2], codeExtends3)
    XCTAssertEqual(matching.edgeMatches[patternAccept1], codeAccept1)
    XCTAssertEqual(matching.edgeMatches[patternAccept2], codeAccept2)
    XCTAssertEqual(matching.edgeMatches[patternVisit1], codeVisit)
  }
  
  static var allTests = [
    ("testAugmentAGM", testAugment),
    ("testExactBestMatch", testMatch)
  ]
  
}
