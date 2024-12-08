import simd

typealias Point = SIMD2<Int>

func safeGet<T: RandomAccessCollection>(_ array: T, _ index: Point) -> T.Element.Element?
where T.Index == Int, T.Element: RandomAccessCollection, T.Element.Index == Int {
    if !array.indices.contains(index.x) { return nil }
    let row = array[index.x]
    return row.indices.contains(index.y) ? row[index.y] : nil
}

extension Array where Element: RandomAccessCollection, Element.Index == Int {
    subscript(_ index: Point) -> Element.Element? {
        if !indices.contains(index.x) { return nil }
        let row = self[index.x]
        return row.indices.contains(index.y) ? row[index.y] : nil
    }

    func points() -> PointsIterator<Self> {
        PointsIterator(self)
    }

    func containsPoint(_ point: Point) -> Bool {
        indices.contains(point.x) && self[point.x].indices.contains(point.y)
    }
}

struct PointsIterator<T: RandomAccessCollection>: IteratorProtocol, Sequence
where T.Index == Int, T.Element: RandomAccessCollection, T.Element.Index == Int {
    let grid: T
    var currentPoint: Point

    init(_ grid: T) {
        self.grid = grid
        self.currentPoint = [0, 0]
    }

    mutating func next() -> (Point, T.Element.Element)? {
        defer {
            currentPoint.y += 1
            if grid.indices.contains(currentPoint.x)
                && currentPoint.y >= grid[currentPoint.x].endIndex
            {
                currentPoint.y = 0
                currentPoint.x += 1
            }
        }

        if let element = safeGet(grid, currentPoint) {
            return (currentPoint, element)
        }
        return nil
    }
}

enum Direction: CaseIterable {
    case north, northEast, east, southEast, south, southWest, west, northWest

    var vector: Point {
        switch self {
        case .north:
            return [-1, 0]
        case .northEast:
            return [-1, 1]
        case .east:
            return [0, 1]
        case .southEast:
            return [1, 1]
        case .south:
            return [1, 0]
        case .southWest:
            return [1, -1]
        case .west:
            return [0, -1]
        case .northWest:
            return [-1, -1]
        }
    }
}

extension Point {
    func rotated(by degrees: Float) -> Point {
        let radians = degrees * .pi / 180
        let cos: Float = cos(radians)
        let sin: Float = sin(radians)
        let x = Float(self.x) * cos - Float(self.y) * sin
        let y = Float(self.x) * sin + Float(self.y) * cos
        return Point(Int(x.rounded()), Int(y.rounded()))
    }

    func equivalentDirection() -> Direction {
        switch (self.x, self.y) {
        case (-1, 0):
            return .north
        case (-1, 1):
            return .northEast
        case (0, 1):
            return .east
        case (1, 1):
            return .southEast
        case (1, 0):
            return .south
        case (1, -1):
            return .southWest
        case (0, -1):
            return .west
        case (-1, -1):
            return .northWest
        default:
            fatalError("Invalid vector for conversion to direction: \(self)")
        }
    }

    var magnitude: Int {
        return Int(sqrt(Float(self.x * self.x + self.y * self.y)).rounded())
    }
}
