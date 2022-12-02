import 'package:flutter/material.dart';

import 'package:truth_or_dare/friends_data.dart';
import 'package:truth_or_dare/text_widgets.dart';
import 'package:truth_or_dare/chat.dart';
import 'package:truth_or_dare/list_items.dart';

// ignore: must_be_immutable
class ContactsScreen extends StatefulWidget {
  ContactsScreen({super.key, required this.friends});

  Friends? friends;

  @override
  ContactsScreenState createState() => ContactsScreenState();
}

class ContactsScreenState extends State<ContactsScreen> {
  late Friends _friends;
  late TextEditingController _nameController, _ipController;

  @override
  void initState() {
    super.initState();
    _friends = widget.friends!;
    _nameController = TextEditingController();
    _ipController = TextEditingController();
  }

  Future<void> _handleChat(Friend friend) async {
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          FloatingActionButton(
            onPressed: () {
              _displayTextInputDialog(context);
            },
            tooltip: 'Add Friend',
            child: const Icon(Icons.add),
          ),
          Expanded(
              child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            children: _friends.map((name) {
              return FriendListItem(
                friend: _friends.getFriend(name)!,
                onListTapped: _handleChat,
                onListEdited: _handleEditFriend,
              );
            }).toList(),
          ))
        ],
      ),
    );
  }
}
