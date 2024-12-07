import Testing

@testable import aoc2024

@Suite struct ConcurrencyTests {
    @Test func testConcurrentFilter() async {
        let numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
        let result = await numbers.concurrentFilter { $0 % 2 == 0 }
        #expect(result == [2, 4, 6, 8, 10])
    }
}
