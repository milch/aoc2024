import Testing

@testable import aoc2024

@Suite struct BoxTests {
    @Test func testClone() {
        let box = Box(1)
        let clone = box.clone()
        #expect(clone == 1)
    }

    @Test func testRefSemantics() {
        let box = Box(1)
        box.value = 2
        #expect(box.value == 2)
        var other = box.value
        #expect(other == 2)
        other += 1
        #expect(box.value == 2)
        #expect(other == 3)
        let otherRef = box
        otherRef.value += 1
        #expect(box.value == 3)
        #expect(otherRef.value == 3)
        box.value += 1
        #expect(box.value == 4)
        #expect(otherRef.value == 4)
    }
}
