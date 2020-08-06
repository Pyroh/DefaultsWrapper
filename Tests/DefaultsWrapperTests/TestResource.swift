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
        ]
    }
}

class TestCase {
    @Defaults(key: .doubleValue, defaultValue: 42)
    var doubleValue: Double
    @Defaults(key: .optionalDoubleValue, defaultValue: 42)
    var optionalDoubleValue: Double?
    @Defaults(key: .optionalNilDoubleValue)
    var optionalNilDoubleValue: Double?
    
    @Defaults(key: .enumValue, defaultValue: .north)
    var enumValue: Direction
    @Defaults(key: .optionalEnumValue, defaultValue: .north)
    var optionalEnumValue: Direction?
    @Defaults(key: .optionalNilEnumValue)
    var optionalNilEnumValue: Direction?
    
    @Defaults(key: .codableValue, defaultValue: CodableStruct())
    var codableValue: CodableStruct
    @Defaults(key: .optionalcodableValue, defaultValue: CodableStruct())
    var optionalcodableValue: CodableStruct?
    @Defaults(key: .optionalNilcodableValue)
    var optionalNilcodableValue: CodableStruct?
    
    @Defaults(key: .arrayValue, defaultValue: [1, 2, 3])
    var arrayValue: [Int]
    @Defaults(key: .optionalArrayValue, defaultValue: [1, 2, 3])
    var optionalArrayValue: [Int]?
    @Defaults(key: .optionalNilArrayValue)
    var optionalNilArrayValue: [Int]?
}

class WrappedTestCase {
    @Defaults(.doubleValue)
    var doubleValue: Double = 42
    @Defaults(.optionalDoubleValue)
    var optionalDoubleValue: Double? = 42
    @Defaults(.optionalNilDoubleValue)
    var optionalNilDoubleValue: Double?

    @Defaults(.enumValue )
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
    var arrayValue: [Int] =  [1, 2, 3]
    @Defaults(.optionalArrayValue)
    var optionalArrayValue: [Int]? =  [1, 2, 3]
    @Defaults(.optionalNilArrayValue)
    var optionalNilArrayValue: [Int]?
}

class CGTestCase {
    @Defaults(key: .floatValue, defaultValue: .zero)
    var floatValue: CGFloat
    @Defaults(key: .optionalFloatValue, defaultValue: .zero)
    var optionalFloatValue: CGFloat?
    @Defaults(key: .optionalNilFloatValue)
    var optionalNilFloatValue: CGFloat?
    
    @Defaults(key: .pointValue, defaultValue: .zero)
    var pointValue: CGPoint
    @Defaults(key: .optionalPointValue, defaultValue: .zero)
    var optionalPointValue: CGPoint?
    @Defaults(key: .optionalNilPointValue)
    var optionalNilPointValue: CGPoint?
    
    @Defaults(key: .sizeValue, defaultValue: .zero)
    var sizeValue: CGSize
    @Defaults(key: .optionalSizeValue, defaultValue: .zero)
    var optionalSizeValue: CGSize?
    @Defaults(key: .optionalNilSizeValue)
    var optionalNilSizeValue: CGSize?
    
    @Defaults(key: .rectValue, defaultValue: .zero)
    var rectValue: CGRect
    @Defaults(key: .optionalRectValue, defaultValue: .zero)
    var optionalRectValue: CGRect?
    @Defaults(key: .optionalNilRectValue)
    var optionalNilRectValue: CGRect?
    
    @Defaults(key: .vectorValue, defaultValue: .zero)
    var vectorValue: CGVector
    @Defaults(key: .optionalVectorValue, defaultValue: .zero)
    var optionalVectorValue: CGVector?
    @Defaults(key: .optionalNilVectorValue)
    var optionalNilVectorValue: CGVector?
    
    @Defaults(key: .transformValue, defaultValue: .identity)
    var transformValue: CGAffineTransform
    @Defaults(key: .optionalTransformValue, defaultValue: .identity)
    var optionalTransformValue: CGAffineTransform?
    @Defaults(key: .optionalNilTransformValue)
    var optionalNilTransformValue:  CGAffineTransform?
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
    
    public static func instanciate(from object: [String : Int]) -> SIMD2<Int>? {
        guard let x = object["x"], let y = object["y"] else { return nil }
        
        return .init(x: x, y: y)
    }
}
