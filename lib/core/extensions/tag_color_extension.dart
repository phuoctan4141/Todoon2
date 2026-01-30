import 'package:flutter/material.dart';

enum TagColorEnum {
  red,
  pink,
  purple,
  deepPurple,
  indigo,
  blue,
  lightBlue,
  cyan,
  teal,
  green,
  lightGreen,
  lime,
  yellow,
  amber,
  orange,
  deepOrange,
  transparent,
}

extension TagColorExtention on TagColorEnum {
  Color get value {
    switch (this) {
      case TagColorEnum.red:
        return Colors.redAccent;
      case TagColorEnum.pink:
        return Colors.pinkAccent;
      case TagColorEnum.purple:
        return Colors.purpleAccent;
      case TagColorEnum.deepPurple:
        return Colors.deepPurpleAccent;
      case TagColorEnum.indigo:
        return Colors.indigoAccent;
      case TagColorEnum.blue:
        return Colors.blueAccent;
      case TagColorEnum.lightBlue:
        return Colors.lightBlueAccent;
      case TagColorEnum.cyan:
        return Colors.cyanAccent;
      case TagColorEnum.teal:
        return Colors.tealAccent;
      case TagColorEnum.green:
        return Colors.greenAccent;
      case TagColorEnum.lightGreen:
        return Colors.lightGreenAccent;
      case TagColorEnum.lime:
        return Colors.limeAccent;
      case TagColorEnum.yellow:
        return Colors.yellowAccent;
      case TagColorEnum.amber:
        return Colors.amberAccent;
      case TagColorEnum.orange:
        return Colors.orangeAccent;
      case TagColorEnum.deepOrange:
        return Colors.deepOrangeAccent;
      case TagColorEnum.transparent:
        return Colors.transparent;
    }
  }

  static TagColorEnum random() {
    final values = TagColorEnum.values;
    values.shuffle();
    return values.first;
  }

  static TagColorEnum fromIndex(int index) =>
      TagColorEnum.values[index % TagColorEnum.values.length];
}
