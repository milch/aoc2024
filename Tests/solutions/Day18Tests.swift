import Testing

@testable import aoc2024

private let testInput = """
    5,4
    4,2
    4,5
    3,0
    2,1
    6,3
    2,4
    1,5
    0,6
    3,3
    2,6
    5,1
    1,2
    5,5
    2,5
    6,5
    1,4
    0,4
    6,4
    1,1
    6,1
    1,0
    0,5
    1,6
    2,0
    """

private let mapSize = 6
@Suite struct Day18Tests {
    let day18 = Day18(input: testInput, mapSize: mapSize, numFallenBytes: 12)

    @Test func testSolvePart1() async {
        let result = await day18.solvePart1()
        #expect(result == 22)
    }

    @Test func testSolvePart2() async {
        let result = await day18.solvePart2()

        // Target coordinate is (6, 1)
        #expect(result == 6 * (mapSize + 1) + 1)
    }
}
