//
//  Data.swift
//  OpenGraph
//
//  Created by p-x9 on 2021/12/04.
//  Copyright © 2021 Satoshi Takano. All rights reserved.
//

import Foundation

extension Data {
    @available(macOS 10.10, *)
    var stringEncoding: String.Encoding? {
#if os(Linux)
        var nsString: NSString?
        guard case let rawValue = NSString.stringEncoding(for: self, encodingOptions: nil, convertedString: &nsString, usedLossyConversion: nil), rawValue != 0 else { return nil }
        return String.Encoding(rawValue: rawValue)
#else
        return nil
#endif
    }
}
