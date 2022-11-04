import XCTest
import OHHTTPStubs
import OHHTTPStubsSwift
@testable import OpenGraph

class OpenGraphTests: XCTestCase {
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
        HTTPStubs.removeAllStubs()
    }
    
    func setupStub(htmlFileName: String) {
        HTTPStubs.stubRequests { request in
            true
        } withStubResponse: { request in
#if SWIFT_PACKAGE
          let path = Bundle.module.path(forResource: htmlFileName, ofType: "html")
#else
          let path = Bundle(for: type(of: self)).path(forResource: htmlFileName, ofType: "html")
#endif
            return .init(fileAtPath: path!, statusCode: 200, headers: nil)
        }
    }
    
    func testCustomHeader() {
        let responseArrived = expectation(description: "response of async request has arrived")
        
        setupStub(htmlFileName: "ogp")
        
        let url = URL(string: "https://www.example.com")!
        var og: OpenGraph!
        var error: Error?
        let headers = ["User-Agent": "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.103 Safari/537.36"]
        OpenGraph.fetch(url: url, headers: headers) { result in
            switch result {
            case .success(let _og): og = _og
            case .failure(let _error): error = _error
            }
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
        OpenGraph.fetch(url: url) { result in
            switch result {
            case .success(let _og): og = _og
            case .failure(let _error): error = _error
            }
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
        OpenGraph.fetch(url: url) { result in
            switch result {
            case .success(let _og): og = _og
            case .failure(let _error): error = _error
            }
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
        
        HTTPStubs.stubRequests { request in
            true
        } withStubResponse: { request in
            return .init(jsonObject: [:], statusCode: 404, headers: nil)
        }

        let url = URL(string: "https://www.example.com")!
        var og: OpenGraph?
        var error: Error?
        OpenGraph.fetch(url: url) { result in
            switch result {
            case .success(let _og): og = _og
            case .failure(let _error): error = _error
            }
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
    
    func testParseError() async {
        OHHTTPStubsSwift.stub { request in
          return true
        } response: { request in
          HTTPStubsResponse()
        }

        HTTPStubs.stubRequests { request in
            true
        } withStubResponse: { request in
            .init(data: "あ".data(using: String.Encoding.shiftJIS)!, statusCode: 200, headers: nil)
        }

        let url = URL(string: "https://www.example.com")!
      
        do {
            _ = try await OpenGraph.fetch(url: url)
        }
        catch let error {
            XCTAssert(error is OpenGraphParseError)
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
