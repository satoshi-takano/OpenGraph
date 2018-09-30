import XCTest
import OHHTTPStubs
@testable import OpenGraph

class OpenGraphTests: XCTestCase {
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
        OHHTTPStubs.removeAllStubs()
    }
    
    func setupStub(htmlFileName: String) {
        OHHTTPStubs.stubRequests(passingTest: { request -> Bool in
            return true
        }) { request -> OHHTTPStubsResponse in
            let path = Bundle(for: type(of: self)).path(forResource: htmlFileName, ofType: "html")
            return OHHTTPStubsResponse(fileAtPath: path!, statusCode: 200, headers: nil)
        }
    }
    
    func testCustomHeader() {
        let responseArrived = expectation(description: "response of async request has arrived")
        
        setupStub(htmlFileName: "ogp")
        
        let url = URL(string: "https://www.example.com")!
        var og: OpenGraph!
        var error: Error?
        let headers = ["User-Agent": "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.103 Safari/537.36"]
        OpenGraph.fetch(url: url, headers: headers) { (_og, _error) in
            og = _og
            error = _error
            responseArrived.fulfill()
        }
        
        waitForExpectations(timeout: 10) { _ in
            XCTAssert(og[.title] == " < It's example.com title > ")
            XCTAssert(og[.type] == "website")
            XCTAssert(og[.url] == "https://www.example.com")
            XCTAssert(og[.image] == "https://www.example.com/images/example.png")
            
            XCTAssert(error == nil)
        }
    }
    
    func testFetching() {
        let responseArrived = expectation(description: "response of async request has arrived")
        
        setupStub(htmlFileName: "ogp")
        
        let url = URL(string: "https://www.example.com")!
        var og: OpenGraph!
        var error: Error?
        OpenGraph.fetch(url: url) { _og, _error in
            og = _og
            error = _error
            responseArrived.fulfill()
        }
        
        waitForExpectations(timeout: 10) { _ in
            XCTAssert(og[.title] == " < It's example.com title > ")
            XCTAssert(og[.type] == "website")
            XCTAssert(og[.url] == "https://www.example.com")
            XCTAssert(og[.image] == "https://www.example.com/images/example.png")
            XCTAssert(og[.description] == "example.com description")
            XCTAssert(og[.imageType] == "image/png")
            XCTAssert(error == nil)
        }
    }
    
    func testEmptyOGP() {
        let responseArrived = expectation(description: "response of async request has arrived")
        
        setupStub(htmlFileName: "empty_ogp")
        
        let url = URL(string: "https://www.example.com")!
        var og: OpenGraph!
        var error: Error?
        OpenGraph.fetch(url: url) { _og, _error in
            og = _og
            error = _error
            responseArrived.fulfill()
        }
        
        waitForExpectations(timeout: 10) { _ in
            XCTAssert(og[.title] == nil)
            XCTAssert(og[.type] == nil)
            XCTAssert(og[.url] == nil)
            XCTAssert(og[.image] == nil)
            
            XCTAssert(error == nil)
        }
    }

    func testHTTPResponseError() {
        let responseArrived = expectation(description: "response of async request has arrived")
        
        OHHTTPStubs.stubRequests(passingTest: { request -> Bool in
            return true
        }) { request -> OHHTTPStubsResponse in
            OHHTTPStubsResponse(jsonObject: [:], statusCode: 404, headers: nil)
        }
        
        let url = URL(string: "https://www.example.com")!
        var og: OpenGraph?
        var error: Error?
        OpenGraph.fetch(url: url) { _og, _error in
            og = _og
            error = _error
            responseArrived.fulfill()
        }
        
        waitForExpectations(timeout: 10) { _ in
            XCTAssert(og == nil)

            XCTAssert(error! is OpenGraphResponseError)
            
            var statusCode: Int = 0
            switch error as! OpenGraphResponseError {
            case .unexpectedStatusCode(let code):
                statusCode = code
                break
            }
            
            XCTAssert(statusCode == 404)
        }
    }
    
    func testParseError() {
        let responseArrived = expectation(description: "response of async request has arrived")
        
        OHHTTPStubs.stubRequests(passingTest: { request -> Bool in
            return true
        }) { request -> OHHTTPStubsResponse in
            OHHTTPStubsResponse(data: "あ".data(using: String.Encoding.shiftJIS)!, statusCode: 200, headers: nil)
        }
        
        let url = URL(string: "https://www.example.com")!
        var og: OpenGraph?
        var error: Error?
        OpenGraph.fetch(url: url) { _og, _error in
            og = _og
            error = _error
            responseArrived.fulfill()
        }
        
        waitForExpectations(timeout: 10) { _ in
            XCTAssert(og == nil)
            XCTAssert(error! is OpenGraphParseError)
        }
    }

    func testParsing() {
        var html = "<meta content=\"It's a description\" property=\"og:description\" />"
        XCTAssert(OpenGraph(htmlString: html)[.description] == "It's a description")
        html = "<meta property=\"og:title\" content=\"It's a title contains single quote\"/>"
        XCTAssert(OpenGraph(htmlString: html)[.title] == "It's a title contains single quote")

        html = "<meta content='It&#39;s a description' property='og:description' />"
        XCTAssert(OpenGraph(htmlString: html)[.description] == "It&#39;s a description")
        html = "<meta content='It is a title contains double quote \"' property='og:title' />"
        XCTAssert(OpenGraph(htmlString: html)[.title] == "It is a title contains double quote \"")
    }
}
