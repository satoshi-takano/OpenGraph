import Foundation

public struct OpenGraph {
    fileprivate let source: [OpenGraphMetadata: String]
    
    public static func fetch(url: URL, completion: @escaping (OpenGraph?, Error?) -> Void) {
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        
        let task = session.dataTask(with: url, completionHandler: { (data, response, error) in
            switch (data, response, error) {
            case (_, _, let error?):
                completion(nil, error)
                break
            case (let data?, let response as HTTPURLResponse, _):
                if !(200..<300).contains(response.statusCode) {
                    completion(nil, OpenGraphResponseError.unexpectedStatusCode(response.statusCode))
                } else {
                    guard let htmlString = String(data: data, encoding: String.Encoding.utf8) else {
                        completion(nil, OpenGraphParseError.encodingError)
                        return
                    }
                    
                    let og = OpenGraph(htmlString: htmlString)
                    completion(og, error)
                }
                break
            default:
                break
            }
        }) 
        
        task.resume()
    }
    
    init(htmlString: String, injector: () -> OpenGraphParser = { DefaultOpenGraphParser() }) {
        let parser = injector()
        source = parser.parse(htmlString: htmlString)
    }
    
    public subscript (attributeName: OpenGraphMetadata) -> String? {
        return source[attributeName]
    }
}

private struct DefaultOpenGraphParser: OpenGraphParser {
}
