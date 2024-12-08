import Testing

@testable import aoc2024

@Suite struct CombinationIteratorTests {
    @Test func testCombinationsOfTwo() async {
        let input = [1, 2, 3, 4, 5]
        var iterator = input.combinations(of: 2)
        #expect(iterator.next() == .some([1, 2]))
        #expect(iterator.next() == .some([1, 3]))
        #expect(iterator.next() == .some([1, 4]))
        #expect(iterator.next() == .some([1, 5]))
        #expect(iterator.next() == .some([2, 3]))
        #expect(iterator.next() == .some([2, 4]))
        #expect(iterator.next() == .some([2, 5]))
        #expect(iterator.next() == .some([3, 4]))
        #expect(iterator.next() == .some([3, 5]))
        #expect(iterator.next() == .some([4, 5]))
        #expect(iterator.next() == nil)
    }

    @Test func TestCombinationsOfTwoWithEmptyInput() async {
        let input: [Int] = []
        var iterator = input.combinations(of: 2)
        #expect(iterator.next() == nil)
    }

    @Test func TestCombinationsOfTwoWithSingleElementInput() async {
        let input: [Int] = [1]
        var iterator = input.combinations(of: 2)
        #expect(iterator.next() == nil)
    }

    @Test func TestCombinationsOfTwoWithTwoElementInput() async {
        let input: [Int] = [1, 2]
        var iterator = input.combinations(of: 2)
        #expect(iterator.next() == .some([1, 2]))
        #expect(iterator.next() == nil)
    }

    @Test func testCombinationsOfThree() async {
        let input = [1, 2, 3, 4, 5]
        var iterator = input.combinations(of: 3)
        #expect(iterator.next() == .some([1, 2, 3]))
        #expect(iterator.next() == .some([1, 2, 4]))
        #expect(iterator.next() == .some([1, 2, 5]))
        #expect(iterator.next() == .some([1, 3, 4]))
        #expect(iterator.next() == .some([1, 3, 5]))
        #expect(iterator.next() == .some([1, 4, 5]))
        #expect(iterator.next() == .some([2, 3, 4]))
        #expect(iterator.next() == .some([2, 3, 5]))
        #expect(iterator.next() == .some([2, 4, 5]))
        #expect(iterator.next() == .some([3, 4, 5]))
        #expect(iterator.next() == nil)
    }

    @Test func testCombinationsOfFour() async {
        let input = [1, 2, 3, 4, 5]
        var iterator = input.combinations(of: 4)
        #expect(iterator.next() == .some([1, 2, 3, 4]))
        #expect(iterator.next() == .some([1, 2, 3, 5]))
        #expect(iterator.next() == .some([1, 2, 4, 5]))
        #expect(iterator.next() == .some([1, 3, 4, 5]))
        #expect(iterator.next() == .some([2, 3, 4, 5]))
        #expect(iterator.next() == nil)
    }

    @Test func testCombinationsOfFive() async {
        let input = [1, 2, 3, 4, 5]
        var iterator = input.combinations(of: 5)
        #expect(iterator.next() == .some([1, 2, 3, 4, 5]))
        #expect(iterator.next() == nil)
    }

    @Test func testCombinationsOfFiveInSix() async {
        let input = [1, 2, 3, 4, 5, 6]
        var iterator = input.combinations(of: 5)
        #expect(iterator.next() == .some([1, 2, 3, 4, 5]))
        #expect(iterator.next() == .some([1, 2, 3, 4, 6]))
        #expect(iterator.next() == .some([1, 2, 3, 5, 6]))
        #expect(iterator.next() == .some([1, 2, 4, 5, 6]))
        #expect(iterator.next() == .some([1, 3, 4, 5, 6]))
        #expect(iterator.next() == .some([2, 3, 4, 5, 6]))
        #expect(iterator.next() == nil)
    }
}
