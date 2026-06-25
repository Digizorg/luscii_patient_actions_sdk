import Flutter
import UIKit
@preconcurrency import Actions

public class LusciiPatientActionsSdkPlugin: NSObject, FlutterPlugin {
  private var _luscii: Any?
  
  private var fetchedTodaysTasks: [Action]?
  private var fetchedSelfCareTasks: [Action]?
  private var fetchedExtraTasks: [Action]?
  
  /// Only make Luscii available when it's iOS 17 or higher
  @available(iOS 17.0, *)
  private var luscii: Luscii {
    if _luscii == nil {
      _luscii = Luscii()
    }
    return _luscii as! Luscii
  }
  
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
    guard #available(iOS 17.0, *) else {
      result(LusciiFlutterSdkError.unsupportedVersion.flutterError)
      return
    }

    switch call.method {
    case "initialize":
      if let arguments = call.arguments as? [String: Any],
         let environment = arguments["iOSEnvironment"] as? String {
         
         if let defaults = UserDefaults(suiteName: "com.luscii.Actions") {
             if environment == "acceptance" {
                 defaults.set("accept", forKey: "com.luscii.ActionsServerEnvironment")
             } else if environment == "test" {
                 defaults.set("test", forKey: "com.luscii.ActionsServerEnvironment")
             } else {
                 defaults.removeObject(forKey: "com.luscii.ActionsServerEnvironment")
             }
             // Force recreation of Luscii instance to pick up new environment settings
             _luscii = nil
         }
      }
      return result(nil)
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
        do {
          try await luscii.authenticate(apiKey: value)
          // Return void/nil if the call succeeds
          return result(nil)
        } catch {
          print(error)
          if error is LusciiAuthenticationError {
            return handleAuthenticationError(error: error, result: result)
          } else {
            return result(LusciiFlutterSdkError.unknown.flutterError)
          }
        }
      }
    case "getTodayActions":
      Task {
        do {
          let actions = try await luscii.todayActions()
          fetchedTodaysTasks = actions
          let convertedActions = actions.map { $0.toMap() }
          return result(convertedActions)
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
        do {
          let existingActions = (fetchedTodaysTasks ?? []) + (fetchedSelfCareTasks ?? []) + (fetchedExtraTasks ?? [])
          let matchingAction: Action
          if let match = existingActions.first(where: { $0.id.uuidString == actionId }) {
            matchingAction = match
          } else {
            let todayActions = try await luscii.todayActions()
            let selfCareActions = try await luscii.selfCareActions()
            let extraActions = try await luscii.extraActions()
            let fetchedActions = selfCareActions + todayActions + extraActions
            guard let match = fetchedActions.first(where: { $0.id.uuidString == actionId }) else {
              let error = LusciiFlutterSdkError.invalidArguments("Action not found")
              return result(error.flutterError)
            }
            matchingAction = match
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
          await MainActor.run {
            do {
              try luscii.launchActionFlow(for: matchingAction, on: rootViewController)
            } catch {
              if error is LusciiAuthenticationError {
                return handleAuthenticationError(error: error, result: result)
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
    case "getSelfCareActions":
      Task {
        do {
          let actions = try await luscii.selfCareActions()
          fetchedSelfCareTasks = actions
          let convertedActions = actions.map { $0.toMap() }
          return result(convertedActions)
        } catch {
          if error is LusciiAuthenticationError {
            return handleAuthenticationError(error: error, result: result)
          } else {
            return result(LusciiFlutterSdkError.unknown.flutterError)
          }
        }
      }
    case "getExtraActions":
      Task {
        do {
          let actions = try await luscii.extraActions()
          fetchedExtraTasks = actions
          let convertedActions = actions.map { $0.toMap() }
          return result(convertedActions)
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
