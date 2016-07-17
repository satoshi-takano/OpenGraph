import Foundation

public enum OpenGraphResponseError: ErrorType {
    case UnexpectedStatusCode(Int)
}