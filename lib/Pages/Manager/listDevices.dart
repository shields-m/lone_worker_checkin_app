import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lone_worker_checkin/Helpers/Constants.dart';
import 'package:lone_worker_checkin/Pages/listJobs.dart';

class ListDevices extends StatefulWidget {
  String _companyID;

  ListDevices(String companyID) {
    this._companyID = companyID;
  }

  @override
  _ListDevicesState createState() => _ListDevicesState();
}

class _ListDevicesState extends State<ListDevices> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Device Listing'),
      ),
      body: _buildJobInfo(context),
    );
  }

  Widget _buildJobInfo(BuildContext context) {
    if (this.widget._companyID != '') {
      return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection('devices')
            .where('company', isEqualTo: this.widget._companyID)
            .snapshots(),
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
    if (data.data["id"] != '') {
      final record = Record.fromSnapshot(data);

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Container(
          decoration: menuDecoration(),
          child:
          Column(children: <Widget>[
          ListTile(
            title: Text(record.name),
            subtitle: Text(record.model.toString()),
            trailing: Text(record.platform),
          ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FlatButton(
                  padding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                  onPressed: () => {Navigator.push(
                  context,
                  MaterialPageRoute(
                  builder: (context) => ListJobs(record.reference.documentID,''),

                  ),
                  )},
                  child: Text(
                    'View Jobs',
                    style: TextStyle(
                        fontSize: 14.0,
                        textBaseline: TextBaseline.alphabetic),
                  ),
                ),
                FlatButton(
                  padding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                  onPressed: () => {Navigator.pop(context)},
                  textColor: Colors.red,
                  child: Text(
                    'Unregister Device',
                    style: TextStyle(
                        fontSize: 14.0,
                        textBaseline: TextBaseline.alphabetic),
                  ),
                ),
              ],
            ),

          ],)
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Container(
          decoration: menuDecoration(),
          child: Column(
            children: <Widget>[
               ListTile(
                  title: Text(
                    data.documentID,
                  ),
                  subtitle: Text('Token Awaiting Registration'),
                ),

               Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    FlatButton(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                      onPressed: () => {CancelRegistrationToken(data.documentID)},
                      textColor: Colors.red,
                      child: Text(
                        'Cancel Registration Token',
                        style: TextStyle(
                            fontSize: 14.0,
                            textBaseline: TextBaseline.alphabetic),
                      ),
                    ),
                  ],
                ),

            ],
          ),
        ),
      );
    }
  }

  void CancelRegistrationToken(String token) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text("Cancel Registration Token?"),
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
                    .collection('devices')
                    .document(token)
                    .delete()
                    .then((onValue) {
                  Navigator.pop(context);

                });
              },
            )
          ],
          content: Text(
              "Are you sure you want to cancel this token?" ),
        );
      },
    );
  }
}



class Record {
  final String name;

  String model;

  String platform;

  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : name = map['name'],
        model = map['model'],
        platform = map['platform'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => name;
}
