//
//  String.swift
//  OpenGraph
//
//  Created by p-x9 on 2021/12/04.
//  Copyright © 2021 Satoshi Takano. All rights reserved.
//

import Foundation

extension String {
    @available(macOS 10.15, iOS 13, watchOS 6, tvOS 13, *)
    init?(data: Data, textEncodingName: String? = nil, `default`: String.Encoding = .utf8) {
        let encoding: String.Encoding = {
            if let textEncodingName = textEncodingName {
                let cfe = CFStringConvertIANACharSetNameToEncoding(textEncodingName as CFString)
                if cfe != kCFStringEncodingInvalidId {
                    let se = CFStringConvertEncodingToNSStringEncoding(cfe)
                    return String.Encoding(rawValue: se)
                }
            }
            if #available(macOS 10.10, *) {
                return data.stringEncoding ?? `default`
            }
            return `default`
        }()

        self.init(data: data, encoding: encoding)
    }
}
