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
