import 'package:fcm_push/fcm_push.dart';

final String serverKey = "AAAA0GvTje8:APA91bE4UfjNtqThh6MMLuwv8L42i_QmCTRT50Gd8c3hIX1DjAWNeyGvz-VC-Wo5xG2koLL0MngpTheLE0f2IVnBK6pr7ERxvl2ZXJdvkmEqUEYsqmgH1Ayq_TS9-aCIyJT516ZlDEE7";


Future<int> sendMessage(String token, String title, String message) async {
  final FCM fcm = new FCM(serverKey);

  final Message fcmMessage = new Message()
    ..to = token
    ..title = title
    ..body = message

  ;

  final String messageID = await fcm.send(fcmMessage);
}