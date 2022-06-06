import 'package:flutter/material.dart';

class HomeMenu extends StatelessWidget {
  final String name;
  final bool isActive;
  final Function onPressed;

  const HomeMenu(
      {Key? key,
      required this.name,
      required this.isActive,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () {
          onPressed();
        },
        child: Container(
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      width: 3.0,
                      color: isActive ? Colors.green : Colors.white))),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Text(
              name,
              style: TextStyle(
                  color: isActive ? Colors.green : Colors.white,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
