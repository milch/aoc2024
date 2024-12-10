enum NodeKind {
    case file
    case freeSpace
}

struct FilesSystemNode: CustomDebugStringConvertible, Hashable {
    let id: Int?
    let blocks: Int
    let kind: NodeKind

    var debugDescription: String {
        switch kind {
        case .file:
            let id = Character("\(id!)")
            return String(repeating: id, count: self.blocks)
        case .freeSpace:
            return String(repeating: ".", count: self.blocks)
        }
    }

    func hash(into hasher: inout Hasher) {
        id?.hash(into: &hasher)
    }

    func checksum(startingAt offset: Int) -> Int {
        (offset..<offset + blocks).reduce(0) {
            $0 + $1 * (id ?? 0)
        }
    }
}

extension Array where Element: Hashable {
    func filterDuplicates() -> [Element] {
        var seen = Set<Element>()
        return filter { seen.insert($0).inserted }
    }
}

extension Array where Element == FilesSystemNode {
    mutating func compactFree(aroundIndex: Int, freeSpaceList: inout [Int]) {
        let surrounds = (aroundIndex - 1..<aroundIndex + 2).clamped(
            to: freeSpaceList.indices)
        let contiguous = zip(surrounds, surrounds.dropFirst()).filter { (prev, next) in
            freeSpaceList[prev] == freeSpaceList[next] - 1
                // After inserting an index they could be equal
                || freeSpaceList[prev] == freeSpaceList[next]
        }.flatMap { [$0.0, $0.1] }.filterDuplicates()
        contiguous.dropFirst().reversed().forEach { listIdx in
            let fileSystemIdx = freeSpaceList.remove(at: listIdx)
            let removed = self.remove(at: fileSystemIdx)
            let first = self[freeSpaceList[contiguous[0]]]
            self[freeSpaceList[contiguous[0]]] = FilesSystemNode(
                id: nil, blocks: first.blocks + removed.blocks, kind: .freeSpace)
        }
        if contiguous.count > 0 {
            (contiguous.first! + 1..<freeSpaceList.endIndex).forEach { idx in
                freeSpaceList[idx] -= (contiguous.count - 1)
            }
        }
    }
}

struct Day09: Solvable {
    let fileSystem: [FilesSystemNode]

    init(input: String) {
        self.fileSystem = input.trimmingCharacters(in: .newlines).enumerated().map { (idx, char) in
            let blocks = Int(char.asciiValue! - Character("0").asciiValue!)
            let kind: NodeKind = idx % 2 == 0 ? .file : .freeSpace
            var id: Int? = nil
            if kind == .file {
                id = idx / 2
            }
            return FilesSystemNode(id: id, blocks: blocks, kind: kind)
        }
    }

    func computeChecksum(for fileSystem: [FilesSystemNode]) -> Int {
        fileSystem.reduce((startingOffset: 0, checksum: 0)) { (acc, node) in
            return (
                acc.startingOffset + node.blocks,
                acc.checksum + node.checksum(startingAt: acc.startingOffset)
            )
        }.checksum
    }

    func solvePart1() async -> Int {
        var fileSystem = self.fileSystem
        var lastFile = fileSystem.endIndex - 1
        var firstFreeSpace = 1

        while firstFreeSpace < lastFile {
            let freeSpace = fileSystem[firstFreeSpace]
            let file = fileSystem[lastFile]

            if freeSpace.blocks > file.blocks {
                fileSystem.remove(at: lastFile)
                fileSystem[firstFreeSpace] = FilesSystemNode(
                    id: nil, blocks: freeSpace.blocks - file.blocks, kind: .freeSpace)
                fileSystem.insert(file, at: firstFreeSpace)
                firstFreeSpace += 1
                lastFile -= 1
            } else if freeSpace.blocks == file.blocks {
                fileSystem.swapAt(lastFile, firstFreeSpace)
                firstFreeSpace += 2
                lastFile -= 2
            } else {
                fileSystem[firstFreeSpace] = FilesSystemNode(
                    id: file.id, blocks: freeSpace.blocks, kind: .file)
                fileSystem[lastFile] = FilesSystemNode(
                    id: file.id, blocks: file.blocks - freeSpace.blocks, kind: .file)
                firstFreeSpace += 2
            }
        }

        return computeChecksum(for: fileSystem)
    }

    func solvePart2() async -> Int {
        var fileSystem = self.fileSystem
        var freeSpaceList = fileSystem.enumerated().filter { $0.element.kind == .freeSpace }.map {
            $0.offset
        }
        var lastFile = fileSystem.endIndex - 1
        var moved = Set<FilesSystemNode>()

        while lastFile > 0 {
            let file = fileSystem[lastFile]
            guard moved.insert(file).inserted && file.kind == .file else {
                lastFile -= 1
                continue
            }

            var foundFreeSpace: (offset: Int, element: Int)? = nil
            for (freeSpaceListIdx, freeSpaceIdx) in freeSpaceList.enumerated() {
                guard freeSpaceList[freeSpaceListIdx] < lastFile else { break }
                let freeSpace = fileSystem[freeSpaceIdx]
                if freeSpace.blocks >= file.blocks {
                    foundFreeSpace = (offset: freeSpaceListIdx, element: freeSpaceIdx)
                    break
                }
            }

            guard let (offset: freeSpaceListIdx, element: freeSpaceIdx) = foundFreeSpace else {
                lastFile -= 1
                continue
            }

            let freeSpace = fileSystem[freeSpaceIdx]

            if freeSpace.blocks > file.blocks {
                fileSystem[lastFile] = FilesSystemNode(
                    id: nil, blocks: file.blocks, kind: .freeSpace)
                fileSystem[freeSpaceIdx] = FilesSystemNode(
                    id: nil, blocks: freeSpace.blocks - file.blocks, kind: .freeSpace)
                fileSystem.insert(file, at: freeSpaceIdx)

                fileSystem.compactFree(
                    aroundIndex: freeSpaceListIdx, freeSpaceList: &freeSpaceList)

                let insertIdx = freeSpaceList.insertSorted(lastFile)
                for freeSpaceIdx in (freeSpaceListIdx..<freeSpaceList.endIndex) {
                    guard freeSpaceList[freeSpaceIdx] <= lastFile else { break }
                    freeSpaceList[freeSpaceIdx] += 1
                }

                fileSystem.compactFree(
                    aroundIndex: insertIdx!,
                    freeSpaceList: &freeSpaceList)

            } else if freeSpace.blocks == file.blocks {
                fileSystem.swapAt(lastFile, freeSpaceIdx)
                freeSpaceList.remove(at: freeSpaceListIdx)
                let insertIdx = freeSpaceList.insertSorted(lastFile)

                fileSystem.compactFree(
                    aroundIndex: insertIdx!, freeSpaceList: &freeSpaceList)
            } else {
                fatalError("Should not happen")
            }

            lastFile -= 1
        }

        return computeChecksum(for: fileSystem)
    }
}
