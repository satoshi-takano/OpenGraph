# A Swift wrapper for Open Graph protocol (OGP)
[![Build Status](https://travis-ci.org/satoshi-takano/OpenGraph.svg?branch=feature%2Fci)](https://travis-ci.org/satoshi-takano/OpenGraph) [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage) [![Platform](https://cocoapod-badges.herokuapp.com/p/OpenGraph/badge.png)](http://cocoadocs.org/docsets/OpenGraph)  
OpenGraph is a Swift wrapper for OGP ([Open Graph protocol](http://ogp.me/)).
You can fetch OpenGraph and get access to the attributes using subscript and enum cases as follows.
```swift
OpenGraph.fetch(url: url) { result in
    switch result {
    case .success(let og):
        print(og[.title]) // => og:title of the web site
        print(og[.type])  // => og:type of the web site
        print(og[.image]) // => og:image of the web site
        print(og[.url])   // => og:url of the web site
    case .failure(let error):
        print(error)
    }
}
```

All metadatas are defined [here](https://github.com/satoshi-takano/OpenGraph/blob/master/OpenGraph/OpenGraphMetadata.swift).  
This library doesn't provide any platform specific views to display OGP data for high portability.

Furthermore, please copy the extension below to your own project if you want to use this library with the Rx interface.

```swift
extension Reactive where Base: OpenGraph {
    static func fetch(url: URL?) -> Observable<OpenGraph> {
        return Observable.create { observer in
            guard let url = url else {
                observer.onCompleted()
                return Disposables.create()
            }

            OpenGraph.fetch(url: url) { result in
                switch result {
                case .success(let og):
                    observer.onNext(og)
                case .failure(let error):
                    observer.onError(error)
                }
                observer.onCompleted()
            }

            return Disposables.create()
        }
    }
}
```

## Requirements
- Xcode 11.x / Swift 5.x (If you use Xcode 10.x, you can use [1.1.0](https://github.com/satoshi-takano/OpenGraph/releases/tag/1.1.0).)
- iOS 8.0 or later
- macOS 10.9 or later
- tvOS 9.0 or later
- watchOS 2.0 or later

If you use Swift 2.2 or 2.3, use [older version of OpenGraph](https://github.com/satoshi-takano/OpenGraph/releases).

## Installation
### CocoaPods
Insert `pod 'OpenGraph'` to your Podfile and run `pod install`.

### Carthage
Insert `github "satoshi-takano/OpenGraph"` to your Cartfile and run `carthage update`.

## License
This library is under the MIT License.
