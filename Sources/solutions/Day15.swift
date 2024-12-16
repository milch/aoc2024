import Foundation
import Parsing

private enum Tile: String, CustomDebugStringConvertible, CaseIterable {
    case wall = "#"
    case floor = "."
    case robot = "@"
    case box = "O"

    var debugDescription: String {
        String(self.rawValue)
    }
}

private enum Instruction: String, CustomDebugStringConvertible, CaseIterable {
    case left = "<"
    case right = ">"
    case down = "v"
    case up = "^"

    var debugDescription: String {
        String(self.rawValue)
    }

    var direction: Direction {
        switch self {
        case .left:
            return .west
        case .right:
            return .east
        case .down:
            return .south
        case .up:
            return .north
        }
    }
}

private struct Day15Input {
    let map: [[Tile]]
    let instructions: [Instruction]
}

private struct Day15Parser: Parser {
    var body: some Parser<Substring, ([[Tile]], [Instruction])> {
        Many {
            Many {
                Tile.parser()
            }
        } separator: {
            "\n"
        }
        Many {
            Instruction.parser()
        } separator: {
            Optionally { "\n" }
        } terminator: {
            Optionally { "\n" }
        }
    }
}

private enum WideTile: String, CustomDebugStringConvertible, CaseIterable {
    case wall = "#"
    case floor = "."
    case robot = "@"
    case leftBox = "["
    case rightBox = "]"

    var debugDescription: String {
        String(self.rawValue)
    }

    static func from(tile: Tile) -> [Self] {
        switch tile {
        case .wall: return [.wall, .wall]
        case .floor: return [.floor, .floor]
        case .robot: return [.robot, .floor]
        case .box: return [.leftBox, .rightBox]
        }
    }
}

struct Day15: Solvable {
    private let map: [[Tile]]
    private let instructions: [Instruction]
    private let wideMap: [[WideTile]]

    init(input: String) {
        let input = try! Day15Parser().parse(input)
        self.map = input.0.dropLast(2)  // For some reason the parser parses the last two \n as empty lines
        self.instructions = input.1
        self.wideMap = map.map {
            $0.flatMap { WideTile.from(tile: $0) }
        }
    }

    func solvePart1() async -> Int {
        var map = self.map
        var robotPosition = map.points().first { $0.1 == .robot }!.0
        map[robotPosition.x][robotPosition.y] = .floor

        for instruction in instructions {
            let direction = instruction.direction
            let next = robotPosition &+ direction.vector
            switch map[next] {
            case .some(.floor): robotPosition = next
            case .some(.wall): continue
            case .none: continue
            case .some(.box):
                let line = map.line(from: next, in: direction)
                let firstNonBox = line.first { $0.1 != .box }
                switch firstNonBox?.1 {
                case .none: break
                case .some(.floor):
                    robotPosition = next
                    map[robotPosition.x][robotPosition.y] = .floor
                    map[firstNonBox!.0.x][firstNonBox!.0.y] = .box
                case .some(.wall): continue
                case .some(.robot), .some(.box): fatalError("Should not happen")
                }
            case .some(.robot): fatalError("Should not happen")
            }
        }
        map[robotPosition.x][robotPosition.y] = .robot

        let boxPositions = map.points().filter { $0.1 == .box }.map { $0.0 }
        return boxPositions.map { $0.x * 100 + $0.y }.reduce(0, +)
    }

    private func move(
        left: Point, right: Point, dir: Direction, map: [[WideTile]], pointsToMove: inout [Point]
    ) -> Bool {
        let northOfLeft = left &+ dir.vector
        let northOfRight = right &+ dir.vector
        switch (map[northOfLeft], map[northOfRight]) {
        case (nil, _), (_, nil), (.some(.wall), _), (_, .some(.wall)): return false
        case (.some(.floor), .some(.floor)):
            break
        case (.some(.floor), .some(.leftBox)):
            guard
                move(
                    left: northOfRight, right: northOfRight &+ Direction.east.vector, dir: dir,
                    map: map,
                    pointsToMove: &pointsToMove)
            else { return false }
        case (.some(.rightBox), .some(.floor)):
            guard
                move(
                    left: northOfLeft &+ Direction.west.vector, right: northOfLeft, dir: dir,
                    map: map,
                    pointsToMove: &pointsToMove)
            else { return false }
        case (.some(.rightBox), .some(.leftBox)):
            guard
                move(
                    left: northOfLeft &+ Direction.west.vector, right: northOfLeft, dir: dir,
                    map: map,
                    pointsToMove: &pointsToMove)
                    && move(
                        left: northOfRight, right: northOfRight &+ Direction.east.vector, dir: dir,
                        map: map,
                        pointsToMove: &pointsToMove)
            else { return false }
        case (.some(.leftBox), .some(.rightBox)):
            guard
                move(
                    left: northOfLeft, right: northOfRight, dir: dir, map: map,
                    pointsToMove: &pointsToMove)
            else { return false }
        case (.some(.robot), _), (_, .some(.robot)), (.some(.leftBox), .some(.leftBox)),
            (.some(.rightBox), .some(.rightBox)), (.some(.floor), .some(.rightBox)),
            (.some(.leftBox), .some(.floor)):
            fatalError("Should not happen")
        }

        pointsToMove.append(left)
        pointsToMove.append(right)
        return true
    }

    func solvePart2() async -> Int {
        var map = self.wideMap
        var robotPosition = map.points().first { $0.1 == .robot }!.0
        map[robotPosition.x][robotPosition.y] = .floor

        for instruction in instructions {
            let direction = instruction.direction
            let next = robotPosition &+ direction.vector
            switch map[next] {
            case .some(.floor): robotPosition = next
            case .some(.wall): continue
            case .none: continue
            case .some(.leftBox), .some(.rightBox):
                if instruction == .left || instruction == .right {
                    // Same logic as in part 1
                    let line = map.line(from: next, in: direction)
                    let firstNonBox = line.enumerated().first {
                        !($0.element.1 == .leftBox || $0.element.1 == .rightBox)
                    }
                    let firstNonBoxTile = firstNonBox?.element.1
                    switch firstNonBoxTile {
                    case .none: break
                    case .some(.floor):
                        robotPosition = next
                        map[robotPosition.x][robotPosition.y] = .floor
                        let newPositions = line.dropFirst().prefix(firstNonBox!.offset).sorted {
                            $0.0.y < $1.0.y
                        }
                        newPositions.enumerated().forEach {
                            (idx, element) in
                            map[element.0.x][element.0.y] =
                                idx % 2 == 0 ? .leftBox : .rightBox
                        }
                    case .some(.wall): continue
                    case .some(.robot), .some(.leftBox), .some(.rightBox):
                        fatalError("Should not happen")
                    }
                } else {
                    let leftSide =
                        map[next] == .some(.leftBox) ? next : next &+ Direction.west.vector
                    let rightSide = leftSide &+ Direction.east.vector
                    var boxPoints = [Point]()
                    if move(
                        left: leftSide, right: rightSide, dir: direction, map: map,
                        pointsToMove: &boxPoints)
                    {
                        let newPoints = boxPoints.map {
                            ($0 &+ direction.vector, map[$0]!)
                        }
                        boxPoints.forEach { pt in
                            map[pt.x][pt.y] = .floor
                        }
                        newPoints.forEach { (pt, tile) in
                            map[pt.x][pt.y] = tile
                        }
                        robotPosition = next
                        map[robotPosition.x][robotPosition.y] = .floor
                    }
                }
            case .some(.robot): fatalError("Should not happen")
            }
        }
        map[robotPosition.x][robotPosition.y] = .robot

        let boxPositions = map.points().filter { $0.1 == .leftBox }.map { $0.0 }
        return boxPositions.map { $0.x * 100 + $0.y }.reduce(0, +)
    }
}
