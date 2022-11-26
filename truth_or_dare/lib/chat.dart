import 'dart:io';
import 'dart:convert';

import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'friends_data.dart';
import 'globals.dart' as globals;
import 'firstscreen.dart' as firstscreen;

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.friend});

  final Friend? friend;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String? imagePath;
  TextEditingController _truthEditingController = TextEditingController();

  void initState() {
    super.initState();
    widget.friend!.addListener(update);
  }

  void dispose() {
    widget.friend!.removeListener(update);
    print("Goodbye");
    super.dispose();
  }

  void update() {
    print("New message!");
    setState(() {});
  }

  Future<void> send(String msg) async {
    await widget.friend!.send(msg).catchError((e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error: $e"),
      ));
    });
  }

  // Code here written with help from: https://www.youtube.com/watch?v=Z_UCTPpgKWI&ab_channel=EffortlessCodeLearning
  // and: https://stackoverflow.com/questions/47027418/how-to-send-image-through-post-using-json-in-flutter
  void pickMedia(ImageSource source) async {
    XFile? xf = await ImagePicker().pickImage(source: source);
    if (xf != null) {
      File imageFile = File(xf.path.toString());
      List<int> imageBytes = imageFile.readAsBytesSync();
      send(base64Encode(imageBytes));
    }
  }

  Widget _buildPopupDialog(BuildContext context, String promptType) {
    return AlertDialog(
      title: const Text('Send Truth or Dare'),
      //mainAxisSize: MainAxisSize.min,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[Text(_getPrompt(promptType))],
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
        _getWidget(
            promptType) //adds a widget at the bottom of the dialog based on truth/dare
      ],
    );
  }

  String truth = "";
  _getWidget(String string) {
    if (string == "truth") {
      return Column(children: <Widget>[
        TextField(
          key: Key("TruthText"),
          decoration: InputDecoration(label: Text("Type your Truth Here")),
          onChanged: (String value) {
            truth = value;
            print(truth);
          },
          controller: _truthEditingController,
        ),
        ValueListenableBuilder<TextEditingValue>(
            valueListenable: _truthEditingController,
            builder: (context, value, child) {
              return TextButton(
                  key: Key("truthSendButton"),
                  onPressed: value.text.isNotEmpty
                      ? () {
                          send(
                              "My truth for ${_getPromptSend("truth")} is:\n ${value.text}");
                          Navigator.pop(context);
                        }
                      : null,
                  child: Icon(Icons.send));
            })
      ]);
    } else {
      return Row(children: <Widget>[
        TextButton(
            key: Key("DidDareButton"),
            onPressed: () {
              send("I did my dare: ${_getPromptSend("dare")}.");
              Navigator.pop(context);
            },
            child: Text("I did my dare")),
        TextButton(
            key: Key("DidNotDoDareButton"),
            onPressed: () {
              send("I didn't do my dare. ${_getPromptSend("dare")} I suck :(");
              Navigator.pop(context);
            },
            child: Text("I didn't do my dare"))
      ]);
    }
  }

_getPrompt(String promptType) {
    if (promptType == "truth") {
      return globals.truths.last; //thows error if there are no more truths
    } else {
      return globals.dares.last; //thows error if there are no more dares
    }
  }
  _getPromptSend(String promptType) {
    if (promptType == "truth") {
      return globals.truths.removeLast(); //thows error if there are no more truths
    } else {
      return globals.dares.removeLast(); //thows error if there are no more dares
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.friend!.name),
        actions: [
          ElevatedButton(
              key: Key("SendDareButton"),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        _buildPopupDialog(context, "dare"));
              },
              child: Text("Send Dare")),
          ElevatedButton(
              key: Key("SendTruthButton"),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        _buildPopupDialog(context, "truth"));
              },
              child: Text("Send Truth"))
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Expanded(child: widget.friend!.bubble_history()),
          MessageBar(
            onSend: (_) => send(_),
            actions: [
              InkWell(
                child: const Icon(
                  Icons.add,
                  color: Colors.black,
                  size: 24,
                ),
                onTap: () {
                  pickMedia(ImageSource.gallery);
                },
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: InkWell(
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.lightBlue,
                    size: 24,
                  ),
                  onTap: () {
                    pickMedia(ImageSource.camera);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
