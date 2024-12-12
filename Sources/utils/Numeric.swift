import Foundation

private func numberDigits(_ number: Double) -> Int {
    return Int(log10(number).rounded(.down)) + 1
}

private func shiftTensPlaces(_ number: Double, by digits: Int) -> Double {
    return number * pow(10.0, Double(digits))
}

extension Int {
    var digitCount: Int {
        return numberDigits(Double(self))
    }

    func shiftTensPlace(by digits: Int) -> Int {
        return Int(shiftTensPlaces(Double(self), by: digits))
    }
}

extension UInt {
    var digitCount: Int {
        return numberDigits(Double(self))
    }

    func shiftTensPlace(by digits: Int) -> UInt {
        return UInt(shiftTensPlaces(Double(self), by: digits))
    }
}

extension Float {
    var digitCount: Int {
        return numberDigits(Double(self))
    }

    func shiftTensPlace(by digits: Int) -> Float {
        return Float(shiftTensPlaces(Double(self), by: digits))
    }
}

extension Double {
    var digitCount: Int {
        return numberDigits(self)
    }

    func shiftTensPlace(by digits: Int) -> Double {
        return shiftTensPlaces(self, by: digits)
    }
}
