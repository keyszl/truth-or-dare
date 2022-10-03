import 'package:flutter/material.dart';
import 'secondscreen.dart';

class FirstScreen extends StatelessWidget {
  const FirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
      ),
      body: const Text("Truth or Dare"),
      bottomNavigationBar: Container(
        height : 30,
        decoration: BoxDecoration(
          color: Colors.pink,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10), 
            topRight: Radius.circular(10),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SecondScreen())
              );
            },

            );
          ],
        ),
      ),
    );
  }
}
