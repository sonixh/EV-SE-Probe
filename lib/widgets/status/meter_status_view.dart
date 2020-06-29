import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:v2g/models/network_handler.dart';
import 'package:v2g/models/user.dart';
import '../../constants.dart';

class MeterStatusView extends StatefulWidget {
  final String iD;
  const MeterStatusView({Key key, @required this.iD}) : super(key: key);

  @override
  _MeterStatusViewState createState() => _MeterStatusViewState();
}

class _MeterStatusViewState extends State<MeterStatusView> {
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
      if (k == 'Reported At ') {
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

  Future _getFuture() {
    print('getting new meter future&&&&&&&&&&&&&&&&');
    String token = Provider.of<User>(context).token;
    String name = Provider.of<User>(context).name;
    String username = Provider.of<User>(context).username;
    String url = Provider.of<User>(context).url;
    return NetworkHandler.fetchMeterStatus(
        token: token,
        name: name,
        username: username,
        url: url,
        meterId: 'EVSE:${widget.iD}');
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
        Duration(seconds: kInterval), (Timer t) => setState(() {}));
    return FutureBuilder(
      future: _getFuture(),
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return SpinKitPulse(
            color: Colors.white,
            size: 200,
          );
        } else {
          return Padding(
            padding: const EdgeInsets.only(
              left: 22,
              top: 20,
            ),
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
