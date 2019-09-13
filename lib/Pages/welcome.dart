import 'package:flutter/services.dart' as prefix0;
import 'package:lone_worker_checkin/Helpers/Notifications.dart';
import 'package:lone_worker_checkin/Pages/Manager/ManagerHome.dart';

import 'package:lone_worker_checkin/Pages/Worker/WorkerHome.dart';
import 'package:http/http.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';

import 'package:lone_worker_checkin/Helpers/Constants.dart';
class welcomePage extends StatefulWidget {
  @override
  _welcomePageState createState() => _welcomePageState();
}

class _welcomePageState extends State<welcomePage> {

 // String data = '';


  @override
  void initState() {
    // TODO: implement initState

    super.initState();

   /* myDeviceId().then((String value) {
      setState(() {
        data = '\n' + value ;
      });
    });
*/


  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lone Worker Check-in'),centerTitle: true,
      ),
      body: _buildBody(context),

    );
  }

  Widget _buildBody(BuildContext context){
   return ListView(

     children: <Widget>[
     NotificationHandler(),

       Padding(
         padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
         child: Center(
           child: Text(
             'Select Mode',
             style: titleText,
           ),
         ),
       ),

     Padding(
       key: ValueKey('Manager'),
       padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
       child: Container(

         decoration: menuDecoration(),
         child: ListTile(

           subtitle: Text('System Management'),
           title: Text('Manager Mode'),
           trailing: Icon(
             Icons.phonelink_lock,
             color: Colors.green,
             size: 30.0,
           ),

             onTap: () {
               Navigator.push(
                 context,
                 MaterialPageRoute(builder: (context) => ManagerHome()),
               );
             }

           ),
         ),
       ),
     Padding(
       key: ValueKey('Worker'),
       padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
       child: Container(
         decoration: menuDecoration(),
         child: ListTile(
           title: Text('Lone Worker Mode'),
           subtitle: Text('My Jobs'),
           trailing: Icon(
             Icons.accessibility_new,
             color: Colors.green,
             size: 30.0,
           ),
             onTap: () {
               Navigator.push(
                 context,
                 MaterialPageRoute(builder: (context) => WorkerHome()),
               );
             }


         ),
       ),
     ),
     Padding(
       key: ValueKey('test'),
       padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
       child: Container(
         decoration: menuDecoration(),
         child: ListTile(
             title: Text('Do a test'),
             subtitle: Text('Am I logged in???'),
             trailing: Icon(
               Icons.tag_faces,
               color: Colors.green,
               size: 30.0,
             ),
             onTap: () {
               runFunction('https://us-central1-lone-worker-checkin.cloudfunctions.net/helloWorld');
             }


         ),
       ),
     ),
   ],
   );
  }



  void runFunction(String function) async{


    final HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(
      functionName: 'test',

    );
    HttpsCallableResult resp2 = await callable.call({'test':'hello'});



    Response resp = await get(function);

      ShowDialog(resp2.data['result'],context);



  }


}
