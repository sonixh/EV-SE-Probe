import 'package:flutter/material.dart';
import '../constants.dart';

class IconContent extends StatelessWidget {
  IconContent({this.icon, this.label});

  final IconData icon;
  final String label;

  double getIconSize(double h) {
    if (h < 900 && h > 400) {
      return h / 18;
    }
    if (h < 900) {
      return h / 25;
    } else {
      return h / 13;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          icon,
          size: getIconSize(MediaQuery.of(context).copyWith().size.height),
        ),
        SizedBox(
          height: 15.0,
        ),
        Text(
          label,
          style: kLabelTextStyle,
        )
      ],
    );
  }
}
