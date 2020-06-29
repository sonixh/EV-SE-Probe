import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:v2g/models/status/ev_status.dart';
import 'package:v2g/models/status/evse_status.dart';
import 'package:v2g/models/user.dart';
import '../../constants.dart';

class StatusWidget extends StatefulWidget {
  final String iD;
  const StatusWidget({Key key, @required this.iD}) : super(key: key);
  @override
  _StatusWidgetState createState() => _StatusWidgetState();
}

class _StatusWidgetState extends State<StatusWidget> {
  Timer timer;

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
        if (k == 'Car Name ' && map['Peer Connected '] == 'false') {
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
                      style: kGreyedOutTextStyle,
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          if (k == 'Bat Module °C (min,avg,max) ') {
            _l.add(
              Container(
                child: FittedBox(
                  fit: BoxFit.fitWidth,
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
    } else if (type == 'ev') {
      EVStatus evStatus = new EVStatus();
      return evStatus.fetchEVStatus(
          vin: widget.iD,
          token: token,
          name: name,
          username: username,
          url: url);
    } else {
      return null;
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          return Container(
            padding: EdgeInsets.only(top: 20, bottom: 30, left: 22, right: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _getWidgets(snapshot.data.map),
            ),
          );
        }
      },
    );
  }
}
