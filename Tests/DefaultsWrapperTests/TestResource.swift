//
//  TestResource.swift
//
//  DefaultsWrapper
//
//  Copyright (c) 2020 Pierre Tacchi
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//


import Foundation
import CoreGraphics
import DefaultsWrapper

extension UserDefaultsKeyName {
    static let doubleValue: UserDefaultsKeyName = "doubleValue"
    static let optionalDoubleValue: UserDefaultsKeyName = "optionalDoubleValue"
    static let optionalNilDoubleValue: UserDefaultsKeyName = "optionalNilDoubleValue"
    
    static let enumValue: UserDefaultsKeyName = "enumValue"
    static let optionalEnumValue: UserDefaultsKeyName = "optionalEnumValue"
    static let optionalNilEnumValue: UserDefaultsKeyName = "optionalNilEnumValue"
    
    static let codableValue: UserDefaultsKeyName = "codableValue"
    static let optionalcodableValue: UserDefaultsKeyName = "optionalcodableValue"
    static let optionalNilcodableValue: UserDefaultsKeyName = "optionalNilcodableValue"
    
    static let arrayValue: UserDefaultsKeyName = "arrayValue"
    static let optionalArrayValue: UserDefaultsKeyName = "optionalArrayValue"
    static let optionalNilArrayValue: UserDefaultsKeyName = "optionalNilArrayValue"
    
    static let floatValue: UserDefaultsKeyName = "floatValue"
    static let optionalFloatValue: UserDefaultsKeyName = "optionalFloatValue"
    static let optionalNilFloatValue: UserDefaultsKeyName = "optionalNilFloatValue"
    
    static let pointValue: UserDefaultsKeyName = "pointValue"
    static let optionalPointValue: UserDefaultsKeyName = "optionalPointValue"
    static let optionalNilPointValue: UserDefaultsKeyName = "optionalNilPointValue"
    
    static let sizeValue: UserDefaultsKeyName = "sizeValue"
    static let optionalSizeValue: UserDefaultsKeyName = "optionalSizeValue"
    static let optionalNilSizeValue: UserDefaultsKeyName = "optionalNilSizeValue"
    
    static let rectValue: UserDefaultsKeyName = "rectValue"
    static let optionalRectValue: UserDefaultsKeyName = "optionalRectValue"
    static let optionalNilRectValue: UserDefaultsKeyName = "optionalNilRectValue"
    
    static let vectorValue: UserDefaultsKeyName = "vectorValue"
    static let optionalVectorValue: UserDefaultsKeyName = "optionalVectorValue"
    static let optionalNilVectorValue: UserDefaultsKeyName = "optionalNilVectorValue"
    
    static let transformValue: UserDefaultsKeyName = "transformValue"
    static let optionalTransformValue: UserDefaultsKeyName = "optionalTransformValue"
    static let optionalNilTransformValue: UserDefaultsKeyName = "optionalNilTransformValue"
    
    static let cgFloatArray: UserDefaultsKeyName = "cgFloatArray"
    static let cgPointArray: UserDefaultsKeyName = "cgPointArray"
    
    static let decimalValue: UserDefaultsKeyName = "decimalValue"
    static let uuidValue: UserDefaultsKeyName = "uuidValue"
    static let localeValue: UserDefaultsKeyName = "localeValue"
    
    static var all: [UserDefaultsKeyName] { [
        .doubleValue,
        .optionalDoubleValue,
        .optionalNilDoubleValue,
        
        .enumValue,
        .optionalEnumValue,
        .optionalNilEnumValue,
        
        .codableValue,
        .optionalcodableValue,
        .optionalNilcodableValue,
        
        .arrayValue,
        .optionalArrayValue,
        .optionalNilArrayValue,
        
        .floatValue,
        .optionalFloatValue,
        .optionalNilFloatValue,
        
        .pointValue,
        .optionalPointValue,
        .optionalNilPointValue,
        
        .sizeValue,
        .optionalSizeValue,
        .optionalNilSizeValue,
        
        .rectValue,
        .optionalRectValue,
        .optionalNilRectValue,
        
        .vectorValue,
        .optionalVectorValue,
        .optionalNilVectorValue,
        
        .transformValue,
        .optionalTransformValue,
        .optionalNilTransformValue,
        
        .cgFloatArray,
        .cgPointArray,
        
        .decimalValue,
        .uuidValue,
        .localeValue
        ]
    }
}

class TestCase {
    @Defaults(.doubleValue)
    var doubleValue: Double = 42
    @Defaults(.optionalDoubleValue)
    var optionalDoubleValue: Double? = 42
    @Defaults(.optionalNilDoubleValue)
    var optionalNilDoubleValue: Double?
    
    @Defaults(.enumValue)
    var enumValue: Direction = .north
    @Defaults(.optionalEnumValue)
    var optionalEnumValue: Direction? = .north
    @Defaults(.optionalNilEnumValue)
    var optionalNilEnumValue: Direction?
    
    @Defaults(.codableValue)
    var codableValue: CodableStruct = CodableStruct()
    @Defaults(.optionalcodableValue)
    var optionalcodableValue: CodableStruct? = CodableStruct()
    @Defaults(.optionalNilcodableValue)
    var optionalNilcodableValue: CodableStruct?
    
    @Defaults(.arrayValue)
    var arrayValue: [Int] = [1, 2, 3]
    @Defaults(.optionalArrayValue)
    var optionalArrayValue: [Int]? = [1, 2, 3]
    @Defaults(.optionalNilArrayValue)
    var optionalNilArrayValue: [Int]?
}

class PreferenceTestCase {
    @Preference(.doubleValue)
    var doubleValue: Double = 42
    @Preference(.optionalDoubleValue)
    var optionalDoubleValue: Double? = 42
    @Preference(.optionalNilDoubleValue)
    var optionalNilDoubleValue: Double?
    
    @Preference(.enumValue)
    var enumValue: Direction = .north
    @Preference(.optionalEnumValue)
    var optionalEnumValue: Direction? = .north
    @Preference(.optionalNilEnumValue)
    var optionalNilEnumValue: Direction?
    
    @Preference(.codableValue)
    var codableValue: CodableStruct = CodableStruct()
    @Preference(.optionalcodableValue)
    var optionalcodableValue: CodableStruct? = CodableStruct()
    @Preference(.optionalNilcodableValue)
    var optionalNilcodableValue: CodableStruct?
    
    @Preference(.arrayValue)
    var arrayValue: [Int] = [1, 2, 3]
    @Preference(.optionalArrayValue)
    var optionalArrayValue: [Int]? = [1, 2, 3]
    @Preference(.optionalNilArrayValue)
    var optionalNilArrayValue: [Int]?
}

class SavedStateTestCase {
    @SavedState(.doubleValue)
    var doubleValue: Double = 42
    @SavedState(.optionalDoubleValue)
    var optionalDoubleValue: Double? = 42
    @SavedState(.optionalNilDoubleValue)
    var optionalNilDoubleValue: Double?
    
    @SavedState(.enumValue)
    var enumValue: Direction = .north
    @SavedState(.optionalEnumValue)
    var optionalEnumValue: Direction? = .north
    @SavedState(.optionalNilEnumValue)
    var optionalNilEnumValue: Direction?
    
    @SavedState(.codableValue)
    var codableValue: CodableStruct = CodableStruct()
    @SavedState(.optionalcodableValue)
    var optionalcodableValue: CodableStruct? = CodableStruct()
    @SavedState(.optionalNilcodableValue)
    var optionalNilcodableValue: CodableStruct?
    
    @SavedState(.arrayValue)
    var arrayValue: [Int] = [1, 2, 3]
    @SavedState(.optionalArrayValue)
    var optionalArrayValue: [Int]? = [1, 2, 3]
    @SavedState(.optionalNilArrayValue)
    var optionalNilArrayValue: [Int]?
}

class CGTestCase {
    @Defaults(.floatValue)
    var floatValue: CGFloat = .zero
    @Defaults(.optionalFloatValue)
    var optionalFloatValue: CGFloat? = .zero
    @Defaults(.optionalNilFloatValue)
    var optionalNilFloatValue: CGFloat?
    
    @Defaults(.pointValue)
    var pointValue: CGPoint = .zero
    @Defaults(.optionalPointValue)
    var optionalPointValue: CGPoint? = .zero
    @Defaults(.optionalNilPointValue)
    var optionalNilPointValue: CGPoint?
    
    @Defaults(.sizeValue)
    var sizeValue: CGSize = .zero
    @Defaults(.optionalSizeValue)
    var optionalSizeValue: CGSize? = .zero
    @Defaults(.optionalNilSizeValue)
    var optionalNilSizeValue: CGSize?
    
    @Defaults(.rectValue)
    var rectValue: CGRect = .zero
    @Defaults(.optionalRectValue)
    var optionalRectValue: CGRect? = .zero
    @Defaults(.optionalNilRectValue)
    var optionalNilRectValue: CGRect?
    
    @Defaults(.vectorValue)
    var vectorValue: CGVector = .zero
    @Defaults(.optionalVectorValue)
    var optionalVectorValue: CGVector? = .zero
    @Defaults(.optionalNilVectorValue)
    var optionalNilVectorValue: CGVector?
    
    @Defaults(.transformValue)
    var transformValue: CGAffineTransform = .identity
    @Defaults(.optionalTransformValue)
    var optionalTransformValue: CGAffineTransform? = .identity
    @Defaults(.optionalNilTransformValue)
    var optionalNilTransformValue:  CGAffineTransform?
}

class CGPreferenceTestCase {
    @Preference(.floatValue)
    var floatValue: CGFloat = .zero
    @Preference(.optionalFloatValue)
    var optionalFloatValue: CGFloat? = .zero
    @Preference(.optionalNilFloatValue)
    var optionalNilFloatValue: CGFloat?
    
    @Preference(.pointValue)
    var pointValue: CGPoint = .zero
    @Preference(.optionalPointValue)
    var optionalPointValue: CGPoint? = .zero
    @Preference(.optionalNilPointValue)
    var optionalNilPointValue: CGPoint?
    
    @Preference(.sizeValue)
    var sizeValue: CGSize = .zero
    @Preference(.optionalSizeValue)
    var optionalSizeValue: CGSize? = .zero
    @Preference(.optionalNilSizeValue)
    var optionalNilSizeValue: CGSize?
    
    @Preference(.rectValue)
    var rectValue: CGRect = .zero
    @Preference(.optionalRectValue)
    var optionalRectValue: CGRect? = .zero
    @Preference(.optionalNilRectValue)
    var optionalNilRectValue: CGRect?
    
    @Preference(.vectorValue)
    var vectorValue: CGVector = .zero
    @Preference(.optionalVectorValue)
    var optionalVectorValue: CGVector? = .zero
    @Preference(.optionalNilVectorValue)
    var optionalNilVectorValue: CGVector?
    
    @Preference(.transformValue)
    var transformValue: CGAffineTransform = .identity
    @Preference(.optionalTransformValue)
    var optionalTransformValue: CGAffineTransform? = .identity
    @Preference(.optionalNilTransformValue)
    var optionalNilTransformValue:  CGAffineTransform?
}

class CGSavedStateTestCase {
    @SavedState(.floatValue)
    var floatValue: CGFloat = .zero
    @SavedState(.optionalFloatValue)
    var optionalFloatValue: CGFloat? = .zero
    @SavedState(.optionalNilFloatValue)
    var optionalNilFloatValue: CGFloat?
    
    @SavedState(.pointValue)
    var pointValue: CGPoint = .zero
    @SavedState(.optionalPointValue)
    var optionalPointValue: CGPoint? = .zero
    @SavedState(.optionalNilPointValue)
    var optionalNilPointValue: CGPoint?
    
    @SavedState(.sizeValue)
    var sizeValue: CGSize = .zero
    @SavedState(.optionalSizeValue)
    var optionalSizeValue: CGSize? = .zero
    @SavedState(.optionalNilSizeValue)
    var optionalNilSizeValue: CGSize?
    
    @SavedState(.rectValue)
    var rectValue: CGRect = .zero
    @SavedState(.optionalRectValue)
    var optionalRectValue: CGRect? = .zero
    @SavedState(.optionalNilRectValue)
    var optionalNilRectValue: CGRect?
    
    @SavedState(.vectorValue)
    var vectorValue: CGVector = .zero
    @SavedState(.optionalVectorValue)
    var optionalVectorValue: CGVector? = .zero
    @SavedState(.optionalNilVectorValue)
    var optionalNilVectorValue: CGVector?
    
    @SavedState(.transformValue)
    var transformValue: CGAffineTransform = .identity
    @SavedState(.optionalTransformValue)
    var optionalTransformValue: CGAffineTransform? = .identity
    @SavedState(.optionalNilTransformValue)
    var optionalNilTransformValue:  CGAffineTransform?
}

class FoundationTestCase {
    @Defaults(.decimalValue)
    var decimalValue: Decimal = .zero
    
    @Defaults(.uuidValue)
    var uuidValue: UUID = .init(uuidString: "00000000-0000-0000-0000-000000000000")!
    
    @Defaults(.localeValue)
    var localValue: Locale = .current
}

class FoundationPreferenceTestCase {
    @Preference(.decimalValue)
    var decimalValue: Decimal = .zero
    
    @Preference(.uuidValue)
    var uuidValue: UUID = .init(uuidString: "00000000-0000-0000-0000-000000000000")!
    
    @Preference(.localeValue)
    var localValue: Locale = .current
}

class FoundationSavedStateTestCase {
    @SavedState(.decimalValue)
    var decimalValue: Decimal = .zero
    
    @SavedState(.uuidValue)
    var uuidValue: UUID = .init(uuidString: "00000000-0000-0000-0000-000000000000")!
    
    @SavedState(.localeValue)
    var localValue: Locale = .current
}

class ArrayTestCase {
    @Defaults(.cgFloatArray) var cgFloatArray: [CGFloat] = []
    @Defaults(.cgPointArray) var cgPointArray: [CGPoint] = []
}

enum Direction: Int, Codable {
    case north = 0
    case west, south, east
}

struct CodableStruct: UserDefaultsCodable, Equatable {
    var intValue: Int = 42
    var doubleValue: Double = 42
    
    var stringValue: String = "Hello"
    var direction: Direction = .north
    
    var scaledValues: [Int] = [0, 10, 20 , 30]
}

func eraseDefaults() {
    UserDefaultsKeyName.all.lazy.map(key).forEach(UserDefaults.standard.removeObject(forKey:))
}

func key(_ key: UserDefaultsKeyName) -> String { key.rawValue }

extension SIMD2: UserDefaultsConvertible where Scalar == Int {
    public func convertedObject() -> [String: Int] {
        ["x": self.x, "y": self.y]
    }
    
    public static func instantiate(from object: [String : Int]) -> SIMD2<Int>? {
        guard let x = object["x"], let y = object["y"] else { return nil }
        
        return .init(x: x, y: y)
    }
}
