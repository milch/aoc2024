import Algorithms
import Foundation
import Parsing

private enum Operand {
    case literal(operand: UInt8)
    case combo(raw: UInt8)

    func value(registers: (a: Int, b: Int, c: Int)) -> Int {
        switch self {
        case .literal(let operand): return Int(operand)
        case .combo(let raw):
            switch raw {
            case 0, 1, 2, 3: return Int(raw)
            case 4: return registers.a
            case 5: return registers.b
            case 6: return registers.c
            case 7: fatalError("7 is reserved!")
            default: fatalError("Invalid opcode: \(raw)")
            }
        }
    }
}

private enum Opcode: UInt8, CaseIterable, CustomDebugStringConvertible {
    case adv = 0
    case bxl = 1
    case bst = 2
    case jnz = 3
    case bxc = 4
    case out = 5
    case bdv = 6
    case cdv = 7

    var debugDescription: String {
        switch self {
        case .adv: return "adv"
        case .bxl: return "bxl"
        case .bst: return "bst"
        case .jnz: return "jnz"
        case .bxc: return "bxc"
        case .out: return "out"
        case .bdv: return "bdv"
        case .cdv: return "cdv"
        }
    }
}

private enum ExecutionResult {
    case executing
    case output(Int)
    case halt
}

private struct Computer {
    var a: Int
    var b: Int
    var c: Int
    let instructions: [UInt8]

    var instructionPointer: UInt = 0

    mutating func executeCycle() -> ExecutionResult {
        guard instructions.indices.contains(Int(instructionPointer) + 1) else { return .halt }

        let instruction = Opcode(rawValue: instructions[Int(instructionPointer)])
        instructionPointer += 1
        let rawOperand = instructions[Int(instructionPointer)]
        instructionPointer += 1

        switch instruction {
        case .none: return .halt
        case .some(.adv):
            let operand = Operand.combo(raw: rawOperand)
            a = Int(Double(a) / pow(2.0, Double(operand.value(registers: (a: a, b: b, c: c)))))
        case .some(.bxl):
            let operand = Operand.literal(operand: rawOperand)
            b = b ^ operand.value(registers: (a: a, b: b, c: c))
        case .some(.bst):
            let operand = Operand.combo(raw: rawOperand)
            b = operand.value(registers: (a: a, b: b, c: c)) % 8
        case .some(.jnz):
            let operand = Operand.literal(operand: rawOperand)
            guard a != 0 else { return .executing }

            instructionPointer = UInt(operand.value(registers: (a: a, b: b, c: c)))
        case .some(.bxc):
            // ignores the operand
            b = b ^ c
        case .some(.out):
            let operand = Operand.combo(raw: rawOperand)
            let result = operand.value(registers: (a: a, b: b, c: c)) % 8
            return .output(result)
        case .some(.bdv):
            let operand = Operand.combo(raw: rawOperand)
            b = Int(Double(a) / pow(2.0, Double(operand.value(registers: (a: a, b: b, c: c)))))
        case .some(.cdv):
            let operand = Operand.combo(raw: rawOperand)
            c = Int(Double(a) / pow(2.0, Double(operand.value(registers: (a: a, b: b, c: c)))))
        }

        return .executing
    }

    init(a: Int, b: Int, c: Int, instructions: [UInt8]) {
        self.a = a
        self.b = b
        self.c = c
        self.instructions = instructions
    }
}

private struct Day17Parser: Parser {
    var body: some Parser<Substring, Computer> {
        Parse(Computer.init) {
            "Register A: "
            Int.parser()
            "\nRegister B: "
            Int.parser()
            "\nRegister C: "
            Int.parser()
            "\n\nProgram: "
            Many {
                UInt8.parser()
            } separator: {
                ","
            } terminator: {
                Optionally { "\n" }
            }

        }
    }
}

struct Day17: Solvable {
    private let computer: Computer

    init(input: String) {
        self.computer = try! Day17Parser().parse(input)
    }

    func runComputer(aRegister: Int? = nil) -> [Int] {
        var computer = self.computer
        computer.a = aRegister ?? computer.a

        var outputs = [Int]()
        loop: while true {
            let result = computer.executeCycle()
            switch result {
            case .executing: continue
            case .output(let output): outputs.append(output)
            case .halt: break loop
            }
        }
        return outputs
    }

    func solvePart1() async -> Int {
        // let outputs = runComputer()
        let outputs = runOptimized(a: computer.a)
        let str = outputs.map { String($0) }.joined(separator: ",")
        print("Outputs: \(str)")
        return 0
    }

    func runOptimized(a: Int) -> [Int] {
        var a = a
        var b = 0
        var c = 0
        var out = [Int]()
        while true {
            b = a % 8
            b = b ^ 1
            c = a / Int(pow(2.0, Double(b)))
            b = b ^ 5
            b = b ^ c
            out.append(b % 8)

            a /= 8
            if a == 0 {
                break
            }
        }
        return out
    }

    func b(a: Int) -> Int {
        var b = a % 8
        b = b ^ 1
        let c = a / Int(pow(2.0, Double(b)))
        b = b ^ 5
        b = b ^ c
        return b % 8
    }

    func solvePart2() async -> Int {
        return 0
    }
}
