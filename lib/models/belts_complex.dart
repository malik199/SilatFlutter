import 'package:flutter/material.dart';
import 'package:silat_flutter/models/pull_color_model.dart';
import 'package:silat_flutter/models/striped_belts.dart';

class BeltsComplex extends StatelessWidget {
  final String curriculum;
  final String color;
  bool? jawaraStripe;
  int? stripes;
  bool? hasYellowStripe;
  BeltsComplex(
      {Key? key,
      required this.curriculum,
      required this.color,
      this.jawaraStripe,
      this.hasYellowStripe,
      this.stripes})
      : super(key: key);

  final double _beltHeight = 35;
  //final double _innerPadding = 10;
  final double _borderRadius = 4;

  @override
  Widget build(BuildContext context) {
    if (curriculum == 'jawara_muda' ||
        curriculum == "instructor" ||
        curriculum == 'guest') {
      return Padding(
        padding: const EdgeInsets.all(0.0),
        child: Stack(children: [
          Container(
              height: _beltHeight,
              decoration: BoxDecoration(
                color: PullColor().getColor(color),
                border: Border.all(
                  color: Colors.black26,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(_borderRadius),
                /*boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.8),
                    spreadRadius: 2,
                    blurRadius: 4,
                    offset: Offset(0, 1), // changes position of shadow
                  ),
                ],*/
              )),
          if (jawaraStripe == true)
            Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                height: 12,
                color: Colors.black),
          StripedBelts().getStripes(stripes ?? 1, hasYellowStripe),
        ]),
        /* child: Container(
            height: _beltHeight,
            decoration: BoxDecoration(
              color: PullColor().getColor(color),
              border: Border.all(
                color: Colors.black26,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(_borderRadius),
            ),
            child: jawaraStripe == true ? Padding(
              padding: EdgeInsets.symmetric(vertical: _innerPadding),
              child: Container(
                color: Colors.black,
              ),
            ) : null
          ), */
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(0.0),
        child: Stack(children: [
          Container(
            height: _beltHeight,
            decoration: BoxDecoration(
              color: PullColor().getColor(color),
              border: Border.all(
                color: Colors.black26,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(_borderRadius),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.8),
                  spreadRadius: 2,
                  blurRadius: 4,
                  offset: Offset(0, 1), // changes position of shadow
                ),
              ],
            ),
          ),
          Container(
            height: _beltHeight,
            decoration: BoxDecoration(
              border: Border.symmetric(
                horizontal: BorderSide(
                    width: 10, color: Colors.white),
              ),
            ),

          ),
          StripedBelts().getStripes(stripes ?? 1, hasYellowStripe),
        ]),
      );
    }
  }
}
