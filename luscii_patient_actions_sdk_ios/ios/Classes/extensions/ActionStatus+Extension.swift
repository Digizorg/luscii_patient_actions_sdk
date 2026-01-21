import Actions

@available(iOS 17.0, *)
extension Actions.ActionFlowResult.Status {
  func toString() -> String {
    switch self {
    case .completed:
      return "completed"
    case .cancelled:
      return "cancelled"
    case .error(let error):
      return "error:\(error?.localizedDescription ?? "")"
    @unknown default:
      return "unknown"
    }
  }
}
