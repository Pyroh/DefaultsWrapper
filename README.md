[![Swift](https://img.shields.io/badge/Swift-5.5-orange.svg?style=flat)](https://swift.org)
[![Platforms](https://img.shields.io/badge/platform-macOS%2011%20%7C%20iOS%2014%20%7C%20tvOS%2014%20%7C%20watchOS%207-lightgrey.svg)](https://developer.apple.com/swift/)
[![Swift Package Manager compatible](https://img.shields.io/badge/SPM-compatible-green.svg?style=flat)](https://swift.org/package-manager/)
[![License](https://img.shields.io/badge/license-MIT-71787A.svg)](https://tldrlegal.com/license/mit-license)

# DefaultsWrapper

DefaultsWrapper is a collection of property wrappers for `UserDefaults`.  

Why is it more interesting than any other property wrapper for `UserDefaults` ?

1. It's new
1. It supports any type that `UserDefaults` already supports 
1. It's type-safe
1. It adds support for `enum`'s _out-of-the-box_*
1. It provides support for `Encodable` types**
1. It has property wrappers that bring these marvelous features to SwiftUI 
1. It can be used with the popular `CoreGraphics` value types 
1. It can be used with optional and non-optional values
1. It automatically registers the default value in the user defaults database
1. It also may not be that interesting at all...

By the way it's as easy to use as any other property wrapper :

```swift
import DefaultsWrapper

struct Game {
    @Defaults("NumberOfPlayers") var playerCount: Int = 3
    @Preference("PlayerName") var playerName: String = "Red"
    @SavedState("StartingPosition") var startPos: CGPoint = .zero
}
```

**DefaultsWrapper** comes with support for all the popular data types \([see the list](#List-of-supported-types)\).

As it is easy to make mistake using string literal keys **DefaultsWrapper** also introduces a `UserDefaultsKeyName` type to help you manage that.  It conforms to both  `RawRepresentable` and `ExpressibleByStringLiteral`. What could be considered as a best practice is to declare all keys at once inside a `UserDefaultsKeyName` extension :

```swift
extension UserDefaultsKeyName {
    static var numberOfPlayers: UserDefaultsKeyName { "NumberOfPlayers" }
    static var playerName: UserDefaultsKeyName { "PlayerName" }
    static var startingPosition: UserDefaultsKeyName { "StartingPosition" }
}
struct Game {
    @Defaults(.numberOfPlayers) var playerCount: Int = 3
    @Preference(.playerName) var playerName: String = "Red"
    @SavedState(.startingPosition) var position: CGPoint = .zero
    ...
}
```

But you still can conveniently use string literals.

_*Conditions may apply._ [See here](#enum-values-support).  
_**The target type should conform to `UserDefaultsCodable` rather than `Codable`._ [See here](#Support-for-Codable-types)

## ✨ What's new in 2.0 ? ✨
**DefaultsWrapper** 2.0 brings two know property wrappers you will use with SwiftUI : 
- `Preference`. A replacement for `AppStorage` but as convenient and as adaptable as `Default`.
- `SavedState`. Works like `State` but the last value set is written to `UserDefaults`. This value is then read every time a new `SavedState` bound to the same key comes to life and becomes the actual value. 


It features a conformance to `Codable` for `Published`. It means that your `ObservableObject` types can now conform to `UserDefaultsCodable` ! (Or just `Codable`). 

It supports `Decimal`, `UUID` and `Locale` *out-of-the-box*.

A brand new documentation thanks to Apple's DocC you can generate directly. It will be made available on another form later this year.

There's also some bug fixes and minor improvements.

## Requirements

- Swift 5.5+
- macOS 11+
- iOS 14+
- tvOS 14+
- watchOS 7+

## Installation

As a Swift Package you can add **DefaultsWrapper** as a dependency in your project's `Package.swift` file :

```Swift
dependencies: [
// Dependencies declare other packages that this package depends on.
...
    .package(url: "https://github.com/Pyroh/DefaultsWrapper", .upToNextMajor(from: "2.0.0")),
...
],
```

Then `import DefaultsWrapper` in every file where you want to use it.

Or you can add the `DefaultsWrapper` folder directly to your project. You can even copy/paste the code somewhere inside your own code.  
**DefaultsWrapper** doesn't need any dependency.

## Using `@Defaults`
Although you can add support for any type you want `@Defaults` come bundled with free support for a bunch of types that should cover most of the cases. If what is already supported is not enough to fit your needs just make your type conform to `UserDefaultsConvertible` and write the conversion code.  
If you don't state otherwise the default value is added to the registration domain ([see here](#Default-value-registration)).

`@Defaults` offers this initializer when wrapping non-optional types ([see here](#Dealing-with-optionals) for more information about `@Defaults` and optional types)  :

```Swift
init(key: UserDefaultsKeyName, 
    defaultValue: @autoclosure DefaultValueProvider, 
    defaults: UserDefaults = .standard, 
    registerValue: Bool = true)
```
- `key`: The key with which to associate the wrapped value.
- `defaultValue`: An expression of the wrapped type.
- `defaults`: The `UserDefaults` instance where to do it. By default it's `UserDefaults.standard`
- `registerValue`: A boolean value that indicates if the default value should be added to de registration domain, [more info here](#Default-value-registration).

### *Standard* types
Since `UserDefaults` won't accept any kind of value itself `@Defaults` must not try and pass a value of an *illegal* type to an `UserDefaults` instance.
Reading [Apple's `UserDefaults`' documentation](https://developer.apple.com/documentation/foundation/userdefaults) the type of an object a user's defaults database accepts can be one of these: `NSData`, `NSString`, `NSNumber`, `NSDate`, `NSArray`, or `NSDictionary`. Since macOS 10.6, `NSURL` has been invited to the party.   
Then Swift arrived and we ended up with `UserDefaults` supporting  `Int`, `Double`, `Float`, `Bool`, `String`, `Data`, `Date`, and `URL`. `Array` is also supported if its `Element` type is of one of these `UserDefaults` supports. And Finally `Dictionnary` is supported too if its `Key` is in fact `String` and if its `Value` type is something supported by `UserDefaults`.

**DefaultsWrapper** declares a protocol called `PropertyListSerializable`. These types conform to this protocol and **can be used with `@Defaults` verbatim**:  
- `Int`
- `Double`
- `Float`
- `Bool` 
- `String`
- `Data`
- `Date`
- `URL`
- `Array` and `Dictonary` also conform to it provided that their respective `Element` and `Key`  follow the aforementioned rule. Dictionary still accepts `Any` as `Value` type.

Obj-C types are not usable with `@Defaults`, [not for free at least](#Using-your-own-types).

### `enum` values support
You can use `enum`' values directly with `@Defaults` if your `enum` type meets certain requirements :
 - it has a raw value
 - its raw value conforms to `PropertyListSerializable`

> You get this support for free without doing anything. What you shouldn't do is to conform such an `enum` to `UserDefaultsCodable`, use `Codable` instead.
 
For example this `enum` is accepted by `@Defaults`:
```Swift
enum Direction: Int {
    case north = 0
    case west, south, east
}
```
These are not:
```Swift
enum Arrow  {
    case up, right, down, left
}

enum HTTPGetResult {
    case http200(String)
    case http301(String, URL)
    case http403(HTTPError)
    case http404(HTTPError)
    ...
}
```
You can still do something about these. We'll cover this later in [*Using your own types*](#Using-your-own-types).

###  Support for `Codable` types
`Codable` types are nice to use with `UserDefaults` since they can be transformed into a `Data` blob rather easily. Nonetheless **DefaultsWrapper** declares this `UserDefaultsCodable` protocol.  
Why? Because most of our  `PropertyListSerializable` conforming types also conform to `Codable` thus using `Double` with `@Defaults` will cause the compiler to ask itself if it is more `Codable` or `PropertyListSerializable`. Of course it won't find the answer and will end up complaining about it. Nobody wants that.

Long story short, `UserDefaultsCodable` is `Codable` without being `Codable`. If you want your `Codable` type also being accepted by `@Defaults` simply conform it to `UserDefaultsCodable` instead. 

### Default value registration
`UserDefaults` offers a registration domain where values are associated to keys. Like in the user's defaults database but these values are transient and will never be written to the disk. When your application starts you register a bunch of properties at once —typically in your app delegate's `applicationDidFinishLaunching` method— and you're good to go.   
`@Defaults` handles this for you. If a default value is set it will be automatically added to the registration domain. You can declare, register and wrap defaults values in just one line of code.
You still need to register values you don't wrap with `@Defaults`. 

It's still sadly not a silver bullet. Imagine that you wrap the same value multiple times in multiple places using different default values, what would happen ? It will depend on execution order. You can't predict execution order all the time so you can avoid default value registration by passing `false` to `registerValue` during wrapper initialization :

```Swift
@Defaults(key: "NumberOfPlayers", defaultValue: 3, registerValue: false)
var playerCount: Int
```

### Dealing with optionals
Every type usable with `@Defaults` can also be used while being optional. The wrapper behavior is slightly different when bound to an optional type : 

- **If a default value is provided**: 
    - the property **will never return `nil`**
    - it will return the actual value or the default value
    - setting the property to `nil` will remove the value from the user's defaults database
- **If no default value is provided** or the default value is `nil`: 
    - the property **can return `nil`** 
    - it will return the actual value or `nil` if there's no registered value for this key 
    - setting the property to `nil` will remove the value from the user's defaults database

### `CoreGraphics` types
You cant use these `CoreGraphics` value types directly with `@Defaults` :
- `CGFloat`
- `CGPoint`
- `CGSize`
- `CGRect`
- `CGVector`
- `CGAffineTransform`

For your convenience these types are not converted to a `Data` blob but to a human-readable `Dictionary`. Sometimes you may need to tweak the defaults by hand using the command line, it will remain possible to modify the `width` property of the `size` property of `RectangularThing`. As `RectangularThing` is a `CGRect` and every CG type is encoded to a `Dictionary` which keys are the same that the corresponding type's property names.  

> **Please note that** :
> - `CGFloat` is simply converted to a `Double` value.
> - `CGAffineTransform` is converted to an array of `Double` following this order: `a`, `b`, `c`, `d`, `tx` and `ty`.

### Using your own types
You may need to put something else in the user's defaults database. For this there's something you can do depending of what the object's type actually is.

#### The type is `NSString`, `NSNumber`, `NSArray`, or `NSDictionary`
Simply declare `PropertyListSerializable` conformance for this type somewhere in your code, it's easy as writing `extension NSNumber: PropertyListSerializable { }` (replace `NSNumber` by the right type of course). Use it at your own risk.

#### This is a common type that should deserve *out-of-the-box* support
It's a 3 steps solution :
1. Fork **DefaultsWrapper**
1. Implement support for the aforementioned type
1. Make a pull request

If you don't know how to do it or don't have time or.... Just open an issue 😉

> Opening an issue or making a pull request doesn't necessarily mean support will be implemented or the PR accepted.

#### It's another thing you can't conform to `UserDefaultsCodable`
You'll still need to conform your type to `UserDefaultsConvertible`. The API is quite simple : 
```Swift
associatedtype PropertyListSerializableType: PropertyListSerializable

/// Converts `self` to a serializable type.
func convertedObject() -> PropertyListSerializableType

/// Converts the serialized object back.
/// - Parameter object: The serialized object.
static func instantiate(from object: PropertyListSerializableType) -> Self?
```

Now it's a two step solution:

1. Implement `convertedObject() -> PropertyListSerializableType`  to convert instances of your type to something conforming to  `PropertyListSerializable`
1. Implement `instantiate(from object: PropertyListSerializableType) -> Self?` to convert something conforming to `PropertyListSerializable` in a new instance of your type, if possible.

As a exemple here is how to conform `SIMD2<Int>` to  `UserDefaultsConvertible` :
```Swift
extension SIMD2: UserDefaultsConvertible where Scalar == Int {
    public func convertedObject() -> [String: Int] {
        ["x": self.x, "y": self.y]
    }

    public static func instantiate(from object: [String : Int]) -> SIMD2<Int>? {
        guard let x = object["x"], let y = object["y"] else { return nil }

        return .init(x: x, y: y)
    }
}
```
or even in a more generic form :
```Swift
extension SIMD2: UserDefaultsConvertible where Scalar: PropertyListSerializable {
    public func convertedObject() -> [String: Scalar] {
        ["x": self.x, "y": self.y]
    }

    public static func instantiate(from object: [String : Scalar]) -> Self? {
        guard let x = object["x"], let y = object["y"] else { return nil }

        return .init(x: x, y: y)
    }
}
```

## `UserDefaults` extension
An `UserDefault` extension is also publicly accessible in **DefaultsWrapper** and allows any `UserDefaults` instance to support as much types as `@Defaults`, `@Preference` or `@SavedState`.  
You can store any supported value using the `set` method, to retrieve values here are the methods (names are self-explanatory) :

```Swift
func rawReprensentable<T: RawRepresentable>(forKey UserDefaultsKeyName: String) -> T? where T.RawValue: PropertyListSerializable
func decodable<T: UserDefaultsCodable>(forKey UserDefaultsKeyName: String) -> T?

// CG Types
func cgFloat(forKey UserDefaultsKeyName: String) -> CGFloat
func cgPoint(forKey UserDefaultsKeyName: String) -> CGPoint
func cgSize(forKey UserDefaultsKeyName: String) -> CGSize
func cgRect(forKey UserDefaultsKeyName: String) -> CGRect
func cgVector(forKey UserDefaultsKeyName: String) -> CGVector
func cgAffineTransform(forKey UserDefaultsKeyName: String) -> CGAffineTransform
```

There is also a `register` method that allows to register only one object instead of a `Dictionary`, for every supported type.

## List of supported types
### Standard types
- `Int`
- `Double`
- `Float`
- `Bool` 
- `String`
- `Data`
- `Date`
- `URL`
- `Array` if its required type `Element` is itself supported
- `Dictonary` if its `Key` required type is `String` and its `Element` one is supported. 

### Foundation
- `Decimal`
- `UUID`
- `Locale`

### Core Graphics
- `CGFloat`
- `CGPoint`
- `CGSize`
- `CGRect`
- `CGVector`
- `CGAffineTransform`

## License

> Copyright (c) 2020-2021 Pierre Tacchi

> Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

> The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

> THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
