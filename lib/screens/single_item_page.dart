import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:v2g/constants.dart';
import 'package:v2g/models/ev.dart';
import 'package:v2g/models/evse.dart';
import 'package:v2g/models/evse_swver.dart';
import 'package:v2g/models/user.dart';
import 'package:v2g/widgets/ev_info_widget.dart';
import 'package:v2g/widgets/evse_info_widget.dart';
import 'package:v2g/widgets/meter_status_view.dart';
import 'package:v2g/widgets/status_widget.dart';

class SingleItemPage extends StatefulWidget {
  const SingleItemPage({Key key, this.iD}) : super(key: key);

  final String iD;

  @override
  _SingleItemPageState createState() => _SingleItemPageState(iD: iD);
}

class _SingleItemPageState extends State<SingleItemPage> {
  Future f;

  _SingleItemPageState({@required this.iD});
  final String iD;

  final Map<int, Widget> evseOptionWidgets = const <int, Widget>{
    0: Text(
      'Status',
      style: TextStyle(fontSize: 29),
    ),
    1: Text(
      'Info',
      style: TextStyle(fontSize: 29),
    ),
    2: Text(
      'Meter',
      style: TextStyle(fontSize: 29),
    ),
  };

  final Map<int, Widget> evOptionWidgets = const <int, Widget>{
    0: Text(
      'Status',
      style: TextStyle(fontSize: 29),
    ),
    1: Text(
      'Info',
      style: TextStyle(fontSize: 29),
    ),
  };

  bool status;
  bool meter;
  int sharedValue = 0;

  double getMarginWidth() {
    double width = MediaQuery.of(context).copyWith().size.width;
    if (width > 430) {
      return width / 5.25;
    } else {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    String type = Provider.of<User>(context).type;
    List evseList = Provider.of<User>(context).evseList;
    List evList = Provider.of<User>(context).evList;
    List evseSwVerList = Provider.of<User>(context).evseSwVerList;
    EVSE evse = new EVSE();
    EV ev = new EV();
    EVSESwVer evseSwVer = new EVSESwVer();

    if (type == 'evse') {
      evse = evseList
          .where(
              (object) => (object.id.toLowerCase().contains(iD.toLowerCase())))
          .toList()[0];
    }

    if (type == 'ev') {
      ev = evList
          .where(
              (object) => (object.id.toLowerCase().contains(iD.toLowerCase())))
          .toList()[0];
    }

    if (sharedValue == 1 && type == 'evse') {
      status = false;
      meter = false;
      try {
        evseSwVer = evseSwVerList
            .where((object) =>
                (object.id.toLowerCase().contains(iD.toLowerCase())))
            .toList()[0];
      } catch (e) {
        print('no config/get info for this evse');
      }
    } else if (sharedValue == 1 && type == 'ev') {
      status = false;
      meter = false;
    } else if (sharedValue == 0 && type == 'evse') {
      status = true;
      meter = false;
    } else if (sharedValue == 0 && type == 'ev') {
      status = true;
      meter = false;
    } else {
      meter = true;
      status = false;
    }

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: <Widget>[
            if (type == 'ev')
              Text(
                'EV: ${ev.name}',
                style: TextStyle(fontSize: 17),
              ),
            if (type == 'evse')
              Text(
                'EVSE: ${evse.name}',
                style: TextStyle(fontSize: 17),
              ),
          ],
        ),
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.only(top: 5, bottom: 0, left: 20, right: 20),
            width: 325,
            child: CupertinoSegmentedControl(
              padding: EdgeInsets.only(top: 0),
              selectedColor: kAccentColor,
              unselectedColor: kBackgroundColor,
              borderColor: kAccentColor,
              children: type == 'ev' ? evOptionWidgets : evseOptionWidgets,
              onValueChanged: (int val) {
                setState(() {
                  sharedValue = val;
                });
              },
              groupValue: sharedValue,
            ),
          ),
          RefreshIndicator(
            color: Colors.white,
            onRefresh: () async {
              setState(() {});
              await Future.delayed(new Duration(seconds: 1));
              return null;
            },
            child: status || meter
                ? Container(
                    height: MediaQuery.of(context).copyWith().size.height - 200,
                    child: ListView(
                      children: [
                        status
                            ? StatusWidget(
                                iD: iD,
                              )
                            : MeterStatusView(iD: iD),
                      ],
                    ),
                  )
                : type == 'evse'
                    ? EVSEInfoWidget(
                        evse: evse,
                        evseSwVer: evseSwVer,
                      )
                    : EVInfoWidget(ev: ev),
          ),
        ],
      ),
    );
  }
}
