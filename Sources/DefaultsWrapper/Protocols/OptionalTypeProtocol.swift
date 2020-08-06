//
//  OptionalTypeProtocol.swift
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

/// An `Optional` abstraction that can be conveniently used as a generic constraint.
/// - Warning:
///     No other thing than `Optional` should conform to this protocol.
/// - Note:
///     This `Optional` wrapper is a knockoff of [SwiftyUserDefaults](https://github.com/sunshinejr/SwiftyUserDefaults)\'s own `OptionalType`.
public protocol OptionalType {
    associatedtype Wrapped
    
    /// The concrete optional type of the instance.
    var wrapped: Wrapped? { get }
    
    /// `nil` when you can't use `nil`.
    static var `nil`: Self { get }
    
    /// Wraps the given instance in a corresponding optional.
    static func wrap(_ wrapping: Wrapped) -> Self
}

extension Optional: OptionalType {
    public var wrapped: Wrapped? { self }
    public static var `nil`: Optional<Wrapped> { nil }

    public static func wrap(_ wrapping: Wrapped) -> Optional<Wrapped> {
        Self(wrapping)
    }
}
