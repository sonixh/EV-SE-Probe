import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:v2g/constants.dart';
import 'package:v2g/models/ev.dart';
import 'package:v2g/models/ev_status.dart';
import 'package:v2g/models/evse.dart';
import 'package:v2g/models/evse_status.dart';
import 'package:v2g/models/user.dart';
import 'package:v2g/screens/single_item_page.dart';
import 'package:v2g/widgets/reusable_card.dart';

class SingleResourcePage extends StatefulWidget {
  const SingleResourcePage({Key key, this.iD, this.vin}) : super(key: key);

  final String iD;
  final String vin;

  @override
  _SingleResourcePage createState() => _SingleResourcePage(iD: iD, vin: vin);
}

class _SingleResourcePage extends State<SingleResourcePage> {
  Future f0;
  Future f1;
  Future<List> listOfFutures;

  _SingleResourcePage({@required this.iD, @required this.vin});
  final String iD;
  final String vin;
  Future f;

  @override
  Widget build(BuildContext context) {
    String token = Provider.of<User>(context).token;
    String name = Provider.of<User>(context).name;
    String username = Provider.of<User>(context).username;
    String url = Provider.of<User>(context).url;
    EVSE evseInfo = new EVSE();
    EV evInfo = new EV();
    EVSEStatus evseStatus = new EVSEStatus();
    EVStatus evStatus = new EVStatus();

    List evseList = Provider.of<User>(context).evseList;
    List evList = Provider.of<User>(context).evList;

    evInfo = evList
        .where(
            (object) => (object.id.toLowerCase().contains(vin.toLowerCase())))
        .toList()[0];
    // print(evInfo.id);
    // print(vin);

    evseInfo = evseList
        .where((object) =>
            (object.name.toLowerCase().contains(iD.toLowerCase())) ||
            (object.id.toLowerCase().contains(iD.toLowerCase())))
        .toList()[0];
    // print(evseInfo.id);
    // print(iD);

    f0 = evseStatus.fetchEVSEStatus(
        evseID: iD, token: token, name: name, username: username, url: url);

    f1 = evStatus.fetchEVStatus(
        vin: vin, token: token, name: name, username: username, url: url);

    return Container(
      child: FutureBuilder(
        future: Future.wait([f0, f1]),
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
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    padding:
                        EdgeInsets.only(top: 5, bottom: 0, left: 20, right: 20),
                    width: 325,
                    child: RefreshIndicator(
                      onRefresh: () async {
                        setState(() {});
                        await Future.delayed(new Duration(seconds: 1));
                        return null;
                      },
                      child: Container(
                        height: 500,
                        child: ListView(
                          children: [
                            Container(
                              child: ReusableCard(
                                colour: kBackgroundColor,
                                margin: 0,
                                onPress: () {
                                  print('Going to EVSE status page');
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
                                  fit: BoxFit.fitWidth,
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
                              FittedBox(
                                child: Container(
                                  child: RichText(
                                    text: TextSpan(
                                      style: kLabelTextStyle,
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: 'RTO/Utility ',
                                          style: kLabelTextStyle,
                                        ),
                                        TextSpan(
                                          text: evseInfo.utility,
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
                                      text: '${snapshot.data[0].realPower} kW',
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
                              child: Divider(thickness: 2, color: Colors.white),
                            ),
                            Container(
                              child: ReusableCard(
                                colour: kBackgroundColor,
                                margin: 0,
                                onPress: () {
                                  print('Going to single EV status page');
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
                                      text: evInfo.id,
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
                                      text: 'SOC ',
                                      style: kLabelTextStyle,
                                    ),
                                    TextSpan(
                                      text: '${snapshot.data[1].soc} %',
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
                          ],
                        ),
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
  }
}
