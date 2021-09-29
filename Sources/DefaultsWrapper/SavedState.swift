//
//  SavedState.swift
//
//  DefaultsWrapper
//
//  MIT License
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

#if !os(Linux)
import SwiftUI

/// A property wrapper type that can read and write a value managed by SwiftUI and persisted to `UserDefaults`.
///
/// The initial value is read from `UserDefaults` using the given key and each subsequent value is written to it. The view is not invalidated on changes made directly or indirectly to `UserDefaults`.
@propertyWrapper public struct SavedState<Element>: DynamicProperty {
    
    /// The underlying value.
    public var wrappedValue: Element {
        get { adapter.value }
        nonmutating set { adapter.setValue(newValue) }
    }
    
    /// A binding to the value.
    public var projectedValue: Binding<Element> {
        .init { adapter.value }
        set: { adapter.setValue($0) }
    }
    
    @StateObject private var adapter: UserDefaultsValueAdapter<Element>
    
    private init(adapter: @autoclosure @escaping () -> UserDefaultsValueAdapter<Element>) {
        self._adapter = .init(wrappedValue: adapter())
    }
}

public extension SavedState where Element: PropertyListSerializable {
    
    /// Creates a dynamic `UserDefaults` wrapper associated with the given key which wrapped type conforms to `PropertyListSerializable`.
    ///
    /// - Parameters:
    ///   - wrappedValue: The default value.
    ///   - key: The key with which to associate the wrapped value.
    ///   - defaults: The `UserDefaults` instance where to do it.
    ///   - registerValue: A boolean value that indicates if the default value should be added to de registration domain.
    init(wrappedValue initialValue: @autoclosure @escaping () -> Element, _ key: UserDefaultsKeyName, defaults: UserDefaults = .standard, registerValue: Bool = true) {
        self.init(adapter: UserDefaultsValueAdapter<Element>(key: key.rawValue, defaultValue: initialValue, defaults: defaults, register: registerValue, observeChanges: false))
    }
}

public extension SavedState where Element: RawRepresentable, Element.RawValue: PropertyListSerializable {
    /// Creates a dymanic `UserDefaults` wrapper associated with the given key which wrapped type conforms to `RawRepresentable` and its corresponding `RawValue` conforms to `PropertyListSerializable`.
    ///
    /// - Parameters:
    ///   - wrappedValue: The default value.
    ///   - key: The key with which to associate the wrapped value.
    ///   - defaults: The `UserDefaults` instance where to do it.
    ///   - registerValue: A boolean value that indicates if the default value should be added to de registration domain.
    init(wrappedValue initialValue: @autoclosure @escaping () -> Element, _ key: UserDefaultsKeyName, defaults: UserDefaults = .standard, registerValue: Bool = true) {
        self.init(adapter: UserDefaultsRawRepresentableValueAdapter(key: key.rawValue, defaultValue: initialValue, defaults: defaults, register: registerValue, observeChanges: false))
    }
}

public extension SavedState where Element: UserDefaultsConvertible {
    
    /// Creates a dynamic `UserDefaults` wrapper associated with the given key which wrapped type conforms to `UserDefaultsConvertible`.
    ///
    /// - Parameters:
    ///   - wrappedValue: The default value.
    ///   - key: The key with which to associate the wrapped value.
    ///   - defaults: The `UserDefaults` instance where to do it.
    ///   - registerValue: A boolean value that indicates if the default value should be added to de registration domain.
    init(wrappedValue initialValue: @autoclosure @escaping () -> Element, _ key: UserDefaultsKeyName, defaults: UserDefaults = .standard, registerValue: Bool = true) {
        self.init(adapter: UserDefaultsUserDefaultsConvertibleValueAdapter(key: key.rawValue, defaultValue: initialValue, defaults: defaults, register: registerValue, observeChanges: false))
    }
}

public extension SavedState where Element: UserDefaultsCodable {
    
    /// Creates a dynamic `UserDefaults` wrapper associated with the given key which wrapped type conforms to `UserDefaultsCodable`.
    ///
    /// - Parameters:
    ///   - wrappedValue: The default value.
    ///   - key: The key with which to associate the wrapped value.
    ///   - defaults: The `UserDefaults` instance where to do it.
    ///   - registerValue: A boolean value that indicates if the default value should be added to de registration domain.
    init(wrappedValue initialValue: @autoclosure @escaping () -> Element, _ key: UserDefaultsKeyName, defaults: UserDefaults = .standard, registerValue: Bool = true) {
        self.init(adapter: UserDefaultsUserDefaultsCodableValueAdapter(key: key.rawValue, defaultValue: initialValue, defaults: defaults, register: registerValue, observeChanges: false))
    }
}


public extension SavedState where Element: AnyOptional, Element.Wrapped: PropertyListSerializable {
    
    /// Creates a dynamic `UserDefaults` wrapper associated with the given key which wrapped type is an optional and conforms to `PropertyListSerializable`.
    ///
    /// - Note:
    ///     If the expression `defaultValue` returns `nil` setting the wrapped value to `nil` at some point will remove the entry from the `UserDefaults` instance's registration domain.
    ///
    /// - Parameters:
    ///   - wrappedValue: The default value.
    ///   - key: The key with which to associate the wrapped value.
    ///   - defaults: The `UserDefaults` instance where to do it.
    ///   - registerValue: A boolean value that indicates if the default value should be added to de registration domain. Ignored if `defaultValue` return `nil`.
    init(wrappedValue initialValue: @autoclosure @escaping () -> Element = .nilValue, _ key: UserDefaultsKeyName, defaults: UserDefaults = .standard, registerValue: Bool = true) {
        self.init(adapter: UserDefaultsOptionalValueAdapter<Element>(key: key.rawValue, defaultValue: initialValue, defaults: defaults, register: registerValue, observeChanges: false))
    }
}

public extension SavedState where Element: AnyOptional, Element.Wrapped: RawRepresentable, Element.Wrapped.RawValue: PropertyListSerializable {
    
    /// Creates dynamic a `UserDefaults` wrapper associated with the given key which wrapped type is an optional and conforms to `RawRepresentable` and its corresponding `RawValue` conforms to `PropertyListSerializable`.
    ///
    /// - Note:
    ///     If the expression `defaultValue` returns `nil` setting the wrapped value to `nil` at some point will remove the entry from the `UserDefaults` instance's registration domain.
    ///
    /// - Parameters:
    ///   - wrappedValue: The default value.
    ///   - key: The key with which to associate the wrapped value.
    ///   - defaults: The `UserDefaults` instance where to do it.
    ///   - registerValue: A boolean value that indicates if the default value should be added to de registration domain. Ignored if `defaultValue` return `nil`.
    init(wrappedValue initialValue: @autoclosure @escaping () -> Element = .nilValue, _ key: UserDefaultsKeyName, defaults: UserDefaults = .standard, registerValue: Bool = true) {
        self.init(adapter: UserDefaultsOptionalRawRepresentableValueAdapter(key: key.rawValue, defaultValue: initialValue, defaults: defaults, register: registerValue, observeChanges: false))
    }
}

public extension SavedState where Element: AnyOptional, Element.Wrapped: UserDefaultsConvertible {
    
    /// Creates a `UserDefaults` wrapper associated with the given key which wrapped type is an optional and conforms to `UserDefaultsConvertible`.
    ///
    /// - Note:
    ///     If the expression `defaultValue` returns `nil` setting the wrapped value to `nil` at some point will remove the entry from the `UserDefaults` instance's registration domain.
    ///
    /// - Parameters:
    ///   - wrappedValue: The default value.
    ///   - key: The key with which to associate the wrapped value.
    ///   - defaults: The `UserDefaults` instance where to do it.
    ///   - registerValue: A boolean value that indicates if the default value should be added to de registration domain. Ignored if `defaultValue` return `nil`.
    init(wrappedValue initialValue: @autoclosure @escaping () -> Element = .nilValue, _ key: UserDefaultsKeyName, defaults: UserDefaults = .standard, registerValue: Bool = true) {
        self.init(adapter: UserDefaultsOptionalUserDefaultsConvertibleValueAdapter(key: key.rawValue, defaultValue: initialValue, defaults: defaults, register: registerValue, observeChanges: false))
    }
}

public extension SavedState where Element: AnyOptional, Element.Wrapped: UserDefaultsCodable {
    
    /// Creates a `UserDefaults` wrapper associated with the given key which wrapped type is an optional and conforms to `UserDefaultsCodable`.
    ///
    /// - Note:
    ///     If the expression `defaultValue` returns `nil` setting the wrapped value to `nil` at some point will remove the entry from the `UserDefaults` instance's registration domain.
    ///
    /// - Parameters:
    ///   - wrappedValue: The default value.
    ///   - key: The key with which to associate the wrapped value.
    ///   - defaults: The `UserDefaults` instance where to do it.
    ///   - registerValue: A boolean value that indicates if the default value should be added to de registration domain. Ignored if `defaultValue` return `nil`.
    init(wrappedValue initialValue: @autoclosure @escaping () -> Element = .nilValue, _ key: UserDefaultsKeyName, defaults: UserDefaults = .standard, registerValue: Bool = true) {
        self.init(adapter: UserDefaultsOptionalUserDefaultsCodableValueAdapter(key: key.rawValue, defaultValue: initialValue, defaults: defaults, register: registerValue, observeChanges: false))
    }
}
#endif
