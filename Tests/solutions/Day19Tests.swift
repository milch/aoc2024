import Testing

@testable import aoc2024

@Suite struct Day19Tests {
    let day19 = Day19(
        input: """
            r, wr, b, g, bwu, rb, gb, br

            brwrr
            bggr
            gbbr
            rrbgbr
            ubwu
            bwurrg
            brgr
            bbrgwb
            """)

    @Test func testSolvePart1() async {
        let result = await day19.solvePart1()
        #expect(result == 6)
    }

    @Test func testSolvePart2() async {
        let result = await day19.solvePart2()
        #expect(result == 16)
    }
}
