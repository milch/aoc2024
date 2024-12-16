import Collections
import Foundation
import Parsing

private enum Tile: String, CustomDebugStringConvertible, CaseIterable {
    case wall = "#"
    case floor = "."
    case start = "S"
    case end = "E"

    var debugDescription: String {
        self.rawValue
    }
}

private struct Day16Parser: Parser {
    var body: some Parser<Substring, [[Tile]]> {
        Many {
            Many {
                Tile.parser()
            }
        } separator: {
            "\n"
        } terminator: {
            Optionally { "\n" }
        }
    }
}

private struct Path: Equatable, Comparable {
    static func == (lhs: Path, rhs: Path) -> Bool {
        lhs.current == rhs.current && lhs.facing == rhs.facing && lhs.costSoFar == rhs.costSoFar
    }

    static func < (lhs: Path, rhs: Path) -> Bool {
        lhs.costSoFar < rhs.costSoFar
    }

    let current: Point
    let facing: Point
    let turnsSoFar: Int
    let movesSoFar: Int
    let seen: Box<Set<Point>>

    var costSoFar: Int {
        turnsSoFar * 1000 + movesSoFar
    }

    func neighbors(in map: [[Tile]]) -> [(next: Point, dir: Point, turns: Int, moves: Int)] {
        return [
            (next: self.current &+ self.facing, dir: self.facing, turns: 0, moves: 1),
            (next: self.current, dir: self.facing.rotated(by: 90), turns: 1, moves: 0),
            (next: self.current, dir: self.facing.rotated(by: -90), turns: 1, moves: 0),
        ].filter { map[$0.0] != nil && map[$0.0] != .some(.wall) }
    }
}

private struct DirectionalPoint: Equatable, Hashable {
    let startPoint: Point
    let facing: Point
}

struct Day16: Solvable {
    private let map: [[Tile]]
    let startPoint: Point
    let endPoint: Point
    private let costMaps = Box([Point: [DirectionalPoint: Int]]())

    init(input: String) {
        map = try! Day16Parser().parse(input)
        startPoint = map.points().first { $0.1 == .start }!.0
        endPoint = map.points().first { $0.1 == .end }!.0
    }

    private func computeCosts(endingAt endPoint: Point) -> [DirectionalPoint: Int] {
        if let costMap = costMaps.value[endPoint] { return costMap }

        var costToReachEnd = [DirectionalPoint: Int]()

        var heap = Heap<Path>(
            Direction.allCardinal.filter { map[endPoint &+ $0.vector] != .some(.wall) }.map {
                Path(
                    current: endPoint, facing: $0.vector, turnsSoFar: 0, movesSoFar: 0,
                    seen: Box(Set()))
            })

        while !heap.isEmpty {
            let path = heap.removeMin()
            let startFromHere = DirectionalPoint(
                startPoint: path.current,
                facing: path.facing.rotated(by: 180))
            guard path.costSoFar <= costToReachEnd[startFromHere, default: Int.max] else {
                continue
            }

            costToReachEnd[startFromHere] = path.costSoFar

            let directions = path.neighbors(in: map)

            for (next, dir, turns, moves) in directions {
                heap.insert(
                    Path(
                        current: next, facing: dir,
                        turnsSoFar: path.turnsSoFar + turns, movesSoFar: path.movesSoFar + moves,
                        seen: path.seen)
                )
            }
        }

        costMaps.value[endPoint] = costToReachEnd

        return costToReachEnd
    }

    func solvePart1() async -> Int {
        let costMap = computeCosts(endingAt: endPoint)

        return costMap[
            DirectionalPoint(startPoint: startPoint, facing: Direction.east.vector), default: 0]
    }

    func solvePart2() async -> Int {
        let costsToReachEnd = computeCosts(endingAt: endPoint)
        let bestPathCost = costsToReachEnd[
            DirectionalPoint(startPoint: startPoint, facing: Direction.east.vector)]!

        var tiles = Set<Point>()

        var deque = Deque<Path>([
            Path(
                current: startPoint, facing: Direction.east.vector, turnsSoFar: 0, movesSoFar: 0,
                seen: Box(Set()))
        ])

        while !deque.isEmpty {
            let path = deque.removeFirst()
            let startFromHere = DirectionalPoint(
                startPoint: path.current,
                facing: path.facing)
            guard path.costSoFar + costsToReachEnd[startFromHere, default: Int.max] <= bestPathCost
            else {
                continue
            }
            path.seen.insert(path.current)

            if path.current == endPoint {
                tiles.formUnion(path.seen.value)
            }

            let directions = path.neighbors(in: map)

            for (next, dir, turns, moves) in directions {
                deque.append(
                    Path(
                        current: next, facing: dir,
                        turnsSoFar: path.turnsSoFar + turns, movesSoFar: path.movesSoFar + moves,
                        seen: directions.count == 1 ? path.seen : Box(path.seen.clone()))
                )
            }
        }

        return tiles.count
    }
}
