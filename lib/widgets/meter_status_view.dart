import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../constants.dart';

class MeterStatusView extends StatelessWidget {
  final Future future;
  const MeterStatusView({Key key, @required this.future}) : super(key: key);

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
    return _l;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return SpinKitPulse(
            color: Colors.white,
            size: 200,
          );
        } else {
          return Padding(
            padding: const EdgeInsets.only(left: 30, top: 20),
            child: Column(
              children: _getWidgets(snapshot.data.map),
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
          );
        }
      },
    );
  }
}
