//
//  DefaultsValue.swift
//
//  DefaultsWrapper
//
//  MIT License
//
//  Copyright (c) 2020-2022 Pierre Tacchi
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

#if !os(Linux)
import Foundation
import Combine
import OptionalType

/// An adaptor to manipulate a specific value linked to a given key from `UserDefaults`.
public struct DefaultsValue<Element> {
    public typealias ChangeCallback = (Element) -> ()
    typealias Adapter = UserDefaultsValueAdapter<Element>
    
    private let adapter: Adapter
    private let cancellable: AnyCancellable?
    
    /// The underlying value.
    public var value: Element {
        get { adapter.value }
        nonmutating set { adapter.setValue(newValue) }
    }
    
    private init(adapter: Adapter, callback: ChangeCallback?) {
        self.adapter = adapter
        self.cancellable = callback.map {
            adapter.$value.dropFirst().receive(on: RunLoop.main).sink(receiveValue: $0)
        }
    }
}

extension DefaultsValue: Equatable where Element: Equatable {
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.value == rhs.value
    }
    
    public static func ==(lhs: Self, rhs: Element) -> Bool {
        lhs.value == rhs
    }
    
    public static func ==(lhs: Element, rhs: Self) -> Bool {
        lhs == rhs.value
    }
}

extension DefaultsValue: Comparable where Element: Comparable {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.value < rhs.value
    }
    
    public static func < (lhs: Self, rhs: Element) -> Bool {
        lhs.value < rhs
    }
    
    public static func < (lhs: Element, rhs: Self) -> Bool {
        lhs < rhs.value
    }
}

extension DefaultsValue: Hashable where Element: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(value)
    }
}

public extension DefaultsValue where Element: PropertyListSerializable {
    
    /// Creates an adaptor to a `UserDefaults` value conforming to `PropertyListSerializable` linked to the given key.
    /// - Parameters:
    ///   - key: The key with which to associate the value.
    ///   - initialValue: The default value.
    ///   - defaults: The `UserDefaults` instance where to do it.
    ///   - registerValue: A boolean value that indicates if the default value should be added to de registration domain.
    ///   - callback: A callback called everytime the value changes.
    init(key: UserDefaultsKeyName,
         initialValue: Element,
         defaults: UserDefaults = .standard,
         registerValue: Bool = true,
         onChange callback: ChangeCallback? = nil) {
        let adapter = UserDefaultsValueAdapter(key: key.rawValue, defaultValue: { initialValue }, defaults: defaults, register: registerValue, observeChanges: !callback.isNil)
        self.init(adapter: adapter, callback: callback)
    }
}

public extension DefaultsValue where Element: RawRepresentable, Element.RawValue: PropertyListSerializable {
    
    /// Creates an adaptor to a `UserDefaults` value conforming to `RawRepresentable` and its corresponding `RawValue` conforms to `PropertyListSerializable` linked to the given key.
    /// - Parameters:
    ///   - key: The key with which to associate the value.
    ///   - initialValue: The default value.
    ///   - defaults: The `UserDefaults` instance where to do it.
    ///   - registerValue: A boolean value that indicates if the default value should be added to de registration domain.
    ///   - callback: A callback called everytime the value changes.
    init(key: UserDefaultsKeyName,
         initialValue: Element,
         defaults: UserDefaults = .standard,
         registerValue: Bool = true,
         onChange callback: ChangeCallback? = nil) {
        let adapter = UserDefaultsRawRepresentableValueAdapter(key: key.rawValue, defaultValue: { initialValue }, defaults: defaults, register: registerValue, observeChanges: !callback.isNil)
        self.init(adapter: adapter, callback: callback)
    }
}

public extension DefaultsValue where Element: UserDefaultsConvertible {
    
    /// Creates an adaptor to a `UserDefaults` value conforming to `UserDefaulsConvertible` linked to the given key.
    /// - Parameters:
    ///   - key: The key with which to associate the value.
    ///   - initialValue: The default value.
    ///   - defaults: The `UserDefaults` instance where to do it.
    ///   - registerValue: A boolean value that indicates if the default value should be added to de registration domain.
    ///   - callback: A callback called everytime the value changes.
    init(key: UserDefaultsKeyName,
         initialValue: Element,
         defaults: UserDefaults = .standard,
         registerValue: Bool = true,
         onChange callback: ChangeCallback? = nil) {
        let adapter = UserDefaultsUserDefaultsConvertibleValueAdapter(key: key.rawValue, defaultValue: { initialValue }, defaults: defaults, register: registerValue, observeChanges: !callback.isNil)
        self.init(adapter: adapter, callback: callback)
    }
}

public extension DefaultsValue where Element: UserDefaultsCodable {
    
    /// Creates an adaptor to a `UserDefaults` value conforming to `UserDefaultsCodable` linked to the given key.
    /// - Parameters:
    ///   - key: The key with which to associate the value.
    ///   - initialValue: The default value.
    ///   - defaults: The `UserDefaults` instance where to do it.
    ///   - registerValue: A boolean value that indicates if the default value should be added to de registration domain.
    ///   - callback: A callback called everytime the value changes.
    init(key: UserDefaultsKeyName,
         initialValue: Element,
         defaults: UserDefaults = .standard,
         registerValue: Bool = true,
         onChange callback: ChangeCallback? = nil) {
        let adapter = UserDefaultsUserDefaultsCodableValueAdapter(key: key.rawValue, defaultValue: { initialValue }, defaults: defaults, register: registerValue, observeChanges: !callback.isNil)
        self.init(adapter: adapter, callback: callback)
    }
}

public extension DefaultsValue where Element: OptionalType, Element.Wrapped: PropertyListSerializable {
    
    /// Creates an adaptor to a `UserDefaults` optional value conforming to `PropertyListSerializable` linked to the given key.
    /// - Parameters:
    ///   - key: The key with which to associate the value.
    ///   - initialValue: The default value.
    ///   - defaults: The `UserDefaults` instance where to do it.
    ///   - registerValue: A boolean value that indicates if the default value should be added to de registration domain.
    ///   - callback: A callback called everytime the value changes.
    init(key: UserDefaultsKeyName,
         initialValue: Element,
         defaults: UserDefaults = .standard,
         registerValue: Bool = true,
         onChange callback: ChangeCallback? = nil) {
        let adapter = UserDefaultsOptionalValueAdapter(key: key.rawValue, defaultValue: { initialValue }, defaults: defaults, register: registerValue, observeChanges: !callback.isNil)
        self.init(adapter: adapter, callback: callback)
    }
}

public extension DefaultsValue where Element: OptionalType, Element.Wrapped: RawRepresentable, Element.Wrapped.RawValue: PropertyListSerializable {
    
    /// Creates an adaptor to a `UserDefaults` optional value conforming to `RawRepresentable` and its corresponding `RawValue` conforms to `PropertyListSerializable` linked to the given key.
    /// - Parameters:
    ///   - key: The key with which to associate the value.
    ///   - initialValue: The default value.
    ///   - defaults: The `UserDefaults` instance where to do it.
    ///   - registerValue: A boolean value that indicates if the default value should be added to de registration domain.
    ///   - callback: A callback called everytime the value changes.
    init(key: UserDefaultsKeyName,
         initialValue: Element,
         defaults: UserDefaults = .standard,
         registerValue: Bool = true,
         onChange callback: ChangeCallback? = nil) {
        let adapter = UserDefaultsOptionalRawRepresentableValueAdapter(key: key.rawValue, defaultValue: { initialValue }, defaults: defaults, register: registerValue, observeChanges: !callback.isNil)
        self.init(adapter: adapter, callback: callback)
    }
}

public extension DefaultsValue where Element: OptionalType, Element.Wrapped: UserDefaultsConvertible {
    
    /// Creates an adaptor to a `UserDefaults` optional value conforming to `UserDefaulsConvertible` linked to the given key.
    /// - Parameters:
    ///   - key: The key with which to associate the value.
    ///   - initialValue: The default value.
    ///   - defaults: The `UserDefaults` instance where to do it.
    ///   - registerValue: A boolean value that indicates if the default value should be added to de registration domain.
    ///   - callback: A callback called everytime the value changes.
    init(key: UserDefaultsKeyName,
         initialValue: Element,
         defaults: UserDefaults = .standard,
         registerValue: Bool = true,
         onChange callback: ChangeCallback? = nil) {
        let adapter = UserDefaultsOptionalUserDefaultsConvertibleValueAdapter(key: key.rawValue, defaultValue: { initialValue }, defaults: defaults, register: registerValue, observeChanges: !callback.isNil)
        self.init(adapter: adapter, callback: callback)
    }
}

public extension DefaultsValue where Element: OptionalType, Element.Wrapped: UserDefaultsCodable {
    
    /// Creates an adaptor to a `UserDefaults` optional value conforming to `UserDefaulsCodable` linked to the given key.
    /// - Parameters:
    ///   - key: The key with which to associate the value.
    ///   - initialValue: The default value.
    ///   - defaults: The `UserDefaults` instance where to do it.
    ///   - registerValue: A boolean value that indicates if the default value should be added to de registration domain.
    ///   - callback: A callback called everytime the value changes.
    init(key: UserDefaultsKeyName,
         initialValue: Element,
         defaults: UserDefaults = .standard,
         registerValue: Bool = true,
         onChange callback: ChangeCallback? = nil) {
        let adapter = UserDefaultsOptionalUserDefaultsCodableValueAdapter(key: key.rawValue, defaultValue: { initialValue }, defaults: defaults, register: registerValue, observeChanges: !callback.isNil)
        self.init(adapter: adapter, callback: callback)
    }
}
#endif
