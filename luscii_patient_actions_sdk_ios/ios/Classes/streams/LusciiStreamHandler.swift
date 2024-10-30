import Flutter
import Actions

class LusciiStreamHandler: NSObject, FlutterStreamHandler {
  private var eventSink: FlutterEventSink?
  
  func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
    eventSink = events
    
    // Subscribe to the notification
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(notificationReceived(_:)),
                                           name: .actionFlowFinished,
                                           object: nil)
    
    return nil
  }
  
  func onCancel(withArguments arguments: Any?) -> FlutterError? {
    eventSink = nil
    // Unsubscribe from the notification
    NotificationCenter.default.removeObserver(self,
                                              name: .actionFlowFinished,
                                              object: nil)
    return nil
  }
  
  @objc func notificationReceived(_ notification: Notification) {
    if let result = notification.userInfo?[ActionsNotificationUserInfoKey.actionFlowResult] as? ActionFlowResult {
      // Prepare data to send to Flutter
      let data: [String: Any] = [
        "actionID": result.actionID.uuidString,
        "status": result.status.toString()
      ]
      
      // Send the data to Flutter
      eventSink?(data)
    }
  }
}
