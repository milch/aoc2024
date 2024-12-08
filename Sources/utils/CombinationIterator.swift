extension Array {
    func combinationsOfTwo() -> CombinationIterator<Self> {
        CombinationIterator(base: self)
    }
}

struct CombinationIterator<Base: RandomAccessCollection>: IteratorProtocol, Sequence {
    typealias Element = (Base.Element, Base.Element)

    private var base: Base
    private var leftIndex: Base.Index
    private var rightIndex: Base.Index

    init(base: Base) {
        self.base = base
        self.leftIndex = base.startIndex
        self.rightIndex = base.index(after: base.startIndex)
    }

    mutating func next() -> Element? {
        guard leftIndex < base.endIndex else { return nil }
        guard rightIndex < base.endIndex else { return nil }

        let left = base[leftIndex]
        let right = base[rightIndex]
        rightIndex = base.index(after: rightIndex)
        if rightIndex == base.endIndex {
            leftIndex = base.index(after: leftIndex)
            rightIndex = base.index(after: leftIndex)
        }
        return (left, right)
    }
}
