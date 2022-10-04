import 'package:flutter/material.dart';
import 'firstscreen.dart';

class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue[200],
        title: const Text("CONTACTS",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: const Text("..."),
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FirstScreen()));
              },
            ),
            IconButton(
              key: Key('iconbutton4'),
              icon: Icon(Icons.contacts),
              iconSize: 30,
              onPressed: () {
                //Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SecondScreen()));
              },
            )
          ],
        ),
      ),
    );
  }
}
