import Testing

@testable import aoc2024

let testInput = """
    3   4
    4   3
    2   5
    1   3
    3   9
    3   3
    """
@Suite struct Day01Tests {
    @Test func testPart1WithGivenInput() {
        let result = Day01(input: testInput).solvePart1()
        #expect(result == 11)
    }

    @Test func testPart1WithNegativeNumbers() {
        let negativeTestInput = """
            2   5
            4   3
            """
        let result = Day01(input: negativeTestInput).solvePart1()
        #expect(result == 2)
    }

    @Test func testPart2WithGivenInput() {
        let result = Day01(input: testInput).solvePart2()
        #expect(result == 31)
    }
}
