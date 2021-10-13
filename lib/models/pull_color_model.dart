import 'package:flutter/material.dart';

class PullColor {

  PullColor();

  Color getColor(color) {
    switch (color) {
      case 'white':
        {
          return Colors.white;
        }
        break;

      case 'yellow':
        {
          return Colors.yellow;
        }
        break;

      case 'green':
        {
          return Colors.green;
        }
        break;

      case 'blue':
        {
          return Colors.blue;
        }
        break;

      case 'purple':
        {
          return Colors.purple;
        }
        break;

      case 'brown':
        {
          return Colors.brown;
        }
        break;

      case 'black':
        {
          return Colors.black;
        }
        break;

      case 'red':
        {
          return Colors.red;
        }
        break;

      default:
        {
          return Colors.white;
        }
        break;
    }
  }
}
