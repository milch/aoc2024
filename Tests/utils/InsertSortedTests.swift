import Testing

@testable import aoc2024

@Suite struct InsertSortedTests {
    @Test func testInsertionIndexEmptyArray() {
        let testArray: [Int] = []
        #expect(testArray.insertionIndex(of: 1) == 0)
    }

    @Test func testInsertionIndexSingleElementEqual() {
        let testArray: [Int] = [1]
        #expect(testArray.insertionIndex(of: 1) == 1)
    }

    @Test func testInsertionIndexSingleElementGreater() {
        let testArray: [Int] = [1]
        #expect(testArray.insertionIndex(of: 2) == 1)
    }

    @Test func testInsertionIndexSingleElementLesser() {
        let testArray: [Int] = [1]
        #expect(testArray.insertionIndex(of: 0) == 0)
    }

    @Test func testInsertionIndexMultipleElementsEqual() {
        let testArray: [Int] = [1, 2, 3]
        #expect(testArray.insertionIndex(of: 2) == 2)
    }

    @Test func testInsertionIndexMultipleElementsGap() {
        let testArray: [Int] = [1, 3]
        #expect(testArray.insertionIndex(of: 2) == 1)
    }

    @Test func testInsert() {
        var testArray = [1, 3, 5, 7, 9]
        testArray.insertSorted(2)
        #expect(testArray == [1, 2, 3, 5, 7, 9])
        testArray.insertSorted(4)
        #expect(testArray == [1, 2, 3, 4, 5, 7, 9])
        testArray.insertSorted(6)
        #expect(testArray == [1, 2, 3, 4, 5, 6, 7, 9])
        testArray.insertSorted(10)
        #expect(testArray == [1, 2, 3, 4, 5, 6, 7, 9, 10])
        testArray.insertSorted(0)
        #expect(testArray == [0, 1, 2, 3, 4, 5, 6, 7, 9, 10])
        testArray.insertSorted(5)
        testArray.insertSorted(5)
        testArray.insertSorted(5)
        #expect(testArray == [0, 1, 2, 3, 4, 5, 5, 5, 5, 6, 7, 9, 10])
    }
}
