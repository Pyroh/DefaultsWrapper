//
//  CGTypesExtension.swift
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


import CoreGraphics

extension CGFloat: UserDefaultsConvertible {
    func convert() -> Double {
        Double(self)
    }
    
    static func reverse(from object: Double) -> CGFloat? {
        CGFloat(object)
    }
}

extension CGPoint: UserDefaultsConvertible {
    func convert() -> [String: Double] {
        ["x": self.x.convert(), "y": self.y.convert()]
    }
    
    static func reverse(from object: [String: Double]) -> CGPoint? {
        guard let x = object["x"], let y = object["y"] else { return nil }
        
        return .init(x: x, y: y)
    }
}

extension CGSize: UserDefaultsConvertible {
    func convert() -> [String: Double] {
        ["width": Double(self.width), "height": Double(self.height)]
    }
    
    static func reverse(from object: [String: Double]) -> CGSize? {
        guard let width = object["width"], let height = object["height"] else { return nil }
        
        return .init(width: width, height: height)
    }
}

extension CGRect: UserDefaultsConvertible {
    func convert() -> [String: [String: Double]] {
        ["origin": self.origin.convert(), "size": self.size.convert()]
    }
    
    static func reverse(from object: [String : [String : Double]]) -> CGRect? {
        guard let origin = object["origin"].flatMap(CGPoint.reverse(from:)),
            let size = object["size"].flatMap(CGSize.reverse(from:)) else { return nil}
        
        return .init(origin: origin, size: size)
    }
}

extension CGVector: UserDefaultsConvertible {
    func convert() -> [String: Double] {
        ["dx": self.dx.convert(), "dy": self.dy.convert()]
    }
    
    static func reverse(from object: [String : Double]) -> CGVector? {
        guard let dx = object["dx"], let dy = object["dy"] else { return nil }
        
        return .init(dx: dx, dy: dy)
    }
}

extension CGAffineTransform: UserDefaultsConvertible {
    func convert() -> [Double] {
        [a, b, c, d, tx, ty].map { $0.convert() }
    }
    
    static func reverse(from object: [Double]) -> CGAffineTransform? {
        guard object.count == 6 else { return nil }
        let v = object.map { CGFloat($0) }
        
        return CGAffineTransform(a: v[0], b: v[1], c: v[2], d: v[3], tx: v[4], ty: v[5])
    }
}

