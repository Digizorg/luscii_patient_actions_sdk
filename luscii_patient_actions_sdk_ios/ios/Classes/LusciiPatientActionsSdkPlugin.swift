import Flutter
import UIKit
import Actions

public class LusciiPatientActionsSdkPlugin: NSObject, FlutterPlugin {
  private var luscii: Luscii?
  
  public static func register(with registrar: FlutterPluginRegistrar) {
    // Setup main channel
    let channel = FlutterMethodChannel(name: "luscii_patient_actions_sdk_ios", binaryMessenger: registrar.messenger())
    
    // Setup event channel
    let eventChannel = FlutterEventChannel(name: "luscii_patient_actions_sdk_ios/events", binaryMessenger: registrar.messenger())
    let streamHandler = LusciiStreamHandler()
    eventChannel.setStreamHandler(streamHandler)
    
    let instance = LusciiPatientActionsSdkPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "initialize":
      guard let args = call.arguments as? [String: Any],
            let environment = args["environment"] as? String else {
        return result(LusciiFlutterSdkError.invalidArguments("Missing environment").flutterError)
      }

      if let defaults = UserDefaults(suiteName: "com.luscii.Actions") {
        if environment == "accept" {
          defaults.set("accept", forKey: "com.luscii.ActionsServerEnvironment")
        } else if environment == "test" {
          defaults.set("test", forKey: "com.luscii.ActionsServerEnvironment")
        } else {
          defaults.removeObject(forKey: "com.luscii.ActionsServerEnvironment")
        }
      }

      luscii = Luscii()
      result(nil)
    case "authenticate":
      // Check if argument is a String
      guard let value = call.arguments as? String else {
        let error = LusciiFlutterSdkError.invalidArguments("Arugment type is not String")
        return result(error.flutterError)
      }
      // Check if value is not empty
      guard !value.isEmpty else {
        let error = LusciiFlutterSdkError.invalidArguments("No API key provided")
        return result(error.flutterError)
      }
      Task {
        guard let luscii = self.luscii else {
          return result(LusciiFlutterSdkError.notInitialized.flutterError)
        }
        do {
          try await luscii.authenticate(apiKey: value)
          // Return void/nil if the call succeeds
          return result(nil)
        } catch {
          if error is LusciiAuthenticationError {
            return handleAuthenticationError(error: error, result: result)
          } else {
            return result(LusciiFlutterSdkError.unknown.flutterError)
          }
        }
      }
    case "getTodayActions":
      Task {
        guard let luscii = self.luscii else {
          return result(LusciiFlutterSdkError.notInitialized.flutterError)
        }
        do {
          let actions = try await luscii.actions().map { $0.toMap() }
          return result(actions)
        } catch {
          if error is LusciiAuthenticationError {
            return handleAuthenticationError(error: error, result: result)
          } else {
            return result(LusciiFlutterSdkError.unknown.flutterError)
          }
        }
      }
    case "launchAction":
      guard let actionId = call.arguments as? String else {
        let error = LusciiFlutterSdkError.invalidArguments("Arugment type is not String")
        return result(error.flutterError)
      }
      Task {
        guard let luscii = self.luscii else {
          return result(LusciiFlutterSdkError.notInitialized.flutterError)
        }
        do {
          let actions = try await luscii.actions()
          let matchingAction = actions.first(where: { $0.id.uuidString == actionId })
          guard let matchingAction else {
            let error = LusciiFlutterSdkError.invalidArguments("Action not found")
            return result(error.flutterError)
          }
          let rootViewController = await MainActor.run {
              UIApplication.shared.connectedScenes
                  .compactMap { $0 as? UIWindowScene }
                  .flatMap { $0.windows }
                  .first { $0.isKeyWindow }?.rootViewController
          }
          guard let rootViewController else {
            let error = LusciiFlutterSdkError.invalidArguments("No key window found")
            return result(error.flutterError)
          }
          DispatchQueue.main.async {
            do {
              try luscii.launchActionFlow(for: matchingAction, on: rootViewController)
            } catch {
              if error is LusciiAuthenticationError {
                return self.handleAuthenticationError(error: error, result: result)
              } else {
                return result(LusciiFlutterSdkError.unknown.flutterError)
              }
            }
          }
        } catch {
          if error is LusciiAuthenticationError {
            return handleAuthenticationError(error: error, result: result)
          } else {
            return result(LusciiFlutterSdkError.unknown.flutterError)
          }
        }
      }
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  func handleAuthenticationError(error: Error, result: @escaping FlutterResult) {
    let typedError = error as! LusciiAuthenticationError
    switch typedError.reason {
    case .invalidAPIKey:
      return result(LusciiFlutterSdkError.invalidAPIKey.flutterError)
    case .unauthorized:
      return result(LusciiFlutterSdkError.unauthorized.flutterError)
    @unknown default:
      return result(LusciiFlutterSdkError.unknown.flutterError)
    }
  }
}
