import Foundation
import Parsing

struct OrderParser: Parser {
    var body: some Parser<Substring, [(Int, Int)]> {
        Many {
            Int.parser()
            "|"
            Int.parser()
        } separator: {
            "\n"
        }
    }
}

struct PrintJobParser: Parser {
    var body: some Parser<Substring, [[Int]]> {
        Many {
            Many {
                Int.parser()
            } separator: {
                ","
            }
        } separator: {
            "\n"
        }
    }
}

struct Day05Input {
    // before - must be printed before after
    let order: [(before: Int, after: Int)]
    let printJobs: [[Int]]

    init(_ order: [(Int, Int)], printJobs: [[Int]]) {
        self.order = order
        self.printJobs = printJobs
    }
}

struct Day05Parser: Parser {
    var body: some Parser<Substring, Day05Input> {
        Parse(Day05Input.init) {
            OrderParser()
            "\n"
            "\n"
            PrintJobParser()
        }
    }
}

extension Array where Index == Int {
    var mid: Element? {
        guard count > 0 else { return nil }
        return self[(count - 1) / 2]
    }
}

struct Day05: Solvable {
    let input: Day05Input
    let mustAfter: [Int: [Int]]

    init(input: String) {
        self.input = try! Day05Parser().parse(input)
        self.mustAfter = Dictionary(grouping: self.input.order, by: { $0.after }).mapValues {
            $0.map { $0.before }
        }
    }

    func isValidPrintJob(_ printJob: [Int]) -> Bool {
        var seen = Set<Int>()
        let dependencies = self.dependencies(for: printJob)
        for num in printJob {
            seen.insert(num)
            guard let deps = dependencies[num] else { continue }
            if !deps.allSatisfy(seen.contains) {
                return false
            }
        }
        return true
    }

    func solvePart1() -> Int {
        return input.printJobs.filter { isValidPrintJob($0) }.map {
            $0.mid ?? 0
        }.reduce(0, +)
    }

    func topologicalSort(_ array: [Int]) -> [Int] {
        let dependents = self.dependents(for: array)
        let dependencies = self.dependencies(for: array)
        var numDependencies = dependencies.mapValues { $0.count }

        var queue = array.filter { numDependencies[$0, default: 0] == 0 }
        var sortedArray = [Int]()

        while !queue.isEmpty {
            let current = queue.removeFirst()
            sortedArray.append(current)

            for node in dependents[current, default: []] {
                numDependencies[node]! -= 1

                if numDependencies[node] == 0 {
                    queue.append(node)
                }
            }
        }
        return sortedArray
    }

    func solvePart2() -> Int {
        let incorrectPrintJobs = input.printJobs.filter { !isValidPrintJob($0) }
        let correctedPrintJobs = incorrectPrintJobs.map { topologicalSort($0) }
        return correctedPrintJobs.map {
            $0.mid ?? 0
        }.reduce(0, +)
    }
}

// Helpers for getting the dependencies and dependents of a print job
extension Day05 {
    func printRules(for printJob: [Int]) -> [(before: Int, after: Int)] {
        return input.order.filter {
            printJob.contains($0.after) && printJob.contains($0.before)
        }
    }

    func dependents(for printJob: [Int]) -> [Int: [Int]] {
        return Dictionary(grouping: printRules(for: printJob), by: { $0.before }).mapValues {
            $0.map { $0.after }
        }
    }

    func dependencies(for printJob: [Int]) -> [Int: [Int]] {
        return Dictionary(grouping: printRules(for: printJob), by: { $0.after }).mapValues {
            $0.map { $0.before }
        }
    }
}
