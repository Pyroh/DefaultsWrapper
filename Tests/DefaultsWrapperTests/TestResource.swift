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
import DefaultsWrapper

extension DefaultName {
    static let doubleValue: DefaultName = "doubleValue"
    static let optionalDoubleValue: DefaultName = "optionalDoubleValue"
    static let optionalNilDoubleValue: DefaultName = "optionalNilDoubleValue"
    
    static let enumValue: DefaultName = "enumValue"
    static let optionalEnumValue: DefaultName = "optionalEnumValue"
    static let optionalNilEnumValue: DefaultName = "optionalNilEnumValue"
    
    static let codableValue: DefaultName = "codableValue"
    static let optionalcodableValue: DefaultName = "optionalcodableValue"
    static let optionalNilcodableValue: DefaultName = "optionalNilcodableValue"
    
    static let arrayValue: DefaultName = "arrayValue"
    static let optionalArrayValue: DefaultName = "optionalArrayValue"
    static let optionalNilArrayValue: DefaultName = "optionalNilArrayValue"
    
    static let floatValue: DefaultName = "floatValue"
    static let optionalFloatValue: DefaultName = "optionalFloatValue"
    static let optionalNilFloatValue: DefaultName = "optionalNilFloatValue"
    
    static let pointValue: DefaultName = "pointValue"
    static let optionalPointValue: DefaultName = "optionalPointValue"
    static let optionalNilPointValue: DefaultName = "optionalNilPointValue"
    
    static let sizeValue: DefaultName = "sizeValue"
    static let optionalSizeValue: DefaultName = "optionalSizeValue"
    static let optionalNilSizeValue: DefaultName = "optionalNilSizeValue"
    
    static let rectValue: DefaultName = "rectValue"
    static let optionalRectValue: DefaultName = "optionalRectValue"
    static let optionalNilRectValue: DefaultName = "optionalNilRectValue"
    
    static let vectorValue: DefaultName = "vectorValue"
    static let optionalVectorValue: DefaultName = "optionalVectorValue"
    static let optionalNilVectorValue: DefaultName = "optionalNilVectorValue"
    
    static let transformValue: DefaultName = "transformValue"
    static let optionalTransformValue: DefaultName = "optionalTransformValue"
    static let optionalNilTransformValue: DefaultName = "optionalNilTransformValue"
    
    static var all: [DefaultName] { [
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

    @Default(key: .doubleValue, defaultValue: 42)
    var doubleValue: Double
    @Default(key: .optionalDoubleValue, defaultValue: 42)
    var optionalDoubleValue: Double?
    @Default(key: .optionalNilDoubleValue)
    var optionalNilDoubleValue: Double?
    
    @Default(key: .enumValue, defaultValue: .north)
    var enumValue: Direction
    @Default(key: .optionalEnumValue, defaultValue: .north)
    var optionalEnumValue: Direction?
    @Default(key: .optionalNilEnumValue)
    var optionalNilEnumValue: Direction?
    
    @Default(key: .codableValue, defaultValue: CodableStruct())
    var codableValue: CodableStruct
    @Default(key: .optionalcodableValue, defaultValue: CodableStruct())
    var optionalcodableValue: CodableStruct?
    @Default(key: .optionalNilcodableValue)
    var optionalNilcodableValue: CodableStruct?
    
    @Default(key: .arrayValue, defaultValue: [1, 2, 3])
    var arrayValue: [Int]
    @Default(key: .optionalArrayValue, defaultValue: [1, 2, 3])
    var optionalArrayValue: [Int]?
    @Default(key: .optionalNilArrayValue)
    var optionalNilArrayValue: [Int]?
}

class CGTestCase {
    @Default(key: .floatValue, defaultValue: .zero)
    var floatValue: CGFloat
    @Default(key: .optionalFloatValue, defaultValue: .zero)
    var optionalFloatValue: CGFloat?
    @Default(key: .optionalNilFloatValue)
    var optionalNilFloatValue: CGFloat?
    
    @Default(key: .pointValue, defaultValue: .zero)
    var pointValue: CGPoint
    @Default(key: .optionalPointValue, defaultValue: .zero)
    var optionalPointValue: CGPoint?
    @Default(key: .optionalNilPointValue)
    var optionalNilPointValue: CGPoint?
    
    @Default(key: .sizeValue, defaultValue: .zero)
    var sizeValue: CGSize
    @Default(key: .optionalSizeValue, defaultValue: .zero)
    var optionalSizeValue: CGSize?
    @Default(key: .optionalNilSizeValue)
    var optionalNilSizeValue: CGSize?
    
    @Default(key: .rectValue, defaultValue: .zero)
    var rectValue: CGRect
    @Default(key: .optionalRectValue, defaultValue: .zero)
    var optionalRectValue: CGRect?
    @Default(key: .optionalNilRectValue)
    var optionalNilRectValue: CGRect?
    
    @Default(key: .vectorValue, defaultValue: .zero)
    var vectorValue: CGVector
    @Default(key: .optionalVectorValue, defaultValue: .zero)
    var optionalVectorValue: CGVector?
    @Default(key: .optionalNilVectorValue)
    var optionalNilVectorValue: CGVector?
    
    @Default(key: .transformValue, defaultValue: .identity)
    var transformValue: CGAffineTransform
    @Default(key: .optionalTransformValue, defaultValue: .identity)
    var optionalTransformValue: CGAffineTransform?
    @Default(key: .optionalNilTransformValue)
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
    DefaultName.all.lazy.map(key).forEach(UserDefaults.standard.removeObject(forKey:))
}

func key(_ key: DefaultName) -> String { key.rawValue }


