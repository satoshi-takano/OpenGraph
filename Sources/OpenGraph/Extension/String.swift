//
//  String.swift
//  OpenGraph
//
//  Created by p-x9 on 2021/12/04.
//  Copyright © 2021 Satoshi Takano. All rights reserved.
//

import Foundation

extension String {
    init?(data: Data, `default`: String.Encoding = .utf8) {
        var encoding = `default`
        if #available(macOS 10.10, *) {
            encoding = data.stringEncoding ?? `default`
        }
        self.init(data: data, encoding: encoding)
    }
}
