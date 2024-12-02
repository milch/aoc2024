import Foundation

struct Day02: Solvable {
    let reports: [[Int]]

    init(input: String) {
        self.reports = input.split(separator: "\n").map { line in
            line.split(separator: " ").map { Int($0)! }
        }
    }

    private func isSafe<T>(level: T) -> Bool where T: Sequence, T.Element == Int {
        let diffs = zip(level, level.dropFirst()).map { $0.0 - $0.1 }
        return diffs.allSatisfy { (1...3).contains(abs($0)) }
            && (diffs.allSatisfy { $0 > 0 } || diffs.allSatisfy { $0 < 0 })
    }

    func solvePart1() -> Int {
        return reports.count { isSafe(level: $0) }
    }

    func solvePart2() -> Int {
        return reports.count { level in
            if isSafe(level: level) {
                return true
            }
            for idx in level.indices {
                var beforeIdx = level.prefix(upTo: idx)
                let afterIdx = level.suffix(from: idx + 1)
                beforeIdx.append(contentsOf: afterIdx)
                if isSafe(level: beforeIdx) {
                    return true
                }
            }
            return false
        }
    }
}
