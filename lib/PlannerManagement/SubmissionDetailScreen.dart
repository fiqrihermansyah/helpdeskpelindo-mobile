import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'PlannerProvider.dart';

class SubmissionDetailScreen extends StatelessWidget {
  final Map submission;

  SubmissionDetailScreen(this.submission);

  @override
  Widget build(BuildContext context) {
    final plannerProvider = Provider.of<PlannerProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(submission['title']),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              submission['title'],
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(submission['description']),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                plannerProvider.closeSubmission(submission['id']);
                Navigator.of(context).pop();
              },
              child: Text('Close Submission'),
            ),
            ElevatedButton(
              onPressed: () {
                plannerProvider.reopenSubmission(submission['id']);
                Navigator.of(context).pop();
              },
              child: Text('Reopen Submission'),
            ),
          ],
        ),
      ),
    );
  }
}
