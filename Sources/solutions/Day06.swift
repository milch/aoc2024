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

    init(input: String) {
        self.map = try! MapParser().parse(input)
        self.guardStartPosition = self.map.points().first { $0.1 == .guard }!.0
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

    func hasLoop(start: Point, extraObstacleAt: Point, movement: Point = Direction.north.vector)
        -> Bool
    {
        let result = tracePath(start: start, direction: movement, obstacleAt: extraObstacleAt)
        switch result {
        case .loop:
            return true
        case .trace:
            return false
        }
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
                movement: vector.rotated(by: -90))
        }.count
    }
}
