//
//  File.swift
//  File
//
//  Created by Pierre Tacchi on 28/09/21.
//

import Foundation

extension UUID: _UserDefaultsConvertible {
    func convert() -> String { uuidString }
    static func reverse(from uuidString: String) -> UUID? { .init(uuidString: uuidString) }
}
