import 'package:fcm_push/fcm_push.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:lone_worker_checkin/Pages/Worker/ViewJob.dart';

import 'dart:io' show Platform;

final String serverKey =
    "AAAA0GvTje8:APA91bE4UfjNtqThh6MMLuwv8L42i_QmCTRT50Gd8c3hIX1DjAWNeyGvz-VC-Wo5xG2koLL0MngpTheLE0f2IVnBK6pr7ERxvl2ZXJdvkmEqUEYsqmgH1Ayq_TS9-aCIyJT516ZlDEE7";

Future<String> sendMessage(String token, String title, String message) async {
  final FCM fcm = new FCM(serverKey);

  final Message fcmMessage = new Message()
    ..to = token
    ..title = title
    ..body = message;

  final String messageID = await fcm.send(fcmMessage);

  return messageID;
}

Future<String> sendMessageWithData(
    String token, String title, String message, String jobId) async {
  final FCM fcm = new FCM(serverKey);

  final Message fcmMessage = new Message()
    ..to = token
    ..title = title
    ..body = message;
  fcmMessage.data.add(new Tuple2('click_action', 'FLUTTER_NOTIFICATION_CLICK'));
  fcmMessage.data.add(new Tuple2('jobId', jobId));

  final String messageID = await fcm.send(fcmMessage);

  return messageID;
}

class NotificationHandler extends StatefulWidget {
  @override
  _NotificationHandlerState createState() => _NotificationHandlerState();
}

class _NotificationHandlerState extends State<NotificationHandler> {
  final Firestore _db = Firestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
    );
  }

  @override
  void initState() {
    print('Handler Init');
    super.initState();
    if (Platform.isIOS) {
      _fcm.requestNotificationPermissions(
          IosNotificationSettings(sound: true, badge: true, alert: true));

      _fcm.onIosSettingsRegistered.listen((IosNotificationSettings settings) {
        print("Settings registered: $settings");
      });
    }

    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        /*showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text(message['notification']['title']),
              subtitle: Text(message['notification']['body'] + ' ' + message['data']['jobID']),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Close'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              FlatButton(
                child: Text('View'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );*/
        final SnackBar snackBar = new SnackBar(
          content: Text(message['notification']['title'] +
              ' - ' +
              message['notification']['body']),
          action: SnackBarAction(
            label: 'View',
            onPressed: () => {
            Navigator.push(
            context,
            MaterialPageRoute(
            builder: (context) => ViewJob(message['data']['jobID'])

            ),
            )

            },
          ),
          duration: Duration(seconds: 15),
        );

        Scaffold.of(context).showSnackBar(snackBar);


      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ViewJob(message['data']['jobID'])

          ),
        );

        // TODO optional
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        // TODO optional
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ViewJob(message['data']['jobID'])

          ),
        );

      },
    );
  }
}

void ShowDialog(String message, BuildContext context) {
  // flutter defined function
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        title: new Text("Alert"),
        content: new Text(message),
        actions: <Widget>[
          // usually buttons at the bottom of the dialog
          new FlatButton(
            child: new Text("Close"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
