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
            return [0, -1]
        case .northEast:
            return [1, -1]
        case .east:
            return [1, 0]
        case .southEast:
            return [1, 1]
        case .south:
            return [0, 1]
        case .southWest:
            return [-1, 1]
        case .west:
            return [-1, 0]
        case .northWest:
            return [-1, -1]
        }
    }
}
