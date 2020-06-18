import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:v2g/models/network_handler.dart';
import 'package:v2g/models/user.dart';
import 'package:v2g/widgets/ev_evse_resource_buttons.dart';
import 'package:v2g/widgets/reusable_card.dart';
import '../constants.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
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

    String iso = Provider.of<User>(context, listen: false).iso;
    String version = Provider.of<User>(context, listen: false).version;
    List margins = [null, null, null, null];

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
              EVEVSEResourceButtons(),
              ////////////////////////
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
