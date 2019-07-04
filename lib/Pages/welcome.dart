import 'package:flutter/material.dart';
import 'package:lone_worker_checkin/Pages/Manager/ManagerHome.dart';
import 'package:lone_worker_checkin/Helpers/LocalFile.dart';
import 'package:lone_worker_checkin/Pages/Worker/WorkerHome.dart';


class welcomePage extends StatefulWidget {
  @override
  _welcomePageState createState() => _welcomePageState();
}

class _welcomePageState extends State<welcomePage> {

  String data = '';


  @override
  void initState() {
    // TODO: implement initState

    super.initState();

    myDeviceId().then((String value) {
      setState(() {
        data = '\n' + value ;
      });
    });



  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lone Worker Check-in'),),
      body: _buildBody(context),

    );
  }

  Widget _buildBody(BuildContext context){
   return ListView(children: <Widget>[
     Padding(
       padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 18.0),
       child:Text('Select the mode you would like to use ' + data),

   ),

     Padding(
       key: ValueKey('Manager'),
       padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
       child: Container(
         decoration: BoxDecoration(
           border: Border.all(color: Colors.green),
           borderRadius: BorderRadius.circular(5.0),
         ),
         child: ListTile(
           title: Text('Manager Mode'),
           trailing: Icon(
             Icons.phonelink_lock,
             color: Colors.green,
             size: 30.0,
           ),

             onTap: () {
               Navigator.pushReplacement(
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
         decoration: BoxDecoration(
           border: Border.all(color: Colors.green),
           borderRadius: BorderRadius.circular(5.0),
         ),
         child: ListTile(
           title: Text('Lone Worker Mode'),
           trailing: Icon(
             Icons.accessibility_new,
             color: Colors.green,
             size: 30.0,
           ),
             onTap: () {
               Navigator.pushReplacement(
                 context,
                 MaterialPageRoute(builder: (context) => WorkerHome()),
               );
             }


         ),
       ),
     ),
   ],
   );
  }
}
