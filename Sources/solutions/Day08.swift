import Collections
import Foundation
import Parsing

private enum Antenna {
    case antenna(label: Character)
    case none

    init(label: Character) {
        if label == "." {
            self = .none
        } else {
            self = .antenna(label: label)
        }
    }

    var label: Character {
        switch self {
        case .antenna(let label): return label
        case .none: fatalError("Tried to access label of none antenna")
        }
    }

    var isAntenna: Bool {
        switch self {
        case .antenna: return true
        default: return false
        }
    }
}

struct Day08: Solvable {
    fileprivate let map: [[Antenna]]
    let antennaPositions: [Character: [Point]]

    init(input: String) {
        self.map = input.split(separator: "\n").map { $0.map { Antenna(label: $0) } }
        self.antennaPositions = Dictionary(
            grouping: map.points().filter { $1.isAntenna }, by: { $1.label }
        ).mapValues { $0.map { $0.0 } }
    }

    func computeAntinodes(_ antinodesForAntennae: ([Point]) -> [Point]) -> Set<Point> {
        let antinodes = antennaPositions.flatMap { (label, antennae) in
            antennae.combinations(of: 2).flatMap(antinodesForAntennae)
        }
        return Set(antinodes)
    }

    func solvePart1() async -> Int {
        computeAntinodes { (points) in
            let (a, b) = (points[0], points[1])
            let firstNode = b &- (a &- b)
            let secondNode = a &- (b &- a)
            return [firstNode, secondNode].filter { map.containsPoint($0) }
        }.count
    }

    func solvePart2() async -> Int {
        computeAntinodes { (points) in
            let (a, b) = (points[0], points[1])
            let bNodes = (0...).lazy.map { b &- $0 &* (a &- b) }.prefix {
                map.containsPoint($0)
            }
            let aNodes = (0...).lazy.map { a &- $0 &* (b &- a) }.prefix {
                map.containsPoint($0)
            }
            return aNodes + bNodes
        }.count
    }
}
