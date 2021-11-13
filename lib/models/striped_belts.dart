import 'package:flutter/material.dart';

class StripedBelts {
  StripedBelts();

  Widget getStripes(int numberOfStripes, bool? yellowStripe) {
    final double _stripeWidth = 10;
    final double _stripeSpacing = 10;
    //final double _innerPadding = 15;
    final double _beltHeight = 35;
    Color _stripeColor = Colors.black;

    if(yellowStripe == true) {
      _stripeColor = Colors.yellow;
    }

      
    var myWidget;
    switch (numberOfStripes) {
      case 1:
        {
          myWidget = Row(children: [
            Expanded(child: SizedBox.shrink())
          ]); // don't return anything
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
                      color: _stripeColor,
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: _stripeSpacing),
                    Container(
                      width: _stripeWidth,
                      color: _stripeColor,
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
                      color: _stripeColor,
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
                      color: _stripeColor,
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
                      color: _stripeColor,
                    ),
                    SizedBox(width: _stripeSpacing),
                    Container(
                      width: _stripeWidth,
                      color: _stripeColor,
                    ),
                    SizedBox(width: _stripeSpacing),
                  ],
                ),
              ),
            ],
          ); // don't return anything
        }
        break;
      case 5:
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
                      color: _stripeColor,
                    ),
                    SizedBox(width: _stripeSpacing),
                    Container(
                      width: _stripeWidth,
                      color: _stripeColor,
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
                      color: _stripeColor,
                    ),
                    SizedBox(width: _stripeSpacing),
                    Container(
                      width: _stripeWidth,
                      color: _stripeColor,
                    ),
                    SizedBox(width: _stripeSpacing),

                  ],
                ),
              ),
            ],
          ); // don't return anything
        }
        break;
      case 6: // doesn't mean 6 stripes, just is the layout for black and red belts
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
                      color: _stripeColor,
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
                      color: _stripeColor,
                    ),
                    SizedBox(width: _stripeSpacing),
                  ],
                ),
              ),
            ],
          ); // don't return anything
        }
        break;
      case 7:
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
                      color: _stripeColor,
                    ),
                    SizedBox(width: _stripeSpacing),
                    Container(
                      width: _stripeWidth,
                      color: _stripeColor,
                    ),
                    SizedBox(width: _stripeSpacing),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: _stripeWidth,
                      color: _stripeColor,
                    ),
                    SizedBox(width: _stripeSpacing),
                    Container(
                      width: _stripeWidth,
                      color: _stripeColor,
                    ),
                    SizedBox(width: _stripeSpacing),
                  ],
                ),
              ),
            ],
          ); // don't return anything
        }
        break;
      case 8:
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
                      color: _stripeColor,
                    ),
                    SizedBox(width: _stripeSpacing),
                    Container(
                      width: _stripeWidth,
                      color: _stripeColor,
                    ),
                    SizedBox(width: _stripeSpacing),
                    Container(
                      width: _stripeWidth,
                      color: _stripeColor,
                    ),
                    SizedBox(width: _stripeSpacing),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: _stripeWidth,
                      color: _stripeColor,
                    ),
                    SizedBox(width: _stripeSpacing),
                    Container(
                      width: _stripeWidth,
                      color: _stripeColor,
                    ),
                    SizedBox(width: _stripeSpacing),
                    Container(
                      width: _stripeWidth,
                      color: _stripeColor,
                    ),
                    SizedBox(width: _stripeSpacing),
                  ],
                ),
              ),
            ],
          ); // don't return anything
        }
        break;
      case 9:
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
                      color: _stripeColor,
                    ),
                    SizedBox(width: _stripeSpacing),
                    Container(
                      width: _stripeWidth,
                      color: _stripeColor,
                    ),
                    SizedBox(width: _stripeSpacing),
                    Container(
                      width: _stripeWidth,
                      color: _stripeColor,
                    ),
                    SizedBox(width: _stripeSpacing),
                    Container(
                      width: _stripeWidth,
                      color: _stripeColor,
                    ),
                    SizedBox(width: _stripeSpacing),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: _stripeWidth,
                      color: _stripeColor,
                    ),
                    SizedBox(width: _stripeSpacing),
                    Container(
                      width: _stripeWidth,
                      color: _stripeColor,
                    ),
                    SizedBox(width: _stripeSpacing),
                    Container(
                      width: _stripeWidth,
                      color: _stripeColor,
                    ),
                    SizedBox(width: _stripeSpacing),
                    Container(
                      width: _stripeWidth,
                      color: _stripeColor,
                    ),
                    SizedBox(width: _stripeSpacing),
                  ],
                ),
              ),
            ],
          ); // don't return anything
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
