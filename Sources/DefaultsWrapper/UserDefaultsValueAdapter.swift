//
//  UserDefaultsValueAdapter.swift
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
import Foundation
import Combine
import OptionalType

class UserDefaultsValueAdapter<Element>: NSObject, ObservableObject {
    @Published var value: Element 
    
    let key: String
    let defaults: UserDefaults
    let observesChanges: Bool
    
    init(key: String, defaultValue: @escaping () -> Element, defaults: UserDefaults, register: Bool, observeChanges: Bool = true) {
        self.key = key
        self.defaults = defaults
        self.observesChanges = observeChanges
        
        self.value = Self.readValue(forKey: key, from: defaults) ?? defaultValue()
        
        super.init()
        
        if register, !defaults.hasValue(forKey: key) {
            Self.registerDefaultValue(defaultValue(), forKey: key, in: defaults)
        }
        
        if observeChanges {
            defaults.addObserver(self, forKeyPath: key, options: [], context: nil)
        }
    }
    
    deinit {
        if observesChanges {
            defaults.removeObserver(self, forKeyPath: key)
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard keyPath == key,
              let newValue = Self.readValue(forKey: key, from: defaults) else { return }
        
        value = newValue
    }
    
    func setValue(_ newValue: Element) {
        Self.writeValue(newValue, forKey: key, to: defaults)
        if !observesChanges { value = newValue }
    }
    
    class func readValue(forKey key: String, from defaults: UserDefaults) -> Element? {
        defaults.object(forKey: key) as? Element
    }
    
    class func writeValue(_ value: Element, forKey key: String, to defaults: UserDefaults) {
        defaults.set(value, forKey: key)
    }
    
    class func registerDefaultValue(_ defaultValue: Element, forKey key: String, in defaults: UserDefaults) {
        defaults.register(defaultValue, forKey: key)
    }
}

// MARK: RawRepresentable

final class UserDefaultsRawRepresentableValueAdapter<Element: RawRepresentable>: UserDefaultsValueAdapter<Element> where Element.RawValue: PropertyListSerializable {
    override class func readValue(forKey key: String, from defaults: UserDefaults) -> Element? {
        defaults.rawReprensentable(forKey: key)
    }
    
    override class func writeValue(_ value: Element, forKey key: String, to defaults: UserDefaults) {
        defaults.set(value, forKey: key)
    }
    
    override class func registerDefaultValue(_ defaultValue: Element, forKey key: String, in defaults: UserDefaults) {
        defaults.register(defaultValue, forKey: key)
    }
}

// MARK: UserDefaultsConvertible

final class UserDefaultsUserDefaultsConvertibleValueAdapter<Element: UserDefaultsConvertible>: UserDefaultsValueAdapter<Element> {
    override class func readValue(forKey key: String, from defaults: UserDefaults) -> Element? {
        defaults.convertible(forKey: key)
    }
    
    override class func writeValue(_ value: Element, forKey key: String, to defaults: UserDefaults) {
        defaults.set(value, forKey: key)
    }
    
    override class func registerDefaultValue(_ defaultValue: Element, forKey key: String, in defaults: UserDefaults) {
        defaults.register(defaultValue, forKey: key)
    }
}

// MARK: UserDefaultsCodable

final class UserDefaultsUserDefaultsCodableValueAdapter<Element: UserDefaultsCodable>: UserDefaultsValueAdapter<Element> {
    override class func readValue(forKey key: String, from defaults: UserDefaults) -> Element? {
        defaults.decodable(forKey: key)
    }
    
    override class func writeValue(_ value: Element, forKey key: String, to defaults: UserDefaults) {
        defaults.set(value, forKey: key)
    }
    
    override class func registerDefaultValue(_ defaultValue: Element, forKey key: String, in defaults: UserDefaults) {
        defaults.register(defaultValue, forKey: key)
    }
}

// MARK: - Optionals

final class UserDefaultsOptionalValueAdapter<Element: OptionalType>: UserDefaultsValueAdapter<Element> {
    override class func readValue(forKey key: String, from defaults: UserDefaults) -> Element? {
        defaults.object(forKey: key) as? Element
    }
    
    override class func writeValue(_ value: Element, forKey key: String, to defaults: UserDefaults) {
        value.wrapped.map { defaults.set($0, forKey: key) }
        if value.wrapped.isNil {
            defaults.removeObject(forKey: key)
        }
    }
    
    override class func registerDefaultValue(_ defaultValue: Element, forKey key: String, in defaults: UserDefaults) {
        defaultValue.wrapped.map { defaults.register($0, forKey: key) }
    }
}

// MARK: RawRepresentable

final class UserDefaultsOptionalRawRepresentableValueAdapter<Element: OptionalType>: UserDefaultsValueAdapter<Element> where Element.Wrapped: RawRepresentable, Element.Wrapped.RawValue: PropertyListSerializable {
    override class func readValue(forKey key: String, from defaults: UserDefaults) -> Element? {
        defaults.rawReprensentable(forKey: key).map(Element.wrap)
    }
    
    override class func writeValue(_ value: Element, forKey key: String, to defaults: UserDefaults) {
        value.wrapped.map { defaults.set($0, forKey: key) }
        if value.wrapped.isNil {
            defaults.removeObject(forKey: key)
        }
    }
    
    override class func registerDefaultValue(_ defaultValue: Element, forKey key: String, in defaults: UserDefaults) {
        defaultValue.wrapped.map { defaults.register($0, forKey: key) }
    }
}

// MARK: UserDefaultsConvertible

final class UserDefaultsOptionalUserDefaultsConvertibleValueAdapter<Element: OptionalType>: UserDefaultsValueAdapter<Element> where Element.Wrapped: UserDefaultsConvertible {
    override class func readValue(forKey key: String, from defaults: UserDefaults) -> Element? {
        defaults.convertible(forKey: key).map(Element.wrap)
    }
    
    override class func writeValue(_ value: Element, forKey key: String, to defaults: UserDefaults) {
        value.wrapped.map { defaults.set($0, forKey: key) }
        if value.isNil { defaults.removeObject(forKey: key) }
    }
    
    override class func registerDefaultValue(_ defaultValue: Element, forKey key: String, in defaults: UserDefaults) {
        defaultValue.wrapped.map { defaults.register($0, forKey: key) }
    }
}

// MARK: UserDefaultsCodable

final class UserDefaultsOptionalUserDefaultsCodableValueAdapter<Element: OptionalType>: UserDefaultsValueAdapter<Element> where Element.Wrapped: UserDefaultsCodable {
    override class func readValue(forKey key: String, from defaults: UserDefaults) -> Element? {
        defaults.decodable(forKey: key).map(Element.wrap)
    }
    
    override class func writeValue(_ value: Element, forKey key: String, to defaults: UserDefaults) {
        value.wrapped.map { defaults.set($0, forKey: key) }
        if value.isNil { defaults.removeObject(forKey: key) }
    }
    
    override class func registerDefaultValue(_ defaultValue: Element, forKey key: String, in defaults: UserDefaults) {
        defaultValue.wrapped.map { defaults.register($0, forKey: key) }
    }
}
#endif
