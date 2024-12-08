import Testing

@testable import aoc2024

@Suite struct CombinationIteratorTests {
    @Test func testCombinationsOfTwo() async {
        let input = [1, 2, 3, 4, 5]
        var iterator = input.combinationsOfTwo()
        #expect(iterator.next()! == (1, 2))
        #expect(iterator.next()! == (1, 3))
        #expect(iterator.next()! == (1, 4))
        #expect(iterator.next()! == (1, 5))
        #expect(iterator.next()! == (2, 3))
        #expect(iterator.next()! == (2, 4))
        #expect(iterator.next()! == (2, 5))
        #expect(iterator.next()! == (3, 4))
        #expect(iterator.next()! == (3, 5))
        #expect(iterator.next()! == (4, 5))
        #expect(iterator.next() == nil)
    }

    @Test func TestCombinationsOfTwoWithEmptyInput() async {
        let input: [Int] = []
        var iterator = input.combinationsOfTwo()
        #expect(iterator.next() == nil)
    }

    @Test func TestCombinationsOfTwoWithSingleElementInput() async {
        let input: [Int] = [1]
        var iterator = input.combinationsOfTwo()
        #expect(iterator.next() == nil)
    }

    @Test func TestCombinationsOfTwoWithTwoElementInput() async {
        let input: [Int] = [1, 2]
        var iterator = input.combinationsOfTwo()
        #expect(iterator.next()! == (1, 2))
        #expect(iterator.next() == nil)
    }
}
