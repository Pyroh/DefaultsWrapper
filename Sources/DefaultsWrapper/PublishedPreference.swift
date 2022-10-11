//
//  PublishedPreference.swift
//
//  DefaultsWrapper.swift
//
//  MIT License
//
//  Copyright (c) 2022 Pierre Tacchi
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
import OptionalType
import Combine

@propertyWrapper public struct PublishedPreference<Element> {
    private typealias GetterBlock = () -> Element
    private typealias SetterBlock = (Element) -> ()
    
    private let getter: GetterBlock
    private let setter: SetterBlock
    
    private let relay: ObserverRelayAdaptor<Element>
    
    public var projectedValue: AnyPublisher<Element, Never> {
        relay.publisher.eraseToAnyPublisher()
    }
    
    @available(*, unavailable)
    public var wrappedValue: Element {
        get { fatalError() }
        set { fatalError() }
    }
    
    private init(getter: @escaping GetterBlock, setter: @escaping SetterBlock, relay: ObserverRelayAdaptor<Element>) {
        self.getter = getter
        self.setter = setter
        self.relay = relay
    }
    
    public static subscript<Instance: ObservableObject>(
        _enclosingInstance instance: Instance,
        wrapped wrappedKeyPath: ReferenceWritableKeyPath<Instance, Element>,
        storage storageKeyPath: ReferenceWritableKeyPath<Instance, PublishedPreference>
    ) -> Element {
        get {
            let wrapper = instance[keyPath: storageKeyPath]
            (instance.objectWillChange as? ObservableObjectPublisher).map(wrapper.relay.updateObservedObjectPublisherIfNeeded)
            return wrapper.getter()
        }
        set {
            let wrapper = instance[keyPath: storageKeyPath]
            wrapper.relay.notify()
            wrapper.setter(newValue)
        }
    }
}

// MARK: - Non-Optional
// MARK: PropertyListSerializable
public extension PublishedPreference where Element: PropertyListSerializable {
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
        let relay = ObserverRelayAdaptor(key.rawValue, getter: getter, defaults: defaults)
        
        self.init(getter: getter, setter: setter, relay: relay)
        
        if registerValue, !defaults.hasValue(forKey: defaultName) {
            defaults.register(initialValue(), forKey: defaultName)
        }
    }
}

// MARK: RawRepresentable

public extension PublishedPreference where Element: RawRepresentable, Element.RawValue: PropertyListSerializable {
    
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
        let relay = ObserverRelayAdaptor(key.rawValue, getter: getter, defaults: defaults)
        
        self.init(getter: getter, setter: setter, relay: relay)
        
        if registerValue, !defaults.hasValue(forKey: defaultName) {
            defaults.register(initialValue(), forKey: defaultName)
        }
    }
}

// MARK: UserDefaultsConvertible

public extension PublishedPreference where Element: UserDefaultsConvertible {
    
    /// Creates a `UserDefaults` wrapper associated with the given key which wrapped type conforms to `UserDefaultsConvertible`.
    ///
    /// - Parameters:
    ///   - wrappedValue: The default value.
    ///   - key: The key with which to associate the wrapped value.
    ///   - defaults: The `UserDefaults` instance where to do it.
    ///   - registerValue: A boolean value that indicates if the default value should be added to de registration domain.
    init(wrappedValue initialValue: @escaping @autoclosure () -> Element, _ key: UserDefaultsKeyName, defaults: UserDefaults = .standard, registerValue: Bool = true) {
        let defaultName = key.rawValue
        
        let getter: GetterBlock = { defaults.convertible(forKey: defaultName) ?? initialValue() }
        let setter: SetterBlock = { defaults.set($0, forKey: defaultName) }
        let relay = ObserverRelayAdaptor(key.rawValue, getter: getter, defaults: defaults)
        
        self.init(getter: getter, setter: setter, relay: relay)
        
        if registerValue, !defaults.hasValue(forKey: defaultName) {
            defaults.register(initialValue(), forKey: defaultName)
        }
    }
}

public extension PublishedPreference where Element: UserDefaultsCodable {
    
    /// Creates a `UserDefaults` wrapper associated with the given key which wrapped type conforms to `UserDefaultsCodable`.
    ///
    /// - Parameters:
    ///   - wrappedValue: The default value.
    ///   - key: The key with which to associate the wrapped value.
    ///   - defaults: The `UserDefaults` instance where to do it.
    ///   - registerValue: A boolean value that indicates if the default value should be added to de registration domain.
    init(wrappedValue initialValue: @escaping @autoclosure () -> Element, _ key: UserDefaultsKeyName, defaults: UserDefaults = .standard, registerValue: Bool = true) {
        let defaultName = key.rawValue
        
        let getter: GetterBlock = { defaults.decodable(forKey: defaultName) ?? initialValue() }
        let setter: SetterBlock = { defaults.set($0, forKey: defaultName)  }
        let relay = ObserverRelayAdaptor(key.rawValue, getter: getter, defaults: defaults)
        
        self.init(getter: getter, setter: setter, relay: relay)
        
        if registerValue, !defaults.hasValue(forKey: defaultName) {
            defaults.register(initialValue(), forKey: defaultName)
        }
    }
}

// MARK: - Optional
// MARK: PropertyListSerializable

public extension PublishedPreference where Element: OptionalType, Element.Wrapped: PropertyListSerializable {
    
    /// Creates a `UserDefaults` wrapper associated with the given key which wrapped type is an optional and conforms to `PropertyListSerializable`.
    ///
    /// - Note: If the expression `defaultValue` returns `nil` setting the wrapped value to `nil` at some point will remove the entry from the `UserDefaults` instance's registration domain.
    ///
    /// - Parameters:
    ///   - wrappedValue: The default value.
    ///   - key: The key with which to associate the wrapped value.
    ///   - defaults: The `UserDefaults` instance where to do it.
    ///   - registerValue: A boolean value that indicates if the default value should be added to de registration domain. Ignored if `defaultValue` return `nil`.
    init(wrappedValue initialValue: @escaping @autoclosure () -> Element = nil, _ key: UserDefaultsKeyName, defaults: UserDefaults = .standard, registerValue: Bool = true) {
        let defaultName = key.rawValue
        
        let getter: GetterBlock = { defaults.object(forKey: defaultName) as? Element ?? initialValue() }
        let setter: SetterBlock = {
            $0.wrapped.map { defaults.set($0, forKey: defaultName) }
            if $0.wrapped == nil {
                defaults.removeObject(forKey: defaultName)
            }
        }
        let relay = ObserverRelayAdaptor(key.rawValue, getter: getter, defaults: defaults)
        
        self.init(getter: getter, setter: setter, relay: relay)
        
        if registerValue, !defaults.hasValue(forKey: defaultName) {
            initialValue().wrapped.map { defaults.register($0, forKey: defaultName) }
        }
    }
}
// MARK: RawRepresentable

public extension PublishedPreference where Element: OptionalType, Element.Wrapped: RawRepresentable, Element.Wrapped.RawValue: PropertyListSerializable {
    
    /// Creates a `UserDefaults` wrapper associated with the given key which wrapped type is an optional and conforms to `RawRepresentable` and its corresponding `RawValue` conforms to `PropertyListSerializable`.
    ///
    /// - Note: If the expression `defaultValue` returns `nil` setting the wrapped value to `nil` at some point will remove the entry from the `UserDefaults` instance's registration domain.
    ///
    /// - Parameters:
    ///   - wrappedValue: The default value.
    ///   - key: The key with which to associate the wrapped value.
    ///   - defaults: The `UserDefaults` instance where to do it.
    ///   - registerValue: A boolean value that indicates if the default value should be added to de registration domain. Ignored if `defaultValue` return `nil`.
    init(wrappedValue initialValue: @escaping @autoclosure () -> Element = nil, _ key: UserDefaultsKeyName, defaults: UserDefaults = .standard, registerValue: Bool = true) {
        let defaultName = key.rawValue
        
        let getter: GetterBlock = { defaults.rawReprensentable(forKey: defaultName).map(Element.wrap) ?? initialValue() }
        let setter: SetterBlock = {
            $0.wrapped.map { defaults.set($0, forKey: defaultName) }
            if $0.isNil { defaults.removeObject(forKey: defaultName) }
        }
        let relay = ObserverRelayAdaptor(key.rawValue, getter: getter, defaults: defaults)
        
        self.init(getter: getter, setter: setter, relay: relay)
        
        if registerValue, !defaults.hasValue(forKey: defaultName) {
            initialValue().wrapped.map { defaults.register($0, forKey: defaultName) }
        }
    }
}

// MARK: UserDefaultsConvertible
public extension PublishedPreference where Element: OptionalType, Element.Wrapped: UserDefaultsConvertible {
    
    /// Creates a `UserDefaults` wrapper associated with the given key which wrapped type is an optional and conforms to `UserDefaultsConvertible`.
    ///
    /// - Note: If the expression `defaultValue` returns `nil` setting the wrapped value to `nil` at some point will remove the entry from the `UserDefaults` instance's registration domain.
    ///
    /// - Parameters:
    ///   - wrappedValue: The default value.
    ///   - key: The key with which to associate the wrapped value.
    ///   - defaults: The `UserDefaults` instance where to do it.
    ///   - registerValue: A boolean value that indicates if the default value should be added to de registration domain. Ignored if `defaultValue` return `nil`.
    init(wrappedValue initialValue: @escaping @autoclosure () -> Element = nil, _ key: UserDefaultsKeyName, defaults: UserDefaults = .standard, registerValue: Bool = true) {
        let defaultName = key.rawValue
        
        let getter: GetterBlock = { defaults.convertible(forKey: defaultName).map(Element.wrap) ?? initialValue() }
        let setter: SetterBlock = {
            $0.wrapped.map { defaults.set($0, forKey: defaultName) }
            if $0.isNil { defaults.removeObject(forKey: defaultName) }
        }
        let relay = ObserverRelayAdaptor(key.rawValue, getter: getter, defaults: defaults)
        
        self.init(getter: getter, setter: setter, relay: relay)
        
        if registerValue, !defaults.hasValue(forKey: defaultName) {
            initialValue().wrapped.map { defaults.register($0, forKey: defaultName) }
        }
    }
}

public extension PublishedPreference where Element: OptionalType, Element.Wrapped: UserDefaultsCodable {
    
    /// Creates a `UserDefaults` wrapper associated with the given key which wrapped type conforms to `UserDefaultsCodable`.
    ///
    /// - Note: If the expression `defaultValue` returns `nil` setting the wrapped value to `nil` at some point will remove the entry from the `UserDefaults` instance's registration domain.
    ///
    /// - Parameters:
    ///   - wrappedValue: The default value.
    ///   - key: The key with which to associate the wrapped value.
    ///   - defaults: The `UserDefaults` instance where to do it.
    ///   - registerValue: A boolean value that indicates if the default value should be added to de registration domain.
    init(wrappedValue initialValue: @escaping @autoclosure () -> Element = nil, _ key: UserDefaultsKeyName, defaults: UserDefaults = .standard, registerValue: Bool = true) {
        let defaultName = key.rawValue
        
        let getter: GetterBlock = { defaults.decodable(forKey: defaultName).map(Element.wrap) ?? initialValue() }
        let setter: SetterBlock = {
            $0.wrapped.map { defaults.set($0, forKey: defaultName) }
            if $0.isNil { defaults.removeObject(forKey: defaultName) }
        }
        let relay = ObserverRelayAdaptor(key.rawValue, getter: getter, defaults: defaults)
        
        self.init(getter: getter, setter: setter, relay: relay)
        
        if registerValue, !defaults.hasValue(forKey: defaultName) {
            initialValue().wrapped.map { defaults.register($0, forKey: defaultName) }
        }
    }
}

#endif
