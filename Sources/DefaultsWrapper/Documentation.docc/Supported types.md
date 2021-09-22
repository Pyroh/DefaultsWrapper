# Supported types

The types supported *out-of-the-box*.

## Overview

Since `UserDefaults` won't accept any kind of value itself `@Defaults`, `@Preference` and `@SavedState` must not try and pass a value of an *illegal* type to an `UserDefaults` instance.

## *Standard* types

Reading [Apple's `UserDefaults`' documentation](https://developer.apple.com/documentation/foundation/userdefaults) the type of an object a user defaults database accepts can be one of these: `NSData`, `NSString`, `NSNumber`, `NSDate`, `NSArray`, or `NSDictionary`.

Since macOS 10.6 `NSURL` has been invited to the party.   

Then Swift arrived and we ended up with `UserDefaults` supporting  `Int`, `Double`, `Float`, `Bool`, `String`, `Data`, `Date`, and `URL`.  

`Array` is also supported if its `Element` required type is of one of these `UserDefaults` supports.  

And Finally `Dictionnary` is supported too if its `Key` is in fact `String` and if its `Value` required type is something supported by `UserDefaults`.

These types conform to ``PropertyListSerializable`` and **can be used with `@Defaults`, `@Preference` and `@SavedState` verbatim**:  
- `Int`
- `Double`
- `Float`
- `Bool` 
- `String`
- `Data`
- `Date`
- `URL`

`Array` and `Dictonary` also comform to it provided that their respective `Element` and `Key`  follow the aforementioned rule. Dictionnary still accepts `Any` as `Value` type.

## Objective-C types

Those types are not usable *out-of-the-box* be you can still do something about it. It starst with reading <doc:Using-your-own-types>.

## enum values support

You can use `enum` values directly with `@Defaults`, `@Preference` or `@SavedState` if your `enum` type meets certain requirements :
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
You can still do something about these. It also starts with reading <doc:Using-your-own-types>.

## CoreGraphics types
You cant use these `CoreGraphics` value types directly with `@Defaults`, `@Preference` and `@SavedState` :
- `CGFloat`
- `CGPoint`
- `CGSize`
- `CGRect`
- `CGVector`
- `CGAffineTransform`

For your convenience these types are not converted to a `Data` blob but to a human-readable `Dictionary`. Sometimes you may need to tweak the defaults by hand using the command line.  

For example it will remain possilble to modify the `width` property of the `size` property of `RectangularThing`. As `RectangularThing` is a `CGRect` and every CG type is encoded to a `Dictionary` which keys are the same that the corresponding type's property names.  

> - `CGFloat` is simply converted to a `Double` value.
> - `CGAffineTransform` is converted to an array of `Double` following this order: `a`, `b`, `c`, `d`, `tx` and `ty`.
