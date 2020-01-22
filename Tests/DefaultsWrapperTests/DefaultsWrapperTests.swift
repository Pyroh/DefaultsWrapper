import XCTest
@testable import DefaultsWrapper

extension DefaultName {
    static let doubleValue: DefaultName = "doubleValue"
    static let optionalDoubleValue: DefaultName = "optionalDoubleValue"
    static let optionalNilDoubleValue: DefaultName = "optionalNilDoubleValue"
    
    static let enumValue: DefaultName = "enumValue"
    static let optionalEnumValue: DefaultName = "optionalEnumValue"
    static let optionalNilEnumValue: DefaultName = "optionalNilEnumValue"
    
    static let codableValue: DefaultName = "codableValue"
    static let optionalcodableValue: DefaultName = "optionalcodableValue"
    static let optionalNilcodableValue: DefaultName = "optionalNilcodableValue"
    
    static var all: [DefaultName] { [
            .doubleValue,
            .optionalDoubleValue,
            .optionalNilDoubleValue,
            
            .enumValue,
            .optionalEnumValue,
            .optionalNilEnumValue,
            
            .codableValue,
            .optionalcodableValue,
            .optionalNilcodableValue,
        ]
    }
}

func eraseDefaults() {
    DefaultName.all.lazy.map(key).forEach(UserDefaults.standard.removeObject(forKey:))
}

func key(_ key: DefaultName) -> String { key.name }

enum Direction: Int, UserDefaultsSerializable, Codable {
    case north = 0
    case west, south, east
}

struct CodableStruct: UserDefaultsCodable, Equatable {
    var intValue: Int = 42
    var doubleValue: Double = 42
    
    var stringValue: String = "Hello"
    var direction: Direction = .north
    
    var scaledValues: [Int] = [0, 10, 20 , 30]
}

class C {
    @Default(key: .doubleValue, defaultValue: 42)
    var doubleValue: Double
    @Default(key: .optionalDoubleValue, defaultValue: 42)
    var optionalDoubleValue: Double?
    @Default(key: .optionalNilDoubleValue)
    var optionalNilDoubleValue: Double?
    
    @Default(key: .enumValue, defaultValue: .north)
    var enumValue: Direction
    @Default(key: .optionalEnumValue, defaultValue: .north)
    var optionalEnumValue: Direction?
    @Default(key: .optionalNilEnumValue)
    var optionalNilEnumValue: Direction?
    
    @Default(key: .codableValue, defaultValue: CodableStruct())
    var codableValue: CodableStruct
    @Default(key: .optionalcodableValue, defaultValue: CodableStruct())
    var optionalcodableValue: CodableStruct?
    @Default(key: .optionalNilcodableValue)
    var optionalNilcodableValue: CodableStruct?
}

final class DefaultsWrapperTests: XCTestCase {
    func testWrapperCreation() {
        eraseDefaults()
        
        let c = C()
        
        XCTAssert(c.doubleValue == 42)
        XCTAssert(c.optionalDoubleValue == 42)
        XCTAssert(c.optionalNilDoubleValue == nil)
        
        XCTAssert(c.enumValue == .north)
        XCTAssert(c.optionalEnumValue == .north)
        XCTAssert(c.optionalNilEnumValue == nil)
        
        XCTAssert(c.codableValue == CodableStruct())
        XCTAssert(c.optionalcodableValue == CodableStruct())
        XCTAssert(c.optionalNilcodableValue == nil)
    }
    
    
    func testWrapperVsDefaults() {
        eraseDefaults()
        
        let c = C()
        let d = UserDefaults.standard
        
        c.doubleValue = 23
        XCTAssert(d.double(forKey: key(.doubleValue)) == 23)
        
        c.optionalDoubleValue = 51
        XCTAssert(d.double(forKey: key(.optionalDoubleValue)) == 51)
        c.optionalDoubleValue = nil
        XCTAssert(d.double(forKey: key(.optionalDoubleValue)) == 42)
        
        XCTAssert(d.object(forKey: key(.optionalNilDoubleValue)) == nil)
        c.optionalNilDoubleValue = 42
        XCTAssert(d.double(forKey: key(.optionalNilDoubleValue)) == 42)
        c.optionalNilDoubleValue = nil
        XCTAssert(d.object(forKey: key(.optionalNilDoubleValue)) == nil)
        
        c.enumValue = .south
        XCTAssert(d.rawReprensentable(forKey: key(.enumValue)) == Direction.south)
        
        c.optionalEnumValue = .west
        XCTAssert(d.rawReprensentable(forKey: key(.optionalEnumValue)) == Direction.west)
        c.optionalEnumValue = nil
        XCTAssert(d.rawReprensentable(forKey: key(.optionalEnumValue)) == Direction.north)
        
        XCTAssert(d.rawReprensentable(forKey: key(.optionalNilEnumValue)) == Optional<Direction>.nil)
        c.optionalNilEnumValue = .east
        XCTAssert(d.rawReprensentable(forKey: key(.optionalNilEnumValue)) == Direction.east)
        c.optionalNilEnumValue = nil
        XCTAssert(d.rawReprensentable(forKey: key(.optionalNilEnumValue)) == Optional<Direction>.nil)
        
        let csRef = CodableStruct()
        var cs1 = csRef
        cs1.intValue = 12
        
        c.codableValue = cs1
        XCTAssert(d.decodable(forKey: key(.codableValue)) == cs1)
        
        var cs2 = cs1
        cs2.stringValue = "Property wrappers rock !"
        
        c.optionalcodableValue = cs2
        XCTAssert(d.decodable(forKey: key(.optionalcodableValue)) == cs2)
        c.optionalcodableValue = nil
        XCTAssert(d.decodable(forKey: key(.optionalcodableValue)) == csRef)
        
        var cs3 = cs2
        cs3.scaledValues = []
        
        XCTAssert(d.decodable(forKey: key(.optionalNilcodableValue)) == Optional<CodableStruct>.nil)
        c.optionalNilcodableValue = cs3
        XCTAssert(d.decodable(forKey: key(.optionalNilcodableValue)) == cs3)
        c.optionalNilcodableValue = nil
        XCTAssert(d.decodable(forKey: key(.optionalNilcodableValue)) == Optional<CodableStruct>.nil)
    }

    static var allTests = [
        ("testWrapperCreation", testWrapperCreation),
        ("testWrapperVsDefaults", testWrapperVsDefaults),
    ]
}
