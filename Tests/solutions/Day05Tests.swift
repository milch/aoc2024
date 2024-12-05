import Testing

@testable import aoc2024

private let testInput = """
    47|53
    97|13
    97|61
    97|47
    75|29
    61|13
    75|53
    29|13
    97|29
    53|29
    61|53
    97|53
    61|29
    47|13
    75|47
    97|75
    47|61
    75|61
    47|29
    75|13
    53|13

    75,47,61,53,29
    97,61,53,29,13
    75,29,13
    75,97,47,61,53
    61,13,29
    97,13,75,29,47
    """

@Suite struct Day05Tests {
    let day03 = Day05(input: testInput)

    @Test func testPart1WithGivenInput() {
        let result = day03.solvePart1()
        #expect(result == 143)
    }

    @Test func testPart2WithGivenInput() {
        let result = day03.solvePart2()
        #expect(result == 123)
    }
}
