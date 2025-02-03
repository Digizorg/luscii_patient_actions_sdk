import 'package:flutter/material.dart';
import 'package:luscii_patient_actions_sdk/luscii_patient_actions_sdk.dart'
    as luscii_sdk;
import 'package:luscii_patient_actions_sdk/model/luscii_action.dart';
import 'package:luscii_patient_actions_sdk/model/luscii_launchable_status.dart';
import 'package:luscii_patient_actions_sdk/result/luscii_result.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final lusciiPatientActionsSdk = await luscii_sdk.authenticate(
    '<API_KEY>',
  );
  if (lusciiPatientActionsSdk is LusciiSuccess) {
    debugPrint('Authenticated successfully');
  } else if (lusciiPatientActionsSdk is LusciiFailure) {
    debugPrint('Authentication failed');
    debugPrint('Error: $lusciiPatientActionsSdk');
  }
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
  List<LusciiAction> actions = [];

  @override
  void initState() {
    super.initState();
    // luscii_sdk.actionFlowStream().listen((event) {
    //   debugPrint('Action stream event: $event');
    //   switch (event) {
    //     case LusciiSuccess(value: final value):
    //       debugPrint(value.actionId);
    //       debugPrint(value.status.toString());
    //     case LusciiFailure(exception: final exception):
    //       debugPrint('Action stream failure: $exception');
    //   }
    // });
  }

  Future<void> getActions() async {
    final result = await luscii_sdk.getActions();
    switch (result) {
      case LusciiSuccess(value: final actions):
        setState(() {
          this.actions = actions;
        });
      case LusciiFailure(exception: final exception):
        debugPrint('Failed to get actions');
        debugPrint(exception.reason);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('LusciiPatientActionsSdk Example')),
      body: Column(
        children: [
          TextButton(
            onPressed: getActions,
            child: const Text('Get actions'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: actions.length,
              itemBuilder: (context, index) {
                final action = actions[index];
                final launchableStatus = action.launchableStatus;
                final String message;
                switch (launchableStatus) {
                  case LaunchableStatusLaunchable():
                    message = 'Launchable';
                  case LaunchableStatusCompleted(
                      completedAt: final completedAt
                    ):
                    message = 'Completed at $completedAt';
                  case LaunchableStatusAfter(afterDate: final afterDate):
                    message = 'After $afterDate';
                  case LaunchableStatusBefore(beforeDate: final beforeDate):
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
