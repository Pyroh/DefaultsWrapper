# Using your own types

You may sometimes need to put something else in the user's defaults database.

## Overview

While using ``UserDefaultsCodable`` may solve most of the cases you can still find some problematic edge-cases.
Then how you can make the wrappers support a new type depends on what the type is.

## The type conforms to Codable or can easily conform to it

`Codable` types are nice to use with `UserDefaults` since they can be transformed into a `Data` blob rather easily. Nonetheless there is the ``UserDefaultsCodable`` protocol.  

Why? Because most of the ``PropertyListSerializable`` conforming types also conform to `Codable`. Thus using `Double` with `@Defaults` would cause the compiler to ask itself if it is more `Codable` or ``PropertyListSerializable``. Of course it won't find the answer and will end up complaining about it. Nobody wants that.

Long story short, ``UserDefaultsCodable`` is `Codable` without being `Codable`. If you want your `Codable` type also being accepted by `@Defaults` simply comform it to `UserDefaultsCodable` instead.  

If it's a type that conforms to `Codable` but that you don't own, you can still extend the type and make it conform to ``UserDefaultsCodable``.

## The type is NSString, NSNumber, NSArray, or NSDictionary

Simply declare ``PropertyListSerializable`` conformance for this type somewhere in your code, it's easy as writting 
```swift
extension NSNumber: PropertyListSerializable { }
```
Replace `NSNumber` by the right type.  

**This is strongly discouraged . Use it at your own risk.**

## This is one of your own type

You'll still need to conform your type to ``UserDefaultsConvertible``. The API is quite simple : 
```swift
associatedtype PropertyListSerializableType: PropertyListSerializable

/// Converts `self` to a serializable type.
func convertedObject() -> PropertyListSerializableType

/// Converts the serialized object back.
/// - Parameter object: The serialized object.
static func instanciate(from object: PropertyListSerializableType) -> Self?
```

### It's a two step solution:

1. Implement ``UserDefaultsConvertible/convertedObject()`` to convert instances of your type to something conforming to  ``PropertyListSerializable``
1. Implement ``UserDefaultsConvertible/instanciate(from:)`` to convert something conforming to ``PropertyListSerializable`` in a new instance of your type, if possible.

As a exemple here is how to conform `SIMD2<Int>` to  ``UserDefaultsConvertible`` :
```swift
extension SIMD2: UserDefaultsConvertible where Scalar == Int {
    public func convertedObject() -> [String: Int] {
        ["x": self.x, "y": self.y]
    }

    public static func instanciate(from object: [String : Int]) -> SIMD2<Int>? {
        guard let x = object["x"], let y = object["y"] else { return nil }
        return .init(x: x, y: y)
    }
}
```
or even in a more generic form :
```swift
extension SIMD2: UserDefaultsConvertible where Scalar: PropertyListSerializable {
    public func convertedObject() -> [String: Scalar] {
        ["x": self.x, "y": self.y]
    }

    public static func instanciate(from object: [String : Scalar]) -> Self? {
        guard let x = object["x"], let y = object["y"] else { return nil }
        return .init(x: x, y: y)
    }
}
```

## This is a common type that should deserve *out-of-the-box* support

It's a 3 steps solution :
1. Fork **DefaultsWrapper**
1. Implement support for the aforementioned type
1. Make a pull request

If you don't know how to do it or don't have time or.... Just open an issue 😉

- Note: Opening an issue or making a pull request doesn't necesseraly mean that support will be implemented or the PR accepted.
