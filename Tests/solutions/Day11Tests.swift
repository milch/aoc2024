import Testing

@testable import aoc2024

@Suite struct Day11Tests {
    @Test func testSolvePart1() async {
        let result = await Day11(input: "125 17").solvePart1()
        #expect(result == 55312)
    }
}
