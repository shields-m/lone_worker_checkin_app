import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lone_worker_checkin/Helpers/LocalFile.dart';
import 'package:lone_worker_checkin/Helpers/User.dart';
import 'package:random_string/random_string.dart';

class RegisterNewDevice1 extends StatefulWidget {
AppUser _appUser = new AppUser();


 RegisterNewDevice1(AppUser appUser){
  this._appUser = appUser;
}

  @override
  _RegisterNewDevice1State createState() => _RegisterNewDevice1State();
}

class _RegisterNewDevice1State extends State<RegisterNewDevice1> {
  String _code = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNewCode().then((String value) {
      setState(() {
        //print(newCode);
        _code = value;
        Firestore.instance.collection('devices').document(_code).setData({
          'registrationToken': _code,
          'company' : this.widget._appUser.company,
          'id' : '',
        });
      });
    });
  }

  Future<String> getNewCode() async {
    String _c = '';
    bool newCode = false;
    DocumentSnapshot doc;
    while (!newCode) {
      _c = randomAlphaNumeric(6).toUpperCase();
      print('*********************************************' +_c);
      doc = await Firestore.instance.collection('devices').document(_c).get();

      newCode = doc.data == null;
      print('*********************************************' + newCode.toString());


    }

    return _c;
  }

  Future<void> CancelRegistration() async
  {

    await Firestore.instance.collection('devices').document(_code).delete();

    Navigator.pop(context);

  }

  /* print('Code: ' +
  _c +
  ' Token: ' +
  DocumentSnapshot.data['registrationToken'].toString());*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register New Device'),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return ListView(
      children: <Widget>[
        Padding(
          key: ValueKey('title'),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Center(
            child: Text(
                'Enter the following code into the lone worker device to register.'),
          ),
        ),
        Padding(
          key: ValueKey('AddDevice'),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Container(
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.green),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Center(
                child: Text(
              _code,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            )),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: _buildDeviceInfo(context),
        )
      ],
    );
  }

  Widget _buildWaiting(BuildContext context) {
    return Column(
      children: <Widget>[
        CircularProgressIndicator(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: MaterialButton(
            onPressed: () => {Navigator.pop(context)},
            child: Text('Skip Waiting'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: RaisedButton(
            onPressed: CancelRegistration,
            child: Text('Cancel this registration'),
          ),
        ),
      ],
    );
  }

  Widget _buildDeviceInfo(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream:
          Firestore.instance.collection('devices').document(_code).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data['name'] == null)
          return _buildWaiting(context);
        var deviceData = snapshot.data;

        return Column(
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 0.0, vertical: 2.0),
              child: Container(
                child: ListTile(
                  title: Text('Device Name'),
                  trailing: Text(deviceData['name']),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 0.0, vertical: 2.0),
              child: Container(
                child: ListTile(
                  title: Text('Device Model'),
                  trailing: Text(deviceData['model']),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 0.0, vertical: 2.0),
              child: Container(
                child: ListTile(
                  title: Text('Device Platform'),
                  trailing: Text(deviceData['platform']),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 0.0, vertical: 2.0),
              child: Container(
                child: ListTile(
                  title: Text('Device ID'),
                  trailing: Text(deviceData['id']),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              child: RaisedButton(
                onPressed: () => {Navigator.pop(context)},
                child: Text('Done'),
              ),
            ),
          ],
        );
      },
    );
  }
}
