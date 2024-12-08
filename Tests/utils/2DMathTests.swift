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

    @Test func testRotatingVectors() {
        let directionsInOrder = [
            Direction.north, Direction.northEast, Direction.east, Direction.southEast,
            Direction.south, Direction.southWest, Direction.west, Direction.northWest,
        ]
        let pairs = zip(directionsInOrder, directionsInOrder.dropFirst())
        for (direction, rotatedDirection) in pairs {
            #expect(direction.vector.rotated(by: -45) == rotatedDirection.vector)
            #expect(rotatedDirection.vector.rotated(by: 45) == direction.vector)
        }

        #expect(Direction.north.vector.rotated(by: -90) == Direction.east.vector)
        #expect(Direction.east.vector.rotated(by: -90) == Direction.south.vector)
        #expect(Direction.south.vector.rotated(by: -90) == Direction.west.vector)
        #expect(Direction.west.vector.rotated(by: -90) == Direction.north.vector)

        #expect(Direction.north.vector.rotated(by: 90) == Direction.west.vector)
        #expect(Direction.east.vector.rotated(by: 90) == Direction.north.vector)
        #expect(Direction.south.vector.rotated(by: 90) == Direction.east.vector)
        #expect(Direction.west.vector.rotated(by: 90) == Direction.south.vector)

        #expect(Direction.north.vector.rotated(by: 180) == Direction.south.vector)
        #expect(Direction.east.vector.rotated(by: -180) == Direction.west.vector)
    }

    @Test func testContainsPoint() {
        let grid: [[Int]] = [
            [1, 2, 3],
            [4, 5, 6],
            [7, 8, 9],
        ]
        #expect(grid.containsPoint([0, 0]))
        #expect(grid.containsPoint([0, 1]))
        #expect(grid.containsPoint([0, 2]))
        #expect(grid.containsPoint([1, 0]))
        #expect(grid.containsPoint([1, 1]))
        #expect(grid.containsPoint([1, 2]))
        #expect(grid.containsPoint([2, 0]))
        #expect(grid.containsPoint([2, 1]))
        #expect(grid.containsPoint([2, 2]))
        #expect(!grid.containsPoint([0, 3]))
        #expect(!grid.containsPoint([3, 0]))
        #expect(!grid.containsPoint([3, 3]))
    }
}
