import Actions

@available(iOS 17.0, *)
extension Action {
  func toMap() -> [String: Any?] {
    return [
      "id": id.uuidString,
      "name": name,
      "icon": icon?.absoluteString,  // Convert URL to string
      "completedAt": completedAt?.timeIntervalSince1970,  // Convert Date to timestamp
      "launchableStatus": serializeLaunchableStatus(),
      "isLaunchable": isLaunchable,
      "isPlanned": isPlanned,
      "isSelfCare": isSelfCare,
      "isExtra": isExtra
    ]
  }
  
  private func serializeLaunchableStatus() -> String {
    switch launchableStatus {
    case .launchable:
      return "launchable"
    case .completed(let date):
      return "completed:\(date.timeIntervalSince1970)"
    case .after(let date):
      return "after:\(date.timeIntervalSince1970)"
    case .before(let date):
      return "before:\(date.timeIntervalSince1970)"
    @unknown default:
      return "unknown"
    }
  }
}
