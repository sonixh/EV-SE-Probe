import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:v2g/models/evse_status.dart';
import 'package:v2g/models/user.dart';
import 'package:v2g/screens/single_resource_page.dart';
import 'package:v2g/widgets/round_icon_button.dart';
import '../constants.dart';

class ResourceList extends StatefulWidget {
  @override
  _ResourceList createState() => _ResourceList();
}

class _ResourceList extends State<ResourceList> {
  String userInputValue = '';
  List sortedList;
  int index;
  bool refreshing = true;
  List evseStatusList;
  Timer timer;

  void displayHelp() {
    showModalBottomSheet(
      isDismissible: true,
      context: context,
      builder: (BuildContext builder) {
        return Container(
          color: Color.fromRGBO(5, 27, 27, 60),
          height: MediaQuery.of(context).copyWith().size.height > 1000
              ? MediaQuery.of(context).copyWith().size.height / 2.5
              : MediaQuery.of(context).copyWith().size.height / 2,
          child: Container(
            decoration: BoxDecoration(
              color: kBackgroundColor,
            ),
            child: Container(
              padding: EdgeInsets.only(top: 15),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 200,
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Text(
                                  'Peer Connected',
                                  style: kLargeLabelTextStyle,
                                ),
                                Text(
                                  '& Online',
                                  style: kLargeLabelTextStyle,
                                ),
                              ],
                            ),
                            color: kAccentColor,
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            width: 200,
                            child: Column(
                              children: [
                                Text(
                                  'Not Peer',
                                  style: kLargeLabelTextStyle,
                                ),
                                Text(
                                  'Connected',
                                  style: kLargeLabelTextStyle,
                                ),
                                Text(
                                  '& Online',
                                  style: kLargeLabelTextStyle,
                                ),
                              ],
                            ),
                            color: Colors.grey,
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            width: 200,
                            child: Column(
                              children: [
                                Text(
                                  'Offline',
                                  style: kLargeLabelTextStyle,
                                ),
                              ],
                            ),
                            color: Colors.black12,
                          ),
                        ],
                      ),
                      SizedBox(width: 10),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              'State: B1',
                              style: kLargeLabelTextStyle,
                            ),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.red, width: 3)),
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              'State: B2',
                              style: kLargeLabelTextStyle,
                            ),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.white, width: 3)),
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              'State: LR',
                              style: kLargeLabelTextStyle,
                            ),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.yellow, width: 3)),
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              'State: NR',
                              style: kLargeLabelTextStyle,
                            ),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.blue, width: 3)),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.green,
                    ),
                    child: FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Done')),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  double getMarginWidth() {
    double width = MediaQuery.of(context).copyWith().size.width;
    if (width > 430) {
      return width / 6.25;
    } else {
      return 0;
    }
  }

  void getEVSEStatusList(
      String token, String name, String username, String url) async {
    if (true) {
      evseStatusList = await EVSEStatus.fetchDetailedEVSEStatusList(
          token: token, username: username, name: name, url: url);
      Provider.of<User>(context, listen: false)
          .setEVSEStatusList(evseStatusList);
      print('EVSE Status list loaded');
    }
    Provider.of<User>(context, listen: false).setType('evse');
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String token = Provider.of<User>(context).token;
    String name = Provider.of<User>(context).name;
    String username = Provider.of<User>(context).username;
    String url = Provider.of<User>(context).url;
    timer?.cancel();
    timer = Timer.periodic(
        Duration(seconds: kInterval),
        (Timer t) => setState(() {
              getEVSEStatusList(token, name, username, url);
              print('refreshing resource list');
            }));

    evseStatusList = Provider.of<User>(context).evseStatusList;
    sortedList = evseStatusList;

    if (sortedList != null) {
      sortedList.sort((a, b) => a.evseState.compareTo(b.evseState));

      sortedList = sortedList
          .where((object) =>
              (object.id
                  .toLowerCase()
                  .contains(userInputValue.toLowerCase())) ||
              (object.name
                  .toLowerCase()
                  .contains(userInputValue.toLowerCase())))
          .toList();
    }
    if (refreshing == true) {
      this.setState(() {
        refreshing = false;
      });
      return Center(
        child: SpinKitPulse(
          color: Colors.white,
          size: 100,
          duration: Duration(seconds: 1),
        ),
      );
    } else if (sortedList != null && refreshing == false) {
      return Container(
        margin:
            EdgeInsets.only(left: getMarginWidth(), right: getMarginWidth()),
        //margin: EdgeInsets.only(top: 70, left: 30, right: 30),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 0, bottom: 5, left: 20, right: 20),
              child: TextField(
                autocorrect: false,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  labelText: 'Search',
                ),
                onChanged: (value) {
                  setState(
                    () {
                      userInputValue = value;
                    },
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Text('EVSE Name ↔︎ EV Name'),
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                ),
                SizedBox(
                  width: 20,
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 4),
                  child: RoundIconButton(
                      icon: Icons.help_outline, onPressed: displayHelp),
                ),
              ],
            ),
            if (sortedList.length != 0)
              Expanded(
                child: Container(
                  padding:
                      EdgeInsets.only(top: 0, left: 5, right: 5, bottom: 0),
                  child: RefreshIndicator(
                    color: Colors.white,
                    onRefresh: () async {
                      setState(() {
                        getEVSEStatusList(token, name, username, url);
                      });
                      await Future.delayed(new Duration(seconds: 1));
                      return null;
                    },
                    child: ListView.builder(
                      itemCount: sortedList.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (BuildContext context, index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            if (sortedList[index].peerConnected == 'true')
                              Connected(sortedList: sortedList, index: index),
                            if (sortedList[index].peerConnected == 'true')
                              SizedBox(
                                height: 10,
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            if (sortedList.length == 0)
              Center(
                child: Text(
                  'Nothing to display for this user',
                  style: TextStyle(fontSize: 22),
                ),
              )
          ],
        ),
      );
    } else {
      return Center(
        child: SpinKitPulse(
          color: Colors.white,
          size: 100,
        ),
      );
    }
  }
}

class Connected extends StatelessWidget {
  const Connected({
    Key key,
    @required this.sortedList,
    @required this.index,
  }) : super(key: key);

  final List sortedList;
  final int index;

  @override
  Widget build(BuildContext context) {
    BoxDecoration box = new BoxDecoration(
      color: kAccentColor,
      border: Border.all(
        width: 3,
        color: Colors.white,
      ),
    );
    BoxDecoration redBox = new BoxDecoration(
      color: kAccentColor,
      border: Border.all(
        width: 3,
        color: Colors.red,
      ),
    );
    BoxDecoration yellowBox = new BoxDecoration(
      color: kAccentColor,
      border: Border.all(
        width: 3,
        color: Colors.yellow,
      ),
    );
    BoxDecoration blueBox = new BoxDecoration(
      color: kAccentColor,
      border: Border.all(
        width: 3,
        color: Colors.lightBlue,
      ),
    );

    if (sortedList[index].evseState == 'B1') {
      box = redBox;
    }
    if (sortedList[index].evseState == 'LR') {
      box = yellowBox;
    }
    if (sortedList[index].evseState == 'NR') {
      box = blueBox;
    }

    return GestureDetector(
      onTap: () {
        // print(sortedList[index].vinConnected);
        // print(sortedList[index].id);
        print(sortedList[index].carName);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SingleResourcePage(
                iD: sortedList[index].id, vin: sortedList[index].vinConnected),
          ),
        );
      },
      child: Container(
        decoration: box,
        margin: EdgeInsets.only(
          left: 7,
          right: 7,
        ),
        padding: EdgeInsets.only(top: 1, bottom: 1, left: 3, right: 3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 25,
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: RichText(
                  text: TextSpan(
                    style: kLabelTextStyle,
                    children: <TextSpan>[
                      TextSpan(
                        text: '${sortedList[index].name}',
                        style: nameTextStyle,
                      ),
                      TextSpan(
                        text: ' ↔︎ ',
                        style: kLargeLabelTextStyle,
                      ),
                      TextSpan(
                        text: '${sortedList[index].carName} ',
                        style: nameTextStyle,
                      ),
                      TextSpan(
                        text: '${sortedList[index].realPower}kW',
                        style: nameWithBackgroundTextStyle,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
