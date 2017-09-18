import Foundation

public struct OpenGraph {
    fileprivate let source: [OpenGraphMetadata: String]
    
    public static func fetch(url: URL, completion: @escaping (OpenGraph?, Error?) -> Void) {
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        let task = session.dataTask(with: url, completionHandler: { (data, response, error) in
            handleFetchResult(data: data, response: response, error: error, callback: completion)
        })
        task.resume()
    }
    
    public static func fetch(url: URL, headers: [String:String], completion: @escaping (OpenGraph?, Error?) -> Void) {
        var mutableURLRequest = URLRequest(url: url)
        for hkey in headers.keys {
            let value:String! = headers[hkey]
            if value != nil {
                mutableURLRequest.setValue(value, forHTTPHeaderField: hkey)
            }
        }
        
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        let task = session.dataTask(with: mutableURLRequest, completionHandler: { (data, response, error) in
            handleFetchResult(data: data, response: response, error: error, callback: completion)
        }) 
        task.resume()
    }
    
    private static func handleFetchResult(data: Data?, response: URLResponse?, error: Error?, callback: @escaping (OpenGraph?, Error?) -> Void){
        switch (data, response, error) {
        case (_, _, let error?):
            callback(nil, error)
            break
        case (let data?, let response as HTTPURLResponse, _):
            if !(200..<300).contains(response.statusCode) {
                callback(nil, OpenGraphResponseError.unexpectedStatusCode(response.statusCode))
            } else {
                guard let htmlString = String(data: data, encoding: String.Encoding.utf8) else {
                    callback(nil, OpenGraphParseError.encodingError)
                    return
                }
                
                let og = OpenGraph(htmlString: htmlString)
                callback(og, error)
            }
            break
        default:
            break
        }
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
