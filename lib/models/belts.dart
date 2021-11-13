import 'package:flutter/material.dart';
import 'package:silat_flutter/models/pull_color_model.dart';
import 'package:silat_flutter/screens/techniques_list.dart';

class Belt extends StatelessWidget {
  final String curriculum;
  final String color;
  const Belt({
    Key? key,
    required this.curriculum,
    required this.color,
  }) : super(key: key);

  final double _beltHeight = 50;
  final double _innerPadding = 15;
  final double _borderRadius = 4;

  @override
  Widget build(BuildContext context) {
    if (curriculum == 'jawara_muda' ||
        curriculum == "instructor" ||
        curriculum == 'guest') {
      return TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    TechniquesList(curriculum: "jawara_muda", color: color)),
          );
        },
        child: Container(
          height: _beltHeight,
          decoration: BoxDecoration(
            color: PullColor().getColor(color),
            border: Border.all(
              color: Colors.black26,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(_borderRadius),
          ),
        ),
      );
    } else {
      return TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    TechniquesList(curriculum: "satria_muda", color: color)),
          );
        },
        child: Container(
          height: _beltHeight,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.grey,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(_borderRadius),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: _innerPadding),
            child: Container(
              color: PullColor().getColor(color),
            ),
          ),
        ),
      );
    }
  }
}