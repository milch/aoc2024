import Testing

@testable import aoc2024

private let testInput = """
    ............
    ........0...
    .....0......
    .......0....
    ....0.......
    ......A.....
    ............
    ............
    ........A...
    .........A..
    ............
    ............
    """

@Suite struct Day08Tests {
    let day08 = Day08(input: testInput)

    @Test func testSolvePart1() async {
        let result = await day08.solvePart1()
        #expect(result == 14)
    }

    @Test func testSolvePart2() async {
        let result = await day08.solvePart2()
        #expect(result == 34)
    }
}
