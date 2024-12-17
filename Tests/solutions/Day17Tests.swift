import Testing

@testable import aoc2024

private let testInput = """
    Register A: 729
    Register B: 0
    Register C: 0

    Program: 0,1,5,4,3,0
    """

@Suite struct Day17Tests {
    let day17 = Day17(input: testInput)

    @Test func testRunComputer() {
        let outputs = day17.runComputer()
        #expect(outputs == [4, 6, 3, 5, 6, 3, 5, 2, 1, 0])
    }

    @Test func testSolvePart2() async {
        let day17 = Day17(
            input: """
                Register A: 2024
                Register B: 0
                Register C: 0

                Program: 0,3,5,4,3,0
                """)
        let result = await day17.solvePart2()
        #expect(result == 117440)
    }
}
