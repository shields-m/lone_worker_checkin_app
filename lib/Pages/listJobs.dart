import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lone_worker_checkin/Helpers/Constants.dart';
import 'package:lone_worker_checkin/Pages/Worker/ViewJob.dart';

class ListJobs extends StatefulWidget {
  String _deviceID, _companyID;

  ListJobs(String deviceID, String companyID) {
    this._deviceID = deviceID;
    this._companyID = companyID;
    //print(deviceID);
  }



  @override
  _ListJobsState createState() => _ListJobsState();
}

class _ListJobsState extends State<ListJobs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Job Listing'),
      ),
      body: _buildJobInfo(context),
    );
  }

  Widget _buildJobInfo(BuildContext context) {
    if (this.widget._deviceID != '')
      {
      return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('jobs').where('device',isEqualTo: this.widget._deviceID).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return LinearProgressIndicator();

          return _buildList(context, snapshot.data.documents);
        },
      );
  }
    if (this.widget._companyID != '')
    {
      return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('jobs').where('comapny',isEqualTo: this.widget._companyID).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return LinearProgressIndicator();

          return _buildList(context, snapshot.data.documents);
        },
      );
    }

    return _buildNoJob(context);

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

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {

    final record = Record.fromSnapshot(data);


    return Padding(

      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration:menuDecoration(),
        child: ListTile(
          title: Text(record.name),
          subtitle: Text(record.location.toString()),
          trailing: Text(record.checkinFreq.toString() + ' Mins'),
          onTap: () => {

          Navigator.push(
          context,
          MaterialPageRoute(
          builder: (context) => ViewJob(record.reference.documentID)

          ),
          )
          },
),
        ),
      );



  }




}

class Record {
  final String name;
  final int checkinFreq;
  String location;

  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['jobName'] != null),
        assert(map['location'] != null),
        assert(map['checkinFreq'] != null),
        name = map['jobName'],
        location = map['location'],
        checkinFreq = map['checkinFreq'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Job<$name>";
}
