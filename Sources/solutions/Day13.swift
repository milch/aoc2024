import Collections
import Foundation
import Parsing

struct ClawMachineConfiguration {
    let aButtonVector: Point
    let bButtonVector: Point
    let prizeLocation: Point
}

private func vector(xSign: Substring, x: Int, ySign: Substring, y: Int) -> Point {
    let xSign = xSign == "+" ? 1 : -1
    let ySign = ySign == "+" ? 1 : -1
    return Point(x * xSign, y * ySign)
}

private struct VectorParser: Parser {
    var body: some Parser<Substring, Point> {
        Parse(vector) {
            "X"
            CharacterSet.init(charactersIn: "+-")
            Int.parser()
            ", "
            "Y"
            CharacterSet.init(charactersIn: "+-")
            Int.parser()
        }
    }
}

private func point(x: Int, y: Int) -> Point {
    Point(x, y)
}

private struct PointParser: Parser {
    var body: some Parser<Substring, Point> {
        Parse(point) {
            "X="
            Int.parser()
            ", "
            "Y="
            Int.parser()
        }
    }
}

struct Day13Parser: Parser {
    var body: some Parser<Substring, [ClawMachineConfiguration]> {
        Many {
            Parse(ClawMachineConfiguration.init) {
                "Button A: "
                VectorParser()
                "\n"
                "Button B: "
                VectorParser()
                "\n"
                "Prize: "
                PointParser()
            }
        } separator: {
            "\n\n"
        } terminator: {
            Optionally { "\n" }
        }
    }
}

struct ClawMachinePresses {
    let totalAPresses: Int
    let totalBPresses: Int
}

struct Day13: Solvable {
    let clawMachines: [ClawMachineConfiguration]

    init(input: String) {
        self.clawMachines = try! Day13Parser().parse(input)
    }

    func solvePart1() async -> Int {
        return clawMachines.compactMap {
            solve2DLinearEquations(
                one: (x: $0.aButtonVector.x, y: $0.bButtonVector.x, equals: $0.prizeLocation.x),
                two: (x: $0.aButtonVector.y, y: $0.bButtonVector.y, equals: $0.prizeLocation.y)
            ).map { $0.a * 3 + $0.b }
        }.reduce(0, +)
    }

    func solvePart2() async -> Int {
        return clawMachines.compactMap {
            solve2DLinearEquations(
                one: (
                    x: $0.aButtonVector.x, y: $0.bButtonVector.x,
                    equals: $0.prizeLocation.x + 10_000_000_000_000
                ),
                two: (
                    x: $0.aButtonVector.y, y: $0.bButtonVector.y,
                    equals: $0.prizeLocation.y + 10_000_000_000_000
                )
            ).map { $0.a * 3 + $0.b }
        }.reduce(0, +)
    }
}
