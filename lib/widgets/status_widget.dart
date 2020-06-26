import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:v2g/models/ev_status.dart';
import 'package:v2g/models/evse_status.dart';
import 'package:v2g/models/user.dart';
import '../constants.dart';
import 'attribute.dart';

class StatusWidget extends StatefulWidget {
  //final Future future;
  final String iD;
  const StatusWidget({Key key, @required this.iD}) : super(key: key);
  @override
  _StatusWidgetState createState() => _StatusWidgetState();
}

class _StatusWidgetState extends State<StatusWidget> {
  Timer timer;
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
      if (map[k] != null && map[k] != '') {
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

  Future _getFuture() {
    String token = Provider.of<User>(context).token;
    String name = Provider.of<User>(context).name;
    String username = Provider.of<User>(context).username;
    String url = Provider.of<User>(context).url;
    EVSEStatus evseStatus = new EVSEStatus();
    String type = Provider.of<User>(context).type;

    if (type == 'evse') {
      return evseStatus.fetchEVSEStatus(
          evseID: widget.iD,
          token: token,
          name: name,
          username: username,
          url: url);
    } else {
      EVStatus evStatus = new EVStatus();
      return evStatus.fetchEVStatus(
          vin: widget.iD,
          token: token,
          name: name,
          username: username,
          url: url);
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String type = Provider.of<User>(context).type;
    timer?.cancel();
    timer = Timer.periodic(
        Duration(seconds: kInterval),
        (Timer t) => setState(() {
              print('refreshing status page');
            }));

    return FutureBuilder(
      future: _getFuture(),
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Container(
            padding: EdgeInsets.only(top: 10, bottom: 30, left: 22, right: 30),
            child: SpinKitPulse(
              color: Colors.white,
              size: 100,
            ),
          );
        } else {
          List<Widget> evStatusChildren = <Widget>[
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
          ];
          if (type == 'evse') {
            return Container(
              padding:
                  EdgeInsets.only(top: 20, bottom: 30, left: 22, right: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _getWidgets(snapshot.data.map),
              ),
            );
          } else {
            return Container(
              padding:
                  EdgeInsets.only(top: 20, bottom: 30, left: 30, right: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _getWidgets(snapshot.data.map),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: evStatusChildren,
                  ),
                ],
              ),
            );
          }
        }
      },
    );
  }
}
