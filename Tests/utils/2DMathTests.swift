import Testing

@testable import aoc2024

@Suite struct MathTests {
    @Test func testPointSubscriptAllValid() {
        let grid: [[Int]] = [
            [1, 2, 3],
            [4, 5, 6],
            [7, 8, 9],
        ]
        #expect(grid[Point([0, 0])] == 1)
        #expect(grid[Point([0, 1])] == 2)
        #expect(grid[Point([0, 2])] == 3)
        #expect(grid[Point([1, 0])] == 4)
        #expect(grid[Point([1, 1])] == 5)
        #expect(grid[Point([1, 2])] == 6)
        #expect(grid[Point([2, 0])] == 7)
        #expect(grid[Point([2, 1])] == 8)
        #expect(grid[Point([2, 2])] == 9)
    }

    @Test func testPointSubscriptAllInvalid() {
        let grid: [[Int]] = [
            [1, 2, 3],
            [4, 5, 6],
            [7, 8, 9],
        ]
        #expect(grid[Point([0, 3])] == nil)
        #expect(grid[Point([3, 0])] == nil)
        #expect(grid[Point([3, 3])] == nil)
    }

    @Test func testPointIterator() {
        let grid: [[Int]] = [
            [1, 2, 3],
            [4, 5, 6],
            [7, 8, 9],
        ]
        var points = grid.points()
        var val = points.next()
        #expect(val?.0 == [0, 0])
        #expect(val?.1 == 1)
        val = points.next()
        #expect(val?.0 == [0, 1])
        #expect(val?.1 == 2)
        val = points.next()
        #expect(val?.0 == [0, 2])
        #expect(val?.1 == 3)
        val = points.next()
        #expect(val?.0 == [1, 0])
        #expect(val?.1 == 4)
        val = points.next()
        #expect(val?.0 == [1, 1])
        #expect(val?.1 == 5)
        val = points.next()
        #expect(val?.0 == [1, 2])
        #expect(val?.1 == 6)
        val = points.next()
        #expect(val?.0 == [2, 0])
        #expect(val?.1 == 7)
        val = points.next()
        #expect(val?.0 == [2, 1])
        #expect(val?.1 == 8)
        val = points.next()
        #expect(val?.0 == [2, 2])
        #expect(val?.1 == 9)
        val = points.next()
        #expect(val == nil)
    }

    @Test func testPointIteratorForInLoop() {
        let grid: [[Int]] = [
            [1, 2, 3],
            [4, 5, 6],
            [7, 8, 9],
        ]
        var remainingExpectedResults = [1, 2, 3, 4, 5, 6, 7, 8, 9]
        var remainingExpectedPoints = [
            Point([0, 0]), Point([0, 1]), Point([0, 2]),
            Point([1, 0]), Point([1, 1]), Point([1, 2]),
            Point([2, 0]), Point([2, 1]), Point([2, 2]),
        ]
        for (point, value) in grid.points() {
            let expectedPoint = remainingExpectedPoints.removeFirst()
            let expectedValue = remainingExpectedResults.removeFirst()
            #expect(point == expectedPoint)
            #expect(value == expectedValue)
        }
    }
}
