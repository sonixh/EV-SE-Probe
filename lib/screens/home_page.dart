import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:v2g/models/ev.dart';
import 'package:v2g/models/ev_status.dart';
import 'package:v2g/models/evse.dart';
import 'package:v2g/models/evse_status.dart';
import 'package:v2g/models/evse_swver.dart';
import 'package:v2g/models/network_handler.dart';
import 'package:v2g/models/user.dart';
import 'package:v2g/screens/resource_page.dart';
import 'package:v2g/widgets/icon_content.dart';
import 'package:v2g/widgets/reusable_card.dart';
import '../constants.dart';
import 'list_page.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> evseList = [];
  List<dynamic> evList = [];
  List<dynamic> evseStatusList = [];
  List<dynamic> evStatusList = [];
  List<dynamic> evseSwVerList = [];

  void getEVSEList(
      String token, String name, String username, String url) async {
    if (evseList.isEmpty) {
      evseList = await EVSE.fetchDetailedEVSEList(
          token: token, name: name, username: username, url: url);
      Provider.of<User>(context, listen: false).setEVSEList(evseList);
      print('EVSE list loaded');
    }
    Provider.of<User>(context, listen: false).setType('evse');
  }

  void getEVSESwVerList(
      String token, String name, String username, String url) async {
    if (evseSwVerList.isEmpty) {
      evseSwVerList = await EVSESwVer.fetchEVSESwVerList(
          token: token, name: name, username: username, url: url);
      Provider.of<User>(context, listen: false).setEVSESwVerList(evseSwVerList);
      print('EVSE Software Version list loaded');
    }
    Provider.of<User>(context, listen: false).setType('evse');
  }

  void getEVList(String token, String name, String username, String url) async {
    if (evList.isEmpty) {
      evList = await EV.fetchDetailedEVList(
          token: token, username: username, name: name, url: url);
      Provider.of<User>(context, listen: false).setEVList(evList);
      print('EV list loaded');
    }
    Provider.of<User>(context, listen: false).setType('ev');
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

  void getEVStatusList(
      String token, String name, String username, String url) async {
    if (true) {
      evStatusList = await EVStatus.fetchDetailedEVStatusList(
          token: token, username: username, name: name, url: url);
      Provider.of<User>(context, listen: false).setEVStatusList(evStatusList);
      print('EV Status list loaded');
    }
    Provider.of<User>(context, listen: false).setType('ev');
  }

  List<double> getMarginWidth() {
    double width = MediaQuery.of(context).copyWith().size.width;
    if (width > 430 && width < 1100) {
      return [width / 4.25, width / 4.25, 0, width / 4.25];
    } else if (width >= 1100) {
      return [width / 4.25, width / 4.25, 0, width / 4.25];
    } else {
      return [40, 40, 25, 50];
    }
  }

  void logout() async {
    String username = Provider.of<User>(context, listen: false).username;
    String token = Provider.of<User>(context, listen: false).token;
    String name = Provider.of<User>(context, listen: false).name;
    String url = Provider.of<User>(context, listen: false).url;

    NetworkHandler nH = NetworkHandler();
    String logoutResponse = (await nH.logout(username, token, name, url));
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('username', null);
    prefs.setString('url', null);

    //Navigator.pushReplacementNamed(context, '/login');
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginPage()));

    if (logoutResponse == 'success') {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    } else {
      print('error logging out');
    }
  }

  void changeRTO() async {
    String username = Provider.of<User>(context, listen: false).username;
    String token = Provider.of<User>(context, listen: false).token;
    String name = Provider.of<User>(context, listen: false).name;
    String url = Provider.of<User>(context, listen: false).url;

    NetworkHandler nH = NetworkHandler();
    String logoutResponse = (await nH.logout(username, token, name, url));
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('iso', null);

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
    if (logoutResponse == 'success') {
      //Navigator.pushReplacementNamed(context, '/login');
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    } else {
      print('error logging out');
    }
  }

  @override
  Widget build(BuildContext context) {
    String iso = Provider.of<User>(context, listen: false).iso;
    String version = Provider.of<User>(context, listen: false).version;
    List margins = [null, null, null, null];

    String token = Provider.of<User>(context).token;
    String name = Provider.of<User>(context).name;
    String username = Provider.of<User>(context).username;
    String url = Provider.of<User>(context).url;

    if (iso != null && version != null) {
      margins = getMarginWidth();
      return Scaffold(
        body: Container(
          margin: EdgeInsets.only(
              right: margins[0],
              left: margins[1],
              top: margins[2],
              //top: 0,
              //bottom: margins[3]
              bottom: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              if (MediaQuery.of(context).copyWith().size.height > 700)
                Expanded(
                  flex: 1,
                  //padding: EdgeInsets.only(top: 30),
                  child: Center(
                    child: Text(
                      iso.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 45,
                      ),
                    ),
                  ),
                ),
              SizedBox(height: 15),
              //Main element on this page
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  ReusableCard(
                    margin: 0,
                    onPress: () {
                      getEVList(token, name, username, url);
                      getEVStatusList(token, name, username, url);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => ListPage()));
                    },
                    colour: kAccentColor,
                    cardChild: Container(
                      padding: EdgeInsets.only(top: 15, bottom: 10),
                      child:
                          IconContent(icon: FontAwesomeIcons.car, label: 'EV'),
                    ),
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
                    colour: kAccentColor,
                    cardChild: Container(
                      padding: EdgeInsets.only(top: 15, bottom: 10),
                      child: IconContent(
                          icon: FontAwesomeIcons.chargingStation,
                          label: 'EVSE'),
                    ),
                    onPress: () {
                      getEVSEList(token, name, username, url);
                      getEVSESwVerList(token, name, username, url);
                      getEVSEStatusList(token, name, username, url);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => ListPage()));
                    },
                  ),
                  Container(
                    padding: EdgeInsets.all(
                      10,
                    ),
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ResourcePage()));
                    },
                    colour: kAccentColor,
                    cardChild: Container(
                      padding: EdgeInsets.only(top: 15, bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            child: IconContent(
                                icon: FontAwesomeIcons.chargingStation,
                                label: 'Peer'),
                          ),
                          Container(width: 30),
                          IconContent(
                              icon: FontAwesomeIcons.car, label: 'Pair'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Container(
                padding: EdgeInsets.only(left: 40, right: 40),
                height: 60,
                child: ReusableCard(
                  margin: 0,
                  colour: Color(0xFFabca46),
                  cardChild: Container(
                    padding: EdgeInsets.all(15),
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Text(
                          'Change RTO',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 25),
                        ),
                      ),
                    ),
                  ),
                  onPress: changeRTO,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 60,
                padding: EdgeInsets.only(left: 50, right: 50),
                child: ReusableCard(
                  margin: 0,
                  colour: Color(0xFFabca46),
                  cardChild: Container(
                    padding: EdgeInsets.all(15),
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Text(
                          'Logout',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 25),
                        ),
                      ),
                    ),
                  ),
                  onPress: logout,
                ),
              ),
              // height > 900
              //     ? SizedBox(
              //         height: 100,
              //       )
              //     : SizedBox(height: 20),
              Expanded(child: SizedBox()),
              Container(
                margin: EdgeInsets.only(bottom: 30),
                child: Center(
                    child: Text(
                  'Version $version',
                  style: kLabelTextStyle,
                )),
              )
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
  }
}
