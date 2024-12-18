import Collections
import Foundation
import Parsing

private enum Operator: String, CaseIterable {
    case add = "+"
    case multiply = "*"
    case concat = "||"

    func evaluate(lhs: Int, rhs: Int) -> Int {
        switch self {
        case .add:
            return lhs + rhs
        case .multiply:
            return lhs * rhs
        case .concat:
            return lhs.shiftTensPlace(by: rhs.digitCount) + rhs
        }
    }

    static var simpleOperators: [Operator] {
        [.add, .multiply]
    }
}

private struct Operation: Equatable, Comparable {
    static func < (lhs: Operation, rhs: Operation) -> Bool {
        lhs.intermediateResult < rhs.intermediateResult
    }

    let intermediateResult: Int
    let `operator`: Operator
    let nextItemIndex: Int
}

private struct Day07Parser: Parser {
    var body: some Parser<Substring, [(Int, [Int])]> {
        Many {
            Int.parser()
            ": "
            Many {
                Int.parser()
            } separator: {
                " "
            }
        } separator: {
            Whitespace(1, .vertical)
        } terminator: {
            Optionally {
                Whitespace(1, .vertical)
            }
        }
    }
}

struct Day07: Solvable {
    let equations: [(Int, [Int])]

    init(input: String) {
        self.equations = try! Day07Parser().parse(input)
    }

    fileprivate func findBalancingEquations(forOperators operators: [Operator]) -> [(
        Int, [Int]
    )] {
        return self.equations.filter { (expectedResult, values) in
            var heap = Heap<Operation>()
            heap.insert(
                contentsOf:
                    operators.map {
                        Operation(intermediateResult: values.first!, operator: $0, nextItemIndex: 1)
                    }
            )
            while !heap.isEmpty {
                let operation = heap.removeMax()
                let lhs = operation.intermediateResult
                let rhs = values[operation.nextItemIndex]
                let result = operation.operator.evaluate(lhs: lhs, rhs: rhs)
                if result > expectedResult { continue }

                if operation.nextItemIndex + 1 == values.count && result == expectedResult {
                    return true
                }
                guard operation.nextItemIndex + 1 < values.count else { continue }

                heap.insert(
                    contentsOf:
                        operators.map {
                            Operation(
                                intermediateResult: result, operator: $0,
                                nextItemIndex: operation.nextItemIndex + 1)
                        }
                )
            }

            return false
        }
    }

    func solvePart1() async -> Int {
        return findBalancingEquations(forOperators: Operator.simpleOperators).reduce(0) {
            $0 + $1.0
        }
    }

    func solvePart2() async -> Int {
        return findBalancingEquations(forOperators: Operator.allCases).reduce(0) {
            $0 + $1.0
        }
    }
}
