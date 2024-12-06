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
    case trace(Set<Position>)
    case loop
}

struct Day06: Solvable {
    let map: [[Tile]]
    let guardStartPosition: Point

    init(input: String) {
        self.map = try! MapParser().parse(input)
        self.guardStartPosition = self.map.points().first { $0.1 == .guard }!.0
    }

    func tracePath(start: Point, direction: Direction = .north, obstacleAt: Point? = nil)
        -> PathResult
    {
        var current = start
        var direction = direction.vector
        var seen = Set<Position>()

        outer: while true {
            let next = current &+ direction
            if seen.contains(
                Position(guardPosition: current, directionVector: direction))
            {
                return .loop
            }

            seen.insert(Position(guardPosition: current, directionVector: direction))
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

        return .trace(seen)
    }

    func solvePart1() -> Int {
        guard case let .trace(trace) = tracePath(start: guardStartPosition) else {
            fatalError("Unexpected loop in the path")
        }

        return Set(trace.map { $0.guardPosition }).count
    }

    func hasLoop(start: Point, extraObstacleAt: Point, direction: Direction = .north) -> Bool {
        let result = tracePath(start: start, obstacleAt: extraObstacleAt)
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
        let pathWithoutGuard = startingPath.filter { position in
            !(position.guardPosition == guardStartPosition
                && position.directionVector == Direction.north.vector)
        }
        let obstructionCandidates = Set(pathWithoutGuard.map { $0.guardPosition })
        return obstructionCandidates.filter {
            hasLoop(start: guardStartPosition, extraObstacleAt: $0)
        }
        .count
    }
}
