//
//  UserDefaultsExtension.swift
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

public extension UserDefaults {
    
    /// Sets the value of the specified default key to the specified `RawReprensantable` value.
    /// - Parameters:
    ///   - value: The value to store in the defaults database.
    ///   - defaultName: The key with which to associate the value.
    func set<T: RawRepresentable>(_ value: T, forKey defaultName: String) where T.RawValue: PropertyListSerializable {
        self.set(value.rawValue, forKey: defaultName)
    }
    
    /// Sets the value of the specified default key to the specified `UserDefaultsCodable` value.
    /// - Parameters:
    ///   - value: The value to store in the defaults database.
    ///   - defaultName: The key with which to associate the value.
    func set<T: UserDefaultsCodable>(_ value: T, forKey defaultName: String) {
        self.set(Self.data(from: value), forKey: defaultName)
    }
    
    /// Returns any `RawReprensentable` value associated with the specified key.
    /// - Parameter defaultName: A key in the current user‘s defaults database.
    func rawReprensentable<T: RawRepresentable>(forKey defaultName: String) -> T? where T.RawValue: PropertyListSerializable {
        self.object(forKey: defaultName).flatMap { $0 as? T.RawValue }.flatMap(T.init(rawValue:))
    }
    
    /// Returns any `UserDefaultsCodable` value associated with the specified key.
    /// - Parameter defaultName: A key in the current user‘s defaults database.
    func decodable<T: UserDefaultsCodable>(forKey defaultName: String) -> T? {
        self.data(forKey: defaultName).flatMap { try? JSONDecoder().decode(T.self, from: $0) }
    }
    
    /// Adds the given value to the registration domain using the given key.
    /// - Parameters:
    ///   - value: The value to register.
    ///   - defaultName: The value's key in the registration domain.
    func register(_ value: Any, forKey defaultName: String) {
        self.register(defaults: [defaultName: value])
    }
    
    /// Adds the given `RawRepresentable` object to the registration domain using the given key.
    /// - Parameters:
    ///   - value: The object to register.
    ///   - defaultName: The object's key in the registration domain.
    func register<T: RawRepresentable>(_ value: T, forKey defaultName: String) where T.RawValue: PropertyListSerializable {
        self.register(value.rawValue, forKey: defaultName)
    }
    
    /// Adds the given `UserDefaultsCodable` object to the registration domain using the given key.
    /// - Parameters:
    ///   - value: The object to register.
    ///   - defaultName: The object's key in the registration domain.
    func register<T: UserDefaultsCodable>(_ value: T, forKey defaultName: String) {
        self.register(Self.data(from: value), forKey: defaultName)
    }
    
    /// Encodes any `Encodable` object to JSON and returns the corresponding JSON utf8 string as a byte buffer.
    ///
    /// - Attention:
    ///     This method will stop execution if the `value` encoding fails.
    ///     `Encodable` type failing to encode is a serious issue and must be handled at coding time.
    ///
    ///
    /// - Parameter value: The byte buffer representing the JSON-encoded object
    private static func data<T: Encodable>(from value: T) -> Data {
        let encoder = JSONEncoder()
        do {
            return try encoder.encode(value)
        }
        catch {
            fatalError(error.localizedDescription)
        }
    }
}
