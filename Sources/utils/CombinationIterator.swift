extension RandomAccessCollection {
    func combinations(of size: Int) -> CombinationIterator<Self> {
        guard size > 1 else { fatalError("Can't create combinations for sizes <= 1") }

        return CombinationIterator(base: self, size: size)
    }
}

struct CombinationIterator<Base: RandomAccessCollection>: IteratorProtocol, Sequence {
    typealias Element = [Base.Element]

    private var base: Base
    private var indices: [Base.Index]
    private let combinationSize: Int

    init(base: Base, size: Int) {
        self.base = base
        self.combinationSize = size
        self.indices = Array(repeating: base.startIndex, count: size)
        for i in 0..<size {
            indices[i] = base.index(indices[i], offsetBy: i)
        }
    }

    mutating func next() -> Element? {
        defer {
            indices[combinationSize - 1] = base.index(
                after: indices[combinationSize - 1])

            var i = combinationSize - 2
            while indices[combinationSize - 1] == base.endIndex && i >= 0 {
                indices[i] = base.index(after: indices[i])
                for j in i + 1..<combinationSize {
                    indices[j] = base.index(indices[j - 1], offsetBy: 1)
                }
                i -= 1
            }
        }

        var result = [Base.Element]()
        for index in indices {
            if index < base.endIndex {
                result.append(base[index])
            } else {
                return nil
            }
        }

        return result
    }
}
