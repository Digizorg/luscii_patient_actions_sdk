import 'package:luscii_patient_actions_sdk_platform_interface/src/method_channel_luscii_patient_actions_sdk.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

/// The interface that implementations of
/// luscii_patient_actions_sdk must implement.
///
/// Platform implementations should extend this class
/// rather than implement it as `LusciiPatientActionsSdk`.
/// Extending this class (using `extends`) ensures that the subclass will get
/// the default implementation, while platform implementations that `implements`
/// this interface will be broken by newly added
/// [LusciiPatientActionsSdkPlatform] methods.
abstract class LusciiPatientActionsSdkPlatform extends PlatformInterface {
  /// Constructs a LusciiPatientActionsSdkPlatform.
  LusciiPatientActionsSdkPlatform() : super(token: _token);

  static final Object _token = Object();

  static LusciiPatientActionsSdkPlatform _instance =
      MethodChannelLusciiPatientActionsSdk();

  /// The default instance of [LusciiPatientActionsSdkPlatform] to use.
  ///
  /// Defaults to [MethodChannelLusciiPatientActionsSdk].
  static LusciiPatientActionsSdkPlatform get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [LusciiPatientActionsSdkPlatform] when they
  /// register themselves.
  static set instance(LusciiPatientActionsSdkPlatform instance) {
    PlatformInterface.verify(instance, _token);
    _instance = instance;
  }

  /// Initialize the SDK.
  Future<void> initialize({bool androidDynamicTheming});

  /// Authenticate the user with the given token.
  Future<void> authenticate(String apiKey);

  /// Get today's actions for the authenticated user.
  Future<List<dynamic>> getTodayActions();

  /// Launch the action with the given ID.
  Future<void> launchAction(String actionId);

  /// Listen to updates the action stream results.
  Stream<Map<String, dynamic>> actionFlowStream();
}
