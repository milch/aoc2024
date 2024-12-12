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

    @Test func testLineIterator() {
        let grid: [[Int]] = [
            [1, 2, 3],
            [4, 5, 6],
            [7, 8, 9],
        ]
        let topLine = grid.line(from: [0, 0], in: .east)
        #expect(topLine.map { $0.1 } == [1, 2, 3])
        let bottomLine = grid.line(from: [2, 2], in: .west)
        #expect(bottomLine.map { $0.1 } == [9, 8, 7])
        var topLeftCorner = grid.line(from: [0, 0], in: .north)
        #expect(topLeftCorner.next()?.0 == .some([0, 0]))
        #expect(topLeftCorner.next() == nil)
        let middleToBottom = grid.line(from: [1, 1], in: .south)
        #expect(middleToBottom.map { $0.1 } == [5, 8])
    }

    @Test func testSurroundingElements() {
        let grid: [[Int]] = [
            [1, 2, 3],
            [4, 5, 6],
            [7, 8, 9],
        ]
        #expect(Set(grid.pointsSurrounding([0, 0], corner: .northEast)) == [[0, 0], [0, 1]])
        #expect(Set(grid.pointsSurrounding([0, 0], corner: .northWest)) == [[0, 0]])
        #expect(
            Set(grid.pointsSurrounding([0, 0], corner: .southEast)) == [
                [0, 0], [0, 1], [1, 0], [1, 1],
            ])
        #expect(Set(grid.pointsSurrounding([0, 0], corner: .southWest)) == [[0, 0], [1, 0]])

        #expect(
            Set(grid.pointsSurrounding([1, 1], corner: .northEast)) == [
                [0, 1], [0, 2], [1, 1], [1, 2],
            ])
        #expect(
            Set(grid.pointsSurrounding([1, 1], corner: .northWest)) == [
                [0, 0], [0, 1], [1, 0], [1, 1],
            ])
        #expect(
            Set(grid.pointsSurrounding([1, 1], corner: .southEast)) == [
                [1, 1], [1, 2], [2, 1], [2, 2],
            ])
        #expect(
            Set(grid.pointsSurrounding([1, 1], corner: .southWest)) == [
                [1, 0], [1, 1], [2, 0], [2, 1],
            ])
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

    @Test func testCorner() {
        #expect(Point([0, 0]).corner(in: .northEast) == PointF(-0.5, 0.5))
        #expect(Point([0, 0]).corner(in: .southEast) == PointF(0.5, 0.5))
        #expect(Point([0, 0]).corner(in: .southWest) == PointF(0.5, -0.5))
        #expect(Point([0, 0]).corner(in: .northWest) == PointF(-0.5, -0.5))

        #expect(Point([0, 0]).corner(in: .southEast) == Point([1, 1]).corner(in: .northWest))
    }
}
