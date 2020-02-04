//
//  Default.swift
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

@available(*, deprecated, renamed: "Defaults")
public typealias Default = Defaults


/// A type linked to an user's defaults entry associated with a key, that can provide a default value and automatically register it.
@propertyWrapper public struct Defaults<Element> {
    
    public typealias DefaultValueProvider = () -> Element
    
    private typealias GetterBlock = () -> Element
    private typealias SetterBlock = (Element) -> ()
    
    private let getter: GetterBlock
    private let setter: SetterBlock
    
    public var wrappedValue: Element {
        get { self.getter() }
        nonmutating set { self.setter(newValue) }
    }
    
    private init(getter: @escaping GetterBlock, setter: @escaping SetterBlock) {
        self.getter = getter
        self.setter = setter
    }
}

// MARK: - Non-Optional
// MARK: PropertyListSerializable
public extension Defaults where Element: PropertyListSerializable {
    
    /// Creates a users's defaults wrapper associated with the given key which wrapped type conforms to `PropertyListSerializable`.
    ///
    /// - Parameters:
    ///   - key: The key with which to associate the wrapped value.
    ///   - defaultValue: An expression of the wrapped type.
    ///   - defaults: The `UserDefaults` instance where to do it.
    ///   - registerValue: A boolean value that indicates if the default value should be added to de registration domain.
    init(key: UserDefaultsKeyName, defaultValue: @autoclosure DefaultValueProvider, defaults: UserDefaults = .standard, registerValue: Bool = true) {
        let defaultName = key.rawValue
        let initialValue = defaultValue()
        
        let getter: GetterBlock = { defaults.object(forKey: defaultName) as? Element ?? initialValue }
        let setter: SetterBlock = { defaults.set($0, forKey: defaultName) }
        
        self = Self(getter: getter, setter: setter)
        
        if registerValue, !defaults.hasValue(forKey: defaultName) {
            defaults.register(initialValue, forKey: defaultName)
        }
    }
}

// MARK: RawRepresentable

public extension Defaults where Element: RawRepresentable, Element.RawValue: PropertyListSerializable {
    
    /// Creates a users's defaults wrapper associated with the given key which wrapped type conforms to `RawRepresentable` and its corresponding `RawValue` conforms to `PropertyListSerializable`.
    ///
    /// - Parameters:
    ///   - key: The key with which to associate the wrapped value.
    ///   - defaultValue: An expression of the wrapped type.
    ///   - defaults: The `UserDefaults` instance where to do it.
    ///   - registerValue: A boolean value that indicates if the default value should be added to de registration domain.
    init(key: UserDefaultsKeyName, defaultValue: @autoclosure DefaultValueProvider, defaults: UserDefaults = .standard, registerValue: Bool = true) {
        let defaultName = key.rawValue
        let initialValue = defaultValue()
        
        let getter: GetterBlock = { defaults.rawReprensentable(forKey: defaultName) ?? initialValue }
        let setter: SetterBlock = { defaults.set($0, forKey: defaultName) }
        
        self = Self(getter: getter, setter: setter)
        
        if registerValue, !defaults.hasValue(forKey: defaultName) {
            defaults.register(initialValue, forKey: defaultName)
        }
    }
}

// MARK: UserDefaultsConvertible

public extension Defaults where Element: UserDefaultsConvertible {
    
    /// Creates a users's defaults wrapper associated with the given key which wrapped type conforms to `UserDefaultsSerializable`.
    ///
    /// - Parameters:
    ///   - key: The key with which to associate the wrapped value.
    ///   - defaultValue: An expression of the wrapped type.
    ///   - defaults: The `UserDefaults` instance where to do it.
    ///   - registerValue: A boolean value that indicates if the default value should be added to de registration domain.
    init(key: UserDefaultsKeyName, defaultValue: @autoclosure DefaultValueProvider, defaults: UserDefaults = .standard, registerValue: Bool = true) {
        let defaultName = key.rawValue
        let initialValue = defaultValue()
        
        let getter: GetterBlock = { SerializableAdapater.deserialize(from: defaults, withKey: defaultName) ?? initialValue }
        let setter: SetterBlock = { SerializableAdapater($0).serialize(in: defaults, withKey: defaultName)}
        
        
        self = Self(getter: getter, setter: setter)
        
        if registerValue, !defaults.hasValue(forKey: defaultName) {
            SerializableAdapater(initialValue).register(in: defaults, withKey: defaultName)
        }
    }
}

// MARK: - Optional
// MARK: PropertyListSerializable

public extension Defaults where Element: OptionalType, Element.Wrapped: PropertyListSerializable {
    
    /// Creates a users's defaults wrapper associated with the given key which wrapped type is an optional and conforms to `PropertyListSerializable`.
    ///
    /// - Note:
    ///     If the expression `defaultValue` returns `nil` setting the wrapped value to `nil` at some point will remove the entry from the `UserDefaults` instance's registration domain.
    ///
    /// - Parameters:
    ///   - key: The key with which to associate the wrapped value.
    ///   - defaultValue: An expression of the wrapped type.
    ///   - defaults: The `UserDefaults` instance where to do it.
    ///   - registerValue: A boolean value that indicates if the default value should be added to de registration domain. Ignored if `defaultValue` return `nil`.
    init(key: UserDefaultsKeyName, defaultValue: @autoclosure DefaultValueProvider = Element.nil, defaults: UserDefaults = .standard, registerValue: Bool = true) {
        let defaultName = key.rawValue
        let initialValue = defaultValue()
        
        let getter: GetterBlock = { defaults.object(forKey: defaultName) as? Element ?? initialValue }
        let setter: SetterBlock = {
            $0.wrapped.map { defaults.set($0, forKey: defaultName) }
            if $0.wrapped == nil {
                defaults.removeObject(forKey: defaultName)
            }
        }
        
        self = Self(getter: getter, setter: setter)
        
        if registerValue, !defaults.hasValue(forKey: defaultName) {
            initialValue.wrapped.map { defaults.register($0, forKey: defaultName) }
        }
    }
}
// MARK: RawRepresentable

public extension Defaults where Element: OptionalType, Element.Wrapped: RawRepresentable, Element.Wrapped.RawValue: PropertyListSerializable {
    
    /// Creates a users's defaults wrapper associated with the given key which wrapped type is an optional and conforms to `RawRepresentable` and its corresponding `RawValue` conforms to `PropertyListSerializable`.
    ///
    /// - Note:
    ///     If the expression `defaultValue` returns `nil` setting the wrapped value to `nil` at some point will remove the entry from the `UserDefaults` instance's registration domain.
    ///
    /// - Parameters:
    ///   - key: The key with which to associate the wrapped value.
    ///   - defaultValue: An expression of the wrapped type.
    ///   - defaults: The `UserDefaults` instance where to do it.
    ///   - registerValue: A boolean value that indicates if the default value should be added to de registration domain. Ignored if `defaultValue` return `nil`.
    init(key: UserDefaultsKeyName, defaultValue: @autoclosure DefaultValueProvider = Element.nil, defaults: UserDefaults = .standard, registerValue: Bool = true) {
        let defaultName = key.rawValue
        let initialValue = defaultValue()
        
        let getter: GetterBlock = { defaults.rawReprensentable(forKey: defaultName).map(Element.wrap) ?? initialValue }
        let setter: SetterBlock = {
            $0.wrapped.map { defaults.set($0, forKey: defaultName) }
            if $0.wrapped == nil {
                defaults.removeObject(forKey: defaultName)
            }
        }
        
        self = Self(getter: getter, setter: setter)
        
        if registerValue, !defaults.hasValue(forKey: defaultName) {
            initialValue.wrapped.map { defaults.register($0, forKey: defaultName) }
        }
    }
}

// MARK: UserDefaultsSerializable
public extension Defaults where Element: OptionalType, Element.Wrapped: UserDefaultsConvertible {
    
    /// Creates a users's defaults wrapper associated with the given key which wrapped type is an optional and conforms to `UserDefaultsSerializable`.
    ///
    /// - Note:
    ///     If the expression `defaultValue` returns `nil` setting the wrapped value to `nil` at some point will remove the entry from the `UserDefaults` instance's registration domain.
    ///
    /// - Parameters:
    ///   - key: The key with which to associate the wrapped value.
    ///   - defaultValue: An expression of the wrapped type.
    ///   - defaults: The `UserDefaults` instance where to do it.
    ///   - registerValue: A boolean value that indicates if the default value should be added to de registration domain. Ignored if `defaultValue` return `nil`.
    init(key: UserDefaultsKeyName, defaultValue: @autoclosure DefaultValueProvider = Element.nil, defaults: UserDefaults = .standard, registerValue: Bool = true) {
        let defaultName = key.rawValue
        let initialValue = defaultValue()
        
        let getter: GetterBlock = { (SerializableAdapater.deserialize(from: defaults, withKey: defaultName)).map(Element.wrap) ?? initialValue }
        let setter: SetterBlock = {
            $0.wrapped.map { SerializableAdapater($0).serialize(in: defaults, withKey: defaultName) }
            if $0.wrapped == nil {
                defaults.removeObject(forKey: defaultName)
            }
        }
        
        self = Self(getter: getter, setter: setter)
        
        if registerValue, !defaults.hasValue(forKey: defaultName) {
            initialValue.wrapped.map { SerializableAdapater($0).register(in: defaults, withKey: defaultName) }
        }
    }
}
