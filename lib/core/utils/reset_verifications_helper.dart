import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';

/// Call this function to reset all verifications
Future<void> callResetVerifications(BuildContext context) async {
  try {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Resetting all verifications...'),
              ],
            ),
          ),
        ),
      ),
    );

    // Call the Cloud Function
    final callable = FirebaseFunctions.instance.httpsCallable(
      'resetAllVerifications',
    );
    final result = await callable.call();

    // Close loading dialog
    if (context.mounted) Navigator.pop(context);

    // Show result
    if (context.mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 8),
              Text('Success'),
            ],
          ),
          content: Text(
            '${result.data['message']}\n\n'
            'Verifications reset: ${result.data['verificationsReset']}\n'
            'Requests deleted: ${result.data['requestsDeleted']}',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  } catch (e) {
    // Close loading dialog if open
    if (context.mounted) Navigator.pop(context);

    // Show error
    if (context.mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.error, color: Colors.red),
              SizedBox(width: 8),
              Text('Error'),
            ],
          ),
          content: Text('Failed to reset verifications: $e'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}
