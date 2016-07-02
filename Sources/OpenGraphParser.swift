//
//  OpenGraphParser.swift
//  OpenGraph
//
//  Created by Satoshi Takano on 2016/07/02.
//  Copyright © 2016年 Satoshi Takano. All rights reserved.
//

import Foundation

public protocol OpenGraphParser {
    func parse(htmlString: String) -> [OpenGraphMetadata: String]
}

extension OpenGraphParser {
    func parse(data: NSData) -> [String: String] {
        guard let str = String(data: data, encoding: NSUTF8StringEncoding) else {
            return [:]
        }
        
    func parse(htmlString: String) -> [OpenGraphMetadata: String] {
        // matching
        let pattern = "<meta\\s+property=\"og:(\\w+)\"\\s+content=\"(.*?)\"\\s*?/*?>.*?"
        let regexp = try! NSRegularExpression(pattern: pattern, options: [.DotMatchesLineSeparators])
        let matches = regexp.matchesInString(str, options: [], range: NSMakeRange(0, str.characters.count))
        if matches.isEmpty {
            return [:]
        }
        
        // create attribute dictionary
        let nsString = str as NSString
        let attributes = matches.reduce([OpenGraphMetadata: String]()) { (attributes, result) -> [OpenGraphMetadata: String] in
            var copiedAttributes = attributes
            let property = nsString.substringWithRange(result.rangeAtIndex(1))
            let content = nsString.substringWithRange(result.rangeAtIndex(2))
            
            if let property = OpenGraphMetadata(rawValue: property) {
                copiedAttributes[property] = content
            }
            
            return copiedAttributes
        }
        
        return attributes
    }
}