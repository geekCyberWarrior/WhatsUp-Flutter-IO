import 'package:flutter/material.dart';

class GreenButton extends StatelessWidget {
  final String value;
  final bool isSmall;
  final Function onPressed;
  final bool disable;

  const GreenButton({
    Key? key,
    required this.value,
    this.isSmall = false,
    required this.onPressed,
    this.disable = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var scaleFactor = isSmall ? 0.5 : 0.9;

    return ElevatedButton(
      onPressed: disable
          ? null
          : () {
              onPressed();
            },
      child: Text(value),
      style: ElevatedButton.styleFrom(
          primary: Colors.green,
          minimumSize:
              Size(MediaQuery.of(context).size.width * scaleFactor, 40),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
    );
  }
}
