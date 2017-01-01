import Foundation

public protocol OpenGraphParser {
    func parse(htmlString: String) -> [OpenGraphMetadata: String]
}

extension OpenGraphParser {
    func parse(htmlString: String) -> [OpenGraphMetadata: String] {
        // matching
        let pattern1 = "<meta\\s+property=\"og:(\\w+)\"\\s+content=\"([^<>]*)\"\\s*?/*?>.*?"
        let pattern2 = "<meta\\s+content=\"([^<>]*)\"\\s+property=\"og:(\\w+)\"\\s*?/*?>.*?"
        let pattern = "\(pattern1)|\(pattern2)"
        let regexp = try! NSRegularExpression(pattern: pattern, options: [.dotMatchesLineSeparators])
        let matches = regexp.matches(in: htmlString, options: [], range: NSMakeRange(0, htmlString.characters.count))
        if matches.isEmpty {
            return [:]
        }

        // create attribute dictionary
        let nsString = htmlString as NSString
        let attributes = matches.reduce([OpenGraphMetadata: String]()) { (attributes, result) -> [OpenGraphMetadata: String] in
            var copiedAttributes = attributes
            var property: String?
            var content: String?

            if result.rangeAt(1).length > 0 && result.rangeAt(2).length > 0 {
                property = nsString.substring(with: result.rangeAt(1))
                content = nsString.substring(with: result.rangeAt(2))
            }

            if result.rangeAt(3).length > 0 && result.rangeAt(4).length > 0 {
                property = nsString.substring(with: result.rangeAt(4))
                content = nsString.substring(with: result.rangeAt(3))
            }

            if let property = property, let content = content {
                if let property = OpenGraphMetadata(rawValue: property) {
                    copiedAttributes[property] = content
                }
            }

            return copiedAttributes
        }
        
        return attributes
    }
}
