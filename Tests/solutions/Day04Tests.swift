import Testing

@testable import aoc2024

private let testInput = """
    MMMSXXMASM
    MSAMXMSMSA
    AMXSXMAAMM
    MSAMASMSMX
    XMASAMXAMM
    XXAMMXXAMA
    SMSMSASXSS
    SAXAMASAAA
    MAMMMXMMMM
    MXMXAXMASX
    """

@Suite struct Day04Tests {
    let day03 = Day04(input: testInput)

    @Test func testPart1WithGivenInput() {
        let result = day03.solvePart1()
        #expect(result == 18)
    }

    @Test func testPart2WithGivenInput() {
        let result = day03.solvePart2()
        #expect(result == 9)
    }
}
