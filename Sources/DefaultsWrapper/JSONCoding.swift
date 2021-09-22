//
//  JSONCoding.swift
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


import Foundation

enum JSONCoding {
    
    /// Encodes any `Encodable` object to JSON and returns the corresponding JSON utf8 string as a `Data` object.
    ///
    /// - Attention: This method will stop execution if the `value` encoding fails. `Encodable` type failing to encode is a serious issue and must be handled at design time.
    ///
    /// - Parameter value: The object to encode.
    static func data<T: Encodable>(from value: T) -> Data {
        let encoder = JSONEncoder()
        do {
            return try encoder.encode(value)
        }
        catch {
            fatalError(error.localizedDescription)
        }
    }
    
    
    /// Attempt to decode any `Decodable` object fron the given `Data` object and return it on success. Return `nil` otherwise.
    /// - Parameter data: the byte buffer to try and decode an object from.
    static func object<T: Decodable>(from data: Data) -> T? {
        try? JSONDecoder().decode(T.self, from: data)
    }
}
