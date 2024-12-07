import Foundation
import Parsing

enum Tile: String, CaseIterable {
    case empty = "."
    case obstruction = "#"
    case `guard` = "^"
}

struct MapParser: Parser {
    var body: some Parser<Substring, [[Tile]]> {
        Many {
            Many {
                Tile.parser()
            }
        } separator: {
            "\n"
        }
    }
}

struct Position: Equatable, Hashable {
    let guardPosition: Point
    let directionVector: Point
}

enum PathResult {
    case trace([Point])
    case loop
}

struct Day06: Solvable {
    let map: [[Tile]]
    let guardStartPosition: Point
    /// Key: row, value: columns in that row for which there is an obstruction
    let obstructionsByRow: [Int: [Int]]
    /// Key: column, value: rows in that column for which there is an obstruction
    let obstructionsByColumn: [Int: [Int]]

    init(input: String) {
        self.map = try! MapParser().parse(input)
        self.guardStartPosition = self.map.points().first { $0.1 == .guard }!.0

        let obstructionLocations = self.map.points().filter { $1 == .obstruction }.map { $0.0 }
        self.obstructionsByRow = Dictionary(grouping: obstructionLocations, by: { $0.x }).mapValues
        {
            $0.map { $0.y }.sorted()
        }
        self.obstructionsByColumn = Dictionary(grouping: obstructionLocations, by: { $0.y })
            .mapValues {
                $0.map { $0.x }.sorted()
            }
    }

    func tracePath(
        start: Point, direction: Point = Direction.north.vector, obstacleAt: Point? = nil
    )
        -> PathResult
    {
        var current = start
        var direction = direction
        var seen = Set<Position>()
        var path = [Point]()

        outer: while true {
            let next = current &+ direction
            if seen.contains(
                Position(guardPosition: current, directionVector: direction))
            {
                return .loop
            }

            seen.insert(Position(guardPosition: current, directionVector: direction))
            path.append(current)
            let tile: Tile? =
                if let obstacleAt = obstacleAt, obstacleAt == next {
                    .some(.obstruction)
                } else {
                    self.map[next]
                }
            switch tile {
            case .none:
                break outer
            case .some(.guard), .some(.empty):
                // Continue the same direction
                current = next
                break
            case .some(.obstruction):
                direction = direction.rotated(by: -90)
                break
            }

        }

        return .trace(path)
    }

    func solvePart1() -> Int {
        guard case let .trace(trace) = tracePath(start: guardStartPosition) else {
            fatalError("Unexpected loop in the path")
        }

        return Set(trace).count
    }

    func hasLoop(start: Point, extraObstacleAt: Point, movement: Direction)
        -> Bool
    {
        var visited = Set<Position>()
        var current: Point? = start
        var direction = movement

        while let point = current {
            if !visited.insert(Position(guardPosition: point, directionVector: direction.vector))
                .inserted
            {
                return true
            }

            var obstructedRows = obstructionsByColumn[point.y] ?? []
            var obstructedColumns = obstructionsByRow[point.x] ?? []
            if extraObstacleAt.x == point.x {
                obstructedColumns.insertSorted(extraObstacleAt.y)
            }
            if extraObstacleAt.y == point.y {
                obstructedRows.insertSorted(extraObstacleAt.x)
            }

            switch direction {
            case .north:
                let obstructedRow = obstructedRows.last { $0 < point.x }
                guard let obstructedRow = obstructedRow else { return false }
                current = Point(x: obstructedRow + 1, y: point.y)
                direction = .east
            case .south:
                let obstructedRow = obstructedRows.first { $0 > point.x }
                guard let obstructionRow = obstructedRow else { return false }
                current = Point(x: obstructionRow - 1, y: point.y)
                direction = .west
            case .east:
                let obstructionColumn = obstructedColumns.first { $0 > point.y }
                guard let obstructionColumn = obstructionColumn else { return false }
                current = Point(x: point.x, y: obstructionColumn - 1)
                direction = .south
            case .west:
                let obstructionColumn = obstructedColumns.last { $0 < point.y }
                guard let obstructionColumn = obstructionColumn else { return false }
                current = Point(x: point.x, y: obstructionColumn + 1)
                direction = .north
            default: fatalError("Invalid direction")
            }
        }

        return false
    }

    func solvePart2() -> Int {
        guard case let .trace(startingPath) = tracePath(start: guardStartPosition) else {
            fatalError("Unexpected loop in the path")
        }

        var seen = Set<Point>()
        return zip(startingPath, startingPath.dropFirst()).filter {
            (previous, current) in
            let vector = current &- previous
            if !seen.insert(current).inserted {
                return false
            }

            return hasLoop(
                start: previous, extraObstacleAt: current,
                movement: vector.rotated(by: -90).equivalentDirection())
        }.count
    }
}
