import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'PlannerProvider.dart';
import 'SubmissionDetailScreen.dart';

class PlannerSubmissionListScreen extends StatelessWidget {
  static const routeName = '/planner-submissions';

  @override
  Widget build(BuildContext context) {
    final plannerProvider = Provider.of<PlannerProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Planner Submissions'),
      ),
      body: FutureBuilder(
        future: plannerProvider.fetchSubmissions(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return ListView.builder(
              itemCount: plannerProvider.submissions.length,
              itemBuilder: (ctx, index) {
                return ListTile(
                  title: Text(plannerProvider.submissions[index]['title']),
                  subtitle:
                      Text(plannerProvider.submissions[index]['description']),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SubmissionDetailScreen(
                          plannerProvider.submissions[index]),
                    ));
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
