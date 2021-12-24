// main.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:archive/archive.dart';
import 'package:archive/archive_io.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'fluttercrypto.de',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final String sourcePasswordList = 'password_list/10-million-password-list-top-100000.txt';
  final String compressedPasswordList = '10-million-password-list-top-100000.zip';

  // This will be displayed on the screen
  String _content = ''; // null safety

  void _zipPasswordFile() async {
    //final bytes = File(sourcePasswordList).readAsBytesSync();
    var _dirPath = await _getDirPath();
    var _zipPath = ('$_dirPath/$compressedPasswordList');
    var encoder = ZipFileEncoder();
    encoder.create(_zipPath);
    encoder.addFile(File(sourcePasswordList));
    encoder.close();
    _textController.text = 'file ' + sourcePasswordList + ' zipped';
  }


  // Find the Documents path
  Future<String> _getDirPath() async {
    final _dir = await getApplicationDocumentsDirectory();
    return _dir.path;
  }

  // This function is triggered when the "Read" button is pressed
  Future<void> _readData() async {
    final _dirPath = await _getDirPath();
    final _myFile = File('$_dirPath/data.txt');
    final _data = await _myFile.readAsString(encoding: utf8);
    setState(() {
      _content = _data;
    });
  }

  // TextField controller
  final _textController = TextEditingController();
  // This function is triggered when the "Write" buttion is pressed
  Future<void> _writeData() async {
    final _dirPath = await _getDirPath();

    final _myFile = File('$_dirPath/data.txt');
    // If data.txt doesn't exist, it will be created automatically

    await _myFile.writeAsString(_textController.text);
    _textController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('read text file write compressed file'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ElevatedButton(
              child: Text('ZIP file'),
              onPressed: _zipPasswordFile,
            ),
            SizedBox(
              height: 15,
            ),



            TextField(
              controller: _textController,
              decoration: InputDecoration(labelText: 'Enter your name'),
            ),
            ElevatedButton(
              child: Text('Save to file'),
              onPressed: _writeData,
            ),
            SizedBox(
              height: 150,
            ),
            Text(

                _content != null
                    ? _content
                    : 'Press the button to load your name',
                style: TextStyle(fontSize: 24, color: Colors.pink)),
            ElevatedButton(
              child: Text('Read my name from the file'),
              onPressed: _readData,
            )
          ],
        ),
      ),
    );
  }
}