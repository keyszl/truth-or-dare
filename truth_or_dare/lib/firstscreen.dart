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
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;

Future<String> loadAssetTruths() async {
  return await rootBundle.loadString('assets/truths.txt');
}

Future<String> loadAssetDares() async {
  return await rootBundle.loadString('assets/dares.txt');
}

class TruthDareScreen extends StatefulWidget {
  TruthDareScreen({super.key, required this.friends, required this.ipAddr});

  Friends? friends;
  String? ipAddr;

  @override
  _TruthDareScreenState createState() => _TruthDareScreenState();
}

class _TruthDareScreenState extends State<TruthDareScreen> {
  late Friends _friends;
  late String _ipAddr;

  void initState() {
    _friends = widget.friends!;
    _ipAddr = widget.ipAddr!;
  }

  //https://api.flutter.dev/flutter/dart-io/File-class.html - how files work
  void _getPrompt(String promptType) async {
    //var filePath = p.join(Directory.current.path, 'dares.txt');

    //if (promptType == "truth") {
    //filePath = p.join(Directory.current.path, 'truths.txt');
    //}

    var contents = "";

    if (promptType == "truth") {
      contents = await loadAssetTruths();
    } else {
      contents = await loadAssetDares();
    }
    var lines = contents.split(',');
    print(lines[0]);

    //File file = File(filePath);

    //Stream<String> lines = file
    //  .openRead()
    //.transform(utf8.decoder) // Decode bytes to UTF-8.
    //.transform(LineSplitter()); // Convert stream to individual lines.

    Random random = Random();

    int rint = random.nextInt(lines.length);
    globals.promptText = lines.elementAt(rint);
    globals.contentType = promptType;
  }

  _getWidget() {
    //selection of type of widget based on truth or dare
    if (globals.contentType == "truth") {
      return const TextField(
        key: Key("TruthText"),
        decoration: InputDecoration(hintText: "Type your Truth Here"),
      );
    } else {
      return Row(children: <Widget>[
        TextButton(
            key: Key("DidDareButton"),
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("I did my dare")),
        TextButton(
            key: Key("DidNotDoDareButton"),
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("I didn't do my dare"))
      ]);
    }
  }

  Widget _buildPopupDialog(BuildContext context) {
    return AlertDialog(
      title: const Text('Prompt:'),
      //mainAxisSize: MainAxisSize.min,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(globals.promptText),
        ],
      ),
      actions: <Widget>[
        TextButton(
          //changing to TextButton. FlatButton doesn't exist...
          onPressed: () {
            Navigator.of(context).pop();
          },
          //textColor: Theme.of(context).primaryColor,
          child: const Text('Close'),
        ),
        _getWidget() //adds a widget at the bottom of the dialog based on truth/dare
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
            key: const Key("TruthButton"),
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
            key: const Key("DareButton"),
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
              _getPrompt("dare");
            },
            child: const Text('DARE'),
          ),
        ),
        Padding(padding: const EdgeInsets.only(top: 35), child: Text(_ipAddr)),
      ],
    ));
    //Text(_ipaddress!, textAlign: TextAlign.center),
  }
}
