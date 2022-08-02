import XCTest
import DefaultsWrapper

struct S {
    @Defaults("someKey")
    var someValue: String = "Hello"

    @Defaults("otherKey")
    var otherValue: String = "Hello world !"
}

class C {
    @Defaults("someKey")
    var someValue: String = "World"

    @Defaults("otherKey")
    var otherValue: String = "Hello world !"
}

struct Person: UserDefaultsCodable, Equatable {
    let firstName: String
    let lastName: String
}

final class DefaultsWrapperTests: XCTestCase {
    
    func testArrays() {
        eraseDefaults()
        
        let arr = ArrayTestCase()
        let d = UserDefaults.standard
        
        // Simple Value
        arr.cgFloatArray = [1, 2]
        XCTAssert(d.array(forKey: key(.cgFloatArray)) as? [Double] == [1, 2])
        
        // Complex Value
        arr.cgPointArray = [CGPoint(x: 1, y: 2), CGPoint(x: 3, y: 4)]
        XCTAssert(d.array(forKey: key(.cgPointArray)) as? [[String: Double]] == [["x": 1.0, "y": 2.0], ["x": 3.0, "y": 4.0]])
        
        arr.codableArray = [.init(firstName: "John", lastName: "Doe")]
        let retrievedCodableArray = d.data(forKey: key(.codableArray))
            .map { try? JSONDecoder().decode([Person].self, from: $0) }

        XCTAssert(retrievedCodableArray == [.init(firstName: "John", lastName: "Doe")])
    }
    
    func testWrapper() {
        eraseDefaults()
        
        let c = TestCase()
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
        
        XCTAssert(d.rawReprensentable(forKey: key(.optionalNilEnumValue)) == Optional<Direction>.none)
        c.optionalNilEnumValue = .east
        XCTAssert(d.rawReprensentable(forKey: key(.optionalNilEnumValue)) == Direction.east)
        c.optionalNilEnumValue = nil
        XCTAssert(d.rawReprensentable(forKey: key(.optionalNilEnumValue)) == Optional<Direction>.none)
        
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
        
        XCTAssert(d.decodable(forKey: key(.optionalNilcodableValue)) == Optional<CodableStruct>.none)
        c.optionalNilcodableValue = cs3
        XCTAssert(d.decodable(forKey: key(.optionalNilcodableValue)) == cs3)
        c.optionalNilcodableValue = nil
        XCTAssert(d.decodable(forKey: key(.optionalNilcodableValue)) == Optional<CodableStruct>.none)
        
        c.arrayValue = [4, 5, 6]
        XCTAssert(d.array(forKey: key(.arrayValue)) as? [Int] == [4, 5, 6])
        
        c.optionalArrayValue = [7, 8, 9]
        XCTAssert(d.array(forKey: key(.optionalArrayValue)) as? [Int] == [7, 8, 9])
        c.optionalArrayValue = nil
        XCTAssert(d.array(forKey: key(.optionalArrayValue)) as? [Int] == [1, 2, 3])
        
        XCTAssert(d.array(forKey: key(.optionalNilArrayValue)) as? [Int] == nil)
        c.optionalNilArrayValue = [1, 2, 3]
        XCTAssert(d.array(forKey: key(.optionalNilArrayValue)) as? [Int] == [1, 2, 3])
        c.optionalNilArrayValue = nil
        XCTAssert(d.array(forKey: key(.optionalNilArrayValue)) as? [Int] == nil)
    }
    
    func testPreference() {
        eraseDefaults()
        
        let c = PreferenceTestCase()
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
        
        XCTAssert(d.rawReprensentable(forKey: key(.optionalNilEnumValue)) == Optional<Direction>.none)
        c.optionalNilEnumValue = .east
        XCTAssert(d.rawReprensentable(forKey: key(.optionalNilEnumValue)) == Direction.east)
        c.optionalNilEnumValue = nil
        XCTAssert(d.rawReprensentable(forKey: key(.optionalNilEnumValue)) == Optional<Direction>.none)
        
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
        
        XCTAssert(d.decodable(forKey: key(.optionalNilcodableValue)) == Optional<CodableStruct>.none)
        c.optionalNilcodableValue = cs3
        XCTAssert(d.decodable(forKey: key(.optionalNilcodableValue)) == cs3)
        c.optionalNilcodableValue = nil
        XCTAssert(d.decodable(forKey: key(.optionalNilcodableValue)) == Optional<CodableStruct>.none)
        
        c.arrayValue = [4, 5, 6]
        XCTAssert(d.array(forKey: key(.arrayValue)) as? [Int] == [4, 5, 6])
        
        c.optionalArrayValue = [7, 8, 9]
        XCTAssert(d.array(forKey: key(.optionalArrayValue)) as? [Int] == [7, 8, 9])
        c.optionalArrayValue = nil
        XCTAssert(d.array(forKey: key(.optionalArrayValue)) as? [Int] == [1, 2, 3])
        
        XCTAssert(d.array(forKey: key(.optionalNilArrayValue)) as? [Int] == nil)
        c.optionalNilArrayValue = [1, 2, 3]
        XCTAssert(d.array(forKey: key(.optionalNilArrayValue)) as? [Int] == [1, 2, 3])
        c.optionalNilArrayValue = nil
        XCTAssert(d.array(forKey: key(.optionalNilArrayValue)) as? [Int] == nil)
    }
    
    func testSavedState() {
        eraseDefaults()
        
        let c = SavedStateTestCase()
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
        
        XCTAssert(d.rawReprensentable(forKey: key(.optionalNilEnumValue)) == Optional<Direction>.none)
        c.optionalNilEnumValue = .east
        XCTAssert(d.rawReprensentable(forKey: key(.optionalNilEnumValue)) == Direction.east)
        c.optionalNilEnumValue = nil
        XCTAssert(d.rawReprensentable(forKey: key(.optionalNilEnumValue)) == Optional<Direction>.none)
        
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
        
        XCTAssert(d.decodable(forKey: key(.optionalNilcodableValue)) == Optional<CodableStruct>.none)
        c.optionalNilcodableValue = cs3
        XCTAssert(d.decodable(forKey: key(.optionalNilcodableValue)) == cs3)
        c.optionalNilcodableValue = nil
        XCTAssert(d.decodable(forKey: key(.optionalNilcodableValue)) == Optional<CodableStruct>.none)
        
        c.arrayValue = [4, 5, 6]
        XCTAssert(d.array(forKey: key(.arrayValue)) as? [Int] == [4, 5, 6])
        
        c.optionalArrayValue = [7, 8, 9]
        XCTAssert(d.array(forKey: key(.optionalArrayValue)) as? [Int] == [7, 8, 9])
        c.optionalArrayValue = nil
        XCTAssert(d.array(forKey: key(.optionalArrayValue)) as? [Int] == [1, 2, 3])
        
        XCTAssert(d.array(forKey: key(.optionalNilArrayValue)) as? [Int] == nil)
        c.optionalNilArrayValue = [1, 2, 3]
        XCTAssert(d.array(forKey: key(.optionalNilArrayValue)) as? [Int] == [1, 2, 3])
        c.optionalNilArrayValue = nil
        XCTAssert(d.array(forKey: key(.optionalNilArrayValue)) as? [Int] == nil)
    }
    
    func testWrapperWithFoundationTypes() {
        eraseDefaults()
        
        let fnd = FoundationTestCase()
        let d = UserDefaults.standard
        
        fnd.decimalValue = 42
        XCTAssert(d.decimal(forKey: key(.decimalValue)) == Decimal(42))
        
        let uuid = UUID()
        fnd.uuidValue = uuid
        XCTAssert(d.uuid(forKey: key(.uuidValue)) == uuid)
        
        let locale = Locale(identifier: "eu")
        fnd.localValue = locale
        XCTAssert(d.locale(forKey: key(.localeValue)) == locale)
    }
    
    func testPreferenceWithFoundationTypes() {
        eraseDefaults()
        
        let fnd = FoundationPreferenceTestCase()
        let d = UserDefaults.standard
        
        fnd.decimalValue = 42
        XCTAssert(d.decimal(forKey: key(.decimalValue)) == Decimal(42))
        
        let uuid = UUID()
        fnd.uuidValue = uuid
        XCTAssert(d.uuid(forKey: key(.uuidValue)) == uuid)
        
        let locale = Locale(identifier: "eu")
        fnd.localValue = locale
        XCTAssert(d.locale(forKey: key(.localeValue)) == locale)
    }
    
    func testSavedStateWithFoundationTypes() {
        eraseDefaults()
        
        let fnd = FoundationSavedStateTestCase()
        let d = UserDefaults.standard
        
        fnd.decimalValue = 42
        XCTAssert(d.decimal(forKey: key(.decimalValue)) == Decimal(42))
        
        let uuid = UUID()
        fnd.uuidValue = uuid
        XCTAssert(d.uuid(forKey: key(.uuidValue)) == uuid)
        
        let locale = Locale(identifier: "eu")
        fnd.localValue = locale
        XCTAssert(d.locale(forKey: key(.localeValue)) == locale)
    }
    
    func testWrapperWithCGTypes() {
        eraseDefaults()
        
        let cg = CGTestCase()
        let d = UserDefaults.standard
        
        // CGFloat
        
        cg.floatValue = 42
        XCTAssert(d.object(forKey: key(.floatValue)) as? Double == 42)
        
        
        cg.optionalFloatValue = 42
        XCTAssert(d.object(forKey: key(.optionalFloatValue)) as? Double == 42)
        cg.optionalFloatValue = nil
        XCTAssert(d.object(forKey: key(.optionalFloatValue)) as? Double == 0)
        
        XCTAssert(d.object(forKey: key(.optionalNilFloatValue)) == nil)
        cg.optionalNilFloatValue = 42
        XCTAssert(d.object(forKey: key(.optionalNilFloatValue)) as? Double == 42)
        cg.optionalNilFloatValue = nil
        XCTAssert(d.object(forKey: key(.optionalNilFloatValue)) == nil)
        
        // CGPoint
        
        cg.pointValue = .init(x: 1, y: 2)
        XCTAssert(d.dictionary(forKey: key(.pointValue)) as? [String: Double] == ["x": 1.0, "y": 2.0])
        
        cg.optionalPointValue = .init(x: 1, y: 2)
        XCTAssert(d.dictionary(forKey: key(.optionalPointValue)) as? [String: Double] == ["x": 1.0, "y": 2.0])
        cg.optionalPointValue = nil
        XCTAssert(d.dictionary(forKey: key(.optionalPointValue)) as? [String: Double] == ["x": 0.0, "y": 0.0])
        
        XCTAssert(d.dictionary(forKey: key(.optionalNilPointValue)) == nil)
        cg.optionalNilPointValue = .init(x: 1, y: 2)
        XCTAssert(d.dictionary(forKey: key(.optionalNilPointValue)) as? [String: Double] == ["x": 1.0, "y": 2.0])
        cg.optionalNilPointValue = nil
        XCTAssert(d.dictionary(forKey: key(.optionalNilPointValue)) == nil)
        
        // CGSize
        
        cg.sizeValue = .init(width: 1, height: 2)
        XCTAssert(d.dictionary(forKey: key(.sizeValue)) as? [String: Double] == ["width": 1.0, "height": 2.0])
        
        cg.optionalSizeValue = .init(width: 1, height: 2)
        XCTAssert(d.dictionary(forKey: key(.optionalSizeValue)) as? [String: Double] == ["width": 1.0, "height": 2.0])
        cg.optionalSizeValue = nil
        XCTAssert(d.dictionary(forKey: key(.optionalSizeValue)) as? [String: Double] == ["width": 0.0, "height": 0.0])
        
        XCTAssert(d.dictionary(forKey: key(.optionalNilSizeValue)) == nil)
        cg.optionalNilSizeValue = .init(width: 1, height: 2)
        XCTAssert(d.dictionary(forKey: key(.optionalNilSizeValue)) as? [String: Double] == ["width": 1.0, "height": 2.0])
        cg.optionalNilSizeValue = nil
        XCTAssert(d.dictionary(forKey: key(.optionalNilSizeValue)) == nil)
        
        // CGRect
        
        let rectRef = CGRect(origin: .init(x: 1, y: 2), size: .init(width: 3, height: 4))
        let rectDictRef = ["origin": ["x": 1.0, "y": 2.0], "size": ["width": 3.0, "height": 4.0]]
        let zeroDictRef = ["origin": ["x": 0.0, "y": 0.0], "size": ["width": 0.0, "height": 0.0]]
        
        cg.rectValue = rectRef
        XCTAssert(d.dictionary(forKey: key(.rectValue)) as? [String: [String: Double]] == rectDictRef)
        
        cg.optionalRectValue = rectRef
        XCTAssert(d.dictionary(forKey: key(.optionalRectValue)) as? [String: [String: Double]] == rectDictRef)
        cg.optionalRectValue = nil
        XCTAssert(d.dictionary(forKey: key(.optionalRectValue)) as? [String: [String: Double]] == zeroDictRef)
        
        XCTAssert(d.dictionary(forKey: key(.optionalNilRectValue)) == nil)
        cg.optionalNilRectValue = rectRef
        XCTAssert(d.dictionary(forKey: key(.optionalNilRectValue)) as? [String: [String: Double]] == rectDictRef)
        cg.optionalNilRectValue = nil
        XCTAssert(d.dictionary(forKey: key(.optionalNilRectValue)) == nil)
        
        // CGVector
        
        cg.vectorValue = .init(dx: 1, dy: 2)
        XCTAssert(d.dictionary(forKey: key(.vectorValue)) as? [String: Double] == ["dx": 1.0, "dy": 2.0])
        
        cg.optionalVectorValue = .init(dx: 1, dy: 2)
        XCTAssert(d.dictionary(forKey: key(.optionalVectorValue)) as? [String: Double] == ["dx": 1.0, "dy": 2.0])
        cg.optionalVectorValue = nil
        XCTAssert(d.dictionary(forKey: key(.optionalVectorValue)) as? [String: Double] == ["dx": 0.0, "dy": 0.0])
        
        XCTAssert(d.dictionary(forKey: key(.optionalNilVectorValue)) == nil)
        cg.optionalNilVectorValue = .init(dx: 1, dy: 2)
        XCTAssert(d.dictionary(forKey: key(.optionalNilVectorValue)) as? [String: Double] == ["dx": 1.0, "dy": 2.0])
        cg.optionalNilVectorValue = nil
        XCTAssert(d.dictionary(forKey: key(.optionalNilVectorValue)) == nil)
        
        // CGAffineTransform
        
        let transRef = CGAffineTransform(a: 1.0, b: 2.0, c: 3.0, d: 4.0, tx: 5.0, ty: 6.0)
        let transArrayRef = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0]
        let identityArrayRef = [1.0, 0.0, 0.0, 1.0, 0.0, 0.0]
        
        cg.transformValue = transRef
        XCTAssert(d.array(forKey: key(.transformValue)) as? [Double] == transArrayRef)
        
        cg.optionalTransformValue = transRef
        XCTAssert(d.array(forKey: key(.optionalTransformValue)) as? [Double] == transArrayRef)
        cg.optionalTransformValue = nil
        XCTAssert(d.array(forKey: key(.optionalTransformValue)) as? [Double] == identityArrayRef)
        
        XCTAssert(d.array(forKey: key(.optionalNilTransformValue)) == nil)
        cg.optionalNilTransformValue = transRef
        XCTAssert(d.array(forKey: key(.optionalNilTransformValue)) as? [Double] == transArrayRef)
        cg.optionalNilTransformValue = nil
        XCTAssert(d.array(forKey: key(.optionalNilTransformValue)) == nil)
    }
    
    func testPreferenceWithCGTypes() {
        eraseDefaults()
        
        let cg = CGPreferenceTestCase()
        let d = UserDefaults.standard
        
        // CGFloat
        
        cg.floatValue = 42
        XCTAssert(d.object(forKey: key(.floatValue)) as? Double == 42)
        
        
        cg.optionalFloatValue = 42
        XCTAssert(d.object(forKey: key(.optionalFloatValue)) as? Double == 42)
        cg.optionalFloatValue = nil
        XCTAssert(d.object(forKey: key(.optionalFloatValue)) as? Double == 0)
        
        XCTAssert(d.object(forKey: key(.optionalNilFloatValue)) == nil)
        cg.optionalNilFloatValue = 42
        XCTAssert(d.object(forKey: key(.optionalNilFloatValue)) as? Double == 42)
        cg.optionalNilFloatValue = nil
        XCTAssert(d.object(forKey: key(.optionalNilFloatValue)) == nil)
        
        // CGPoint
        
        cg.pointValue = .init(x: 1, y: 2)
        XCTAssert(d.dictionary(forKey: key(.pointValue)) as? [String: Double] == ["x": 1.0, "y": 2.0])
        
        cg.optionalPointValue = .init(x: 1, y: 2)
        XCTAssert(d.dictionary(forKey: key(.optionalPointValue)) as? [String: Double] == ["x": 1.0, "y": 2.0])
        cg.optionalPointValue = nil
        XCTAssert(d.dictionary(forKey: key(.optionalPointValue)) as? [String: Double] == ["x": 0.0, "y": 0.0])
        
        XCTAssert(d.dictionary(forKey: key(.optionalNilPointValue)) == nil)
        cg.optionalNilPointValue = .init(x: 1, y: 2)
        XCTAssert(d.dictionary(forKey: key(.optionalNilPointValue)) as? [String: Double] == ["x": 1.0, "y": 2.0])
        cg.optionalNilPointValue = nil
        XCTAssert(d.dictionary(forKey: key(.optionalNilPointValue)) == nil)
        
        // CGSize
        
        cg.sizeValue = .init(width: 1, height: 2)
        XCTAssert(d.dictionary(forKey: key(.sizeValue)) as? [String: Double] == ["width": 1.0, "height": 2.0])
        
        cg.optionalSizeValue = .init(width: 1, height: 2)
        XCTAssert(d.dictionary(forKey: key(.optionalSizeValue)) as? [String: Double] == ["width": 1.0, "height": 2.0])
        cg.optionalSizeValue = nil
        XCTAssert(d.dictionary(forKey: key(.optionalSizeValue)) as? [String: Double] == ["width": 0.0, "height": 0.0])
        
        XCTAssert(d.dictionary(forKey: key(.optionalNilSizeValue)) == nil)
        cg.optionalNilSizeValue = .init(width: 1, height: 2)
        XCTAssert(d.dictionary(forKey: key(.optionalNilSizeValue)) as? [String: Double] == ["width": 1.0, "height": 2.0])
        cg.optionalNilSizeValue = nil
        XCTAssert(d.dictionary(forKey: key(.optionalNilSizeValue)) == nil)
        
        // CGRect
        
        let rectRef = CGRect(origin: .init(x: 1, y: 2), size: .init(width: 3, height: 4))
        let rectDictRef = ["origin": ["x": 1.0, "y": 2.0], "size": ["width": 3.0, "height": 4.0]]
        let zeroDictRef = ["origin": ["x": 0.0, "y": 0.0], "size": ["width": 0.0, "height": 0.0]]
        
        cg.rectValue = rectRef
        XCTAssert(d.dictionary(forKey: key(.rectValue)) as? [String: [String: Double]] == rectDictRef)
        
        cg.optionalRectValue = rectRef
        XCTAssert(d.dictionary(forKey: key(.optionalRectValue)) as? [String: [String: Double]] == rectDictRef)
        cg.optionalRectValue = nil
        XCTAssert(d.dictionary(forKey: key(.optionalRectValue)) as? [String: [String: Double]] == zeroDictRef)
        
        XCTAssert(d.dictionary(forKey: key(.optionalNilRectValue)) == nil)
        cg.optionalNilRectValue = rectRef
        XCTAssert(d.dictionary(forKey: key(.optionalNilRectValue)) as? [String: [String: Double]] == rectDictRef)
        cg.optionalNilRectValue = nil
        XCTAssert(d.dictionary(forKey: key(.optionalNilRectValue)) == nil)
        
        // CGVector
        
        cg.vectorValue = .init(dx: 1, dy: 2)
        XCTAssert(d.dictionary(forKey: key(.vectorValue)) as? [String: Double] == ["dx": 1.0, "dy": 2.0])
        
        cg.optionalVectorValue = .init(dx: 1, dy: 2)
        XCTAssert(d.dictionary(forKey: key(.optionalVectorValue)) as? [String: Double] == ["dx": 1.0, "dy": 2.0])
        cg.optionalVectorValue = nil
        XCTAssert(d.dictionary(forKey: key(.optionalVectorValue)) as? [String: Double] == ["dx": 0.0, "dy": 0.0])
        
        XCTAssert(d.dictionary(forKey: key(.optionalNilVectorValue)) == nil)
        cg.optionalNilVectorValue = .init(dx: 1, dy: 2)
        XCTAssert(d.dictionary(forKey: key(.optionalNilVectorValue)) as? [String: Double] == ["dx": 1.0, "dy": 2.0])
        cg.optionalNilVectorValue = nil
        XCTAssert(d.dictionary(forKey: key(.optionalNilVectorValue)) == nil)
        
        // CGAffineTransform
        
        let transRef = CGAffineTransform(a: 1.0, b: 2.0, c: 3.0, d: 4.0, tx: 5.0, ty: 6.0)
        let transArrayRef = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0]
        let identityArrayRef = [1.0, 0.0, 0.0, 1.0, 0.0, 0.0]
        
        cg.transformValue = transRef
        XCTAssert(d.array(forKey: key(.transformValue)) as? [Double] == transArrayRef)
        
        cg.optionalTransformValue = transRef
        XCTAssert(d.array(forKey: key(.optionalTransformValue)) as? [Double] == transArrayRef)
        cg.optionalTransformValue = nil
        XCTAssert(d.array(forKey: key(.optionalTransformValue)) as? [Double] == identityArrayRef)
        
        XCTAssert(d.array(forKey: key(.optionalNilTransformValue)) == nil)
        cg.optionalNilTransformValue = transRef
        XCTAssert(d.array(forKey: key(.optionalNilTransformValue)) as? [Double] == transArrayRef)
        cg.optionalNilTransformValue = nil
        XCTAssert(d.array(forKey: key(.optionalNilTransformValue)) == nil)
    }
    
    func testSavedStateWithCGTypes() {
        eraseDefaults()
        
        let cg = CGSavedStateTestCase()
        let d = UserDefaults.standard
        
        // CGFloat
        
        cg.floatValue = 42
        XCTAssert(d.object(forKey: key(.floatValue)) as? Double == 42)
        
        
        cg.optionalFloatValue = 42
        XCTAssert(d.object(forKey: key(.optionalFloatValue)) as? Double == 42)
        cg.optionalFloatValue = nil
        XCTAssert(d.object(forKey: key(.optionalFloatValue)) as? Double == 0)
        
        XCTAssert(d.object(forKey: key(.optionalNilFloatValue)) == nil)
        cg.optionalNilFloatValue = 42
        XCTAssert(d.object(forKey: key(.optionalNilFloatValue)) as? Double == 42)
        cg.optionalNilFloatValue = nil
        XCTAssert(d.object(forKey: key(.optionalNilFloatValue)) == nil)
        
        // CGPoint
        
        cg.pointValue = .init(x: 1, y: 2)
        XCTAssert(d.dictionary(forKey: key(.pointValue)) as? [String: Double] == ["x": 1.0, "y": 2.0])
        
        cg.optionalPointValue = .init(x: 1, y: 2)
        XCTAssert(d.dictionary(forKey: key(.optionalPointValue)) as? [String: Double] == ["x": 1.0, "y": 2.0])
        cg.optionalPointValue = nil
        XCTAssert(d.dictionary(forKey: key(.optionalPointValue)) as? [String: Double] == ["x": 0.0, "y": 0.0])
        
        XCTAssert(d.dictionary(forKey: key(.optionalNilPointValue)) == nil)
        cg.optionalNilPointValue = .init(x: 1, y: 2)
        XCTAssert(d.dictionary(forKey: key(.optionalNilPointValue)) as? [String: Double] == ["x": 1.0, "y": 2.0])
        cg.optionalNilPointValue = nil
        XCTAssert(d.dictionary(forKey: key(.optionalNilPointValue)) == nil)
        
        // CGSize
        
        cg.sizeValue = .init(width: 1, height: 2)
        XCTAssert(d.dictionary(forKey: key(.sizeValue)) as? [String: Double] == ["width": 1.0, "height": 2.0])
        
        cg.optionalSizeValue = .init(width: 1, height: 2)
        XCTAssert(d.dictionary(forKey: key(.optionalSizeValue)) as? [String: Double] == ["width": 1.0, "height": 2.0])
        cg.optionalSizeValue = nil
        XCTAssert(d.dictionary(forKey: key(.optionalSizeValue)) as? [String: Double] == ["width": 0.0, "height": 0.0])
        
        XCTAssert(d.dictionary(forKey: key(.optionalNilSizeValue)) == nil)
        cg.optionalNilSizeValue = .init(width: 1, height: 2)
        XCTAssert(d.dictionary(forKey: key(.optionalNilSizeValue)) as? [String: Double] == ["width": 1.0, "height": 2.0])
        cg.optionalNilSizeValue = nil
        XCTAssert(d.dictionary(forKey: key(.optionalNilSizeValue)) == nil)
        
        // CGRect
        
        let rectRef = CGRect(origin: .init(x: 1, y: 2), size: .init(width: 3, height: 4))
        let rectDictRef = ["origin": ["x": 1.0, "y": 2.0], "size": ["width": 3.0, "height": 4.0]]
        let zeroDictRef = ["origin": ["x": 0.0, "y": 0.0], "size": ["width": 0.0, "height": 0.0]]
        
        cg.rectValue = rectRef
        XCTAssert(d.dictionary(forKey: key(.rectValue)) as? [String: [String: Double]] == rectDictRef)
        
        cg.optionalRectValue = rectRef
        XCTAssert(d.dictionary(forKey: key(.optionalRectValue)) as? [String: [String: Double]] == rectDictRef)
        cg.optionalRectValue = nil
        XCTAssert(d.dictionary(forKey: key(.optionalRectValue)) as? [String: [String: Double]] == zeroDictRef)
        
        XCTAssert(d.dictionary(forKey: key(.optionalNilRectValue)) == nil)
        cg.optionalNilRectValue = rectRef
        XCTAssert(d.dictionary(forKey: key(.optionalNilRectValue)) as? [String: [String: Double]] == rectDictRef)
        cg.optionalNilRectValue = nil
        XCTAssert(d.dictionary(forKey: key(.optionalNilRectValue)) == nil)
        
        // CGVector
        
        cg.vectorValue = .init(dx: 1, dy: 2)
        XCTAssert(d.dictionary(forKey: key(.vectorValue)) as? [String: Double] == ["dx": 1.0, "dy": 2.0])
        
        cg.optionalVectorValue = .init(dx: 1, dy: 2)
        XCTAssert(d.dictionary(forKey: key(.optionalVectorValue)) as? [String: Double] == ["dx": 1.0, "dy": 2.0])
        cg.optionalVectorValue = nil
        XCTAssert(d.dictionary(forKey: key(.optionalVectorValue)) as? [String: Double] == ["dx": 0.0, "dy": 0.0])
        
        XCTAssert(d.dictionary(forKey: key(.optionalNilVectorValue)) == nil)
        cg.optionalNilVectorValue = .init(dx: 1, dy: 2)
        XCTAssert(d.dictionary(forKey: key(.optionalNilVectorValue)) as? [String: Double] == ["dx": 1.0, "dy": 2.0])
        cg.optionalNilVectorValue = nil
        XCTAssert(d.dictionary(forKey: key(.optionalNilVectorValue)) == nil)
        
        // CGAffineTransform
        
        let transRef = CGAffineTransform(a: 1.0, b: 2.0, c: 3.0, d: 4.0, tx: 5.0, ty: 6.0)
        let transArrayRef = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0]
        let identityArrayRef = [1.0, 0.0, 0.0, 1.0, 0.0, 0.0]
        
        cg.transformValue = transRef
        XCTAssert(d.array(forKey: key(.transformValue)) as? [Double] == transArrayRef)
        
        cg.optionalTransformValue = transRef
        XCTAssert(d.array(forKey: key(.optionalTransformValue)) as? [Double] == transArrayRef)
        cg.optionalTransformValue = nil
        XCTAssert(d.array(forKey: key(.optionalTransformValue)) as? [Double] == identityArrayRef)
        
        XCTAssert(d.array(forKey: key(.optionalNilTransformValue)) == nil)
        cg.optionalNilTransformValue = transRef
        XCTAssert(d.array(forKey: key(.optionalNilTransformValue)) as? [Double] == transArrayRef)
        cg.optionalNilTransformValue = nil
        XCTAssert(d.array(forKey: key(.optionalNilTransformValue)) == nil)
    }
    
    func testDefaultsValue() {
        eraseDefaults()
        
        let exp = expectation(description: "onChangeDoubleValue")
        exp.expectedFulfillmentCount = 2
        
        let doubleValue = DefaultsValue(key: .doubleValue, initialValue: Double(42)) { value in
            exp.fulfill()
        }
        
        let doubleValueCopy = doubleValue
        
        doubleValue.value = 21
        
        XCTAssert(doubleValue == 21)
        XCTAssert(doubleValue < 42)
        
        doubleValueCopy.value = 42
        
        XCTAssert(21 < doubleValue)
        XCTAssert(42 == doubleValue)
        
        waitForExpectations(timeout: 1)
    }
    
    static var allTests = [
        ("testWrapper", testWrapper),
        ("testWrapperWithCGTypes", testWrapperWithCGTypes),
    ]
}
