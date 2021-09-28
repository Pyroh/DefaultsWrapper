//
//  OptionalTypeProtocol.swift
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

/// An `Optional` abstraction that can be conveniently used as a generic constraint.
///
/// This `Optional` wrapper is a knockoff of [SwiftyUserDefaults](https://github.com/sunshinejr/SwiftyUserDefaults)\'s `OptionalType`.
///
/// - Note: `Optional` conforms to this protocol.
/// - Remark: No type other than `Optional` should conform to this protocol.
///

public protocol AnyOptional {
    /// The type of the wrapped subject.
    associatedtype Wrapped
    
    /// The concrete optional type of the instance.
    var wrappedValue: Wrapped? { get }
    
    /// The receiver is nil.
    var isNil: Bool { get }
    
    /// `nil` when you can't use `nil`.
    static var nilValue: Self { get }
    
    /// Wraps the given instance in a corresponding optional.
    static func wrapValue(_ wrapping: Wrapped) -> Self
}

extension Optional: AnyOptional {
    public var wrappedValue: Wrapped? { self }
    public var isNil: Bool { self == nil }
    public static var nilValue: Self { nil }

    public static func wrapValue(_ wrapping: Wrapped) -> Self {
        Self(wrapping)
    }
}

