import 'package:flutter/material.dart';

class StripedBelts {
  StripedBelts();

  Widget getStripes(int numberOfStripes) {
    final double _stripeWidth = 10;
    final double _stripeSpacing = 10;
    final double _innerPadding = 15;
    final double _beltHeight = 35;

    var myWidget;
    switch (numberOfStripes) {
      case 1:
        {
          myWidget = Row(children: [
            Expanded(child: SizedBox.shrink())
          ]); // dont return anything
        }
        break;
      case 2:
        {
          myWidget = Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: _stripeWidth,
                      color: Colors.black,
                    ),
                    SizedBox(width: _stripeSpacing),
                  ],
                ),
              ),
            ],
          );
        }
        break;
      case 3:
        {
          myWidget = Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: _stripeWidth,
                      color: Colors.black,
                    ),
                    SizedBox(width: _stripeSpacing),
                    Container(
                      width: _stripeWidth,
                      color: Colors.black,
                    ),
                    SizedBox(width: _stripeSpacing),
                  ],
                ),
              ),
            ],
          );
        }
        break;
      case 4:
        {
          myWidget = Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: _stripeSpacing),
                    Container(
                      width: _stripeWidth,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: _stripeWidth,
                      color: Colors.black,
                    ),
                    SizedBox(width: _stripeSpacing),
                    Container(
                      width: _stripeWidth,
                      color: Colors.black,
                    ),
                    SizedBox(width: _stripeSpacing),
                  ],
                ),
              ),
            ],
          ); // dont return anything
        }
        break;
      default:
        {
          myWidget = SizedBox.shrink();
        }
        break;
    }
    return Container(height: _beltHeight, child: myWidget);
  }
}
