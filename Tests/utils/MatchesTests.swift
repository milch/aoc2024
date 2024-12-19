import Testing

@testable import aoc2024

@Suite struct MatchesTests {
    @Test func testMatchesEmpty() {
        let testArray: [Int] = []
        #expect(testArray.matches(prefix: [1, 2, 3]) == false)
        #expect(testArray.matches(prefix: [1]) == false)
        #expect(testArray.matches(prefix: []) == true)
    }

    @Test func testMatchesSingleElement() {
        let testArray: [Int] = [1]
        #expect(testArray.matches(prefix: [1]) == true)
        #expect(testArray.matches(prefix: [1, 2]) == false)
        #expect(testArray.matches(prefix: [2, 2]) == false)
    }

    @Test func testMatchesPartially() {
        let testArray: [Int] = [1, 2, 3]
        #expect(testArray.matches(prefix: [1]) == true)
        #expect(testArray.matches(prefix: [1, 2]) == true)
        #expect(testArray.matches(prefix: [1, 2, 3]) == true)
        #expect(testArray.matches(prefix: [1, 2, 4]) == false)
        #expect(testArray.matches(prefix: [1, 2, 3, 4]) == false)
    }
}
