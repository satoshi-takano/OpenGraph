import Foundation

public protocol OpenGraphParser {
    func parse(htmlString: String) -> [OpenGraphMetadata: String]
}

extension OpenGraphParser {
    func parse(htmlString: String) -> [OpenGraphMetadata: String] {
        // matching
        let pattern = "<meta\\s+property=\"og:(\\w+)\"\\s+content=\"(.*?)\"\\s*?/*?>.*?"
        let regexp = try! NSRegularExpression(pattern: pattern, options: [.dotMatchesLineSeparators])
        let matches = regexp.matches(in: htmlString, options: [], range: NSMakeRange(0, htmlString.characters.count))
        if matches.isEmpty {
            return [:]
        }
        
        // create attribute dictionary
        let nsString = htmlString as NSString
        let attributes = matches.reduce([OpenGraphMetadata: String]()) { (attributes, result) -> [OpenGraphMetadata: String] in
            var copiedAttributes = attributes
            let property = nsString.substring(with: result.rangeAt(1))
            let content = nsString.substring(with: result.rangeAt(2))
            
            if let property = OpenGraphMetadata(rawValue: property) {
                copiedAttributes[property] = content
            }
            
            return copiedAttributes
        }
        
        return attributes
    }
}
