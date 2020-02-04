//
//  DefaultName.swift
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

@available(*, deprecated, renamed: "UserDefaultsKeyName")
public typealias DefaultName = UserDefaultsKeyName

/// A `UserDefaults` key.
///
/// Since `DefaultName` conforms to `ExpressibleByStringLiteral` a string literal can be used where a `DefaultName` is expected.
///
/// It means that if there's such a function :
/// ```Swift
/// func ImInNeedOfA(defaultName key: DefaultName) {
///     print(key)
/// }
/// ```
/// this code :
/// ```
/// let somePropertyKey: DefaultName = "somePropertyKey"
/// ImInNeedOfA(defaultName: somePropertyKey)
/// ```
/// and this code :
/// ```
/// ImInNeedOfA(defaultName: "somePropertyKey")
/// ```
/// will produce the same result.
public struct UserDefaultsKeyName: RawRepresentable, ExpressibleByStringLiteral, CustomStringConvertible {
    public var rawValue: String
    public var description: String { self.rawValue }
    
    public init(stringLiteral value: String) {
        self.rawValue = value
    }
    
    public init?(rawValue: String) {
        self.rawValue = rawValue
    }
}

