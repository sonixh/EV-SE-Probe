import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:v2g/models/ev.dart';
import 'package:v2g/models/ev_status.dart';
import 'package:v2g/models/evse.dart';
import 'package:v2g/models/evse_status.dart';
import 'package:v2g/models/user.dart';
import 'package:v2g/screens/list_page.dart';
import 'package:v2g/screens/resource_page.dart';
import 'package:v2g/widgets/reusable_card.dart';
import '../constants.dart';
import 'icon_content.dart';

class EVEVSEResourceButtons extends StatefulWidget {
  @override
  _EVEVSEResourceButtonsState createState() => _EVEVSEResourceButtonsState();
}

class _EVEVSEResourceButtonsState extends State<EVEVSEResourceButtons> {
  List<dynamic> evseList = [];
  List<dynamic> evList = [];
  List<dynamic> evseStatusList = [];
  List<dynamic> evStatusList = [];
  EVSE devse = new EVSE();
  EV dev = new EV();
  EVSEStatus evseStatus = new EVSEStatus();
  EVStatus evStatus = new EVStatus();

  void getEVSEList(
      String token, String name, String username, String url) async {
    if (evseList.isEmpty) {
      evseList = await devse.fetchDetailedEVSEList(
          token: token, name: name, username: username, url: url);
      Provider.of<User>(context, listen: false).setEVSEList(evseList);
      print('EVSE list loaded');
      //only prints out 'instance of EVSE'
      //print(evseList);
    }
    Provider.of<User>(context, listen: false).setType('evse');
  }

  void getEVList(String token, String name, String username, String url) async {
    if (evList.isEmpty) {
      evList = await dev.fetchDetailedEVList(
          token: token, username: username, name: name, url: url);
      Provider.of<User>(context, listen: false).setEVList(evList);
      print('EV list loaded');
    }
    Provider.of<User>(context, listen: false).setType('ev');
  }

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

  void getEVStatusList(
      String token, String name, String username, String url) async {
    if (true) {
      evStatusList = await evStatus.fetchDetailedEVStatusList(
          token: token, username: username, name: name, url: url);
      Provider.of<User>(context, listen: false).setEVStatusList(evStatusList);
      print('EV Status list loaded');
    }
    Provider.of<User>(context, listen: false).setType('ev');
  }

  @override
  Widget build(BuildContext context) {
    String token = Provider.of<User>(context).token;
    String name = Provider.of<User>(context).name;
    String username = Provider.of<User>(context).username;
    String url = Provider.of<User>(context).url;
    //String role = Provider.of<User>(context).role;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        //if (role == "developer")
        ReusableCard(
          margin: 0,
          onPress: () {
            getEVList(token, name, username, url);
            getEVStatusList(token, name, username, url);
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => ListPage()));
          },
          colour: kAccentColor,
          cardChild: Container(
            padding: EdgeInsets.only(top: 15, bottom: 10),
            child: IconContent(icon: FontAwesomeIcons.car, label: 'EV'),
          ),
        ),
        //if (role == "developer")
        Container(
          padding: EdgeInsets.all(10),
          child: Divider(
            color: Colors.white,
            thickness: 3,
          ),
        ),
        ReusableCard(
          margin: 0,
          colour: kAccentColor,
          cardChild: Container(
            padding: EdgeInsets.only(top: 15, bottom: 10),
            child: IconContent(
                icon: FontAwesomeIcons.chargingStation, label: 'EVSE'),
          ),
          onPress: () {
            getEVSEList(token, name, username, url);
            getEVSEStatusList(token, name, username, url);
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => ListPage()));
          },
        ),
        Container(
          padding: EdgeInsets.all(10),
          child: Divider(
            color: Colors.white,
            thickness: 3,
          ),
        ),
        ReusableCard(
          margin: 0,
          onPress: () {
            getEVList(token, name, username, url);
            getEVStatusList(token, name, username, url);
            getEVSEList(token, name, username, url);
            getEVSEStatusList(token, name, username, url);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ResourcePage()));
          },
          colour: kAccentColor,
          cardChild: Container(
            padding: EdgeInsets.only(top: 15, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconContent(
                    icon: FontAwesomeIcons.chargingStation, label: 'Peer'),
                Container(width: 30),
                IconContent(icon: FontAwesomeIcons.car, label: 'Pair'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
