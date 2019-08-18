# A Swift wrapper for the Open Graph protocol (OGP)
[![Build Status](https://travis-ci.org/satoshi-takano/OpenGraph.svg?branch=feature%2Fci)](https://travis-ci.org/satoshi-takano/OpenGraph) [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage) [![Platform](https://cocoapod-badges.herokuapp.com/p/OpenGraph/badge.png)](http://cocoadocs.org/docsets/OpenGraph)  
OpenGraph is a Swift wrapper for the OGP ([Open Graph protocol](http://ogp.me/)).
You can fetch OpenGraph,then you can access the attributes with subscript and the key provided by enum type.
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

If you want to use Rx interface, use an extension below.
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
- Xcode 9 / Swift 4.0 or 3.2 (If you use Xcode 8.x, you can use [1.0.2](https://github.com/satoshi-takano/OpenGraph/releases/tag/1.0.2).)
- iOS 8.0 or later
- macOS 10.9 or later
- tvOS 9.0 or later
- watchOS 2.0 or later

If you use Swift 2.2 or 2.3, use [older version of OpenGraph](https://github.com/satoshi-takano/OpenGraph/tree/0.1.0).

## Installation
### CocoaPods
Insert `pod 'OpenGraph'` to your Podfile and run `pod install`.

### Carthage
Insert `github "satoshi-takano/OpenGraph"` to your Cartfile and run `carthage update`.

## License
This project and library has been created by Satoshi Takano and is under the MIT License.
