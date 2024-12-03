import Testing

@testable import aoc2024

private let testInput = "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"

@Suite struct Day03Tests {
    let day03 = Day03(input: testInput)

    @Test func testPart1WithGivenInput() {
        let result = day03.solvePart1()
        #expect(result == 161)
    }

    @Test func testPart2WithGivenInput() {
        let result = day03.solvePart2()
        #expect(result == 48)
    }
}
