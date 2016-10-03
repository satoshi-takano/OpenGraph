# OpenGraph
[![Build Status](https://travis-ci.org/satoshi-takano/OpenGraph.svg?branch=feature%2Fci)](https://travis-ci.org/satoshi-takano/OpenGraph)  
OpenGraph is a Swift wrapper for the OGP ([Open Graph protocol](http://ogp.me/)).
You can fetch OpenGraph,then you can access the attributes with subscript and the key provided by enum type.
```swift
OpenGraph.fetch(url) { og, error in
    print(og?[.title]) // => og:title of the web site
    print(og?[.type])  // => og:type of the web site
    print(og?[.image]) // => og:image of the web site
    print(og?[.url])   // => og:url of the web site
}
```

## Requirements
- Swift 3.0
- iOS 8.0 or later
- macOS 10.9 or later
- tvOS 9.0 or later
- watchOS 2.0 or later

## Installation
### CocoaPods
Insert `pod 'OpenGraph'` to your Podfile and run `pod install`.

### Carthage
Insert `github "satoshi-takano/OpenGraph"` to your Cartfile and run `carthage update`.

## License
This project and library has been created by Satoshi Takano and is under the MIT License.
