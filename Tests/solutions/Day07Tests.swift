import Testing

@testable import aoc2024

private let testInput = """
    190: 10 19
    3267: 81 40 27
    83: 17 5
    156: 15 6
    7290: 6 8 6 15
    161011: 16 10 13
    192: 17 8 14
    21037: 9 7 18 13
    292: 11 6 16 20
    """

@Suite struct Day07Tests {
    let day07 = Day07(input: testInput)

    @Test func testPart1WithGivenInput() async {
        let result = await day07.solvePart1()
        #expect(result == 3749)
    }

    @Test func testPart2WithGivenInput() async {
        let result = await day07.solvePart2()
        #expect(result == 11387)
    }
}
