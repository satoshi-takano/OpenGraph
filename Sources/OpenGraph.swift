//
//  OpenGraph.swift
//  Melpy
//
//  Created by Satoshi Takano on 2016/07/01.
//  Copyright © 2016年 DeNA. All rights reserved.
//

import Foundation

public struct OpenGraph {
    private let source: [OpenGraphMetadata: String]
    
    init(data: NSData, injector: () -> OpenGraphParser = { DefaultOpenGraphParser() }) {
        let parser = injector()
        source = parser.parse(data)
    }
    
    public subscript (attributeName: OpenGraphMetadata) -> String? {
        return source[attributeName]
    }
}

private struct DefaultOpenGraphParser: OpenGraphParser {
}