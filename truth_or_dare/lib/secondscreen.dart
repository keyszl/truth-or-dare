import 'package:flutter/material.dart';
import 'firstscreen.dart';

import 'package:truth_or_dare/friends_data.dart';
import 'package:truth_or_dare/text_widgets.dart';
import 'package:truth_or_dare/chat.dart';
import 'package:truth_or_dare/list_items.dart';

class SecondScreen extends StatefulWidget {
  SecondScreen({super.key, required this.friends});

  Friends? friends;

  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  String? _ipaddress = "Loading...";
  late Friends _friends;
  late List<DropdownMenuItem<String>> _friendList;
  late TextEditingController _nameController, _ipController;

  void initState() {
    super.initState();
    _friends = widget.friends!;
    _nameController = TextEditingController();
    _ipController = TextEditingController();
  }

  Future<void> _handleChat(Friend friend) async {
    print("Chat");
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChatScreen(friend: friend),
      ),
    );
  }

  void _handleEditFriend(Friend friend) {
    setState(() {
      print("Edit");
    });
  }

  void addNew() {
    setState(() {
      _friends.add(_nameController.text, _ipController.text);
    });
  }

  final ButtonStyle yesStyle =
      ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));
  final ButtonStyle noStyle =
      ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));

  Future<void> _displayTextInputDialog(BuildContext context) async {
    print("Loading Dialog");
    _nameController.text = "";
    _ipController.text = "";
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Add A Friend'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextEntry(
                    width: 200,
                    label: "Name",
                    inType: TextInputType.text,
                    controller: _nameController),
                TextEntry(
                    width: 200,
                    label: "IP Address",
                    inType: TextInputType.number,
                    controller: _ipController),
              ],
            ),
            actions: <Widget>[
              ElevatedButton(
                key: const Key("CancelButton"),
                style: noStyle,
                child: const Text('Cancel'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              ElevatedButton(
                key: const Key("OKButton"),
                style: yesStyle,
                child: const Text('OK'),
                onPressed: () {
                  setState(() {
                    addNew();
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue[200],
        title: const Text("CONTACTS",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: Center(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          children: _friends.map((name) {
            return FriendListItem(
              friend: _friends.getFriend(name)!,
              onListTapped: _handleChat,
              onListEdited: _handleEditFriend,
            );
          }).toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _displayTextInputDialog(context);
        },
        tooltip: 'Add Friend',
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.pink[50],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              key: Key('iconbutton3'),
              iconSize: 30,
              icon: Icon(Icons.home),
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const FirstScreen()));
              },
            ),
            IconButton(
              key: Key('iconbutton4'),
              icon: Icon(Icons.contacts),
              iconSize: 30,
              onPressed: () {},
            )
          ],
        ),
      ),
    );
  }
}
