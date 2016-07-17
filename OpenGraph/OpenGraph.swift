import Foundation

public struct OpenGraph {
    private let source: [OpenGraphMetadata: String]
    
    public static func fetch(url: NSURL, completion: (OpenGraph?, ErrorType?) -> Void) {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: configuration)
        
        let task = session.dataTaskWithURL(url) { (data, response, error) in
            switch (data, response, error) {
            case (_, _, let error?):
                completion(nil, error)
                break
            case (let data?, let response as NSHTTPURLResponse, _):
                if !(200..<300).contains(response.statusCode) {
                    completion(nil, OpenGraphResponseError.UnexpectedStatusCode(response.statusCode))
                } else {
                    guard let htmlString = String(data: data, encoding: NSUTF8StringEncoding) else {
                        completion(nil, OpenGraphParseError.EncodingError)
                        return
                    }
                    
                    let og = OpenGraph(htmlString: htmlString)
                    completion(og, error)
                }
                break
            default:
                break
            }
        }
        
        task.resume()
    }
    
    init(htmlString: String, injector: () -> OpenGraphParser = { DefaultOpenGraphParser() }) {
        let parser = injector()
        source = parser.parse(htmlString)
    }
    
    public subscript (attributeName: OpenGraphMetadata) -> String? {
        return source[attributeName]
    }
}

private struct DefaultOpenGraphParser: OpenGraphParser {
}