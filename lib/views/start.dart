import 'package:flutter/material.dart';
import 'package:whats_up/widgets/green_button.dart';
import 'package:whats_up/widgets/icon.dart';

class StartView extends StatelessWidget {
  const StartView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(flex: 2, child: Container()),
          const Expanded(
            flex: 3,
            child: IconView(
              name: "WhatsUp",
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 45),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Best best chat app of this centery",
                    style: TextStyle(color: Colors.white),
                  ),
                  GreenButton(
                    value: "Continue",
                    onPressed: () {
                      Navigator.pushNamed(context, "/signin");
                    },
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
