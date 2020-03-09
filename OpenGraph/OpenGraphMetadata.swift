import Foundation

public enum OpenGraphMetadata: String, CaseIterable {
    // Basic Metadata
    case title
    case type
    case image
    case url
    
    // Optional Metadata
    case audio
    case description
    case determiner
    case locale
    case localeAlternate = "locale:alternate"
    case siteName = "site_name"
    case video
    
    // Structured Properties
    case imageUrl        = "image:url"
    case imageSecure_url = "image:secure_url"
    case imageType       = "image:type"
    case imageWidth      = "image:width"
    case imageHeight     = "image:height"
    
    // Music
    case musicDuration    = "music:duration"
    case musicAlbum       = "music:album"
    case musicAlbumDisc   = "music:album:disc"
    case musicAlbumMusic  = "music:album:track"
    case musicMusician    = "music:musician"
    case musicSong        = "music:song"
    case musicSongDisc    = "music:song:disc"
    case musicSongTrack   = "music:song:track"
    case musicReleaseDate = "music:release_date"
    case musicCreator     = "music:creator"

    // Video
    case videoActor       = "video:actor"
    case videoActorRole   = "video:actor:role"
    case videoDirector    = "video:director"
    case videoWriter      = "video:writer"
    case videoDuration    = "video:duration"
    case videoReleaseDate = "video:releaseDate"
    case videoTag         = "video:tag"
    case videoSeries      = "video:series"

    // No Vertical
    case articlePublishedTime  = "article:published_time"
    case articleModifiedTime   = "article:modified_time"
    case articleExpirationTime = "article:expiration_time"
    case articleAuthor         = "article:author"
    case articleSection        = "article:section"
    case articleTag            = "article:tag"

    case bookAuthor      = "book:author"
    case bookIsbn        = "book:isbn"
    case bookReleaseDate = "book:release_date"
    case bookTag         = "book:tag"

    case profileFirstName = "profile:first_name"
    case profileLastName  = "profile:last_name"
    case profileUsername  = "profile:username"
    case profileGender    = "profile:gender"
}

#if !swift(>=4.2)
public protocol CaseIterable {
    associatedtype AllCases: Collection where AllCases.Element == Self
    static var allCases: AllCases { get }
}
extension CaseIterable where Self: Hashable {
    public static var allCases: [Self] {
        return [Self](AnySequence { () -> AnyIterator<Self> in
            var raw = 0
            var first: Self?
            return AnyIterator {
                let current = withUnsafeBytes(of: &raw) { $0.load(as: Self.self) }
                if raw == 0 {
                    first = current
                } else if current == first {
                    return nil
                }
                raw += 1
                return current
            }
        })
    }
}
#endif
