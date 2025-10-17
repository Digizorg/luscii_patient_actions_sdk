import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:luscii_patient_actions_sdk/luscii_patient_actions_sdk.dart'
    as luscii_sdk;
import 'package:luscii_patient_actions_sdk/model/luscii_sdk_action.dart';
import 'package:luscii_patient_actions_sdk/model/luscii_sdk_launchable_status.dart';
import 'package:luscii_patient_actions_sdk/result/luscii_sdk_result.dart';

// API key can be injected via environment variables or substituted during CI/CD
String get apiKey {
  // First check for environment variable
  if (Platform.environment.containsKey('LUSCII_API_KEY')) {
    return Platform.environment['LUSCII_API_KEY']!;
  }

  // Fallback to a placeholder that can be replaced during CI/CD
  const key = String.fromEnvironment(
    'LUSCII_API_KEY',
    defaultValue: '<YOUR_API_KEY>',
  );

  if (key != '<YOUR_API_KEY>') {
    return key;
  }

  // Final fallback
  return '<TEST_API_KEY>';
}

Future<void> initApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  debugPrint('Initializing SDK...');
  final initialize = await luscii_sdk.initialize(androidDynamicTheming: true);
  if (initialize is LusciiSdkSuccess) {
    debugPrint('SDK initialized successfully');
  } else if (initialize is LusciiSdkFailure) {
    debugPrint('SDK initialization failed');
    debugPrint('Error: $initialize');
  }

  debugPrint('Authenticating with API key: ${apiKey.substring(0, 4)}...');
  final lusciiPatientActionsSdk = await luscii_sdk.authenticate(apiKey);
  if (lusciiPatientActionsSdk is LusciiSdkSuccess) {
    debugPrint('Authenticated successfully');
  } else if (lusciiPatientActionsSdk is LusciiSdkFailure) {
    debugPrint('Authentication failed');
    debugPrint('Error: $lusciiPatientActionsSdk');
  }
}

Future<void> main() async {
  await initApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<LusciiSdkAction>? actions;
  String? errorMessage;

  @override
  void initState() {
    super.initState();

    luscii_sdk.actionFlowStream().listen((event) {
      debugPrint('Action stream event: $event');
      switch (event) {
        case LusciiSdkSuccess(value: final value):
          debugPrint(value.actionId);
          debugPrint(value.status.toString());
        case LusciiSdkFailure(exception: final exception):
          debugPrint('Action stream failure: $exception');
      }
    });
  }

  Future<void> getTodayActions() async {
    // Reset error state before making the request
    setState(() {
      errorMessage = null;
    });

    try {
      debugPrint('Starting getActions API call...');
      final result = await luscii_sdk.getTodayActions();
      switch (result) {
        case LusciiSdkSuccess(value: final actions):
          debugPrint('Successfully received ${actions.length} actions');
          setState(() {
            this.actions = actions;
            errorMessage = null;
          });
        case LusciiSdkFailure(exception: final exception):
          debugPrint('Failed to get actions');
          debugPrint(exception.reason);
          setState(() {
            errorMessage = 'Error: ${exception.reason}';
          });
      }
    } catch (e) {
      debugPrint('Unexpected error in getActions: $e');
      setState(() {
        errorMessage = 'Error: Unexpected error occurred - $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('LusciiPatientActionsSdk Example')),
      body: Column(
        children: [
          TextButton(
            onPressed: getTodayActions,
            child: const Text('Get actions'),
          ),
          if (errorMessage != null)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                errorMessage!,
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
            ),
          Expanded(
            child: actions == null
                // Initial state - no actions fetched yet
                ? const Center(
                    child: Text(
                      'Press "Get actions" to retrieve your actions',
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                : actions!.isEmpty
                // Empty list state - actions fetched but none available
                ? const Center(
                    child: Text(
                      'No actions available',
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                // Actions available state
                : ListView.builder(
                    itemCount: actions!.length,
                    itemBuilder: (context, index) {
                      final action = actions![index];
                      final launchableStatus = action.launchableStatus;
                      final String message;
                      switch (launchableStatus) {
                        case LaunchableSdkStatusLaunchable():
                          message = 'Launchable';
                        case LaunchableSdkStatusCompleted(
                          completedAt: final completedAt,
                        ):
                          message = 'Completed at $completedAt';
                        case LaunchableSdkStatusAfter(
                          afterDate: final afterDate,
                        ):
                          message = 'After $afterDate';
                        case LaunchableSdkStatusBefore(
                          beforeDate: final beforeDate,
                        ):
                          message = 'Before $beforeDate';
                      }
                      return GestureDetector(
                        onTap: () => luscii_sdk.launchAction(action.id),
                        child: ListTile(
                          title: Text('Action ${action.name}'),
                          subtitle: Text(message),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
