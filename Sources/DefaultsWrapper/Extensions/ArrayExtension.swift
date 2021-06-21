//
//  File.swift
//  
//
//  Created by Pierre Tacchi on 21/06/21.
//

import Foundation

extension Array: UserDefaultsConvertible where Element: UserDefaultsConvertible {
    public func convertedObject() -> some PropertyListSerializable {
        map { $0.convertedObject() }
    }
    
    public static func instanciate(from object: PropertyListSerializableType) -> Array<Element>? {
        guard let array = object as? [Element.PropertyListSerializableType] else { return nil }
        return array.compactMap(Element.instanciate(from:))
    }
}
