import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lone_worker_checkin/Helpers/LocalFile.dart';

class WorkerHome extends StatefulWidget {
  @override
  _WorkerHomeState createState() => _WorkerHomeState();
}

class _WorkerHomeState extends State<WorkerHome> {
  @override
  final  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  String _token;
  String _validationError;
  final _deviceTokenController = TextEditingController();
  final _deviceNameController = TextEditingController();

  void initState() {
    // TODO: implement initState
    super.initState();
    _validationError = '';
    myToken().then((String value) {
      setState(() {
        _token = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_token == '') {
      //Unregistered Device
      return Scaffold(
        appBar: AppBar(
          title: Text('Lone Worker Mode'),
        ),
        body: _buildRegister(context),
      );
    } else {
      //Device already registered
      return Scaffold(
        appBar: AppBar(
          title: Text('Lone Worker Mode'),
        ),
        body: _buildBody(context),
      );
    }
  }

  Widget _buildBody(BuildContext context) {
    return ListView(
      children: <Widget>[
        Text(_token),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: RaisedButton(
            onPressed: unregisterDevice,
            child: Text('Unregister Device'),
          ),
        ),
      ],
    );
  }

  Widget _buildRegister(BuildContext context) {
    return ListView(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Center(
            child: Text('Enter the registration code from your Manager.'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Container(
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.green),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Center(
              child: TextField(
                key: Key('DeviceToken'),
                controller: _deviceTokenController,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(6),
                ],
                textCapitalization: TextCapitalization.characters,
                decoration: InputDecoration(
                    border: InputBorder.none, hintText: '_ _ _ _ _ _'),
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Center(
            child: Text('Enter a name for this device.'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Container(
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.green),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Center(
              child: TextField(
                key: Key('DeviceName'),
                controller: _deviceNameController,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(25),
                ],
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                    border: InputBorder.none, hintText: 'Device Name'),
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: RaisedButton(
            onPressed: registerDevice,
            child: Text('Register'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Center(
            child: Text(
              _validationError,
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void test() {
    setState(() {
      _token = "HELLO";
    });
  }

  void registerDevice() {


    FocusScope.of(context).requestFocus(new FocusNode());
    print(_deviceTokenController.text);
    print(_deviceNameController.text);
    String myToken = _deviceTokenController.text.toString().toUpperCase();
    ValidateToken(myToken).then((bool valid) {
      myDeviceId().then((String deviceID) {
        getDeviceModel().then((String _model) {
          if (Platform.isIOS) iOS_Permission();

          _firebaseMessaging.getToken().then((_fbmToken){


          setState(() {
            _validationError = '';
            if (!valid)
              _validationError =
                  "The code you entered is invalid, please rety.";
            else if (_deviceNameController.text.trim() == '')
              _validationError =
                  "You must enter a device name, plese try again.";
            else {
              //It is all valid, YEY!!!
              String _platform = Platform.operatingSystem;

              _token = myToken;
              saveToken(myToken);
              Firestore.instance
                  .collection('devices')
                  .document(_token)
                  .setData({
                'registrationToken': _token,
                'name': _deviceNameController.text,
                'platform': _platform,
                'model': _model,
                'id': deviceID,
                'fbmToken' : _fbmToken,
              });

            }
          });
        });
        });
      });
    });
  }

  void iOS_Permission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true)
    );
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings)
    {
      print("Settings registered: $settings");
    });
  }

  Future<String> getDeviceModel() async {
    String _model = '';

    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      _model = androidInfo.model;
    } else {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      _model = iosInfo.model;
    }

    return _model;
  }

  void unregisterDevice() {
    setState(() {
      Firestore.instance.collection('devices').document(_token).delete();
      deleteToken();
      _token = '';
    });
  }

  Future<bool> ValidateToken(String token) async {
    bool _c = true;
    DocumentSnapshot doc;
    doc = await Firestore.instance.collection('devices').document(token).get();
    print(doc.data);
    _c = doc.data != null;

    if (_c) {
      _c = doc.data['id'] == null;
    }
    print(_c);
    return _c;
  }
}
