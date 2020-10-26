//
//  UserDefaultsValueAdapter.swift
//
//  DefaultsWrapper
//
//  MIT License
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

class UserDefaultsValueAdapter<Element>: NSObject, ObservableObject {
    @Published var value: Element
    
    let key: String
    let defaultValue: Element
    let defaults: UserDefaults
    
    init(key: String, defaultValue: Element, defaults: UserDefaults, register: Bool) {
        self.key = key
        self.defaultValue = defaultValue
        self.defaults = defaults
        
        self.value = Self.readValue(forKey: key, from: defaults) ?? defaultValue
        
        super.init()
        
        if register, !defaults.hasValue(forKey: key) {
            Self.registerDefaultValue(defaultValue, forKey: key, in: defaults)
        }
        defaults.addObserver(self, forKeyPath: key, options: [], context: nil)
    }
    
    deinit {
        defaults.removeObserver(self, forKeyPath: key)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard keyPath == key,
              let newValue = Self.readValue(forKey: key, from: defaults) else { return }
        print(newValue)
        value = newValue
    }
    
    func setValue(_ value: Element) {
        Self.writeValue(value, forKey: key, to: defaults)
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

class UserDefaultsRawRepresentableValueAdapter<Element: RawRepresentable>: UserDefaultsValueAdapter<Element> where Element.RawValue: PropertyListSerializable {
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

class UserDefaultsUserDefaultsConvertibleValueAdapter<Element: UserDefaultsConvertible>: UserDefaultsValueAdapter<Element> {
    override class func readValue(forKey key: String, from defaults: UserDefaults) -> Element? {
        SerializableAdapter.deserialize(from: defaults, withKey: key)
    }
    
    override class func writeValue(_ value: Element, forKey key: String, to defaults: UserDefaults) {
        SerializableAdapter(value).serialize(in: defaults, withKey: key)
    }
    
    override class func registerDefaultValue(_ defaultValue: Element, forKey key: String, in defaults: UserDefaults) {
        defaults.register(defaultValue, forKey: key)
    }
}

// MARK: - Optionals

class UserDefaultsOptionalValueAdapter<Element: OptionalType>: UserDefaultsValueAdapter<Element> {
    override class func readValue(forKey key: String, from defaults: UserDefaults) -> Element? {
        defaults.object(forKey: key) as? Element
    }
    
    override class func writeValue(_ value: Element, forKey key: String, to defaults: UserDefaults) {
        value.wrapped.map { defaults.set($0, forKey: key) }
        if value.wrapped == nil {
            defaults.removeObject(forKey: key)
        }
    }
    
    override class func registerDefaultValue(_ defaultValue: Element, forKey key: String, in defaults: UserDefaults) {
        defaultValue.wrapped.map { defaults.register($0, forKey: key) }
    }
}

// MARK: RawRepresentable

class UserDefaultsOptionalRawRepresentableValueAdapter<Element: OptionalType>: UserDefaultsValueAdapter<Element> where Element.Wrapped: RawRepresentable, Element.Wrapped.RawValue: PropertyListSerializable {
    override class func readValue(forKey key: String, from defaults: UserDefaults) -> Element? {
        defaults.rawReprensentable(forKey: key).map(Element.wrap)
    }
    
    override class func writeValue(_ value: Element, forKey key: String, to defaults: UserDefaults) {
        value.wrapped.map { defaults.set($0, forKey: key) }
        if value.wrapped == nil {
            defaults.removeObject(forKey: key)
        }
    }
    
    override class func registerDefaultValue(_ defaultValue: Element, forKey key: String, in defaults: UserDefaults) {
        defaultValue.wrapped.map { defaults.register($0, forKey: key) }
    }
}

// MARK: UserDefaultsConvertible

class UserDefaultsOptionalUserDefaultsConvertibleValueAdapter<Element: OptionalType>: UserDefaultsValueAdapter<Element> where Element.Wrapped: UserDefaultsConvertible {
    override class func readValue(forKey key: String, from defaults: UserDefaults) -> Element? {
        (SerializableAdapter.deserialize(from: defaults, withKey: key)).map(Element.wrap)
    }
    
    override class func writeValue(_ value: Element, forKey key: String, to defaults: UserDefaults) {
        value.wrapped.map { SerializableAdapter($0).serialize(in: defaults, withKey: key) }
        if value.wrapped == nil {
            defaults.removeObject(forKey: key)
        }
    }
    
    override class func registerDefaultValue(_ defaultValue: Element, forKey key: String, in defaults: UserDefaults) {
        defaultValue.wrapped.map { SerializableAdapter($0).register(in: defaults, withKey: key) }
    }
}
