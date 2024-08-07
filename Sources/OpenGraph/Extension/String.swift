//
//  String.swift
//  OpenGraph
//
//  Created by p-x9 on 2021/12/04.
//  Copyright © 2021 Satoshi Takano. All rights reserved.
//

import Foundation

extension String {
    init?(data: Data, textEncodingName: String? = nil, `default`: String.Encoding = .utf8) {
        let encoding: String.Encoding = {
            if let textEncodingName = textEncodingName {
                let cfe = CFStringConvertIANACharSetNameToEncoding(textEncodingName as CFString)
                if cfe != kCFStringEncodingInvalidId {
                    let se = CFStringConvertEncodingToNSStringEncoding(cfe)
                    return String.Encoding(rawValue: se)
                }
            }
            return data.stringEncoding ?? `default`
        }()

        self.init(data: data, encoding: encoding)
    }
    
    //Retreived from: https://stackoverflow.com/a/30141700
    /// Returns a new string made by replacing in the `String`
    /// all HTML character entity references with the corresponding
    /// character.
    var stringByDecodingHTMLEntities : String {
        // Mapping from XML/HTML character entity reference to character
        // From http://en.wikipedia.org/wiki/List_of_XML_and_HTML_character_entity_references
        let characterEntities : [ Substring : Character ] = [
            // XML predefined entities:
            "&quot;"    : "\"",
            "&amp;"     : "&",
            "&apos;"    : "'",
            "&lt;"      : "<",
            "&gt;"      : ">",

            // HTML character entity references:
            "&nbsp;"    : "\u{00a0}",
            // ...
            "&diams;"   : "♦",
        ]

        // ===== Utility functions =====

        // Convert the number in the string to the corresponding
        // Unicode character, e.g.
        //    decodeNumeric("64", 10)   --> "@"
        //    decodeNumeric("20ac", 16) --> "€"
        func decodeNumeric(_ string : Substring, base : Int) -> Character? {
            guard let code = UInt32(string, radix: base),
                let uniScalar = UnicodeScalar(code) else { return nil }
            return Character(uniScalar)
        }

        // Decode the HTML character entity to the corresponding
        // Unicode character, return `nil` for invalid input.
        //     decode("&#64;")    --> "@"
        //     decode("&#x20ac;") --> "€"
        //     decode("&lt;")     --> "<"
        //     decode("&foo;")    --> nil
        func decode(_ entity : Substring) -> Character? {

            if entity.hasPrefix("&#x") || entity.hasPrefix("&#X") {
                return decodeNumeric(entity.dropFirst(3).dropLast(), base: 16)
            } else if entity.hasPrefix("&#") {
                return decodeNumeric(entity.dropFirst(2).dropLast(), base: 10)
            } else {
                return characterEntities[entity]
            }
        }

        // ===== Method starts here =====

        var result = ""
        var position = startIndex

        // Find the next '&' and copy the characters preceding it to `result`:
        while let ampRange = self[position...].range(of: "&") {
            result.append(contentsOf: self[position ..< ampRange.lowerBound])
            position = ampRange.lowerBound

            // Find the next ';' and copy everything from '&' to ';' into `entity`
            guard let semiRange = self[position...].range(of: ";") else {
                // No matching ';'.
                break
            }
            let entity = self[position ..< semiRange.upperBound]
            position = semiRange.upperBound

            if let decoded = decode(entity) {
                // Replace by decoded character:
                result.append(decoded)
            } else {
                // Invalid entity, copy verbatim:
                result.append(contentsOf: entity)
            }
        }
        // Copy remaining characters to `result`:
        result.append(contentsOf: self[position...])
        return result
    }
}
