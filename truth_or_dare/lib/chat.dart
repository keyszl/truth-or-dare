import 'dart:io';
import 'dart:convert';

import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'friends_data.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.friend});

  final Friend? friend;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String? imagePath;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat with " + widget.friend!.name),
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
