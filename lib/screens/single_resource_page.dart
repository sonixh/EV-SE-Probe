import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:v2g/constants.dart';
import 'package:v2g/models/info/ev.dart';
import 'package:v2g/models/status/ev_status.dart';
import 'package:v2g/models/info/evse.dart';
import 'package:v2g/models/status/evse_status.dart';
import 'package:v2g/models/network_handler.dart';
import 'package:v2g/models/user.dart';
import 'package:v2g/screens/single_item_page.dart';
//import 'package:v2g/widgets/emergency_charge_button.dart';
import 'package:v2g/widgets/ui/reusable_card.dart';

class SingleResourcePage extends StatefulWidget {
  const SingleResourcePage({Key key, this.iD, this.vin}) : super(key: key);
  final String iD;
  final String vin;

  @override
  _SingleResourcePage createState() => _SingleResourcePage(iD: iD, vin: vin);
}

class _SingleResourcePage extends State<SingleResourcePage> {
  _SingleResourcePage({@required this.iD, @required this.vin});
  final String iD;
  final String vin;
  EVSE evseInfo = new EVSE();
  EV evInfo = new EV();
  EVSEStatus evseStatus = new EVSEStatus();
  EVStatus evStatus = new EVStatus();
  Timer timer;

  Future<List> _getFs() {
    String token = Provider.of<User>(context).token;
    String name = Provider.of<User>(context).name;
    String username = Provider.of<User>(context).username;
    String url = Provider.of<User>(context).url;

    Future f0 = evseStatus.fetchEVSEStatus(
        evseID: iD, token: token, name: name, username: username, url: url);

    Future f1 = evStatus.fetchEVStatus(
        vin: vin, token: token, name: name, username: username, url: url);

    Future f2 = NetworkHandler.fetchMeterStatus(
        meterId: 'EVSE:$iD',
        token: token,
        name: name,
        username: username,
        url: url);

    return Future.wait([f0, f1, f2]);
  }

  String parseSoc(AsyncSnapshot snapshot) {
    try {
      return '${double.parse(snapshot.data[1].soc).truncate().toString()}% / ';
    } catch (e) {
      return '';
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
              print('refreshing single resource page');
            }));

    List evseList = Provider.of<User>(context).evseList;
    List evList = Provider.of<User>(context).evList;

    if (evInfo != null && evList.length != 0) {
      try {
        evInfo = evList
            .where((object) =>
                (object.id.toLowerCase().contains(vin.toLowerCase())))
            .toList()[0];
      } catch (e) {
        print('$e here in single resource page');
      }
    }

    if (evseInfo != null && evseList.length != 0) {
      evseInfo = evseList
          .where(
              (object) => (object.id.toLowerCase().contains(iD.toLowerCase())))
          .toList()[0];
    }

    return Container(
      child: FutureBuilder(
        future: _getFs(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              appBar: AppBar(
                title: Column(
                  children: <Widget>[
                    Text(
                      'Resource',
                      style: TextStyle(fontSize: 17),
                    ),
                  ],
                ),
                elevation: 0,
              ),
              body: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(
                            top: 5, bottom: 0, left: 20, right: 20),
                        width: 325,
                        child: RefreshIndicator(
                          color: Colors.white,
                          onRefresh: () async {
                            setState(() {});
                            await Future.delayed(new Duration(seconds: 1));
                            return null;
                          },
                          child: ListView(
                            children: [
                              Container(
                                child: ReusableCard(
                                  colour: kBackgroundColor,
                                  margin: 0,
                                  onPress: () {
                                    print('Going to EVSE status page');
                                    Provider.of<User>(context, listen: false)
                                        .setType('evse');
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            SingleItemPage(iD: iD),
                                      ),
                                    );
                                  },
                                  cardChild: RichText(
                                    text: TextSpan(
                                      style: kLabelTextStyle,
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: 'EVSE Name ',
                                          style: kLabelTextStyle,
                                        ),
                                        TextSpan(
                                          text: snapshot.data[0].name,
                                          style: kLargeLabelRouteTextStyle,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                child: RichText(
                                  text: TextSpan(
                                    style: kLabelTextStyle,
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: 'EVSE ID ',
                                        style: kLabelTextStyle,
                                      ),
                                      TextSpan(
                                        text: snapshot.data[0].id,
                                        style: kLargeLabelTextStyle,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                child: RichText(
                                  text: TextSpan(
                                    style: kLabelTextStyle,
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: 'Reverse Feeding ',
                                        style: kLabelTextStyle,
                                      ),
                                      TextSpan(
                                        text: evseInfo.reverse,
                                        style: kLargeLabelTextStyle,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              if (evseInfo.address != "")
                                Container(
                                  height: 20,
                                  child: FittedBox(
                                    alignment: Alignment.centerLeft,
                                    child: RichText(
                                      text: TextSpan(
                                        style: kLabelTextStyle,
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: 'Address ',
                                            style: kLabelTextStyle,
                                          ),
                                          TextSpan(
                                            text: evseInfo.address,
                                            style: kLargeLabelTextStyle,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              if (evseInfo.utility != "")
                                Container(
                                  height: 20,
                                  child: FittedBox(
                                    alignment: Alignment.centerLeft,
                                    child: RichText(
                                      text: TextSpan(
                                        style: kLabelTextStyle,
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: 'RTO/Utility ',
                                            style: kLabelTextStyle,
                                          ),
                                          TextSpan(
                                            text:
                                                '${evseInfo.iso}/ ${evseInfo.utility}',
                                            style: kLargeLabelTextStyle,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              Container(
                                child: RichText(
                                  text: TextSpan(
                                    style: kLabelTextStyle,
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: 'State ',
                                        style: kLabelTextStyle,
                                      ),
                                      TextSpan(
                                        text: snapshot.data[0].evseState,
                                        style: kLargeLabelTextStyle,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                child: RichText(
                                  text: TextSpan(
                                    style: kLabelTextStyle,
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: 'GFCI ',
                                        style: kLabelTextStyle,
                                      ),
                                      TextSpan(
                                        text: snapshot.data[0].gfci,
                                        style: kLargeLabelTextStyle,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                child: RichText(
                                  text: TextSpan(
                                    style: kLabelTextStyle,
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: 'Real Power ',
                                        style: kLabelTextStyle,
                                      ),
                                      TextSpan(
                                        text:
                                            '${snapshot.data[0].realPower} kW',
                                        style: kLargeLabelTextStyle,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                child: RichText(
                                  text: TextSpan(
                                    style: kLabelTextStyle,
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: 'Power Factor ',
                                        style: kLabelTextStyle,
                                      ),
                                      TextSpan(
                                        text: snapshot.data[0].powerFactor,
                                        style: kLargeLabelTextStyle,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                child: RichText(
                                  text: TextSpan(
                                    style: kLabelTextStyle,
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: 'Peer Connected ',
                                        style: kLabelTextStyle,
                                      ),
                                      TextSpan(
                                        text: snapshot.data[0].peerConnected,
                                        style: kLargeLabelTextStyle,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(top: 5, bottom: 5),
                                child:
                                    Divider(thickness: 2, color: Colors.white),
                              ),
                              Container(
                                child: ReusableCard(
                                  colour: kBackgroundColor,
                                  margin: 0,
                                  onPress: () {
                                    print(vin);
                                    if (snapshot.data[1].name != 'null') {
                                      print('Going to single EV status page');
                                      Provider.of<User>(context, listen: false)
                                          .setType('ev');
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              SingleItemPage(iD: vin),
                                        ),
                                      );
                                    }
                                  },
                                  cardChild: RichText(
                                    text: TextSpan(
                                      style: kLabelTextStyle,
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: 'EV Name ',
                                          style: kLabelTextStyle,
                                        ),
                                        TextSpan(
                                          text: snapshot.data[1].name,
                                          style: kLargeLabelRouteTextStyle,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                child: RichText(
                                  text: TextSpan(
                                    style: kLabelTextStyle,
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: 'VIN ',
                                        style: kLabelTextStyle,
                                      ),
                                      TextSpan(
                                        //text: evInfo.id,
                                        text: '${snapshot.data[1].vin}',
                                        style: kLargeLabelTextStyle,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
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
                                            '${snapshot.data[1].socKwh} kWh',
                                        style: kLargeLabelTextStyle,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                child: RichText(
                                  text: TextSpan(
                                    style: kLabelTextStyle,
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: 'Primary Status ',
                                        style: kLabelTextStyle,
                                      ),
                                      TextSpan(
                                        text: snapshot.data[1].primaryStatus,
                                        style: kLargeLabelTextStyle,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                child: RichText(
                                  text: TextSpan(
                                    style: kLabelTextStyle,
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: 'Secondary Status ',
                                        style: kLabelTextStyle,
                                      ),
                                      TextSpan(
                                        text: snapshot.data[1].secondaryStatus,
                                        style: kLargeLabelTextStyle,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                child: RichText(
                                  text: TextSpan(
                                    style: kLabelTextStyle,
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: 'Peer Connected ',
                                        style: kLabelTextStyle,
                                      ),
                                      TextSpan(
                                        text: snapshot.data[1].peerConnected,
                                        style: kLargeLabelTextStyle,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                child: RichText(
                                  text: TextSpan(
                                    style: kLabelTextStyle,
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: 'Power Flow ',
                                        style: kLabelTextStyle,
                                      ),
                                      TextSpan(
                                        text:
                                            '${snapshot.data[1].powerFlow} kW',
                                        style: kLargeLabelTextStyle,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              MediaQuery.of(context).copyWith().size.width < 450
                                  ? Container(
                                      child: FittedBox(
                                        fit: BoxFit.fitWidth,
                                        child: RichText(
                                          text: TextSpan(
                                            style: kLabelTextStyle,
                                            children: <TextSpan>[
                                              TextSpan(
                                                text:
                                                    'Bat. Module °C (min,avg,max) ',
                                                style: kLabelTextStyle,
                                              ),
                                              TextSpan(
                                                text:
                                                    ('${double.parse(snapshot.data[1].tCellMin).truncate().toString()}, ${double.parse(snapshot.data[1].tCellAvg).truncate().toString()}, ${double.parse(snapshot.data[1].tCellMax).truncate().toString()}'),
                                                style: kLargeLabelTextStyle,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(
                                      child: RichText(
                                        text: TextSpan(
                                          style: kLabelTextStyle,
                                          children: <TextSpan>[
                                            TextSpan(
                                              text:
                                                  'Bat. Module °C (min,avg,max) ',
                                              style: kLabelTextStyle,
                                            ),
                                            TextSpan(
                                              text:
                                                  ('${double.parse(snapshot.data[1].tCellMin).truncate().toString()}, ${double.parse(snapshot.data[1].tCellAvg).truncate().toString()}, ${double.parse(snapshot.data[1].tCellMax).truncate().toString()}'),
                                              style: kLargeLabelTextStyle,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                              Container(
                                padding: EdgeInsets.only(top: 5, bottom: 5),
                                child:
                                    Divider(thickness: 2, color: Colors.white),
                              ),
                              Container(
                                child: RichText(
                                  text: TextSpan(
                                    style: kLabelTextStyle,
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: 'Meter Name ',
                                        style: kLabelTextStyle,
                                      ),
                                      TextSpan(
                                        text: '${snapshot.data[2].meterName}',
                                        style: kLargeLabelTextStyle,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                child: RichText(
                                  text: TextSpan(
                                    style: kLabelTextStyle,
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: 'Meter ID ',
                                        style: kLabelTextStyle,
                                      ),
                                      TextSpan(
                                        text: '${snapshot.data[2].meterId}',
                                        style: kLargeLabelTextStyle,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                child: RichText(
                                  text: TextSpan(
                                    style: kLabelTextStyle,
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: 'Power Factor ',
                                        style: kLabelTextStyle,
                                      ),
                                      TextSpan(
                                        text: '${snapshot.data[2].powerFactor}',
                                        style: kLargeLabelTextStyle,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                child: RichText(
                                  text: TextSpan(
                                    style: kLabelTextStyle,
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: 'Power Flow Real ',
                                        style: kLabelTextStyle,
                                      ),
                                      TextSpan(
                                        text:
                                            '${snapshot.data[2].powerFlowReal} kW',
                                        style: kLargeLabelTextStyle,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // StreamBuilder<int>(
                              //   stream: Provider.of<User>(context).intStream(),
                              //   builder: (context, snapshot) {
                              //     if (snapshot.hasData) {
                              //       print(snapshot.data);
                              //       return Text(
                              //           '${Provider.of<User>(context).count}');
                              //     } else {
                              //       return Text('Waiting...');
                              //     }
                              //   },
                              // ),
                              //SizedBox(height: 30),
                              //EmergencyChargeButton(vin: snapshot.data[1].vin),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
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
  }
}
