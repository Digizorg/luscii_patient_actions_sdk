import Flutter

enum LusciiFlutterSdkError: Error {
    case unknown
    case invalidArguments(_ reason: String)
    case invalidAPIKey
    case unauthorized
  
  var flutterError: FlutterError {
    switch self {
    case .unknown:
      return .init(code: "0", message: "Unknown error", details: nil)
    case .invalidArguments(let reason):
      return .init(code: "1", message: reason, details: nil)
    case .invalidAPIKey:
      return .init(code: "2", message: "Invaild API Key", details: nil)
    case .unauthorized:
      return .init(code: "3", message: "Unauthorized", details: nil)
    }
  }
}
