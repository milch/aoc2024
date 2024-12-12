import Testing

@testable import aoc2024

private let testInput = """
    RRRRIICCFF
    RRRRIICCCF
    VVRRRCCFFF
    VVRCCCJFFF
    VVVVCJJCFE
    VVIVCCJJEE
    VVIIICJJEE
    MIIIIIJJEE
    MIIISIJEEE
    MMMISSJEEE
    """

@Suite struct Day12Tests {
    let day12 = Day12(input: testInput)

    @Test func testSolvePart1() async {
        let result = await day12.solvePart1()
        #expect(result == 1930)
    }

    @Test func testPart1Simple() async {
        let input = """
            AAAA
            BBCD
            BBCC
            EEEC
            """
        let result = await Day12(input: input).solvePart1()
        #expect(result == 140)
    }
    @Test func testPart1OneContainsAnother() async {
        let input = """
            OOOOO
            OXOXO
            OOOOO
            OXOXO
            OOOOO
            """
        let result = await Day12(input: input).solvePart1()
        #expect(result == 772)
    }

    @Test func testSolvePart2() async {
        let result = await day12.solvePart2()
        #expect(result == 1206)
    }

    @Test func testPart2Simple() async {
        let input = """
            AAAA
            BBCD
            BBCC
            EEEC
            """
        let result = await Day12(input: input).solvePart2()
        #expect(result == 80)
    }

    @Test func testPart2EShape() async {
        let input = """
            EEEEE
            EXXXX
            EEEEE
            EXXXX
            EEEEE
            """
        let result = await Day12(input: input).solvePart2()
        #expect(result == 236)
    }

    @Test func testPart2OneContainsAnother() async {
        let input = """
            OOOOO
            OXOXO
            OOOOO
            OXOXO
            OOOOO
            """
        let result = await Day12(input: input).solvePart2()
        #expect(result == 436)
    }
}
