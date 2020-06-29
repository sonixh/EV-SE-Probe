import 'package:flutter/material.dart';
import 'package:v2g/models/info/ev.dart';
import '../../constants.dart';

class EVInfoWidget extends StatelessWidget {
  EVInfoWidget({@required this.ev});
  final EV ev;

  List<Widget> _getWidgets(Map map) {
    List<Widget> _l = [];
    String k;
    String value;
    for (k in map.keys) {
      try {
        value = map[k];
      } catch (e) {
        value = 'null';
      }
      if (map[k] == null || map[k] == '') {
      } else {
        _l.add(
          Container(
            child: RichText(
              text: TextSpan(
                style: kLabelTextStyle,
                children: <TextSpan>[
                  TextSpan(
                    text: k,
                    style: kLabelTextStyle,
                  ),
                  TextSpan(
                    text: value,
                    style: kLargeLabelTextStyle,
                  ),
                ],
              ),
            ),
          ),
        );
      }
    }
    return _l;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20, bottom: 30, left: 22, right: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _getWidgets(ev.map),
      ),
    );
  }
}
