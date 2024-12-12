import Testing

@testable import aoc2024

@Suite struct NumericTests {
    @Test func testDigitCount() {
        #expect(1.digitCount == 1)
        #expect(2.digitCount == 1)
        #expect(3.digitCount == 1)

        #expect(9.digitCount == 1)
        #expect(10.digitCount == 2)
        #expect(11.digitCount == 2)

        #expect(18.digitCount == 2)
        #expect(19.digitCount == 2)
        #expect(20.digitCount == 2)
        #expect(21.digitCount == 2)
        #expect(22.digitCount == 2)
        #expect(23.digitCount == 2)

        #expect(97.digitCount == 2)
        #expect(98.digitCount == 2)
        #expect(99.digitCount == 2)
        #expect(100.digitCount == 3)
        #expect(101.digitCount == 3)
        #expect(102.digitCount == 3)

        #expect(1000.digitCount == 4)
        #expect(9999.digitCount == 4)
    }

    @Test func testShiftTensPlacePositive() {
        #expect(1.shiftTensPlace(by: 0) == 1)
        #expect(1.shiftTensPlace(by: 1) == 10)
        #expect(1.shiftTensPlace(by: 2) == 100)
        #expect(1.shiftTensPlace(by: 3) == 1000)

        #expect(10.shiftTensPlace(by: 0) == 10)
        #expect(10.shiftTensPlace(by: 1) == 100)
        #expect(10.shiftTensPlace(by: 2) == 1000)
        #expect(10.shiftTensPlace(by: 3) == 10000)

        #expect(100.shiftTensPlace(by: 0) == 100)
        #expect(100.shiftTensPlace(by: 1) == 1000)
        #expect(100.shiftTensPlace(by: 2) == 10000)
        #expect(100.shiftTensPlace(by: 3) == 100000)

        #expect(1234.shiftTensPlace(by: 0) == 1234)
        #expect(1234.shiftTensPlace(by: 1) == 12340)
        #expect(1234.shiftTensPlace(by: 2) == 123400)
        #expect(1234.shiftTensPlace(by: 3) == 1_234_000)
    }

    @Test func testShiftTensPlaceNegative() {
        #expect(10.shiftTensPlace(by: -1) == 1)

        #expect(100.shiftTensPlace(by: -1) == 10)
        #expect(100.shiftTensPlace(by: -2) == 1)

        #expect(1234.shiftTensPlace(by: -1) == 123)
        #expect(1234.shiftTensPlace(by: -2) == 12)
        #expect(1234.shiftTensPlace(by: -3) == 1)
    }
}
