// The Swift Programming Language
// https://docs.swift.org/swift-book
//
// Swift Argument Parser
// https://swiftpackageindex.com/apple/swift-argument-parser/documentation

import ArgumentParser
import Foundation

protocol Solvable {
    init(input: String)
    func solvePart1() -> Int
    func solvePart2() -> Int
}

extension Solvable {
    func solvePart1() -> Int {
        return 0
    }

    func solvePart2() -> Int {
        return 0
    }
}

@main
struct aoc2024: ParsableCommand {
    @Option(name: .shortAndLong, help: "Day number")
    var day: Int

    private func getSolver(for day: Int) -> Solvable.Type? {
        let solvers: [Int: Solvable.Type] = [
            1: Day01.self,
            2: Day02.self,
        ]
        return solvers[day]
    }

    private func readInput(for day: Int) -> String {
        let inputFileName = String(format: "./inputs/input_%02d.txt", day)
        return try! String(contentsOfFile: inputFileName, encoding: .utf8)
    }

    mutating func run() throws {
        guard let solverType = getSolver(for: day) else {
            print("\(day) not implemented yet")
            return
        }

        let input = readInput(for: day)
        let solver = solverType.init(input: input)
        let part1Result = solver.solvePart1()
        let part2Result = solver.solvePart2()

        print("Day \(day) Part 1: \(part1Result)")
        print("Day \(day) Part 2: \(part2Result)")
    }
}
