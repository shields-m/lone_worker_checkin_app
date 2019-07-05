import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lone_worker_checkin/Pages/Manager/RegisterNewDevice.dart';

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
      ),
      body: _handleCurrentScreen(context),
    );
  }

  bool _loading = false;
  String _errorMessage = "";

  Widget _handleCurrentScreen(BuildContext context) {
    return new StreamBuilder<FirebaseUser>(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            return _buildBody(context);
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
        decoration: InputDecoration(
          hintText: 'Email',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
        ),
      );

      final password = TextFormField(
        controller: _passwordTextController,
        autofocus: false,
        obscureText: true,
        decoration: InputDecoration(
          hintText: 'Password',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
        ),
      );

      final loginButton = Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          onPressed: () {
            signIn(_emailTextController.text, _passwordTextController.text);
          },
          padding: EdgeInsets.all(12),
          color: Colors.green,
          child: Text('Log In', style: TextStyle(color: Colors.white)),
        ),
      );

      final forgotLabel = FlatButton(
        child: Text(
          'Forgot password?',
          style: TextStyle(color: Colors.black54),
        ),
        onPressed: () {sendForgotPasswordEmail();},
      );

      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(left: 24.0, right: 24.0),
            children: <Widget>[
              SizedBox(height: 48.0),
              Text('You must log in to user manager mode.'),
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
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String _userEmail = '';

  Future<String> signIn(String email, String password) async {
    setState(() {
      _errorMessage = '';
      _loading = true;
    });

    try {
      FirebaseUser user = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      print(user.uid);
      return user.uid;
    } catch (e) {
      setState(() {
        _loading = false;
        if (Platform.isIOS) {
          _errorMessage = e.details;
        } else
          _errorMessage = e.message;
      });
    }
  }

  Future<String> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<String> sendForgotPasswordEmail() async {
    setState(() {
      _errorMessage = '';

    });
    try {
      await _firebaseAuth.sendPasswordResetEmail(
          email: _emailTextController.text);
      setState(() {
        _errorMessage = "Password reset email sent.";
      });

    }
    catch(e) {
      setState(() {

        if (Platform.isIOS) {
          _errorMessage = e.details;
        } else
          _errorMessage = e.message;
      });
        }
  }

  Widget _buildBody(BuildContext context) {
    _loading = false;

    _firebaseAuth.currentUser().then((FirebaseUser u){

      setState(() {
        _userEmail = u.email;
      });
    });
    return ListView(
      children: <Widget>[
        Padding(

          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.green),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: ListTile(
                title: Text(_userEmail),
                trailing: Icon(
                  Icons.person,
                  color: Colors.green,
                  size: 30.0,
                ),

                ),
          ),
        ),
        Padding(
          key: ValueKey('AddDevice'),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.green),
              borderRadius: BorderRadius.circular(5.0),
            ),
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
                        builder: (context) => RegisterNewDevice1()),
                  );
                }),
          ),
        ),
        Padding(
          key: ValueKey('AddJob'),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.green),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: ListTile(
              title: Text('Add New Lone Working Job'),
              trailing: Icon(
                Icons.add_location,
                color: Colors.green,
                size: 30.0,
              ),
            ),
          ),
        ),
        Padding(
          key: ValueKey('ActiveJobs'),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.green),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: ListTile(
              title: Text('Active Jobs Screen'),
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
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.green),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: ListTile(
              title: Text('Sign out of manager mode'),
              trailing: Icon(
                Icons.subdirectory_arrow_left,
                color: Colors.green,
                size: 30.0,
              ),
              onTap: () {
                signOut();
              },
            ),
          ),
        ),
      ],
    );
  }
}
