import XCTest
import DefaultsWrapper

final class UserDefaultsExtensionTests: XCTestCase {
    
    func testCGTypes() {
        let d = UserDefaults.standard
        
        ["cgfloat", "cgpoint", "cgsize", "cgrect", "cgvector", "cgaffinetransform"].forEach(d.removeObject(forKey:))
        
        d.set(CGFloat(42), forKey: "cgfloat")
        XCTAssert(d.cgFloat(forKey: "cgfloat") == 42)
        XCTAssert(d.cgFloat(forKey: "not a key") == .zero)
        
        d.set(CGPoint(x: 1, y: 2), forKey: "cgpoint")
        XCTAssert(d.cgPoint(forKey: "cgpoint") == CGPoint(x: 1, y: 2))
        XCTAssert(d.cgPoint(forKey: "not a key") == .zero)
        
        d.set(CGSize(width: 3, height: 4), forKey: "cgsize")
        XCTAssert(d.cgSize(forKey: "cgsize") == CGSize(width: 3, height: 4))
        XCTAssert(d.cgSize(forKey: "not a key") == .zero)
        
        d.set(CGRect(origin: .init(x: 1, y: 2), size: .init(width: 3, height: 4)), forKey: "cgrect")
        XCTAssert(d.cgRect(forKey: "cgrect") == CGRect(origin: .init(x: 1, y: 2), size: .init(width: 3, height: 4)))
        XCTAssert(d.cgRect(forKey: "not a key") == .zero)
        
        d.set(CGVector(dx: 1, dy: 2), forKey: "cgvector")
        XCTAssert(d.cgVector(forKey: "cgvector") == CGVector(dx: 1, dy: 2))
        XCTAssert(d.cgVector(forKey: "not a key") == .zero)
        
        d.set(CGAffineTransform(scaleX: 1, y: 2), forKey: "cgaffinetransform")
        XCTAssert(d.cgAffineTransform(forKey: "cgaffinetransform") == CGAffineTransform(scaleX: 1, y: 2))
        XCTAssert(d.cgAffineTransform(forKey: "not a key") == .identity)
    }
    
    static var allTests = [
        ("testCGTypes", testCGTypes),
    ]
}
