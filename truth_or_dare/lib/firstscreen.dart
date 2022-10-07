import 'package:flutter/material.dart';
import 'secondscreen.dart';

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:network_info_plus/network_info_plus.dart';

import 'package:truth_or_dare/friends_data.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  String? _ipaddress = "Loading...";
  late StreamSubscription<Socket> server_sub;
  late Friends _friends;
  late List<DropdownMenuItem<String>> _friendList;
  late TextEditingController _nameController, _ipController;

  void initState() {
    super.initState();
    _friends = Friends();
    _friends.add("Self", "127.0.0.1");
    _nameController = TextEditingController();
    _ipController = TextEditingController();
    _setupServer();
    _findIPAddress();
  }

  void dispose() {
    server_sub.cancel();
    super.dispose();
  }

  Future<void> _findIPAddress() async {
    // Thank you https://stackoverflow.com/questions/52411168/how-to-get-device-ip-in-dart-flutter
    String? ip = await NetworkInfo().getWifiIP();
    setState(() {
      _ipaddress = "My IP: " + ip!;
    });
  }

  Future<void> _setupServer() async {
    try {
      ServerSocket server =
          await ServerSocket.bind(InternetAddress.anyIPv4, ourPort);
      server_sub = server.listen(_listenToSocket); // StreamSubscription<Socket>
    } on SocketException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error: $e"),
      ));
    }
  }

  void _listenToSocket(Socket socket) {
    socket.listen((data) {
      setState(() {
        _handleIncomingMessage(socket.remoteAddress.address, data);
      });
    });
  }

  void _handleIncomingMessage(String ip, Uint8List incomingData) {
    String received = String.fromCharCodes(incomingData);
    print("Received '$received' from '$ip'");
    _friends.receiveFrom(ip, received);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue[190],
        title: const Text(
          "HOME",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
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
              },
              child: const Text('DARE'),
            ),
          )
        ],
      )),
      //Text(_ipaddress!, textAlign: TextAlign.center),
      bottomNavigationBar: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.pink[50],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              key: const Key('iconbutton1'),
              icon: const Icon(Icons.home),
              iconSize: 30,
              onPressed: () {},
            ),
            IconButton(
              key: const Key('iconbutton2'),
              icon: const Icon(Icons.contacts),
              iconSize: 30,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SecondScreen(friends: _friends)));
                //Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }
}
