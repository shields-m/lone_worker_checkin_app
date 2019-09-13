import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lone_worker_checkin/Helpers/Auth.dart';
import 'package:lone_worker_checkin/Helpers/LocalFile.dart';
import 'package:lone_worker_checkin/Helpers/User.dart';
import 'package:lone_worker_checkin/Pages/Manager/NewJob.dart';
import 'package:lone_worker_checkin/Pages/Manager/RegisterNewDevice.dart';
import 'package:lone_worker_checkin/Helpers/Constants.dart';
import 'package:lone_worker_checkin/Pages/listJobs.dart';
import 'package:lone_worker_checkin/Pages/Manager/listDevices.dart';


AppUser appUser;
final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
String _userDetails = '';
bool _loading = false;
String _errorMessage = "";

class ManagerHome extends StatefulWidget {
  @override
  _ManagerHomeState createState() => _ManagerHomeState();
}

class _ManagerHomeState extends State<ManagerHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manager Mode'),
        centerTitle: true,
      ),
      body: _handleCurrentScreen(context),
    );
  }

  Widget _handleCurrentScreen(BuildContext context) {
    return new StreamBuilder<FirebaseUser>(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            return new ManagerModeBody();
          }
          return LoginScreen(context);
        });
  }

  Widget LoginScreen(BuildContext context) {
    if (_loading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      final email = TextFormField(
        controller: _emailTextController,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: getInputDecoration('Email'),
      );

      final password = TextFormField(
        controller: _passwordTextController,
        autofocus: false,
        obscureText: true,
        decoration: getInputDecoration('Password'),
      );

      final loginButton = Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          onPressed: () {
            logIn(_emailTextController.text, _passwordTextController.text);
          },
          padding: EdgeInsets.all(12),
          color: Colors.green,
          child: Text('Log In', style: TextStyle(color: Colors.white)),
        ),
      );

      final forgotLabel = FlatButton(
        child: Text(
          'Forgot password?',
        ),
        onPressed: () {
          forgotPassword();
        },
      );

      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: ListView(
            padding: EdgeInsets.only(left: 24.0, right: 24.0),
            children: <Widget>[
              SizedBox(height: 48.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Center(
                  child: Text(
                    'Login to access manager mode',
                    style: titleText,
                  ),
                ),
              ),
              SizedBox(height: 12.0),
              email,
              SizedBox(height: 8.0),
              password,
              SizedBox(height: 24.0),
              loginButton,
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
                child: Center(
                  child: Text(
                    _errorMessage,
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
              forgotLabel
            ],
          ),
        ),
      );
    }
  }

  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  Future<String> logIn(String email, String password) async {
    setState(() {
      _errorMessage = '';
      _loading = true;
    });
    signIn(_firebaseAuth, email, password).then((String message) {
      setState(() {
        _loading = false;
        _errorMessage = message;
      });
    });
  }

  Future<String> forgotPassword() async {
    setState(() {
      _errorMessage = '';
      _loading = true;
    });

    sendForgotPasswordEmail(_firebaseAuth, _emailTextController.text)
        .then((String message) {
      setState(() {
        _errorMessage = message;
        _loading = false;
      });
    });
  }
}

class ManagerModeBody extends StatefulWidget {
  @override
  _ManagerModeBodyState createState() => _ManagerModeBodyState();
}

class _ManagerModeBodyState extends State<ManagerModeBody> {
  @override
  void initState() {
    appUser = new AppUser();
    _userDetails = '';
    _firebaseAuth.currentUser().then((FirebaseUser user) {
      myDeviceId().then((String deviceID) {
        Firestore.instance
            .collection('users')
            .document(user.uid)
            .get()
            .then((DocumentSnapshot doc) {
          appUser.user = user;
          appUser.deviceID = deviceID;
          appUser.company = doc["company"].toString();
          appUser.fullName = doc["fullname"].toString();
          Firestore.instance
              .collection('companies')
              .document(appUser.company)
              .get()
              .then((DocumentSnapshot companydoc) {
            appUser.companyName = companydoc["name"].toString();
            setState(() {
              _userDetails =
                  appUser.fullName + ' (' + appUser.companyName + ')';
            });
          });
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _loading = false;

    return ListView(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Container(
            decoration: menuDecoration(),
            child: ListTile(
              title: Text(_userDetails),
              trailing: Icon(
                Icons.person,
                color: Colors.green,
                size: 30.0,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Center(
            child: Text(
              'Jobs',
              style: titleText,
            ),
          ),
        ),
        Padding(
          key: ValueKey('AddJob'),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Container(
            decoration: menuDecoration(),
            child: ListTile(
              title: Text('Add New Lone Working Job'),
              trailing: Icon(
                Icons.add_location,
                color: Colors.green,
                size: 30.0,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NewJob(appUser)),
                );
              },
            ),
          ),
        ),
        Padding(
          key: ValueKey('ActiveJobs'),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Container(
            decoration: menuDecoration(),
            child: ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ListJobs('', appUser.company),
                  ),
                );
              },
              title: Text('All Active Jobs'),
              trailing: Icon(
                Icons.access_time,
                color: Colors.green,
                size: 30.0,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Center(
            child: Text(
              'Lone Worker Devices',
              style: titleText,
            ),
          ),
        ),
        Padding(
          key: ValueKey('AddDevice'),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Container(
            decoration: menuDecoration(),
            child: ListTile(
                title: Text('Add Lone Worker Device'),
                trailing: Icon(
                  Icons.add_box,
                  color: Colors.green,
                  size: 30.0,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RegisterNewDevice1(appUser)),
                  );
                }),
          ),
        ),
        Padding(
          key: ValueKey('AllDevices'),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Container(
            decoration: menuDecoration(),
            child: ListTile(
                title: Text('All Lone Worker Devices'),
                trailing: Icon(
                  Icons.apps,
                  color: Colors.green,
                  size: 30.0,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ListDevices( appUser.company),
                    ),
                  );
                }),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Center(
            child: Text(
              'Functions',
              style: titleText,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Container(
            decoration: menuDecoration(),
            child: ListTile(
              title: Text('Sign out of manager mode'),
              trailing: Icon(
                Icons.subdirectory_arrow_left,
                color: Colors.green,
                size: 30.0,
              ),
              onTap: () {
                signOut(_firebaseAuth);
              },
            ),
          ),
        ),
      ],
    );
  }
}
