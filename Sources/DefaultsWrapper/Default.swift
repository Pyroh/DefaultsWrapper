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

@propertyWrapper
public struct Default<Element> {
    
    public typealias DefaultValueProvider = () -> Element
    
    private let getter: () -> Element
    private let setter: (Element) -> ()
    
    public var wrappedValue: Element {
        get { self.getter() }
        nonmutating set { self.setter(newValue) }
    }
    
    public init(key: DefaultName, defaultValue: @autoclosure DefaultValueProvider, defaults: UserDefaults = .standard) {
        let defaultName = key.name
        let initialValue = defaultValue()
        
        self.getter = { defaults.object(forKey: defaultName) as? Element ?? initialValue }
        self.setter = { defaults.set($0, forKey: defaultName) }
        
        defaults.register(initialValue, forKey: defaultName)
    }
}

public extension Default where Element: UserDefaultsSerializable {
    init(key: DefaultName, defaultValue: @autoclosure DefaultValueProvider, defaults: UserDefaults = .standard) {
        let defaultName = key.name
        let initialValue = defaultValue()
        
        self.getter = { Element.deserialize(from: defaults, withKey: defaultName) ?? initialValue }
        self.setter = { $0.serialize(in: defaults, withKey: defaultName) }
        
        initialValue.register(in: defaults, withKey: defaultName)
    }
}

public extension Default where Element: OptionalType {
    init(key: DefaultName, defaultValue: @autoclosure DefaultValueProvider = Element.nil, defaults: UserDefaults = .standard) {
        let defaultName = key.name
        let initialValue = defaultValue()
        
        self.getter = { defaults.object(forKey: defaultName) as? Element ?? initialValue }
        self.setter = {
            $0.wrapped.map { defaults.set($0, forKey: defaultName) }
            if $0.wrapped == nil {
                defaults.removeObject(forKey: defaultName)
                initialValue.wrapped.map { defaults.register($0, forKey: defaultName) }
            }
        }
        
        initialValue.wrapped.map { defaults.register($0, forKey: defaultName) }
    }
}

public extension Default where Element: OptionalType, Element.Wrapped: UserDefaultsSerializable {
    init(key: DefaultName, defaultValue: @autoclosure DefaultValueProvider = Element.nil, defaults: UserDefaults = .standard) {
        let defaultName = key.name
        let initialValue = defaultValue()
        
        self.getter = { (Element.Wrapped.deserialize(from: defaults, withKey: defaultName)).map(Element.wrap) ?? initialValue }
        self.setter = {
            $0.wrapped.map { $0.serialize(in: defaults, withKey: defaultName) }
            if $0.wrapped == nil {
                defaults.removeObject(forKey: defaultName)
                initialValue.wrapped.map { $0.register(in: defaults, withKey: defaultName) }
            }
        }
        
        initialValue.wrapped.map { $0.register(in: defaults, withKey: defaultName) }
    }
}
