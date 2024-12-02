import Testing

@testable import aoc2024

private let testInput = """
    7 6 4 2 1
    1 2 7 8 9
    9 7 6 2 1
    1 3 2 4 5
    8 6 4 4 1
    1 3 6 7 9
    """

@Suite struct Day02Tests {
    let day02 = Day02(input: testInput)

    @Test func testPart1WithGivenInput() {
        let result = day02.solvePart1()
        #expect(result == 2)
    }

    @Test func testPart2WithGivenInput() {
        let result = day02.solvePart2()
        #expect(result == 4)
    }
}
