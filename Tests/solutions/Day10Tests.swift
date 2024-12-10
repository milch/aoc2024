import Testing

@testable import aoc2024

private let testInput = """
    89010123
    78121874
    87430965
    96549874
    45678903
    32019012
    01329801
    10456732
    """

@Suite struct Day10Tests {
    let day10 = Day10(input: testInput)

    @Test func testSolvePart1() async {
        let result = await day10.solvePart1()
        #expect(result == 36)
    }

    @Test func testSimpleMapPart2() async {
        let day10 = Day10(
            input: """
                .....0.
                ..4321.
                ..5..2.
                ..6543.
                ..7..4.
                ..8765.
                ..9....
                """)
        let result = await day10.solvePart2()
        #expect(result == 3)
    }

    @Test func testComplexMapPart2() async {
        let day10 = Day10(
            input: """
                ..90..9
                ...1.98
                ...2..7
                6543456
                765.987
                876....
                987....
                """)
        let result = await day10.solvePart2()
        #expect(result == 13)
    }

    @Test func testSolvePart2() async {
        let result = await day10.solvePart2()
        #expect(result == 81)
    }
}
