//
//  Defaults.swift
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

typealias UserDefault = UserDefaults

/// Keeps compatibility with previous versions.
@available(*, deprecated, renamed: "Defaults")
public typealias Default = Defaults


/// A type linked to an `Userdefaults` entry associated with a key, that can provide a default value and automatically register it.
@propertyWrapper public struct Defaults<Element> {
    private typealias GetterBlock = () -> Element
    private typealias SetterBlock = (Element) -> ()

    private let getter: GetterBlock
    private let setter: SetterBlock
    
    /// The underlying value.
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
    
    /// Creates a `UserDefaults` wrapper associated with the given key which wrapped type conforms to `PropertyListSerializable`.
    ///
    /// - Parameters:
    ///   - key: The key with which to associate the wrapped value.
    ///   - defaultValue: An expression of the wrapped type.
    ///   - defaults: The `UserDefaults` instance where to do it.
    ///   - registerValue: A boolean value that indicates if the default value should be added to de registration domain.
    @available(*, deprecated)
    init(key: UserDefaultsKeyName, defaultValue: @escaping @autoclosure () -> Element, defaults: UserDefaults = .standard, registerValue: Bool = true) {
        let defaultName = key.rawValue
        
        let getter: GetterBlock = { defaults.object(forKey: defaultName) as? Element ?? defaultValue() }
        let setter: SetterBlock = { defaults.set($0, forKey: defaultName) }
        
        self.init(getter: getter, setter: setter)

        if registerValue, !defaults.hasValue(forKey: defaultName) {
            defaults.register(defaultValue(), forKey: defaultName)
        }
    }

    /// Creates a `UserDefaults` wrapper associated with the given key which wrapped type conforms to `PropertyListSerializable`.
    ///
    /// - Parameters:
    ///   - key: The key with which to associate the wrapped value.
    ///   - value: An expression of the wrapped type.
    ///   - defaults: The `UserDefaults` instance where to do it.
    ///   - registerValue: A boolean value that indicates if the default value should be added to de registration domain.
    @available(*, deprecated)
    init(_ key: UserDefaultsKeyName, value: @escaping @autoclosure () -> Element, defaults: UserDefaults = .standard, registerValue: Bool = true) {
        let defaultName = key.rawValue

        let getter: GetterBlock = { defaults.object(forKey: defaultName) as? Element ?? value() }
        let setter: SetterBlock = { defaults.set($0, forKey: defaultName) }

        self.init(getter: getter, setter: setter)

        if registerValue, !defaults.hasValue(forKey: defaultName) {
            defaults.register(value(), forKey: defaultName)
        }
    }

    /// Creates a users defaults wrapper associated with the given key which wrapped type conforms to `PropertyListSerializable`.
    ///
    /// - Parameters:
    ///   - wrappedValue: The default value.
    ///   - key: The key with which to associate the wrapped value.
    ///   - defaults: The `UserDefaults` instance where to do it.
    ///   - registerValue: A boolean value that indicates if the default value should be added to de registration domain.
    init(wrappedValue initialValue: @escaping @autoclosure () -> Element, _ key: UserDefaultsKeyName, defaults: UserDefaults = .standard, registerValue: Bool = true) {
        let defaultName = key.rawValue

        let getter: GetterBlock = { defaults.object(forKey: defaultName) as? Element ?? initialValue() }
        let setter: SetterBlock = { defaults.set($0, forKey: defaultName) }

        self.init(getter: getter, setter: setter)

        if registerValue, !defaults.hasValue(forKey: defaultName) {
            defaults.register(initialValue(), forKey: defaultName)
        }
    }
}

// MARK: RawRepresentable

public extension Defaults where Element: RawRepresentable, Element.RawValue: PropertyListSerializable {
    
    /// Creates a `UserDefaults` wrapper associated with the given key which wrapped type conforms to `RawRepresentable` and its corresponding `RawValue` conforms to `PropertyListSerializable`.
    ///
    /// - Parameters:
    ///   - key: The key with which to associate the wrapped value.
    ///   - defaultValue: An expression of the wrapped type.
    ///   - defaults: The `UserDefaults` instance where to do it.
    ///   - registerValue: A boolean value that indicates if the default value should be added to de registration domain.
    @available(*, deprecated)
    init(key: UserDefaultsKeyName, defaultValue: @escaping @autoclosure () -> Element, defaults: UserDefaults = .standard, registerValue: Bool = true) {
        let defaultName = key.rawValue
        
        let getter: GetterBlock = { defaults.rawReprensentable(forKey: defaultName) ?? defaultValue() }
        let setter: SetterBlock = { defaults.set($0, forKey: defaultName) }
        
        self.init(getter: getter, setter: setter)
        
        if registerValue, !defaults.hasValue(forKey: defaultName) {
            defaults.register(defaultValue(), forKey: defaultName)
        }
    }

    /// Creates a `UserDefaults` wrapper associated with the given key which wrapped type conforms to `RawRepresentable` and its corresponding `RawValue` conforms to `PropertyListSerializable`.
    ///
    /// - Parameters:
    ///   - key: The key with which to associate the wrapped value.
    ///   - value: An expression of the wrapped type.
    ///   - defaults: The `UserDefaults` instance where to do it.
    ///   - registerValue: A boolean value that indicates if the default value should be added to de registration domain.
    @available(*, deprecated)
    init(_ key: UserDefaultsKeyName, value: @escaping @autoclosure () -> Element, defaults: UserDefaults = .standard, registerValue: Bool = true) {
        let defaultName = key.rawValue

        let getter: GetterBlock = { defaults.rawReprensentable(forKey: defaultName) ?? value() }
        let setter: SetterBlock = { defaults.set($0, forKey: defaultName) }

        self.init(getter: getter, setter: setter)

        if registerValue, !defaults.hasValue(forKey: defaultName) {
            defaults.register(value(), forKey: defaultName)
        }
    }

    /// Creates a `UserDefaults` wrapper associated with the given key which wrapped type conforms to `RawRepresentable` and its corresponding `RawValue` conforms to `PropertyListSerializable`.
    ///
    /// - Parameters:
    ///   - wrappedValue: The default value.
    ///   - key: The key with which to associate the wrapped value.
    ///   - defaults: The `UserDefaults` instance where to do it.
    ///   - registerValue: A boolean value that indicates if the default value should be added to de registration domain.
    init(wrappedValue initialValue: @escaping @autoclosure () -> Element, _ key: UserDefaultsKeyName, defaults: UserDefaults = .standard, registerValue: Bool = true) {
        let defaultName = key.rawValue

        let getter: GetterBlock = { defaults.rawReprensentable(forKey: defaultName) ?? initialValue() }
        let setter: SetterBlock = { defaults.set($0, forKey: defaultName) }

        self.init(getter: getter, setter: setter)

        if registerValue, !defaults.hasValue(forKey: defaultName) {
            defaults.register(initialValue(), forKey: defaultName)
        }
    }
}

// MARK: UserDefaultsConvertible

public extension Defaults where Element: UserDefaultsConvertible {
    
    /// Creates a `UserDefaults` wrapper associated with the given key which wrapped type conforms to `UserDefaultsConvertible`.
    ///
    /// - Parameters:
    ///   - key: The key with which to associate the wrapped value.
    ///   - defaultValue: An expression of the wrapped type.
    ///   - defaults: The `UserDefaults` instance where to do it.
    ///   - registerValue: A boolean value that indicates if the default value should be added to de registration domain.
    @available(*, deprecated)
    init(key: UserDefaultsKeyName, defaultValue: @escaping @autoclosure () -> Element, defaults: UserDefaults = .standard, registerValue: Bool = true) {
        let defaultName = key.rawValue
        
        let getter: GetterBlock = { SerializableAdapter.deserialize(from: defaults, withKey: defaultName) ?? defaultValue() }
        let setter: SetterBlock = { SerializableAdapter($0).serialize(in: defaults, withKey: defaultName)}
        
        self.init(getter: getter, setter: setter)
        
        if registerValue, !defaults.hasValue(forKey: defaultName) {
            SerializableAdapter(defaultValue()).register(in: defaults, withKey: defaultName)
        }
    }

    /// Creates a `UserDefaults` wrapper associated with the given key which wrapped type conforms to `UserDefaultsConvertible`.
    ///
    /// - Parameters:
    ///   - key: The key with which to associate the wrapped value.
    ///   - value: An expression of the wrapped type.
    ///   - defaults: The `UserDefaults` instance where to do it.
    ///   - registerValue: A boolean value that indicates if the default value should be added to de registration domain.
    @available(*, deprecated)
    init(_ key: UserDefaultsKeyName, value: @escaping @autoclosure () -> Element, defaults: UserDefaults = .standard, registerValue: Bool = true) {
        let defaultName = key.rawValue

        let getter: GetterBlock = { SerializableAdapter.deserialize(from: defaults, withKey: defaultName) ?? value() }
        let setter: SetterBlock = { SerializableAdapter($0).serialize(in: defaults, withKey: defaultName)}

        self.init(getter: getter, setter: setter)

        if registerValue, !defaults.hasValue(forKey: defaultName) {
            SerializableAdapter(value()).register(in: defaults, withKey: defaultName)
        }
    }

    /// Creates a `UserDefaults` wrapper associated with the given key which wrapped type conforms to `UserDefaultsConvertible`.
    ///
    /// - Parameters:
    ///   - wrappedValue: The default value.
    ///   - key: The key with which to associate the wrapped value.
    ///   - defaults: The `UserDefaults` instance where to do it.
    ///   - registerValue: A boolean value that indicates if the default value should be added to de registration domain.
    init(wrappedValue initialValue: @escaping @autoclosure () -> Element, _ key: UserDefaultsKeyName, defaults: UserDefaults = .standard, registerValue: Bool = true) {
        let defaultName = key.rawValue

        let getter: GetterBlock = { SerializableAdapter.deserialize(from: defaults, withKey: defaultName) ?? initialValue() }
        let setter: SetterBlock = { SerializableAdapter($0).serialize(in: defaults, withKey: defaultName)}

        self.init(getter: getter, setter: setter)

        if registerValue, !defaults.hasValue(forKey: defaultName) {
            SerializableAdapter(initialValue()).register(in: defaults, withKey: defaultName)
        }
    }
}

// MARK: - Optional
// MARK: PropertyListSerializable

public extension Defaults where Element: AnyOptional, Element.Wrapped: PropertyListSerializable {
    
    /// Creates a `UserDefaults` wrapper associated with the given key which wrapped type is an optional and conforms to `PropertyListSerializable`.
    ///
    /// - Note:
    ///     If the expression `defaultValue` returns `nil` setting the wrapped value to `nil` at some point will remove the entry from the `UserDefaults` instance's registration domain.
    ///
    /// - Parameters:
    ///   - key: The key with which to associate the wrapped value.
    ///   - defaultValue: An expression of the wrapped type.
    ///   - defaults: The `UserDefaults` instance where to do it.
    ///   - registerValue: A boolean value that indicates if the default value should be added to de registration domain. Ignored if `defaultValue` return `nil`.
    @available(*, deprecated)
    init(key: UserDefaultsKeyName, defaultValue: @escaping @autoclosure () -> Element = .nilValue, defaults: UserDefaults = .standard, registerValue: Bool = true) {
        let defaultName = key.rawValue
        
        let getter: GetterBlock = { defaults.object(forKey: defaultName) as? Element ?? defaultValue() }
        let setter: SetterBlock = {
            $0.wrappedValue.map { defaults.set($0, forKey: defaultName) }
            if $0.wrappedValue == nil {
                defaults.removeObject(forKey: defaultName)
            }
        }
        
        self.init(getter: getter, setter: setter)
        
        if registerValue, !defaults.hasValue(forKey: defaultName) {
            defaultValue().wrappedValue.map { defaults.register($0, forKey: defaultName) }
        }
    }

    /// Creates a users's defaults wrapper associated with the given key which wrapped type is an optional and conforms to `PropertyListSerializable`.
    ///
    /// - Note:
    ///     If the expression `defaultValue` returns `nil` setting the wrapped value to `nil` at some point will remove the entry from the `UserDefaults` instance's registration domain.
    ///
    /// - Parameters:
    ///   - key: The key with which to associate the wrapped value.
    ///   - value: An expression of the wrapped type.
    ///   - defaults: The `UserDefaults` instance where to do it.
    ///   - registerValue: A boolean value that indicates if the default value should be added to de registration domain. Ignored if `defaultValue` return `nil`.
    @available(*, deprecated)
    init(_ key: UserDefaultsKeyName, value: @escaping @autoclosure () -> Element, defaults: UserDefaults = .standard, registerValue: Bool = true) {
        let defaultName = key.rawValue

        let getter: GetterBlock = { defaults.object(forKey: defaultName) as? Element ?? value() }
        let setter: SetterBlock = {
            $0.wrappedValue.map { defaults.set($0, forKey: defaultName) }
            if $0.wrappedValue == nil {
                defaults.removeObject(forKey: defaultName)
            }
        }

        self.init(getter: getter, setter: setter)

        if registerValue, !defaults.hasValue(forKey: defaultName) {
            value().wrappedValue.map { defaults.register($0, forKey: defaultName) }
        }
    }

    /// Creates a `UserDefaults` wrapper associated with the given key which wrapped type is an optional and conforms to `PropertyListSerializable`.
    ///
    /// - Note:
    ///     If the expression `defaultValue` returns `nil` setting the wrapped value to `nil` at some point will remove the entry from the `UserDefaults` instance's registration domain.
    ///
    /// - Parameters:
    ///   - wrappedValue: The default value.
    ///   - key: The key with which to associate the wrapped value.
    ///   - defaults: The `UserDefaults` instance where to do it.
    ///   - registerValue: A boolean value that indicates if the default value should be added to de registration domain. Ignored if `defaultValue` return `nil`.
    init(wrappedValue initialValue: @escaping @autoclosure () -> Element = .nilValue, _ key: UserDefaultsKeyName, defaults: UserDefaults = .standard, registerValue: Bool = true) {
        let defaultName = key.rawValue

        let getter: GetterBlock = { defaults.object(forKey: defaultName) as? Element ?? initialValue() }
        let setter: SetterBlock = {
            $0.wrappedValue.map { defaults.set($0, forKey: defaultName) }
            if $0.wrappedValue == nil {
                defaults.removeObject(forKey: defaultName)
            }
        }

        self.init(getter: getter, setter: setter)

        if registerValue, !defaults.hasValue(forKey: defaultName) {
            initialValue().wrappedValue.map { defaults.register($0, forKey: defaultName) }
        }
    }
}
// MARK: RawRepresentable

public extension Defaults where Element: AnyOptional, Element.Wrapped: RawRepresentable, Element.Wrapped.RawValue: PropertyListSerializable {
    
    /// Creates a `UserDefaults` wrapper associated with the given key which wrapped type is an optional and conforms to `RawRepresentable` and its corresponding `RawValue` conforms to `PropertyListSerializable`.
    ///
    /// - Note:
    ///     If the expression `defaultValue` returns `nil` setting the wrapped value to `nil` at some point will remove the entry from the `UserDefaults` instance's registration domain.
    ///
    /// - Parameters:
    ///   - key: The key with which to associate the wrapped value.
    ///   - defaultValue: An expression of the wrapped type.
    ///   - defaults: The `UserDefaults` instance where to do it.
    ///   - registerValue: A boolean value that indicates if the default value should be added to de registration domain. Ignored if `defaultValue` return `nil`.
    @available(*, deprecated)
    init(key: UserDefaultsKeyName, defaultValue: @escaping @autoclosure () -> Element = .nilValue, defaults: UserDefaults = .standard, registerValue: Bool = true) {
        let defaultName = key.rawValue
        
        let getter: GetterBlock = { defaults.rawReprensentable(forKey: defaultName).map(Element.wrapValue) ?? defaultValue() }
        let setter: SetterBlock = {
            $0.wrappedValue.map { defaults.set($0, forKey: defaultName) }
            if $0.wrappedValue == nil {
                defaults.removeObject(forKey: defaultName)
            }
        }
        
        self.init(getter: getter, setter: setter)
        
        if registerValue, !defaults.hasValue(forKey: defaultName) {
            defaultValue().wrappedValue.map { defaults.register($0, forKey: defaultName) }
        }
    }

    /// Creates a `UserDefaults` wrapper associated with the given key which wrapped type is an optional and conforms to `RawRepresentable` and its corresponding `RawValue` conforms to `PropertyListSerializable`.
    ///
    /// - Note:
    ///     If the expression `defaultValue` returns `nil` setting the wrapped value to `nil` at some point will remove the entry from the `UserDefaults` instance's registration domain.
    ///
    /// - Parameters:
    ///   - key: The key with which to associate the wrapped value.
    ///   - value: An expression of the wrapped type.
    ///   - defaults: The `UserDefaults` instance where to do it.
    ///   - registerValue: A boolean value that indicates if the default value should be added to de registration domain. Ignored if `defaultValue` return `nil`.
    @available(*, deprecated)
    init(_ key: UserDefaultsKeyName, value: @escaping @autoclosure () -> Element, defaults: UserDefaults = .standard, registerValue: Bool = true) {
        let defaultName = key.rawValue

        let getter: GetterBlock = { defaults.rawReprensentable(forKey: defaultName).map(Element.wrapValue) ?? value() }
        let setter: SetterBlock = {
            $0.wrappedValue.map { defaults.set($0, forKey: defaultName) }
            if $0.wrappedValue == nil {
                defaults.removeObject(forKey: defaultName)
            }
        }

        self.init(getter: getter, setter: setter)

        if registerValue, !defaults.hasValue(forKey: defaultName) {
            value().wrappedValue.map { defaults.register($0, forKey: defaultName) }
        }
    }

    /// Creates a `UserDefaults` wrapper associated with the given key which wrapped type is an optional and conforms to `RawRepresentable` and its corresponding `RawValue` conforms to `PropertyListSerializable`.
    ///
    /// - Note:
    ///     If the expression `defaultValue` returns `nil` setting the wrapped value to `nil` at some point will remove the entry from the `UserDefaults` instance's registration domain.
    ///
    /// - Parameters:
    ///   - wrappedValue: The default value.
    ///   - key: The key with which to associate the wrapped value.
    ///   - defaults: The `UserDefaults` instance where to do it.
    ///   - registerValue: A boolean value that indicates if the default value should be added to de registration domain. Ignored if `defaultValue` return `nil`.
    init(wrappedValue initialValue: @escaping @autoclosure () -> Element = .nilValue, _ key: UserDefaultsKeyName, defaults: UserDefaults = .standard, registerValue: Bool = true) {
        let defaultName = key.rawValue

        let getter: GetterBlock = { defaults.rawReprensentable(forKey: defaultName).map(Element.wrapValue) ?? initialValue() }
        let setter: SetterBlock = {
            $0.wrappedValue.map { defaults.set($0, forKey: defaultName) }
            if $0.wrappedValue == nil {
                defaults.removeObject(forKey: defaultName)
            }
        }

        self.init(getter: getter, setter: setter)

        if registerValue, !defaults.hasValue(forKey: defaultName) {
            initialValue().wrappedValue.map { defaults.register($0, forKey: defaultName) }
        }
    }
}

// MARK: UserDefaultsConvertible
public extension Defaults where Element: AnyOptional, Element.Wrapped: UserDefaultsConvertible {
    
    /// Creates a `UserDefaults` wrapper associated with the given key which wrapped type is an optional and conforms to `UserDefaultsConvertible`.
    ///
    /// - Note:
    ///     If the expression `defaultValue` returns `nil` setting the wrapped value to `nil` at some point will remove the entry from the `UserDefaults` instance's registration domain.
    ///
    /// - Parameters:
    ///   - key: The key with which to associate the wrapped value.
    ///   - defaultValue: An expression of the wrapped type.
    ///   - defaults: The `UserDefaults` instance where to do it.
    ///   - registerValue: A boolean value that indicates if the default value should be added to de registration domain. Ignored if `defaultValue` return `nil`.
    @available(*, deprecated)
    init(key: UserDefaultsKeyName, defaultValue: @escaping @autoclosure () -> Element = .nilValue, defaults: UserDefaults = .standard, registerValue: Bool = true) {
        let defaultName = key.rawValue
        
        let getter: GetterBlock = { (SerializableAdapter.deserialize(from: defaults, withKey: defaultName)).map(Element.wrapValue) ?? defaultValue() }
        let setter: SetterBlock = {
            $0.wrappedValue.map { SerializableAdapter($0).serialize(in: defaults, withKey: defaultName) }
            if $0.wrappedValue == nil {
                defaults.removeObject(forKey: defaultName)
            }
        }
        
        self.init(getter: getter, setter: setter)
        
        if registerValue, !defaults.hasValue(forKey: defaultName) {
            defaultValue().wrappedValue.map { SerializableAdapter($0).register(in: defaults, withKey: defaultName) }
        }
    }

    /// Creates a `UserDefaults` wrapper associated with the given key which wrapped type is an optional and conforms to `UserDefaultsConvertible`.
    ///
    /// - Note:
    ///     If the expression `defaultValue` returns `nil` setting the wrapped value to `nil` at some point will remove the entry from the `UserDefaults` instance's registration domain.
    ///
    /// - Parameters:
    ///   - key: The key with which to associate the wrapped value.
    ///   - value: An expression of the wrapped type.
    ///   - defaults: The `UserDefaults` instance where to do it.
    ///   - registerValue: A boolean value that indicates if the default value should be added to de registration domain. Ignored if `defaultValue` return `nil`.
    @available(*, deprecated)
    init(_ key: UserDefaultsKeyName, value: @escaping @autoclosure () -> Element, defaults: UserDefaults = .standard, registerValue: Bool = true) {
        let defaultName = key.rawValue

        let getter: GetterBlock = { (SerializableAdapter.deserialize(from: defaults, withKey: defaultName)).map(Element.wrapValue) ?? value() }
        let setter: SetterBlock = {
            $0.wrappedValue.map { SerializableAdapter($0).serialize(in: defaults, withKey: defaultName) }
            if $0.wrappedValue == nil {
                defaults.removeObject(forKey: defaultName)
            }
        }

        self.init(getter: getter, setter: setter)

        if registerValue, !defaults.hasValue(forKey: defaultName) {
            value().wrappedValue.map { SerializableAdapter($0).register(in: defaults, withKey: defaultName) }
        }
    }

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
    init(wrappedValue initialValue: @escaping @autoclosure () -> Element = .nilValue, _ key: UserDefaultsKeyName, defaults: UserDefaults = .standard, registerValue: Bool = true) {
        let defaultName = key.rawValue

        let getter: GetterBlock = { (SerializableAdapter.deserialize(from: defaults, withKey: defaultName)).map(Element.wrapValue) ?? initialValue() }
        let setter: SetterBlock = {
            $0.wrappedValue.map { SerializableAdapter($0).serialize(in: defaults, withKey: defaultName) }
            if $0.wrappedValue == nil {
                defaults.removeObject(forKey: defaultName)
            }
        }

        self.init(getter: getter, setter: setter)

        if registerValue, !defaults.hasValue(forKey: defaultName) {
            initialValue().wrappedValue.map { SerializableAdapter($0).register(in: defaults, withKey: defaultName) }
        }
    }
}
