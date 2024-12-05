import Foundation
import Parsing

enum Label: String, CaseIterable {
    case x = "X"
    case m = "M"
    case a = "A"
    case s = "S"
}

struct Day04Parser: Parser {
    var body: some Parser<Substring, [[Label]]> {
        Many {
            Many(into: [Label]()) {
                $0.append($1)
            } element: {
                Label.parser()
            }
        } separator: {
            "\n"
        }
    }
}

struct Day04: Solvable {
    let grid: [[Label]]

    init(input: String) {
        self.grid = try! Day04Parser().parse(input)
    }

    func solvePart1() -> Int {
        var count = 0
        for (start, label) in grid.points() {
            if label == .x {
                Direction.allCases.forEach { direction in
                    let mMaybe = grid[start &+ direction.vector]
                    let aMaybe = grid[start &+ 2 &* direction.vector]
                    let sMaybe = grid[start &+ 3 &* direction.vector]
                    if mMaybe == .some(.m) && aMaybe == .some(.a) && sMaybe == .some(.s) {
                        count += 1
                    }
                }
            }
        }
        return count
    }

    func solvePart2() -> Int {
        var count = 0
        for (start, label) in grid.points() {
            if label == .a {
                let topRight = grid[start &+ Direction.northEast.vector]
                let bottomLeft = grid[start &+ Direction.southWest.vector]
                let bottomRight = grid[start &+ Direction.southEast.vector]
                let topLeft = grid[start &+ Direction.northWest.vector]

                switch (topRight, bottomLeft, topLeft, bottomRight) {
                case (.some(.m), .some(.s), .some(.m), .some(.s)):
                    count += 1
                case (.some(.s), .some(.m), .some(.m), .some(.s)):
                    count += 1
                case (.some(.s), .some(.m), .some(.s), .some(.m)):
                    count += 1
                case (.some(.m), .some(.s), .some(.s), .some(.m)):
                    count += 1
                default:
                    break
                }
            }
        }
        return count
    }
}
