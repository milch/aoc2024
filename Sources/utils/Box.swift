/// Enables reference semantics for an embedded value
final class Box<T> {
    var value: T

    init(_ value: T) {
        self.value = value
    }

    /// Functionally does the same as box.value but is more explicit
    func clone() -> T {
        return value
    }
}
