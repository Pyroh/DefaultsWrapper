//
//  PropertyListSerializableProtocol.swift
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

/// Used to mark a type that conforms to it as serializable in a property list.
/// - Remark:
///     You shouldn't conform your own types or any other type to this protocol.
public protocol PropertyListSerializable { }

extension Int: PropertyListSerializable { }
extension Double: PropertyListSerializable { }
extension Float: PropertyListSerializable { }
extension Bool: PropertyListSerializable { }

extension String: PropertyListSerializable { }
extension Data: PropertyListSerializable { }
extension Date: PropertyListSerializable { }
extension URL: PropertyListSerializable { }

extension Dictionary: PropertyListSerializable where Key == String, Value: PropertyListSerializable { }
extension Array: PropertyListSerializable where Element: PropertyListSerializable { }
