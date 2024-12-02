import Foundation

struct Day01: Solvable {
    let parsed: [[Int]]
    var leftList: [Int] { return parsed[0] }
    var rightList: [Int] { return parsed[1] }

    init(input: String) {
        self.parsed = input.split(separator: "\n").reduce(into: [[], []]) {
            lists, line in
            let parts = line.split(separator: " ")

            lists[0].insertSorted(Int(parts[0])!)
            lists[1].insertSorted(Int(parts[1])!)
        }
    }

    func solvePart1() -> Int {
        let distances = zip(leftList, rightList).map { (left, right) in
            return abs(left - right)
        }
        return distances.reduce(0, +)
    }

    func countNumbers(in list: [Int]) -> [Int: Int] {
        return list.reduce(into: [:]) { counts, number in
            counts[number] = (counts[number] ?? 0) + 1
        }
    }

    func solvePart2() -> Int {
        let rightCounts = countNumbers(in: rightList)
        return leftList.reduce(0) { sum, left in
            sum + (rightCounts[left] ?? 0) * left
        }
    }
}
