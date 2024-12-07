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
            let shiftBy = Int(pow(10, log10(Double(rhs)).rounded(.down) + 1))
            return shiftBy * lhs + rhs
        }
    }

    static var simpleOperators: [Operator] {
        [.add, .multiply]
    }
}

private struct Operation: Equatable {
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

    fileprivate func findBalancingEquations(forOperators operators: [Operator]) -> [(Int, [Int])] {
        return self.equations.filter { (expectedResult, values) in
            var queue = [Operation]()
            operators.forEach {
                queue.append(
                    Operation(intermediateResult: values.first!, operator: $0, nextItemIndex: 1)
                )
            }
            while !queue.isEmpty {
                let operation = queue.removeFirst()
                let lhs = operation.intermediateResult
                let rhs = values[operation.nextItemIndex]
                let result = operation.operator.evaluate(lhs: lhs, rhs: rhs)
                if result > expectedResult { continue }

                if operation.nextItemIndex + 1 == values.count && result == expectedResult {
                    return true
                }
                guard operation.nextItemIndex + 1 < values.count else { continue }

                operators.forEach {
                    queue.append(
                        Operation(
                            intermediateResult: result, operator: $0,
                            nextItemIndex: operation.nextItemIndex + 1))
                }
            }

            return false
        }
    }

    func solvePart1() -> Int {
        return findBalancingEquations(forOperators: Operator.simpleOperators).reduce(0) {
            $0 + $1.0
        }
    }

    func solvePart2() -> Int {
        return findBalancingEquations(forOperators: Operator.allCases).reduce(0) {
            $0 + $1.0
        }
    }
}
