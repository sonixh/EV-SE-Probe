import 'package:flutter/material.dart';
import 'package:v2g/models/evse.dart';
import 'package:v2g/models/evse_swver.dart';
import '../constants.dart';

class EVSEInfoWidget extends StatelessWidget {
  final EVSE evse;
  final EVSESwVer evseSwVer;
  EVSEInfoWidget({@required this.evse, @required this.evseSwVer});

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
      } else if (k == 'Address ' ||
          k == 'Latitude, Longitude ' ||
          k == 'RTO/Utility ' ||
          k == 'Meter Serial Number ') {
        _l.add(
          FittedBox(
            fit: BoxFit.fitWidth,
            child: Container(
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
          ),
        );
      } else if (map[k] != '') {
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
      } else {}
    }
    return _l;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20, bottom: 30, left: 30, right: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _getWidgets(evse.map),
          ),
          Container(
            child: RichText(
              text: TextSpan(
                style: kLabelTextStyle,
                children: <TextSpan>[
                  TextSpan(
                    text: 'Agent Version ',
                    style: kLabelTextStyle,
                  ),
                  TextSpan(
                    text: evseSwVer.agentRevision,
                    style: kLargeLabelTextStyle,
                  ),
                ],
              ),
            ),
          ),
          Container(
            child: RichText(
              text: TextSpan(
                style: kLabelTextStyle,
                children: <TextSpan>[
                  TextSpan(
                    text: 'VEL Version ',
                    style: kLabelTextStyle,
                  ),
                  TextSpan(
                    text: evseSwVer.velRevision,
                    style: kLargeLabelTextStyle,
                  ),
                ],
              ),
            ),
          ),
          if (evseSwVer.rCDVersion != null)
            Container(
              child: RichText(
                text: TextSpan(
                  style: kLabelTextStyle,
                  children: <TextSpan>[
                    TextSpan(
                      text: 'RCD Version ',
                      style: kLabelTextStyle,
                    ),
                    TextSpan(
                      text: evseSwVer.rCDVersion,
                      style: kLargeLabelTextStyle,
                    ),
                  ],
                ),
              ),
            ),
          if (evseSwVer.meterVersion != null)
            Container(
              child: RichText(
                text: TextSpan(
                  style: kLabelTextStyle,
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Meter Version ',
                      style: kLabelTextStyle,
                    ),
                    TextSpan(
                      text: evseSwVer.meterVersion,
                      style: kLargeLabelTextStyle,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
