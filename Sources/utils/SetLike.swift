protocol SetLike {
    associatedtype Element
    mutating func insert(_ element: Element) -> (inserted: Bool, memberAfterInsert: Element)
}

extension Set: SetLike {}
extension Box: SetLike where T: SetLike {
    func insert(_ element: T.Element) -> (inserted: Bool, memberAfterInsert: T.Element) {
        return value.insert(element)
    }
}
