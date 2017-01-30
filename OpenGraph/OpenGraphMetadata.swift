import Foundation

public enum OpenGraphMetadata: String {
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
    case musicReleaseDate = "music:releaseDate"
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
    case articlePublishedTime  = "article:publishedTime"
    case articleModifiedTime   = "article:modifiedTime"
    case articleExpirationTime = "article:expirationTime"
    case articleAuthor         = "article:author"
    case articleSection        = "article:section"
    case articleTag            = "article:tag"

    case bookAuthor      = "book:author"
    case bookIsbn        = "book:isbn"
    case bookReleaseDate = "book:releaseDate"
    case bookTag         = "book:tag"

    case profileFirstName = "profile:firstName"
    case profileLastName  = "profile:lastName"
    case profileUsername  = "profile:username"
    case profileGender    = "profile:gender"
}