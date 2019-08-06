import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:lone_worker_checkin/Helpers/Notifications.dart';
import 'package:lone_worker_checkin/Helpers/User.dart';


class NewJob extends StatefulWidget {
  AppUser _appUser = new AppUser();

  NewJob(AppUser appUser) {
    this._appUser = appUser;
  }

  @override
  _NewJobState createState() => _NewJobState();
}

class _NewJobState extends State<NewJob> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Lone Worker Job'),
      ),
      body: NewJobForm(this.widget._appUser),
    );
  }
}

class NewJobForm extends StatefulWidget {
  AppUser _appUser = new AppUser();

  NewJobForm(AppUser appUser) {
    this._appUser = appUser;
  }

  @override
  _NewJobFormState createState() => _NewJobFormState();
}

final _formKey = GlobalKey<FormState>();

class NewJobData {
  String jobName;
  String device;
  String location;
  String personName;
  int checkinFreq;
  DateTime createdDate;
  DateTime estimatedCompletion;
  bool completed;
  String company;
  String createdBy;
}

class _NewJobFormState extends State<NewJobForm> {
  NewJobData _job;
  String _selectedDevice;
int _selectedFreq;
  DateTime _selectedDate = DateTime.now();

  TimeOfDay _selectedTime = TimeOfDay.now();
  Map deviceTokens;

  Future<Null> _selectDate(BuildContext context) async {

    final DateTime picked = await showDatePicker(context: context, initialDate: _selectedDate, firstDate: new DateTime(2018), lastDate: new DateTime(2199));
if(picked != null )
  {
    final TimeOfDay pickedTime = await showTimePicker(context: context, initialTime: _selectedTime);
    if(pickedTime != null)
      {
        setState(() {
          _selectedTime = pickedTime;
          _selectedDate = new DateTime(picked.year,picked.month,picked.day,pickedTime.hour,pickedTime.minute);
          this._job.estimatedCompletion = _selectedDate;
        });
      }
  }

  }

  @override
  Widget build(BuildContext context) {
    _job = new NewJobData();
    deviceTokens = new Map();

    //CollectionReference devices = Firestore.instance
    // .collection('devices')
    // .where('company', isEqualTo: this.widget._appUser.company);

    return Form(
      key: _formKey,
      child: ListView(
        children: <Widget>[
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return 'You must enter a job name';
                }
                return null;
              },
              onSaved: (String val) {
                this._job.jobName = val;
              },
              decoration: InputDecoration(
                labelText: 'Job Name',
                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
              ),
            ),
          ),

          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 3.0),
            child: StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance
                    .collection('devices')
                    .where('company', isEqualTo: this.widget._appUser.company)
                    .where('id', isGreaterThan: '')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: LinearProgressIndicator(),
                    );
                  }

                  return new DropdownButtonFormField(
                    value: _selectedDevice,
                    validator: (value) {
                      if (value == null) {
                        return 'You must select a device';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Select Device',
                      contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      border:
                      OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                    ),
                    onChanged: (String newValue) {
                      setState(() {
                        _selectedDevice = newValue;
                      });
                    },
                    items: snapshot.data.documents
                        .map((DocumentSnapshot document) {
                      deviceTokens[document.data['registrationToken']] =
                          document.data['fbmToken'];
                      return new DropdownMenuItem<String>(
                        value: document.data['registrationToken'],

                        child: new Text(document.data['name']),
                      );
                    }).toList(),
                    onSaved: (String value) {
                      this._job.device = value;
                    },
                  );
                }),
          ),
          Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return 'You must enter the name of the person.';
                }
                return null;
              },
              onSaved: (String val) {
                this._job.personName = val;
              },
              decoration: InputDecoration(
                labelText: 'Who is carryiong out the job?',
                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
              ),
            ),
          ),
          Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return 'You must enter a location';
                }
                return null;
              },
              onSaved: (String val) {
                this._job.location  = val;
              },
              decoration: InputDecoration(
                labelText: 'Location of Job',
                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
              ),
            ),
          ),
          Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 3.0),
            child:  DropdownButtonFormField(
                    value: _selectedFreq,
              validator: (value) {
                if (value == null) {
                  return 'You must select the check-in frequency';
                }
                return null;
              },
                    decoration: InputDecoration(
                      labelText: 'Check-in Frequency',
                      contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      border:
                      OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                    ),
                    onChanged: (int newValue) {
                      setState(() {
                        _selectedFreq = newValue;
                      });
                    },
                    items:<int>[30, 60, 90]
                        .map<DropdownMenuItem<int>>((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text(value.toString() + ' Minutes'),
                      );
                    })
                        .toList(),
                    onSaved: (int value) {
                      this._job.checkinFreq = value;
                    },
                  ),
          ),
          Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: Container(

              width: double.infinity,

              decoration: BoxDecoration(
                border: Border.all(color: Colors.black38),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Column(

                children: <Widget>[
                  Text("${_selectedDate.toLocal()}"),
                  SizedBox(height: 10.0,),
                  RaisedButton(
                    onPressed: () => _selectDate(context),
                    child: Text('Select date'),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
              onPressed: () {
                // Validate returns true if the form is valid, or false
                // otherwise.
                FocusScope.of(context).requestFocus(new FocusNode());
                if (_formKey.currentState.validate()) {
                  // If the form is valid, display a Snackbar.
                  _formKey.currentState.save();
                  this._job.createdDate = DateTime.now();
                  this._job.company = this.widget._appUser.company;
                  this._job.createdBy = this.widget._appUser.user.uid;


                  var _result = Firestore.instance.runTransaction((Transaction tx) async {
                    var _result = await Firestore.instance.collection('jobs').add(
                        {
                         'jobName': this._job.jobName,
                         'device': this._job.device,
                         'location': this._job.location,
                         'personName': this._job.personName,
                         'checkinFreq': this._job.checkinFreq,
                         'createdDate': this._job.createdDate,

                         'completed': false,
                         'company': this._job.company,
                         'createdBy': this._job.createdBy,
                        });

                    return _result;

                  });

                  Scaffold.of(context).showSnackBar(
                      SnackBar(content: Text('Job Added')));
                  sendMessage(deviceTokens[this._job.device], 'New Job Added',
                      this._job.jobName);
                }
              },
              child: Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }

  void _showDialog(String message) {
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
}
