import Testing

@testable import aoc2024

private let testInput = """
    p=0,4 v=3,-3
    p=6,3 v=-1,-3
    p=10,3 v=-1,2
    p=2,0 v=2,-1
    p=0,0 v=1,3
    p=3,0 v=-2,-2
    p=7,6 v=-1,-3
    p=3,0 v=-1,-2
    p=9,3 v=2,3
    p=7,3 v=-1,2
    p=2,4 v=2,-3
    p=9,5 v=-3,-3
    """

@Suite struct Day14Tests {
    let day14 = Day14(input: testInput, mapSize: [7, 11])

    @Test func testSolvePart1() async {
        let result = await day14.solvePart1()
        #expect(result == 12)
    }
}
