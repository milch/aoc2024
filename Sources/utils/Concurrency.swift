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

    func concurrentMap<T>(_ transform: @Sendable @escaping (Element) async -> T) async -> [T]
    where T: Sendable {
        return await withTaskGroup(of: T.self) { group in
            // Add tasks for each element
            for element in self {
                group.addTask {
                    let result = await transform(element)
                    return result
                }
            }

            // Collect results
            var transformedElements = [T]()
            for await transformedElement in group {
                transformedElements.append(transformedElement)
            }
            return transformedElements
        }
    }
}
