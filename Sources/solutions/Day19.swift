import Collections
import Foundation
import Parsing

private enum StripeColor: String, CaseIterable, CustomDebugStringConvertible {
    case white = "w"
    case blue = "u"
    case black = "b"
    case red = "r"
    case green = "g"

    var debugDescription: String {
        self.rawValue
    }
}

private struct Day19Parser: Parser {
    var body: some Parser<Substring, ([[StripeColor]], [[StripeColor]])> {
        Many {
            Many {
                StripeColor.parser()
            }
        } separator: {
            ", "
        } terminator: {
            "\n\n"
        }
        Many {
            Many {
                StripeColor.parser()
            }
        } separator: {
            "\n"
        } terminator: {
            Optionally { "\n" }
        }
    }
}

extension RandomAccessCollection where Element == StripeColor {
    fileprivate func str() -> String {
        return self.map { $0.rawValue }.joined(separator: "")
    }
}

struct Day19: Solvable {
    private let availableTowels: [[StripeColor]]
    private let desiredPatterns: [[StripeColor]]

    private let availableTowelsByColor: [StripeColor: [[StripeColor]]]

    init(input: String) {
        let (availableTowels, desiredPatterns) = try! Day19Parser().parse(
            input.trimmingCharacters(in: .newlines))

        self.availableTowels = availableTowels
        self.desiredPatterns = desiredPatterns
        self.availableTowelsByColor = availableTowels.reduce(into: [:]) { map, towel in
            map[towel.first!, default: []].append(towel)
        }
    }

    func solvePart1() async -> Int {
        let canMake = desiredPatterns.filter { countOfWays(toArrange: $0) > 0 }

        return canMake.count
    }

    private var counts = Box([String: Int]())

    private func countOfWays<T: RandomAccessCollection>(toArrange pattern: T) -> Int
    where T.Element == StripeColor {
        guard pattern.count > 0 else { return 1 }
        guard counts.value[pattern.str()] == nil else { return counts.value[pattern.str()]! }

        let first = pattern.first!
        let matchingTowels = availableTowelsByColor[first, default: []]
        let count = matchingTowels.filter { pattern.matches(prefix: $0) }.map {
            1 * countOfWays(toArrange: pattern.dropFirst($0.count))
        }.reduce(0, +)
        counts.value[pattern.str()] = count
        return count
    }

    func solvePart2() async -> Int {
        return desiredPatterns.reduce(0) { $0 + countOfWays(toArrange: $1) }
    }
}
