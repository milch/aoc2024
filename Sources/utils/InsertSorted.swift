extension RandomAccessCollection where Element: Comparable {
    fileprivate func binarySearch(for element: Element) -> (index: Index, isFound: Bool) {
        var low = startIndex
        var high = endIndex

        while low < high {
            let mid = index(low, offsetBy: distance(from: low, to: high) / 2)
            if self[mid] == element {
                return (mid, true)
            } else if self[mid] < element {
                low = index(after: mid)
            } else {
                high = mid
            }
        }
        return (low, false)
    }

    func insertionIndex(of element: Element) -> Index? {
        let binarySearchResult = binarySearch(for: element)
        return binarySearchResult.isFound
            ? index(after: binarySearchResult.index) : binarySearchResult.index
    }
}

extension Array where Element: Comparable {
    mutating func insertSorted(_ element: Element) {
        guard let index = insertionIndex(of: element) else { return }
        insert(element, at: index)
    }
}
