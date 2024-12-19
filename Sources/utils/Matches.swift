import Foundation

extension RandomAccessCollection where Element: Equatable {
    func matches<S: RandomAccessCollection>(prefix: S) -> Bool where S.Element == Element {
        guard prefix.count <= self.count else { return false }

        return prefix.enumerated().allSatisfy { (idx, element) in
            let valueIdx = self.index(self.startIndex, offsetBy: idx)

            return element == self[valueIdx]
        }
    }
}
