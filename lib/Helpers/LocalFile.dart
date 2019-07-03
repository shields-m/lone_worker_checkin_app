import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  print(directory.path);
  return directory.path;
}

Future<File> get _localFile async {
  final path = await _localPath;
  return File('$path/guid.txt');
}

Future<String> readContent() async {
  try {
    final file = await _localFile;
    // Read the file
    String contents = await file.readAsString();
    // Returning the contents of the file
    return contents;
  } catch (e) {
    // If encountering an error, return
    return 'Error!';
  }
}

Future<File> writeContent(String value) async {
  final file = await _localFile;
  // Write the file

  return file.writeAsString(value);
}

Future<String> myDeviceId() async {
  bool _gotNew = false;
  var uuid = new Uuid();
  final file = await _localFile;
  String _deviceId;
  String _existing = await readContent();
  if (_existing == 'Error!' || _existing.trim() == '') {
    _deviceId = uuid.v1();
    _gotNew = true;
  } else {
    print(uuid.parse((_existing)));
    var sum = uuid.parse((_existing)).reduce((a, b) => a + b);
    if (sum > 0) {
      _deviceId = _existing;
    } else {
      _deviceId = uuid.v1();
      _gotNew = true;
    }
  }

  if (_gotNew) {
    await writeContent(_deviceId);
  }
  print(_deviceId);
  return _deviceId;
}
