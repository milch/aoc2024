extension Sequence where Element: Sendable {
    func concurrentFilter(_ condition: @Sendable @escaping (Element) async -> Bool) async
        -> [Element]
    {
        return await withTaskGroup(of: (Element, Bool).self) { group in
            // Add tasks for each element
            for element in self {
                group.addTask {
                    let result = await condition(element)
                    return (element, result)
                }
            }

            // Collect results
            var filteredElements = [Element]()
            for await (element, passed) in group {
                if passed {
                    filteredElements.append(element)
                }
            }
            return filteredElements
        }
    }
}
