import Testing

@testable import aoc2024

@Suite struct ConcurrencyTests {
    @Test func testConcurrentFilter() async {
        let numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
        let result = await numbers.concurrentFilter { $0 % 2 == 0 }
        #expect(result == [2, 4, 6, 8, 10])
    }

    @Test func testConcurrentMap() async {
        let numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
        let result = await numbers.concurrentMap { $0 * 2 }
        #expect(result.sorted() == [2, 4, 6, 8, 10, 12, 14, 16, 18, 20])
    }
}
