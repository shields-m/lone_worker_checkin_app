import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ViewJob extends StatefulWidget {
  String _jobID;

  ViewJob(String jobID) {
    this._jobID = jobID;
  }

  @override
  _ViewJobState createState() => _ViewJobState();
}

class _ViewJobState extends State<ViewJob> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Job Details'),
      ),
      body: _buildJobInfo(context),
    );
  }

  Widget _buildJobInfo(BuildContext context) {
   // print(this.widget._jobID);
    return StreamBuilder<DocumentSnapshot>(
      stream: Firestore.instance
          .collection('jobs')
          .document(this.widget._jobID)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return _buildNoJob(context);
        var jobData = snapshot.data;
        //print(jobData.data);
        if (jobData.data != null) {
          return Column(
            children: <Widget>[
              ListTile(
                title: Text('Job Name'),
                subtitle: Text(jobData['jobName']),
              ),
              ListTile(
                title: Text('Location'),
                subtitle: Text(jobData['location']),
              ),
              ListTile(
                title: Text('Device'),
                subtitle: Text(jobData['device']),
              ),
              ListTile(
                title: Text('Person'),
                subtitle: Text(jobData['personName']),
              ),
              ListTile(
                title: Text('Checkin Frequency'),
                subtitle: Text(jobData['checkinFreq'].toString() + ' Minutes'),
              ),
              ListTile(
                title: Text('Current Status'),
                subtitle: Text(jobData['completed'].toString()),
              ),
              ButtonBar(
                alignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    onPressed: () => {Navigator.pop(context)},
                    child: Text('Close'),
                  ),
                  RaisedButton(
                    onPressed: () => {Navigator.pop(context)},
                    child: Text('Start Job'),
                  ),
                  RaisedButton(
                    onPressed: () => {DeleteJob()},
                    child: Text('Delete Job'),
                  ),
                ],
              ),
            ],
          );
        } else {
          return new LinearProgressIndicator();
        }
      },
    );
  }

  Widget _buildNoJob(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: LinearProgressIndicator(),
        ),
      ],
    );
  }

  void DeleteJob() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text("Delete Job?"),
          actions: <Widget>[
            FlatButton(
              child: Text("No"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text("Yes"),
              onPressed: () {
                Firestore.instance
                    .collection('jobs')
                    .document(this.widget._jobID)
                    .delete()
                    .then((onValue) {
                  Navigator.pop(context);
                  Navigator.pop(context);
                });
              },
            )
          ],
          content: Text(
              "Are you sure you want to delete this job?" ),
        );
      },
    );
  }
}
