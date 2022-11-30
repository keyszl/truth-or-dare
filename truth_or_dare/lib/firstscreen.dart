import 'dart:math';

import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';

import 'package:network_info_plus/network_info_plus.dart';

import 'package:truth_or_dare/friends_data.dart';
import 'package:truth_or_dare/main.dart';
import 'package:truth_or_dare/secondscreen.dart';
import 'chat.dart';
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
  TruthDareScreen({
    super.key,
    required this.friends,
    required this.ipAddr,
    this.friend,
    //this.friend,
  });

  Friends? friends;
  String? ipAddr;
  Friend? friend;
  //final Friend? friend;

  @override
  _TruthDareScreenState createState() => _TruthDareScreenState();
}

class _TruthDareScreenState extends State<TruthDareScreen> {
  late Friends _friends;
  late String _ipAddr;
  late Friend friend;

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

    Random random = new Random();

    int rint = random.nextInt(lines.length);
    globals.promptText = lines.elementAt(rint);
  }

  Future<void> send(String msg) async {
    await widget.friend!.send(msg).catchError((e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error: $e"),
      ));
    });
  }

  @override
  Widget _buildPopupDialog(BuildContext context) {
    // ignore: unnecessary_new
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
        TextButton(
            onPressed: () {
              send(Text(globals.promptText).toString());
            },
            child: Text(_friends.last.toString())),
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
