import Testing

@testable import aoc2024

private let testInput = """
    ....#.....
    .........#
    ..........
    ..#.......
    .......#..
    ..........
    .#..^.....
    ........#.
    #.........
    ......#...
    """

@Suite struct Day06Tests {
    let day03 = Day06(input: testInput)

    @Test func testPart1WithGivenInput() {
        let result = day03.solvePart1()
        #expect(result == 41)
    }

    @Test func testPart2WithGivenInput() {
        let result = day03.solvePart2()
        #expect(result == 6)
    }
}
