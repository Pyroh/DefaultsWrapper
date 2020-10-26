//
//  UserDefautsSerializableProtocol.swift
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

/// A type that can serialize and deserialize itself in and from the user's defaults database.
typealias UserDefaultsSerializable = DefaultsSerializable&DefaultsDeserializable

/// A type that can serialize itself in the user's defaults database.
protocol DefaultsSerializable {
    
    /// Serializes `self` in the given `UserDefaults` instance.
    /// - Parameters:
    ///   - defaults: The database in which to store the serialized `self`.
    ///   - defaultName: The key associated with the stored serialized `self`.
    func serialize(in defaults: UserDefaults, withKey defaultName: String)
    
    
    /// Serializes and adds`self` to the registration domain using the given key.
    /// - Parameters:
    ///   - defaults: The database in which to register the serialized `self`.
    ///   - defaultName: The key associated with the registered serialized `self`.
    func register(in defaults: UserDefaults, withKey defaultName: String)
}

/// A type that can deserialize itself from the user's defaults database.
protocol DefaultsDeserializable {
    associatedtype DeserializedType
    
    /// Deserializes and returns any instance of `Self` associated with the given key from the given `UserDefaults` instance. Returns `nil` otherwize
    /// - Parameters:
    ///   - defaults: The database in which to try to deserialize an instance of `Self`.
    ///   - defaultName: The key associated with the stored serialized `self`.
    static func deserialize(from defaults: UserDefaults, withKey defaultName: String) -> DeserializedType?
}

struct SerializableAdapter<Convertible: UserDefaultsConvertible>: DefaultsSerializable {
    private let convertible: Convertible
    
    init(_ convertible: Convertible) {
        self.convertible = convertible
    }
    
    func serialize(in defaults: UserDefaults, withKey defaultName: String) {
        defaults.set(self.convertible.convertedObject(), forKey: defaultName)
    }
    
    func register(in defaults: UserDefaults, withKey defaultName: String) {
        defaults.register(self.convertible.convertedObject(), forKey: defaultName)
    }
}

extension SerializableAdapter: DefaultsDeserializable {
    static func deserialize(from defaults: UserDefaults, withKey defaultName: String) -> Convertible?  {
        (defaults.object(forKey: defaultName) as? Convertible.PropertyListSerializableType).flatMap(Convertible.instanciate(from: ))
    }
}
