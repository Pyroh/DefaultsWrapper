//
//  SavedState.swift
//
//  DefaultsWrapper
//
//  MIT License
//
//  Copyright (c) 2021 Pierre Tacchi
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

import SwiftUI

@propertyWrapper public struct SavedState<Element>: DynamicProperty {
    public var wrappedValue: Element {
        get { adapter.value }
        nonmutating set { adapter.setValue(newValue) }
    }
    
    public var projectedValue: Binding<Element> {
        .init { () -> Element in
            adapter.value
        } set: { (value) in
            adapter.setValue(value)
        }
    }
    
    @ObservedObject private var adapter: UserDefaultsValueAdapter<Element>
    
    private init(adapter: UserDefaultsValueAdapter<Element>) {
        self.adapter = adapter
    }
}

public extension SavedState where Element: PropertyListSerializable {
    init(wrappedValue initialValue: Element, _ key: UserDefaultsKeyName, defaults: UserDefaults = .standard, registerValue: Bool = true) {
        self.init(adapter: UserDefaultsValueAdapter<Element>(key: key.rawValue, defaultValue: initialValue, defaults: defaults, register: registerValue, observeChanges: false))
    }
}

public extension SavedState where Element: RawRepresentable, Element.RawValue: PropertyListSerializable {
    init(wrappedValue initialValue: Element, _ key: UserDefaultsKeyName, defaults: UserDefaults = .standard, registerValue: Bool = true) {
        self.init(adapter: UserDefaultsRawRepresentableValueAdapter(key: key.rawValue, defaultValue: initialValue, defaults: defaults, register: registerValue, observeChanges: false))
    }
}

public extension SavedState where Element: UserDefaultsConvertible {
    init(wrappedValue initialValue: Element, _ key: UserDefaultsKeyName, defaults: UserDefaults = .standard, registerValue: Bool = true) {
        self.init(adapter: UserDefaultsUserDefaultsConvertibleValueAdapter(key: key.rawValue, defaultValue: initialValue, defaults: defaults, register: registerValue, observeChanges: false))
    }
}

public extension SavedState where Element: OptionalType, Element.Wrapped: PropertyListSerializable {
    init(wrappedValue initialValue: Element = .nil, _ key: UserDefaultsKeyName, defaults: UserDefaults = .standard, registerValue: Bool = true) {
        self.init(adapter: UserDefaultsOptionalValueAdapter<Element>(key: key.rawValue, defaultValue: initialValue, defaults: defaults, register: registerValue, observeChanges: false))
    }
}

public extension SavedState where Element: OptionalType, Element.Wrapped: RawRepresentable, Element.Wrapped.RawValue: PropertyListSerializable {
    init(wrappedValue initialValue: Element, _ key: UserDefaultsKeyName, defaults: UserDefaults = .standard, registerValue: Bool = true) {
        self.init(adapter: UserDefaultsOptionalRawRepresentableValueAdapter(key: key.rawValue, defaultValue: initialValue, defaults: defaults, register: registerValue, observeChanges: false))
    }
}

public extension SavedState where Element: OptionalType, Element.Wrapped: UserDefaultsConvertible {
    init(wrappedValue initialValue: Element, _ key: UserDefaultsKeyName, defaults: UserDefaults = .standard, registerValue: Bool = true) {
        self.init(adapter: UserDefaultsOptionalUserDefaultsConvertibleValueAdapter(key: key.rawValue, defaultValue: initialValue, defaults: defaults, register: registerValue, observeChanges: false))
    }
}
