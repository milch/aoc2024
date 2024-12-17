import Testing

@testable import aoc2024

private enum TestTile: String, CaseIterable {
    case wall = "#"
    case floor = "."
}

@Suite struct ParsingTests {

    @Test func testMapParser() {
        let input = """
            #######
            #.....#
            #..#..#
            #.....#
            #######
            """
        let result = try! MapParser<TestTile>().parse(input)
        #expect(result[0] == [.wall, .wall, .wall, .wall, .wall, .wall, .wall])
        #expect(result[1] == [.wall, .floor, .floor, .floor, .floor, .floor, .wall])
        #expect(result[2] == [.wall, .floor, .floor, .wall, .floor, .floor, .wall])
        #expect(result[3] == [.wall, .floor, .floor, .floor, .floor, .floor, .wall])
        #expect(result[4] == [.wall, .wall, .wall, .wall, .wall, .wall, .wall])
    }

    @Test func testMapParserHandlesEmptyLines() {
        let input = """
            #######
            #.....#
            #..#..#
            #.....#
            #######


            """
        let result = try! MapParser<TestTile>().parse(input)
        #expect(result[0] == [.wall, .wall, .wall, .wall, .wall, .wall, .wall])
        #expect(result[1] == [.wall, .floor, .floor, .floor, .floor, .floor, .wall])
        #expect(result[2] == [.wall, .floor, .floor, .wall, .floor, .floor, .wall])
        #expect(result[3] == [.wall, .floor, .floor, .floor, .floor, .floor, .wall])
        #expect(result[4] == [.wall, .wall, .wall, .wall, .wall, .wall, .wall])
    }
}
