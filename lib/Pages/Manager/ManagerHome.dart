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
      appBar: AppBar(title: Text('Manager Mode'),),
      body: _buildBody(context),

    );
  }

  Widget _buildBody(BuildContext context){
    return Column(children: <Widget>[
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
                  MaterialPageRoute(builder: (context) => RegisterNewDevice1()),
                );
              }

          ),
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
    ],
    );
  }
}
