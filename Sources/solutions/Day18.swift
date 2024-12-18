import Collections
import Foundation
import Parsing

private struct CoordinateParser: Parser {
    var body: some Parser<Substring, (Int, Int)> {
        Int.parser()
        ","
        Int.parser()
    }
}

private struct Day18Parser: Parser {
    var body: some Parser<Substring, [(Int, Int)]> {
        Many {
            CoordinateParser()
        } separator: {
            "\n"
        } terminator: {
            Optionally { "\n" }

        }
    }
}

private enum Tile: CustomDebugStringConvertible {
    case floor
    case obstacle

    var debugDescription: String {
        switch self {
        case .floor: return "."
        case .obstacle: return "#"
        }
    }
}

private struct Path: Comparable, Equatable {
    static func < (lhs: Path, rhs: Path) -> Bool {
        lhs.cost < rhs.cost
    }

    static func == (lhs: Path, rhs: Path) -> Bool {
        lhs.point == rhs.point
    }

    let point: Point
    let endPoint: Point
    let cost: Int

    var estimatedRemainingCost: Int {
        return (point &- endPoint).magnitude
    }

    func neighbors(in map: [[Tile]]) -> [Path] {
        let neighborPoints = Direction.allCardinal.map { self.point &+ $0.vector }.filter {
            map[$0] == .some(.floor)
        }
        return neighborPoints.map {
            Path(point: $0, endPoint: self.endPoint, cost: self.cost + 1)
        }
    }
}

struct Day18: Solvable {
    private let fallingBytes: [Point]
    private let mapSize: Int
    private let numFallenBytes: Int

    init(input: String) {
        self.init(input: input, mapSize: 70, numFallenBytes: 1024)
    }

    init(input: String, mapSize: Int, numFallenBytes: Int) {
        self.fallingBytes = try! Day18Parser().parse(input).map { (x, y) in Point(y, x) }
        self.mapSize = mapSize + 1
        self.numFallenBytes = numFallenBytes
    }

    private func path(through map: [[Tile]]) -> (Path, [Point])? {
        var heap = Heap([
            Path(point: Point(0, 0), endPoint: Point(mapSize - 1, mapSize - 1), cost: 0)
        ])

        var cheapestPath: [Point: Int] = [:]
        var previousNode: [Point: Point] = [:]

        var path: Path? = nil
        while !heap.isEmpty {
            let current = heap.removeMin()
            if current.point == Point(mapSize - 1, mapSize - 1) {
                path = current
                break
            }

            current.neighbors(in: map).forEach { neighbor in
                if neighbor.cost < cheapestPath[neighbor.point, default: Int.max] {
                    heap.insert(neighbor)
                    cheapestPath[neighbor.point] = neighbor.cost
                    previousNode[neighbor.point] = current.point
                }
            }
        }

        guard let path = path else { return nil }

        let points: [Point] = Array(unsafeUninitializedCapacity: path.cost) { (buffer, count) in
            var idx = path.cost - 1
            var current: Point? = path.point
            while let prev = previousNode[current!] {
                buffer[idx] = prev
                current = prev
                idx -= 1
                if prev == Point(0, 0) {
                    break
                }
            }
            count = path.cost - idx - 1
        }

        return (path, points)
    }

    func solvePart1() async -> Int {
        var map = Array(repeating: Array(repeating: Tile.floor, count: mapSize), count: mapSize)
        self.fallingBytes.prefix(numFallenBytes).forEach { pt in
            map[pt.x][pt.y] = .obstacle
        }

        return path(through: map)!.0.cost
    }

    func solvePart2() async -> Int {
        var map = Array(repeating: Array(repeating: Tile.floor, count: mapSize), count: mapSize)
        self.fallingBytes.prefix(numFallenBytes).forEach { pt in
            map[pt.x][pt.y] = .obstacle
        }

        var low = numFallenBytes
        var high = fallingBytes.count - 1
        var mid = low + (high - low) / 2

        while low < high {
            var newMap = map
            (numFallenBytes...mid).forEach { toSet in
                newMap[fallingBytes[toSet].x][fallingBytes[toSet].y] = .obstacle
            }

            if path(through: newMap) != nil {
                low = mid + 1
            } else {
                high = mid
            }
            mid = low + (high - low) / 2
        }
        let problemCoordinate = fallingBytes[mid]

        print("Coordinate: \(problemCoordinate.y),\(problemCoordinate.x)")
        return problemCoordinate.y * mapSize + problemCoordinate.x
    }
}
