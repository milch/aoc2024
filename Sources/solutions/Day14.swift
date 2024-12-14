import Foundation
import Parsing

struct Robot {
    let position: Point
    let velocity: Point

    init(xPosition: Int, yPosition: Int, xVelocity: Int, yVelocity: Int) {
        self.position = Point(yPosition, xPosition)  // In 2DMath, y is the first parameter
        self.velocity = Point(yVelocity, xVelocity)
    }
}

struct Day14Parser: Parser {
    var body: some Parser<Substring, [Robot]> {
        Many {
            Parse(Robot.init) {
                "p="
                Int.parser()
                ","
                Int.parser()
                " v="
                Int.parser()
                ","
                Int.parser()
            }
        } separator: {
            "\n"
        } terminator: {
            Optionally { "\n" }
        }
    }
}

private func prettyPrint(robots: [Point], mapSize: Point) {
    for row in (0..<mapSize.x) {
        for col in (0..<mapSize.y) {
            let robotCount = robots.filter { $0.x == row && $0.y == col }.count
            if robotCount > 0 {
                print("\(robotCount)", terminator: "")
            } else {
                print(" ", terminator: "")
            }
        }
        print("")
    }
}

struct Day14: Solvable {
    let robots: [Robot]
    let mapSize: Point

    init(input: String) {
        self.init(input: input, mapSize: Point(103, 101))
    }

    init(input: String, mapSize: Point) {
        self.robots = try! Day14Parser().parse(input)
        self.mapSize = mapSize
    }

    func robotPositions(afterSteps movement: Int) -> [Point] {
        return robots.map { robot in
            let newPosition = (robot.position &+ movement &* robot.velocity) % mapSize
            return Point([
                newPosition.x >= 0 ? newPosition.x : mapSize.x + newPosition.x,
                newPosition.y >= 0 ? newPosition.y : mapSize.y + newPosition.y,
            ])
        }
    }

    func solvePart1() async -> Int {
        let afterMovement = robotPositions(afterSteps: 100)

        let byQuadrant = Dictionary(grouping: afterMovement) { pos in
            switch (
                pos.x < mapSize.x / 2, pos.y < mapSize.y / 2,
                pos.x == mapSize.x / 2 || pos.y == mapSize.y / 2
            ) {
            case (_, _, true): return "none"
            case (true, true, false): return "NW"
            case (true, false, false): return "NE"
            case (false, false, false): return "SE"
            case (false, true, false): return "SW"
            }
        }.mapValues { $0.count }
        return byQuadrant["NW", default: 0] * byQuadrant["NE", default: 0]
            * byQuadrant["SE", default: 0] * byQuadrant["SW", default: 0]
    }

    func solvePart2() async -> Int {
        for movement in 0..<11000 {  // It's on about an 11k periodic cycle
            let robotPositions = robotPositions(afterSteps: movement)

            var xCounts = Array(repeating: 0, count: mapSize.x)
            var yCounts = Array(repeating: 0, count: mapSize.y)
            for pos in robotPositions {
                xCounts[pos.x] += 1
                yCounts[pos.y] += 1
            }

            // Assume it has at least 2 rows and 2 columns as a frame
            if xCounts.count(where: { $0 > 28 }) > 1
                && yCounts.count(where: { $0 > 28 }) > 1
            {
                prettyPrint(robots: robotPositions, mapSize: mapSize)
                return movement
            }
        }
        return 0
    }
}
