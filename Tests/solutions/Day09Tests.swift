import Testing

@testable import aoc2024

private let testInput = "2333133121414131402"

@Suite struct Day09Tests {
    let day09 = Day09(input: testInput)

    // @Test func testSolvePart1() async {
    //     let result = await day09.solvePart1()
    //     #expect(result == 1928)
    // }

    @Test func testSolvePart2() async {
        let result = await day09.solvePart2()
        #expect(result == 2858)
    }
}
