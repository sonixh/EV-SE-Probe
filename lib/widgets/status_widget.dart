import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:v2g/models/user.dart';
import 'attribute.dart';

class StatusWidget extends StatefulWidget {
  final Future future;
  const StatusWidget({Key key, this.future}) : super(key: key);
  @override
  _StatusWidgetState createState() => _StatusWidgetState();
}

class _StatusWidgetState extends State<StatusWidget> {
  @override
  Widget build(BuildContext context) {
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
            //This is called METER_REV in the agent
            // Attribute(
            //   snapshot: snapshot,
            //   label: 'rev ',
            //   x: 'status',
            // ),
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
              label: 'Timestamp ',
              x: 'timestamp',
            ),
            Attribute(
              snapshot: snapshot,
              label: 'Real Power ',
              x: 'energyTotal',
            ),
            Attribute(
              snapshot: snapshot,
              label: 'Net Energy ',
              x: 'energyNet',
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
              label: 'Peer Connected ',
              x: 'peerConnected',
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
          ];
          List<Widget> evStatusChildren = <Widget>[
            Attribute(snapshot: snapshot, label: 'Name ', x: 'name'),
            Attribute(snapshot: snapshot, label: 'EVSE Name ', x: 'evseName'),
            Attribute(
                snapshot: snapshot,
                label: 'Peer Connected ',
                x: 'peerConnected'),
            Attribute(snapshot: snapshot, label: 'State of Charge ', x: 'soc'),
            Attribute(snapshot: snapshot, label: 'Miles ', x: 'miles'),
            Attribute(snapshot: snapshot, label: 'Credit ', x: 'credit'),
            Attribute(
                snapshot: snapshot,
                label: 'Primary Status ',
                x: 'primaryStatus'),
          ];
          String type = Provider.of<User>(context).type;
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
