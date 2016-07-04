# OpenGraph
OpenGraph is a Swift wrapper for the [Open Graph protocol](http://ogp.me/).

```swift
OpenGraph.fetch(url) { og, error in
    print(og?[.title]) // => og:title of the web site
    print(og?[.type])  // => og:type of the web site
    print(og?[.image]) // => og:image of the web site
    print(og?[.url])   // => og:url of the web site
}
```

## Installation
TBD

## License
This project and library has been created by Satoshi Takano and is under the MIT License.
