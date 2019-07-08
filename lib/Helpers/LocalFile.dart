import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  //print(directory.path);
  return directory.path;
}

Future<File> get _guidFile async {
  final path = await _localPath;
  return File('$path/guid.txt');
}

Future<File> get _tokenFile async {
  final path = await _localPath;
  return File('$path/token.txt');
}

Future<String> readContent(String f) async {
  try {
    File file;
    if (f == 'guid')
      file = await _guidFile;
    else
      file = await _tokenFile;
    // Read the file
    String contents = await file.readAsString();
    // Returning the contents of the file
    return contents;
  } catch (e) {
    // If encountering an error, return
    return 'Error!';
  }
}

Future<File> writeContent(String value, String f) async {
  File file;
  if (f == 'guid')
    file = await _guidFile;
  else
    file = await _tokenFile;
  // Write the file

  return file.writeAsString(value);
}

Future<String> myDeviceId() async {
  bool _gotNew = false;
  var uuid = new Uuid();
  String _deviceId;
  String _existing = await readContent('guid');
  if (_existing == 'Error!' || _existing.trim() == '') {
    _deviceId = uuid.v1();
    _gotNew = true;
  } else {
    //print(uuid.parse((_existing)));
    var sum = uuid.parse((_existing)).reduce((a, b) => a + b);
    if (sum > 0) {
      _deviceId = _existing;
    } else {
      _deviceId = uuid.v1();
      _gotNew = true;
    }
  }

  if (_gotNew) {
    await writeContent(_deviceId, 'guid');
  }
  //print(_deviceId);
  return _deviceId;
}

Future<String> myToken() async
{
  String _token;
  String _existing = await readContent('token');
  if (_existing == 'Error!' || _existing.trim() == '') {
    _token = '';
  } else {
    _token = _existing;
  }

  print(_token);

  return _token;
}

void saveToken(String token) async
{
  await writeContent(token, 'token');
}

void deleteToken() async
{
  File file;

  file = await _tokenFile;

  await file.delete();
}
