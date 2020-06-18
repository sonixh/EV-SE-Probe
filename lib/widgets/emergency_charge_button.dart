import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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

  void inititateCharge() async {
    setState(() {
      updateSelected = true;
    });
    print('here');
    await Future.delayed(const Duration(seconds: 10), () {});
    // await NetworkHandler.startCharge(
    //     token: Provider.of<User>(context, listen: false).token,
    //     username: Provider.of<User>(context, listen: false).username,
    //     name: Provider.of<User>(context, listen: false).name,
    //     url: Provider.of<User>(context, listen: false).url,
    //     //vin: widget.vin,
    //     //miles: x
    //     );
    setState(() {
      updateSelected = false;
    });
  }

  void cancelCharge() async {
    await NetworkHandler.cancelCharge(
        token: Provider.of<User>(context, listen: false).token,
        username: Provider.of<User>(context, listen: false).username,
        name: Provider.of<User>(context, listen: false).name,
        url: Provider.of<User>(context, listen: false).url,
        vin: widget.vin);

    setState(() {
      updateSelected = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(flex: 18, child: SizedBox()),
        Expanded(
          flex: 40,
          child: Container(
            padding: EdgeInsets.all(1.5),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: CupertinoButton(
              padding: EdgeInsets.all(10),
              onPressed: inititateCharge,
              color: kAccentColor,
              child: updateSelected
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Charging',
                          style: kLabelTextStyle,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(width: 10),
                        SpinKitThreeBounce(color: Colors.white, size: 18)
                      ],
                    )
                  : Text(
                      'Charge Now',
                      style: kLabelTextStyle,
                      textAlign: TextAlign.center,
                    ),
            ),
          ),
        ),
        Expanded(flex: 4, child: SizedBox()),
        if (updateSelected)
          Expanded(
            flex: 30,
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
        Expanded(flex: 18, child: SizedBox()),
      ],
    );
  }
}
