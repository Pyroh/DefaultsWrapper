//
//  UserDefaultsKeyName.swift
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

/// Keeps compatibility with previous versions.
@available(*, deprecated, renamed: "UserDefaultsKeyName")
public typealias DefaultName = UserDefaultsKeyName

/// A `UserDefaults` key.
///
/// Since `UserDefaultsKeyName` conforms to `ExpressibleByStringLiteral` a string literal can be used where a `UserDefaultsKeyName` is expected.
///
/// It means that if there's such a function :
/// ```swift
/// func ImInNeedOfA(defaultName key: UserDefaultsKeyName) {
///     print(key)
/// }
/// ```
/// this code :
/// ```swift
/// let somePropertyKey: DefaultName = "somePropertyKey"
/// ImInNeedOfA(defaultName: somePropertyKey)
/// ```
/// and this code :
/// ```swift
/// ImInNeedOfA(defaultName: "somePropertyKey")
/// ```
/// will produce the same result.
///
/// ## Best practice
/// To avoid confusion when using strings as identifier it's best to extend `UserDefaultsKeyName`. You can then declare the keys as you add static properties to `UserDefaultsKeyName`.
///
/// ```swift
/// extension UserDefaultsKeyName {
///     static var numberOfPlayers: UserDefaultsKeyName { "NumberOfPlayers" }
///     static var playerName: UserDefaultsKeyName { "PlayerName" }
///     static var startingPosition: UserDefaultsKeyName { "StartingPosition" }
/// }
///
/// struct Game {
///     @Defaults(.numberOfPlayers) var playerCount: Int = 3
///     @Defaults(.playerName) var playerCount: String = "Red"
///     @SavedState(.startingPosition) var position: CGPoint = .zero
///     ...
/// }
/// ```
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

extension UserDefaultsKeyName: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
}
