import 'dart:math';

import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';

import 'package:network_info_plus/network_info_plus.dart';

import 'package:truth_or_dare/friends_data.dart';
import 'globals.dart' as globals;
import 'package:path/path.dart' as p;

class TruthDareScreen extends StatefulWidget {
  TruthDareScreen({super.key, required this.friends});

  Friends? friends;

  @override
  _TruthDareScreenState createState() => _TruthDareScreenState();
}

class _TruthDareScreenState extends State<TruthDareScreen> {
  late Friends _friends;

  void initState() {
    _friends = widget.friends!;
  }

  //https://api.flutter.dev/flutter/dart-io/File-class.html - how files work
  void _getPrompt(String promptType) async {
    var filePath = p.join(Directory.current.path, 'dares.txt');

    if (promptType == "truth") {
      filePath = p.join(Directory.current.path, 'lib', 'truths.txt');
    }

    File file = File(filePath);

    Stream<String> lines = file
        .openRead()
        .transform(utf8.decoder) // Decode bytes to UTF-8.
        .transform(LineSplitter()); // Convert stream to individual lines.

    Random random = new Random();
    int length = 0;
    await for (var line in lines) {
      length += 1;
    }

    int rint = random.nextInt(length);
    print(rint);
    globals.promptText = lines.elementAt(rint) as String;
  }

  Widget _buildPopupDialog(BuildContext context) {
    return new AlertDialog(
      title: const Text('Prompt:'),
      //mainAxisSize: MainAxisSize.min,
      content: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(globals.promptText),
        ],
      ),
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Close'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        //const SizedBox(height: 30),
        SizedBox(
          height: 70,
          width: 180,
          child: TextButton(
            // TRUTH BUTTON
            key: const Key("Truth Button"),
            style: TextButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 175, 219, 237),
              padding: const EdgeInsets.all(16.0),
              textStyle: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            onPressed: () {
              // do something
              showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      _buildPopupDialog(context));
              _getPrompt("truth");
            },
            child: const Text('TRUTH'),
          ),
        ),
        const SizedBox(height: 30),
        SizedBox(
          height: 70,
          width: 180,
          child: TextButton(
            //DARE BUTTON
            key: const Key("Dare Button"),
            style: TextButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 175, 219, 237),
              padding: const EdgeInsets.all(16.0),
              textStyle: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            onPressed: () {
              // do something
              showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      _buildPopupDialog(context));
              _getPrompt("truth");
            },
            child: const Text('DARE'),
          ),
        )
      ],
    ));
    //Text(_ipaddress!, textAlign: TextAlign.center),
  }
}
