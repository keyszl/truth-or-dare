// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:truth_or_dare/firstscreen.dart';
import 'package:truth_or_dare/secondscreen.dart';
import 'package:truth_or_dare/friends_data.dart';

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:network_info_plus/network_info_plus.dart';

void main() {
  runApp(const MaterialApp(
    title: "Truth/Dare",
    home: MainScreen(),
  ));
}

//Screen Container (in short)
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  String? _ipaddress = "Loading...";
  late StreamSubscription<Socket> serverSub;
  late Friends _friends;
  late List<DropdownMenuItem<String>> _friendList;
  late TextEditingController _nameController, _ipController;
  int selectedIndex = 0;
  List<Widget> pages = [];

  @override
  void initState() {
    super.initState();
    _friends = Friends();
    _friends.add("Self", "127.0.0.1");
    _nameController = TextEditingController();
    _ipController = TextEditingController();
    _setupServer();
    _findIPAddress();
    pages = [
      TruthDareScreen(
        friends: _friends,
        ipAddr: _ipaddress,
      ),
      ContactsScreen(friends: _friends)
    ];
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  void dispose() {
    serverSub.cancel();
    super.dispose();
  }

  Future<void> _findIPAddress() async {
    // Thank you https://stackoverflow.com/questions/52411168/how-to-get-device-ip-in-dart-flutter
    String? ip = await NetworkInfo().getWifiIP();
    setState(() {
      _ipaddress = "My IP: $ip!";
    });
  }

  Future<void> _setupServer() async {
    try {
      ServerSocket server =
          await ServerSocket.bind(InternetAddress.anyIPv4, ourPort);
      serverSub = server.listen(_listenToSocket); // StreamSubscription<Socket>
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
    print("Received $received from $ip");
    _friends.receiveFrom(ip, received);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: RichText(
            text: const TextSpan(children: [
              TextSpan(
                  text: "TRUTH",
                  style: TextStyle(
                      color: Color.fromARGB(255, 98, 190, 233),
                      fontSize: 28,
                      fontWeight: FontWeight.bold)),
              TextSpan(
                  text: " OR ",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold)),
              TextSpan(
                  text: "DARE",
                  style: TextStyle(
                      color: Color.fromARGB(255, 255, 17, 0),
                      fontSize: 28,
                      fontWeight: FontWeight.bold))
            ]),
          ),
        ),
        body: pages.elementAt(selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: Icon(
                    key: const Key('iconhome'),
                    Icons.home,
                    color: Colors.pink[50],
                  ),
                  label: "Truths/Dares"),
              BottomNavigationBarItem(
                  icon: Icon(
                    key: const Key('iconcontacts'),
                    Icons.contacts,
                    color: Colors.pink[50],
                  ),
                  label: "Contacts"),
            ],
            currentIndex: selectedIndex,
            onTap: onItemTapped,
            selectedLabelStyle: TextStyle(color: Colors.pink[50], fontSize: 14),
            unselectedLabelStyle:
                const TextStyle(fontSize: 14, color: Colors.black)));
  }
}
