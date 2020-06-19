import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:v2g/models/network_handler.dart';
import 'package:v2g/models/user.dart';
import '../constants.dart';

class EmergencyChargeButton extends StatefulWidget {
  final String vin;
  const EmergencyChargeButton({Key key, @required this.vin});
  @override
  _EmergencyChargeButtonState createState() => _EmergencyChargeButtonState();
}

class _EmergencyChargeButtonState extends State<EmergencyChargeButton> {
  bool updateSelected = false;
  int minutesRemaining = 10;
  Timer t;
  String errorMessage;
  String startChargeMessage;

  @override
  void dispose() {
    try {
      t.cancel();
    } catch (e) {
      print('Here in emergency charge button $e');
    }
    super.dispose();
  }

  void inititateCharge() async {
    startChargeMessage = await NetworkHandler.startCharge(
      token: Provider.of<User>(context, listen: false).token,
      username: Provider.of<User>(context, listen: false).username,
      name: Provider.of<User>(context, listen: false).name,
      url: Provider.of<User>(context, listen: false).url,
      vin: widget.vin,
    );
    if (startChargeMessage == 'null') {
      setState(() {
        updateSelected = true;
        errorMessage = null;
      });

      Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          t = timer;
          minutesRemaining = ((600 - t.tick) / 60).round();
          print('$minutesRemaining -------- ${t.tick}');
        });
        if (t.tick == 600) {
          t.cancel();
          cancelCharge();
        }
      });
    }
    setState(() {});
  }

  void cancelCharge() async {
    errorMessage = await NetworkHandler.cancelCharge(
        token: Provider.of<User>(context, listen: false).token,
        username: Provider.of<User>(context, listen: false).username,
        name: Provider.of<User>(context, listen: false).name,
        url: Provider.of<User>(context, listen: false).url,
        vin: widget.vin);

    t.cancel();

    setState(() {
      updateSelected = false;
      minutesRemaining = 10;
    });
  }

  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Would you like to cancel emergency charge?'),
        actions: [
          FlatButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('No'),
          ),
          FlatButton(
            onPressed: _cancelFromDialog,
            child: Text('Yes'),
          ),
        ],
      ),
    );
  }

  void _cancelFromDialog() {
    cancelCharge();
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(flex: 9, child: SizedBox()),
              Expanded(
                flex:
                    MediaQuery.of(context).copyWith().size.width > 500 ? 5 : 13,
                child: Container(
                  padding: EdgeInsets.all(1.5),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: CupertinoButton(
                    padding: EdgeInsets.all(10),
                    onPressed: inititateCharge,
                    color: updateSelected ? Colors.green : Colors.grey[600],
                    child: updateSelected
                        ? Text(
                            'Charging',
                            style: kLabelTextStyle,
                            textAlign: TextAlign.center,
                          )
                        : Text(
                            'Charge Now',
                            style: kLabelTextStyle,
                            textAlign: TextAlign.center,
                          ),
                  ),
                ),
              ),
              if (updateSelected)
                Expanded(
                    flex: 5,
                    child: Text(
                      minutesRemaining.toString(),
                      textAlign: TextAlign.center,
                      style: kLargeLabelTextStyle,
                    )),
              if (updateSelected)
                Expanded(
                  flex: MediaQuery.of(context).copyWith().size.width > 500
                      ? 5
                      : 10,
                  child: Container(
                    child: CupertinoButton(
                      padding: EdgeInsets.all(10),
                      onPressed: cancelCharge,
                      color: Colors.grey,
                      child: Text(
                        'Cancel',
                        style: kLabelTextStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              Expanded(flex: 9, child: SizedBox()),
            ],
          ),
          if (errorMessage != null)
            Container(
              margin: EdgeInsets.only(top: 3),
              child: Text(
                '$errorMessage',
                style: TextStyle(color: Colors.red),
              ),
            ),
          if (startChargeMessage != 'null' && startChargeMessage != null)
            Container(
              margin: EdgeInsets.only(top: 3),
              child: Text(
                '$startChargeMessage',
                style: TextStyle(color: Colors.red),
              ),
            ),
        ],
      ),
    );
  }
}
