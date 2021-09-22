//
//  PropertyListSerializableProtocol.swift
//
//  DefaultsWrapper
//
//  Copyright (c) 2020-2021 Pierre Tacchi
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

/// A protocol types that are natively supported by `UserDefaults` conform to.
///
/// Comforming types :
/// - `Int`
/// - `Double`
/// - `Float`
/// - `Bool`
/// - `String`
/// - `Data`
/// - `Date`
/// - `URL`
/// - `Array` is supported if its `Element` required type itself conforms to ``PropertyListSerializable``.
/// - `Dictionnary` is supported too if its `Key` is in fact `String` and if its `Value` required type conforms to ``PropertyListSerializable`.
/// - Important: You shouldn't conform your own types or any other type to this protocol. Unless this documentation says otherwise...
public protocol PropertyListSerializable { }

extension Int: PropertyListSerializable { }
extension Double: PropertyListSerializable { }
extension Float: PropertyListSerializable { }
extension Bool: PropertyListSerializable { }

extension String: PropertyListSerializable { }
extension Data: PropertyListSerializable { }
extension Date: PropertyListSerializable { }
extension URL: PropertyListSerializable { }

extension Dictionary: PropertyListSerializable where Key == String { }
extension Array: PropertyListSerializable where Element: PropertyListSerializable { }
