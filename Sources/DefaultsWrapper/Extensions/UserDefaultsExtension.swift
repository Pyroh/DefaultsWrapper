//
//  UserDefaultsExtension.swift
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
import CoreGraphics

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
        self.set(JSONCoding.data(from: value), forKey: defaultName)
    }
    
    /// Sets the value of the specified default key to the specified `UserDefaultsConvertible` value.
    /// - Parameters:
    ///   - value: The value to store in the defaults database.
    ///   - defaultName: The key with which to associate the value.
    func set<T: UserDefaultsConvertible>(_ value: T, forKey defaultName: String) {
        self.set(value.convertedObject(), forKey: defaultName)
    }
    
    /// Sets the value of the specified default key to the specified `Decimal` value.
    /// - Parameters:
    ///   - value: The value to store in the defaults database.
    ///   - defaultName: The key with which to associate the value.
    func set(_ value: Decimal, forKey defaultName: String) {
        self.set(JSONCoding.data(from: value), forKey: defaultName)
    }
    
    /// Sets the value of the specified default key to the specified `UUID` value.
    /// - Parameters:
    ///   - value: The value to store in the defaults database.
    ///   - defaultName: The key with which to associate the value.
    func set(_ value: UUID, forKey defaultName: String) {
        self.set(value.uuidString, forKey: defaultName)
    }
    
    /// Sets the value of the specified default key to the specified `Locale` value.
    /// - Parameters:
    ///   - value: The value to store in the defaults database.
    ///   - defaultName: The key with which to associate the value
    func set(_ value: Locale, forKey defaultName: String) {
        self.set(JSONCoding.data(from: value), forKey: defaultName)
    }
    
    /// Returns any `RawReprensentable` value associated with the specified key.
    /// - Parameter defaultName: A key in the current user‘s defaults database.
    func rawReprensentable<T: RawRepresentable>(forKey defaultName: String) -> T? where T.RawValue: PropertyListSerializable {
        (self.object(forKey: defaultName) as? T.RawValue).flatMap(T.init(rawValue:))
    }
    
    /// Returns any `UserDefaultsCodable` value associated with the specified key.
    /// - Parameter defaultName: A key in the current user‘s defaults database.
    func decodable<T: UserDefaultsCodable>(forKey defaultName: String) -> T? {
        self.data(forKey: defaultName).flatMap { JSONCoding.object(from: $0) }
    }
    
    /// Returns any `UserDefaultsConvertible` value associated with the specified key.
    /// - Parameter defaultName: A key in the current user‘s defaults database.
    func convertible<T: UserDefaultsConvertible>(forKey defaultName: String) -> T? {
        (self.object(forKey: defaultName) as? T.PropertyListSerializableType).flatMap { T.instantiate(from: $0) }
    }
    
    /// Returns any `Decimal` value associated with the specified key.
    /// - Parameter defaultName: A key in the current user‘s defaults database.
    func decimal(forKey defaultName: String) -> Decimal {
        self.decodable(forKey: defaultName) ?? .zero
    }
    
    /// Returns any `UUID` value associated with the specified key.
    /// - Parameter defaultName: A key in the current user‘s defaults database.
    func uuid(forKey defaultName: String) -> UUID? {
        self.string(forKey: defaultName).flatMap(UUID.init(uuidString: ))
    }
    
    /// Returns any `Locale` value associated with the specified key.
    /// - Parameter defaultName: A key in the current user‘s defaults database.
    func locale(forKey defaultName: String) -> Locale? {
        self.decodable(forKey: defaultName)
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
        self.register(JSONCoding.data(from: value), forKey: defaultName)
    }
    
    /// Adds the given `UserDefaultsConvertible` object to the registration domain using the given key.
    /// - Parameters:
    ///   - value: The object to register.
    ///   - defaultName: The object's key in the registration domain.
    func register<T: UserDefaultsConvertible>(_ value: T, forKey defaultName: String) {
        self.register(value.convertedObject(), forKey: defaultName)
    }
    
    /// Adds the given `Decimal` value to the registration domain using the given key.
    /// - Parameters:
    ///   - value: The value to register.
    ///   - defaultName: The object's key in the registration domain.
    func register(_ value: Decimal, defaultName: String) {
        self.register(value, forKey: defaultName)
    }
    
    /// Adds the given `UUID` value to the registration domain using the given key.
    /// - Parameters:
    ///   - value: The value to register.
    ///   - defaultName: The object's key in the registration domain.
    func register(_ value: UUID, defaultName: String) {
        self.register(value.uuidString, forKey: defaultName)
    }
    
    /// Adds the given `Locale` value to the registration domain using the given key.
    /// - Parameters:
    ///   - value: The value to register.
    ///   - defaultName: The object's key in the registration domain.
    func register(_ value: Locale, defaultName: String) {
        self.register(value, forKey: defaultName)
    }
}

extension UserDefaults {
    
    /// Returns `true` if any value is associated with the given key, `false` otherwise.
    /// - Parameter defaultName: The with which a value could be associated
    func hasValue(forKey defaultName: String) -> Bool {
        self.object(forKey: defaultName) != nil
    }
}

public extension UserDefaults {
    /// Sets the value of the specified default key to the specified `CGFloat` value.
    /// - Parameters:
    ///   - value: The value to store in the defaults database.
    ///   - defaultName: The key with which to associate the value.
    func set(_ value: CGFloat, forKey defaultName: String) {
        self.set(value.convert(), forKey: defaultName)
    }
    
    /// Returns the `CGFloat` value associated with the specified key.
    /// - Parameter defaultName: A key in the current user‘s defaults database.
    func cgFloat(forKey defaultName: String) -> CGFloat {
        (self.object(forKey: defaultName) as? CGFloat.ConvertedType).flatMap(CGFloat.reverse(from:)) ?? .zero
    }
    
    /// Adds the given `CGFloat` value to the registration domain using the given key.
    /// - Parameters:
    ///   - value: The value to register.
    ///   - defaultName: The object's key in the registration domain.
    func register(_ value: CGFloat, forKey defaultName: String) {
        self.register(value.convert(), forKey: defaultName)
    }
    
    /// Sets the value of the specified default key to the specified `CGPoint` value.
    /// - Parameters:
    ///   - value: The value to store in the defaults database.
    ///   - defaultName: The key with which to associate the value.
    func set(_ value: CGPoint, forKey defaultName: String) {
        self.set(value.convert(), forKey: defaultName)
    }
    
    /// Returns the `CGPoint` value associated with the specified key.
    /// - Parameter defaultName: A key in the current user‘s defaults database.
    func cgPoint(forKey defaultName: String) -> CGPoint {
        (self.object(forKey: defaultName) as? CGPoint.ConvertedType).flatMap(CGPoint.reverse(from:)) ?? .zero
    }
    
    /// Adds the given `CGPoint` value to the registration domain using the given key.
    /// - Parameters:
    ///   - value: The value to register.
    ///   - defaultName: The object's key in the registration domain.
    func register(_ value: CGPoint, forKey defaultName: String) {
        self.register(value.convert(), forKey: defaultName)
    }
    
    /// Sets the value of the specified default key to the specified `CGSize` value.
    /// - Parameters:
    ///   - value: The value to store in the defaults database.
    ///   - defaultName: The key with which to associate the value.
    func set(_ value: CGSize, forKey defaultName: String) {
        self.set(value.convert(), forKey: defaultName)
    }
    
    /// Returns the `CGSize` value associated with the specified key.
    /// - Parameter defaultName: A key in the current user‘s defaults database.
    func cgSize(forKey defaultName: String) -> CGSize {
        (self.object(forKey: defaultName) as? CGSize.ConvertedType).flatMap(CGSize.reverse(from:)) ?? .zero
    }
    
    /// Adds the given `CGSize` value to the registration domain using the given key.
    /// - Parameters:
    ///   - value: The value to register.
    ///   - defaultName: The object's key in the registration domain.
    func register(_ value: CGSize, forKey defaultName: String) {
        self.register(value.convert(), forKey: defaultName)
    }
    
    /// Sets the value of the specified default key to the specified `CGRect` value.
    /// - Parameters:
    ///   - value: The value to store in the defaults database.
    ///   - defaultName: The key with which to associate the value.
    func set(_ value: CGRect, forKey defaultName: String) {
        self.set(value.convert(), forKey: defaultName)
    }
    
    /// Returns the `CGRect` value associated with the specified key.
    /// - Parameter defaultName: A key in the current user‘s defaults database.
    func cgRect(forKey defaultName: String) -> CGRect {
        (self.object(forKey: defaultName) as? CGRect.ConvertedType).flatMap(CGRect.reverse(from:)) ?? .zero
    }
    
    /// Adds the given `CGRect` value to the registration domain using the given key.
    /// - Parameters:
    ///   - value: The value to register.
    ///   - defaultName: The object's key in the registration domain.
    func register(_ value: CGRect, forKey defaultName: String) {
        self.register(value.convert(), forKey: defaultName)
    }
    
    /// Sets the value of the specified default key to the specified `CGVector` value.
    /// - Parameters:
    ///   - value: The value to store in the defaults database.
    ///   - defaultName: The key with which to associate the value.
    func set(_ value: CGVector, forKey defaultName: String) {
        self.set(value.convert(), forKey: defaultName)
    }
    
    /// Returns the `CGVector` value associated with the specified key.
    /// - Parameter defaultName: A key in the current user‘s defaults database.
    func cgVector(forKey defaultName: String) -> CGVector {
        (self.object(forKey: defaultName) as? CGVector.ConvertedType).flatMap(CGVector.reverse(from:)) ?? .zero
    }
    
    /// Adds the given `CGVector` value to the registration domain using the given key.
    /// - Parameters:
    ///   - value: The value to register.
    ///   - defaultName: The object's key in the registration domain.
    func register(_ value: CGVector, forKey defaultName: String) {
        self.register(value.convert(), forKey: defaultName)
    }
    
    /// Sets the value of the specified default key to the specified `CGAffineTransform` value.
    /// - Parameters:
    ///   - value: The value to store in the defaults database.
    ///   - defaultName: The key with which to associate the value.
    func set(_ value: CGAffineTransform, forKey defaultName: String) {
        self.set(value.convert(), forKey: defaultName)
    }
    
    /// Returns the `CGAffineTransform` value associated with the specified key.
    /// - Parameter defaultName: A key in the current user‘s defaults database.
    func cgAffineTransform(forKey defaultName: String) -> CGAffineTransform {
        (self.object(forKey: defaultName) as? CGAffineTransform.ConvertedType).flatMap(CGAffineTransform.reverse(from:)) ?? .identity
    }
    
    /// Adds the given `CGAffineTransform` value to the registration domain using the given key.
    /// - Parameters:
    ///   - value: The value to register.
    ///   - defaultName: The object's key in the registration domain.
    func register(_ value: CGAffineTransform, forKey defaultName: String) {
        self.register(value.convert(), forKey: defaultName)
    }
}
