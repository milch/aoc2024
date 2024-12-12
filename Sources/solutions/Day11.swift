import Collections
import Foundation
import Parsing

private struct Day11Parser: Parser {
    var body: some Parser<Substring, [UInt]> {
        Many {
            UInt.parser()
        } separator: {
            " "
        } terminator: {
            Optionally {
                "\n"
            }
        }
    }
}

struct Day11: Solvable {
    let stones: [UInt]
    let stonesByCount: [UInt: Int]

    init(input: String) {
        stones = try! Day11Parser().parse(input)
        stonesByCount = Dictionary(grouping: stones) { $0 }.mapValues { $0.count }
    }

    func tick(stones: [UInt: Int]) -> [UInt: Int] {
        var result = [UInt: Int]()
        for (stone, count) in stones {
            if stone == 0 {
                result[1, default: 0] += count
            } else if let digits = .some(stone.digitCount), digits % 2 == 0 {
                let leftHalf = stone.shiftTensPlace(by: -digits / 2)
                let zeroed = leftHalf.shiftTensPlace(by: digits / 2)
                let rightHalf = stone - zeroed

                result[leftHalf, default: 0] += count
                result[rightHalf, default: 0] += count
            } else {
                result[stone * 2024, default: 0] += count
            }
        }
        return result
    }

    func solve(forGenerations generations: Int) -> Int {
        let stones = (0..<generations).reduce(stonesByCount) { acc, i in
            return tick(stones: acc)
        }
        return stones.values.reduce(0) { $0 + $1 }
    }

    func solvePart1() async -> Int {
        return solve(forGenerations: 25)
    }

    func solvePart2() async -> Int {
        return solve(forGenerations: 75)
    }
}
