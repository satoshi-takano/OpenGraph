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
    
    func testCustomHeader() {
        let responseArrived = expectation(description: "response of async request has arrived")
        
        OHHTTPStubs.stubRequests(passingTest: { request -> Bool in
            return true
        }) { request -> OHHTTPStubsResponse in
            let path = Bundle(for: type(of: self)).path(forResource: "example.com", ofType: "html")
            return OHHTTPStubsResponse(fileAtPath: path!, statusCode: 200, headers: nil)
        }
        
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
            XCTAssert(og[.title] == "example.com title")
            XCTAssert(og[.type] == "website")
            XCTAssert(og[.url] == "https://www.example.com")
            XCTAssert(og[.image] == "https://www.example.com/images/example.png")
            
            XCTAssert(error == nil)
        }
    }
    
    func testFetching() {
        let responseArrived = expectation(description: "response of async request has arrived")
        
        OHHTTPStubs.stubRequests(passingTest: { request -> Bool in
                return true
            }) { request -> OHHTTPStubsResponse in
                let path = Bundle(for: type(of: self)).path(forResource: "example.com", ofType: "html")
                return OHHTTPStubsResponse(fileAtPath: path!, statusCode: 200, headers: nil)
            }
        
        let url = URL(string: "https://www.example.com")!
        var og: OpenGraph!
        var error: Error?
        OpenGraph.fetch(url: url) { _og, _error in
            og = _og
            error = _error
            responseArrived.fulfill()
        }
        
        waitForExpectations(timeout: 10) { _ in
            XCTAssert(og[.title] == "example.com title")
            XCTAssert(og[.type] == "website")
            XCTAssert(og[.url] == "https://www.example.com")
            XCTAssert(og[.image] == "https://www.example.com/images/example.png")
            
            XCTAssert(error == nil)
        }
    }
    
    // Detect og:xxx also when order of attributes are reversed.
    func testFetching2() {
        let responseArrived = expectation(description: "response of async request has arrived")
        
        OHHTTPStubs.stubRequests(passingTest: { request -> Bool in
            return true
        }) { request -> OHHTTPStubsResponse in
            let path = Bundle(for: type(of: self)).path(forResource: "example2.com", ofType: "html")
            return OHHTTPStubsResponse(fileAtPath: path!, statusCode: 200, headers: nil)
        }
        
        let url = URL(string: "https://www.example2.com")!
        var og: OpenGraph!
        var error: Error?
        OpenGraph.fetch(url: url) { _og, _error in
            og = _og
            error = _error
            responseArrived.fulfill()
        }
        
        waitForExpectations(timeout: 10) { _ in
            XCTAssert(og[.title] == "example2.com title")
            XCTAssert(og[.type] == "website2")
            XCTAssert(og[.url] == "https://www.example2.com")
            XCTAssert(og[.image] == "https://www.example2.com/images/example2.png")
            
            XCTAssert(error == nil)
        }
    }
    
    // When the meta tag contains other attributes.
    func testFetching3() {
        let responseArrived = expectation(description: "response of async request has arrived")
        
        OHHTTPStubs.stubRequests(passingTest: { request -> Bool in
            return true
        }) { request -> OHHTTPStubsResponse in
            let path = Bundle(for: type(of: self)).path(forResource: "example3.com", ofType: "html")
            return OHHTTPStubsResponse(fileAtPath: path!, statusCode: 200, headers: nil)
        }
        
        let url = URL(string: "https://www.example3.com")!
        var og: OpenGraph!
        var error: Error?
        OpenGraph.fetch(url: url) { _og, _error in
            og = _og
            error = _error
            responseArrived.fulfill()
        }
        
        waitForExpectations(timeout: 10) { _ in
            XCTAssert(og[.title] == "example3.com title")
            XCTAssert(og[.type] == "website3")
            XCTAssert(og[.url] == "https://www.example3.com")
            XCTAssert(og[.image] == "https://www.example3.com/images/example3.png")
            
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
}
