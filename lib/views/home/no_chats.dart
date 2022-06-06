import 'package:flutter/material.dart';
import 'package:whats_up/widgets/green_button.dart';
import 'package:whats_up/widgets/icon.dart';

class NoChatsView extends StatelessWidget {
  const NoChatsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
        child: Column(
      children: [
        // Expanded(child: Container()),
        const SizedBox(height: 150),
        const Flexible(child: IconView(name: "")),
        const SizedBox(height: 20),
        const Flexible(
          child: Text(
            "You haven't chat yet",
            style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 20),
        Flexible(
            child: GreenButton(
          value: "Start Chatting",
          isSmall: true,
          onPressed: () {
            Navigator.pushNamed(context, "/");
          },
        )),
        // Expanded(child: Container()),
      ],
    ));
  }
}
