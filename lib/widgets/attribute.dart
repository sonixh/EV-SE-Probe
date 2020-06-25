import 'package:flutter/material.dart';
import '../constants.dart';

class Attribute extends StatefulWidget {
  final AsyncSnapshot snapshot;
  final String label;
  final String x;

  Attribute({
    @required this.snapshot,
    @required this.label,
    @required this.x,
  });

  @override
  _AttributeState createState() => _AttributeState();
}

class _AttributeState extends State<Attribute> {
  @override
  Widget build(BuildContext context) {
    String internal;
    String externalString;
    bool show = true;

    String makeString(AsyncSnapshot snapshot) {
      if (widget.x == 'rev') {
        internal = snapshot.data.rev;
      }
      if (widget.x == 'rcd') {
        internal = snapshot.data.rcd;
      }
      if (widget.x == 'evseState') {
        internal = snapshot.data.evseState;
      }
      if (widget.x == 'evState') {
        internal = snapshot.data.evState;
      }
      if (widget.x == 'gfci') {
        internal = snapshot.data.gfci;
      }
      if (widget.x == 'peerConnected') {
        internal = snapshot.data.peerConnected;
      }
      if (widget.x == 'realPower') {
        internal = snapshot.data.realPower + " kW";
      }
      if (widget.x == 'secondaryStatus') {
        internal = snapshot.data.secondaryStatus;
      }
      if (widget.x == 'energyDown') {
        internal = snapshot.data.energyDown + " kWh";
      }
      if (widget.x == 'energyUp') {
        internal = snapshot.data.energyUp + " kWh";
      }
      if (widget.x == 'energyNet') {
        internal = snapshot.data.energyNet + " kWh";
      }
      if (widget.x == 'energyTotal') {
        internal = snapshot.data.energyTotal + " kWh";
      }
      if (widget.x == 'timestamp') {
        internal = snapshot.data.timestamp;
      }
      if (widget.x == 'carName') {
        internal = snapshot.data.carName;
      }
      if (widget.x == 'status') {
        internal = snapshot.data.status;
      }
      if (widget.x == 'name') {
        internal = snapshot.data.name;
      }
      if (widget.x == 'evseName') {
        internal = snapshot.data.evseName;
      }
      if (widget.x == 'soc') {
        internal = snapshot.data.soc + " %";
      }
      if (widget.x == 'primaryStatus') {
        internal = snapshot.data.primaryStatus;
      }
      if (widget.x == 'tAmbient') {
        internal = snapshot.data.tBatt;
        if (internal != null) {
          internal = internal + ' °C';
        }
      }
      if (widget.x == 'tCellAvg') {
        internal = snapshot.data.tCellAvg;
        if (internal != null) {
          internal = internal + ' °C';
        }
      }
      if (widget.x == 'tCellMin') {
        internal = snapshot.data.tCellMin;
        if (internal != null) {
          internal = internal + ' °C';
        }
      }
      if (widget.x == 'tCellMax') {
        internal = snapshot.data.tCellMax;
        if (internal != null) {
          internal = internal + ' °C';
        }
      }
      if (widget.x == 'meterSource') {
        internal = snapshot.data.meterSource;
      }

      if (internal == null || internal == '') {
        this.setState(() {
          show = false;
        });
        return null;
      } else {
        return internal;
      }
    }

    externalString = makeString(widget.snapshot);
    if (show) {
      return Container(
        child: RichText(
          text: TextSpan(
            style: kLabelTextStyle,
            children: <TextSpan>[
              TextSpan(
                text: widget.label,
                style: kLabelTextStyle,
              ),
              if (widget.label != "Car Name ")
                TextSpan(
                  text: externalString,
                  style: kLargeLabelTextStyle,
                ),
              if (widget.snapshot.data.peerConnected == 'false' &&
                  widget.label == "Car Name ")
                TextSpan(
                  text: externalString,
                  style: kGreyedOutTextStyle,
                ),
              if (widget.snapshot.data.peerConnected == 'true' &&
                  widget.label == "Car Name ")
                TextSpan(
                  text: externalString,
                  style: kLargeLabelTextStyle,
                ),
            ],
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}
