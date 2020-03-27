import 'package:flutter/material.dart';

class ReusableCard extends StatelessWidget {
  ReusableCard(
      {@required this.colour,
      this.cardChild,
      this.onPress,
      @required this.margin});

  final Color colour;
  final Widget cardChild;
  final Function onPress;
  final double margin;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        child: cardChild,
        margin: EdgeInsets.all(margin),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.lightGreen,
              offset: Offset(0, 0.2),
              blurRadius: 0,
            )
          ],
          borderRadius: BorderRadius.circular(30),
          color: colour,
        ),
      ),
    );
  }
}
