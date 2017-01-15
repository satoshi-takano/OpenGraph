import Foundation

public protocol OpenGraphParser {
    func parse(htmlString: String) -> [OpenGraphMetadata: String]
}

extension OpenGraphParser {
    func parse(htmlString: String) -> [OpenGraphMetadata: String] {
        // matching
        let pattern1 = "<meta\\s.*?property=\"og:(\\w+?)\".*?/?>"
        let pattern2 = "content=\"([^<>]*?)\""
        let regexp1  = try! NSRegularExpression(pattern: pattern1, options: [.dotMatchesLineSeparators])
        let regexp2  = try! NSRegularExpression(pattern: pattern2, options: [.dotMatchesLineSeparators])
        let matches1 = regexp1.matches(in: htmlString,
                                       options: [],
                                       range: NSMakeRange(0, htmlString.characters.count))
        if matches1.isEmpty {
            return [:]
        }

        // create attribute dictionary
        let nsString = htmlString as NSString
        let attributes = matches1.reduce([OpenGraphMetadata: String]()) { (attributes, result) -> [OpenGraphMetadata: String] in
            var copiedAttributes = attributes
            let property = nsString.substring(with: result.rangeAt(1))
            let content  = { () -> String in
                let metaTag  = nsString.substring(with: result.rangeAt(0))
                let matches2 = regexp2.matches(in: metaTag,
                                               options: [],
                                               range: NSMakeRange(0, metaTag.characters.count))
                guard let result = matches2.first else { return "" }
                return (metaTag as NSString).substring(with: result.rangeAt(1))
            }()

            guard let metadata = OpenGraphMetadata(rawValue: property) else {
                return copiedAttributes
            }
            copiedAttributes[metadata] = content
            return copiedAttributes
        }
        
        return attributes
    }
}
