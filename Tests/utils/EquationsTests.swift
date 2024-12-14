import Accelerate
import Testing

@testable import aoc2024

@Suite struct EquationsTests {
    @Test func testSolve2DLinearEquations() {
        var one = (x: 94, y: 22, equals: 8400)
        var two = (x: 34, y: 67, equals: 5400)
        var result = solve2DLinearEquations(one: one, two: two)
        #expect(result == .some(EquationResult(a: 80, b: 40)))

        one = (x: 26, y: 67, equals: 12748)
        two = (x: 66, y: 21, equals: 12176)
        result = solve2DLinearEquations(one: one, two: two)
        #expect(result == nil)

        one = (x: 94, y: 22, equals: 8400 + 10_000_000_000_000)
        two = (x: 34, y: 67, equals: 5400 + 10_000_000_000_000)
        result = solve2DLinearEquations(one: one, two: two)
        #expect(result == nil)

        one = (x: 26, y: 67, equals: 12748 + 10_000_000_000_000)
        two = (x: 66, y: 21, equals: 12176 + 10_000_000_000_000)
        result = solve2DLinearEquations(one: one, two: two)
        #expect(result != nil)

        one = (x: 17, y: 84, equals: 7870 + 10_000_000_000_000)
        two = (x: 86, y: 37, equals: 6450 + 10_000_000_000_000)
        result = solve2DLinearEquations(one: one, two: two)
        #expect(result == nil)

        one = (x: 69, y: 27, equals: 18641 + 10_000_000_000_000)
        two = (x: 23, y: 71, equals: 10279 + 10_000_000_000_000)
        result = solve2DLinearEquations(one: one, two: two)
        #expect(result != nil)
    }
}
