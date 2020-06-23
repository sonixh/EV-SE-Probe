import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:v2g/models/user.dart';
import '../constants.dart';
import 'attribute.dart';

class StatusWidget extends StatefulWidget {
  final Future future;
  const StatusWidget({Key key, @required this.future}) : super(key: key);
  @override
  _StatusWidgetState createState() => _StatusWidgetState();
}

class _StatusWidgetState extends State<StatusWidget> {
  String parseTemp(AsyncSnapshot snapshot) {
    try {
      return '${double.parse(snapshot.data.tCellMin).truncate().toString()}, ${double.parse(snapshot.data.tCellAvg).truncate().toString()}, ${double.parse(snapshot.data.tCellMax).truncate().toString()}';
    } catch (e) {
      return 'null';
    }
  }

  String parseSoc(AsyncSnapshot snapshot) {
    try {
      return '${double.parse(snapshot.data.soc).truncate().toString()}% / ';
    } catch (e) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    String type = Provider.of<User>(context).type;

    return FutureBuilder(
      future: widget.future,
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Container(
            padding: EdgeInsets.only(top: 10, bottom: 30, left: 30, right: 30),
            child: SpinKitPulse(
              color: Colors.white,
              size: 100,
            ),
          );
        } else {
          List<Widget> evseStatusChildren = <Widget>[
            Attribute(
              snapshot: snapshot,
              label: 'Status ',
              x: 'status',
            ),
            Attribute(
              snapshot: snapshot,
              label: 'Car Name ',
              x: 'carName',
            ),
            Attribute(
              snapshot: snapshot,
              label: 'Peer Connected ',
              x: 'peerConnected',
            ),
            FittedBox(
              fit: BoxFit.fitWidth,
              child: Attribute(
                snapshot: snapshot,
                label: 'Timestamp ',
                x: 'timestamp',
              ),
            ),
            Attribute(
              snapshot: snapshot,
              label: 'Real Power ',
              x: 'realPower',
            ),
            Attribute(
              snapshot: snapshot,
              label: 'Energy Up ',
              x: 'energyUp',
            ),
            Attribute(
              snapshot: snapshot,
              label: 'Energy Down ',
              x: 'energyDown',
            ),
            Attribute(
              snapshot: snapshot,
              label: 'GFCI ',
              x: 'gfci',
            ),
            Attribute(
              snapshot: snapshot,
              label: 'EV State ',
              x: 'evState',
            ),
            Attribute(
              snapshot: snapshot,
              label: 'EVSE State ',
              x: 'evseState',
            ),
            Attribute(
                snapshot: snapshot, label: 'Meter Source ', x: 'meterSource')
          ];
          List<Widget> evStatusChildren = <Widget>[
            Attribute(snapshot: snapshot, label: 'EVSE Name ', x: 'evseName'),
            Attribute(
                snapshot: snapshot,
                label: 'Peer Connected ',
                x: 'peerConnected'),
            if (type == 'ev')
              Container(
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: RichText(
                    text: TextSpan(
                      style: kLabelTextStyle,
                      children: <TextSpan>[
                        TextSpan(
                          text: 'State of Charge ',
                          style: kLabelTextStyle,
                        ),
                        TextSpan(
                          text: parseSoc(snapshot) +
                              '${snapshot.data.socKwh} kWh',
                          style: kLargeLabelTextStyle,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            Attribute(snapshot: snapshot, label: 'Miles ', x: 'miles'),
            Attribute(
                snapshot: snapshot,
                label: 'Primary Status ',
                x: 'primaryStatus'),
            Attribute(
                snapshot: snapshot,
                label: 'Secondary Status ',
                x: 'secondaryStatus'),
            Attribute(
                snapshot: snapshot, label: 'Battery Temperature ', x: 'tBatt'),
            Container(
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: RichText(
                  text: TextSpan(
                    style: kLabelTextStyle,
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Bat. Module °C (min,avg,max) ',
                        style: kLabelTextStyle,
                      ),
                      TextSpan(
                        text: parseTemp(snapshot),
                        style: kLargeLabelTextStyle,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (type == 'ev')
              Container(
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: RichText(
                    text: TextSpan(
                      style: kLabelTextStyle,
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Power Flow ',
                          style: kLabelTextStyle,
                        ),
                        TextSpan(
                          text: '${snapshot.data.powerFlow} kW',
                          style: kLargeLabelTextStyle,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ];
          if (type == 'evse') {
            return Container(
              padding:
                  EdgeInsets.only(top: 20, bottom: 30, left: 30, right: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: evseStatusChildren,
              ),
            );
          } else {
            return Container(
              padding:
                  EdgeInsets.only(top: 20, bottom: 30, left: 30, right: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: evStatusChildren,
              ),
            );
          }
        }
      },
    );
  }
}
