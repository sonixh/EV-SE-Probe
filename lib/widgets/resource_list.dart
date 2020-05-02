import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:v2g/models/evse_status.dart';
import 'package:v2g/models/user.dart';
import 'package:v2g/screens/single_resource_page.dart';
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
  EVSEStatus evseStatus = new EVSEStatus();
  List evseStatusList;

  void getEVSEStatusList(
      String token, String name, String username, String url) async {
    if (true) {
      evseStatusList = await evseStatus.fetchDetailedEVSEStatusList(
          token: token, username: username, name: name, url: url);
      Provider.of<User>(context, listen: false)
          .setEVSEStatusList(evseStatusList);
      print('EVSE Status list loaded');
    }
    Provider.of<User>(context, listen: false).setType('evse');
  }

  @override
  Widget build(BuildContext context) {
    //List evStatusList = Provider.of<User>(context).evStatusList;
    String token = Provider.of<User>(context).token;
    String name = Provider.of<User>(context).name;
    String username = Provider.of<User>(context).username;
    String url = Provider.of<User>(context).url;

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
      return Column(
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
          Container(
            child: Text('EVSE Name ↔︎ EV Name'),
            padding: EdgeInsets.only(top: 10, bottom: 10),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(top: 0, left: 5, right: 5, bottom: 0),
              child: RefreshIndicator(
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
        ],
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
