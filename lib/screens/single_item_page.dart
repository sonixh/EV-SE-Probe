import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:v2g/constants.dart';
import 'package:v2g/models/ev.dart';
import 'package:v2g/models/evse.dart';
import 'package:v2g/models/ev_status.dart';
import 'package:v2g/models/evse_status.dart';
import 'package:v2g/models/user.dart';
import 'package:v2g/widgets/ev_info_widget.dart';
import 'package:v2g/widgets/evse_info_widget.dart';
import 'package:v2g/widgets/status_widget.dart';

class SingleItemPage extends StatefulWidget {
  const SingleItemPage({Key key, this.iD, this.type}) : super(key: key);

  final String iD;
  final String type;

  @override
  _SingleItemPageState createState() => _SingleItemPageState(iD: iD);
}

class _SingleItemPageState extends State<SingleItemPage> {
  Future f;
  int _count = 0;

  _SingleItemPageState({@required this.iD});
  final String iD;

  final Map<int, Widget> optionWidgets = const <int, Widget>{
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
  int sharedValue = 0;

  @override
  Widget build(BuildContext context) {
    String token = Provider.of<User>(context).token;
    String name = Provider.of<User>(context).name;
    String username = Provider.of<User>(context).username;
    String url = Provider.of<User>(context).url;
    String type = Provider.of<User>(context).type;
    List evseList = Provider.of<User>(context).evseList;
    List evList = Provider.of<User>(context).evList;
    EVSE evse = new EVSE();
    DetailedEV ev = new DetailedEV();

    if (sharedValue == 1 && type == 'evse') {
      status = false;
      evse = evseList
          .where((object) =>
              (object.name.toLowerCase().contains(iD.toLowerCase())) ||
              (object.id.toLowerCase().contains(iD.toLowerCase())))
          .toList()[0];
    } else if (sharedValue == 1 && type == 'ev') {
      status = false;
      ev = evList
          .where((object) =>
              (object.name.toLowerCase().contains(iD.toLowerCase())) ||
              (object.id.toLowerCase().contains(iD.toLowerCase())))
          .toList()[0];
    } else if (sharedValue == 0 && type == 'evse') {
      status = true;
      EVSEStatus evseStatus = new EVSEStatus();
      f = evseStatus.fetchEVSEStatus(
          evseID: iD, token: token, name: name, username: username, url: url);
    } else {
      status = true;
      EVStatus evStatus = new EVStatus();
      f = evStatus.fetchEVStatus(
          vin: iD, token: token, name: name, username: username, url: url);
    }

    if (status) {
      return Container(
        child: FutureBuilder(
          future: f,
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return Scaffold(
                appBar: AppBar(
                  title: Column(
                    children: <Widget>[
                      Text(
                        '${snapshot.data.name}',
                        style: TextStyle(fontSize: 17),
                      ),
                    ],
                  ),
                  elevation: 0,
                ),
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(
                          top: 5, bottom: 0, left: 20, right: 20),
                      width: 325,
                      child: CupertinoSegmentedControl(
                        padding: EdgeInsets.only(top: 0),
                        selectedColor: kAccentColor,
                        borderColor: kAccentColor,
                        children: optionWidgets,
                        onValueChanged: (int val) {
                          setState(() {
                            sharedValue = val;
                          });
                        },
                        groupValue: sharedValue,
                      ),
                    ),
                    RefreshIndicator(
                      onRefresh: () async {
                        setState(() {
                          _count = _count + 1;
                        });
                        await Future.delayed(new Duration(seconds: 1));
                        return null;
                      },
                      child: Container(
                        height: 500,
                        child: ListView(
                          children: [
                            StatusWidget(future: f),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Center(
                child: Container(
                  color: kBackgroundColor,
                  child: SpinKitPulse(
                    color: Colors.white,
                    size: 100,
                  ),
                ),
              );
            }
          },
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Column(
            children: <Widget>[
              if (type == 'evse')
                Text(
                  '${evse.name}',
                  style: TextStyle(fontSize: 17),
                ),
              if (type == 'ev')
                Text(
                  '${ev.name}',
                  style: TextStyle(fontSize: 17),
                ),
            ],
          ),
          elevation: 0,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 5, bottom: 0, left: 20, right: 20),
              width: 325,
              child: CupertinoSegmentedControl(
                padding: EdgeInsets.only(top: 0),
                selectedColor: kAccentColor,
                borderColor: kAccentColor,
                children: optionWidgets,
                onValueChanged: (int val) {
                  setState(() {
                    sharedValue = val;
                  });
                },
                groupValue: sharedValue,
              ),
            ),
            if (sharedValue == 1 && type == 'evse')
              EVSEInfoWidget(future: evse),
            if (sharedValue == 1 && type == 'ev') EVInfoWidget(future: ev),
          ],
        ),
      );
    }
  }
}
