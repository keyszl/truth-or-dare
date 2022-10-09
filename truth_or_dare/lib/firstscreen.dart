import 'package:flutter/material.dart';

import 'package:truth_or_dare/friends_data.dart';

class TruthDareScreen extends StatefulWidget {
  TruthDareScreen({super.key, required this.friends});

  Friends? friends;

  @override
  _TruthDareScreenState createState() => _TruthDareScreenState();
}

class _TruthDareScreenState extends State<TruthDareScreen> {
  late Friends _friends;

  void initState() {
    _friends = widget.friends!;
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
    ));
    //Text(_ipaddress!, textAlign: TextAlign.center),
  }
}
