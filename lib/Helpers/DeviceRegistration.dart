import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

class Replies {

  final String title;
  final Map coordinates;

  Replies({
    @required this.title,
    @required this.coordinates,
  });

  Map<String, dynamic> toJson() =>
      {
        'title': title,
        'coordinates': coordinates,
      };

}

class Device {
   String name;
   String id;
   String serialNumber;
   String platform;
   String deviceRegistrationToken;
   DateTime dateRegistered;
   String model;


  @override
  String toString() => name;
}