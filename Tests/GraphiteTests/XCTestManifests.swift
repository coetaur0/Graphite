import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
  return [
    testCase(GraphTests.allTests),
    testCase(VertexTests.allTests),
    testCase(MatchingTests.allTests)
  ]
}
#endif
