//
//  OpenGraphTests.swift
//  OpenGraphTests
//
//  Created by Satoshi Takano on 2016/07/02.
//  Copyright © 2016年 Satoshi Takano. All rights reserved.
//

import XCTest
@testable import OpenGraph

class OpenGraphTests: XCTestCase {
    // htmlString is
    // <!doctype html>
    // <html lang="en">
    // <head>
    //   <meta charset="utf-8">
    //   <meta http-equiv="X-UA-Compatible" content="IE=edge">
    //   <title>Title</title>
    //   <meta name="description" content="Description">
    //   <meta property="og:title" content="example.com title">
    //   <meta property="og:type" content="website">
    //   <meta property="og:url" content="https://example.com">
    //   <meta property="og:image" content="https://example.com/example.png">
    //   <meta property="og:description" content="example.com description">
    //   <link rel="stylesheet" media="all" href="/main.css" />
    // </head>
    // </html>
    private let htmlString = "<!doctype html><html lang=\"en\"><head>  <meta charset=\"utf-8\">  <meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\">  <title>Title</title>  <meta name=\"description\" content=\"Description\">  <meta property=\"og:type\" content=\"website\">  <meta property=\"og:url\" content=\"https://example.com\">  <meta property=\"og:image\" content=\"https://example.com/example.png\">  <meta property=\"og:title\" content=\"example.com title\">  <meta property=\"og:description\" content=\"example.com description\">  <link rel=\"stylesheet\" media=\"all\" href=\"/main.css\" /></head></html>"
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testBasicMetadata() {
        let og = OpenGraph(htmlString: htmlString)
        XCTAssert(og[.title] == "example.com title")
        XCTAssert(og[.type] == "website")
        XCTAssert(og[.url] == "https://example.com")
        XCTAssert(og[.image] == "https://example.com/example.png")
    }
    
}
