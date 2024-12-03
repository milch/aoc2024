import Foundation
import Parsing

enum InstructionLabel: String, CaseIterable {
    case mul = "mul"
    case disable = "don't"
    case enable = "do"
}

struct Instruction: CustomDebugStringConvertible {
    let label: InstructionLabel
    let lhs: Int?
    let rhs: Int?
    var debugDescription: String {
        if let lhs = lhs, let rhs = rhs {
            return "\(label)(\(lhs),\(rhs))"
        } else {
            return "\(label)"
        }
    }

    func evaluate() -> Int {
        switch self.label {
        // noop so part 1 continues working
        case .enable:
            return 0
        case .disable:
            return 0
        case .mul:
            return lhs! * rhs!
        }
    }

    init(_ label: InstructionLabel, operands: (Int, Int)? = nil) {
        self.label = label
        self.lhs = operands?.0
        self.rhs = operands?.1
    }
}

struct InstructionParser: Parser {
    var body: some Parser<Substring, Instruction> {
        Parse(Instruction.init) {
            InstructionLabel.parser()
            Optionally {
                "("
                Int.parser()
                ","
                Int.parser()
                ")"
            }
        }

    }
}

struct Day03: Solvable {
    let instructions: [Instruction]

    init(input: String) {
        var instructions: [Instruction] = []
        var remainingInput = input
        while let range = remainingInput.range(
            of: "mul\\([0-9]+,[0-9]+\\)|don't|do", options: .regularExpression)
        {
            let match = String(remainingInput[range])
            remainingInput = String(remainingInput[range.upperBound...])

            do {
                let parsedResult = try InstructionParser().parse(match)
                instructions.append(parsedResult)
            } catch {
                // Silently ignore parsing errors
                continue
            }
        }
        self.instructions = instructions
    }

    func solvePart1() -> Int {
        return instructions.reduce(0) { sum, instruction in
            return sum + instruction.evaluate()
        }
    }

    func solvePart2() -> Int {
        let (_, sum) = instructions.reduce((isEnabled: true, sum: 0)) { result, instruction in
            switch instruction.label {
            case .enable:
                return (true, result.sum)
            case .disable:
                return (false, result.sum)
            case .mul:
                if result.isEnabled {
                    return (true, result.sum + instruction.evaluate())
                } else {
                    return (false, result.sum)
                }
            }
        }
        return sum
    }
}
