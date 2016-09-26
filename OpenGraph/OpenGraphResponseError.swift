import Foundation

public enum OpenGraphResponseError: Error {
    case unexpectedStatusCode(Int)
}
