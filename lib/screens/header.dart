import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final String headerText;
  Header({
    Key? key,
    required this.headerText
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(headerText, style: TextStyle(color: Colors.white)),
        Image.asset('assets/images/silatlogo.png', scale: 10),
      ],
    );
  }
}