import 'package:flutter/material.dart';
import 'firstscreen.dart';

class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contacts"),
      ),
      body: const Text("Truth or Dare"),
      bottomNavigationBar: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.pink[20],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              iconSize: 30,
              icon: Icon(Icons.home),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SecondScreen()));
              },
            ),
            IconButton(
              icon: Icon(Icons.contacts),
              iconSize: 30,
              onPressed: () {
                //Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FirstScreen()));
              },
            )
          ],
        ),
      ),
    );
  }
}
