import Foundation

struct EquationResult: Equatable {
    let a: Int
    let b: Int

    init(a: Int, b: Int) {
        self.a = a
        self.b = b
    }
}

func solve2DLinearEquations(one: (x: Int, y: Int, equals: Int), two: (x: Int, y: Int, equals: Int))
    -> EquationResult?
{
    // Use Int128 to avoid overflows
    let determinant = Int128(one.x) * Int128(two.y) - Int128(one.y) * Int128(two.x)
    guard determinant != 0 else { return nil }

    let dA = Int128(one.equals) * Int128(two.y) - Int128(two.equals) * Int128(one.y)
    let dB = Int128(one.x) * Int128(two.equals) - Int128(two.x) * Int128(one.equals)
    let a = dA / determinant
    let b = dB / determinant

    let result = EquationResult(a: Int(a), b: Int(b))

    guard result.a * one.x + result.b * one.y == one.equals else { return nil }
    guard result.a * two.x + result.b * two.y == two.equals else { return nil }

    return result
}
