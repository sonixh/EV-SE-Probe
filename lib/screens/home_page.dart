import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:v2g/models/network_handler.dart';
import 'package:v2g/models/user.dart';
import 'package:v2g/widgets/developer.dart';
import 'package:v2g/widgets/reusable_card.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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

      Navigator.pushReplacementNamed(context, '/login');

      if (logoutResponse == 'success') {
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        print('error logging out');
      }
    }

    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(right: 40, left: 40, top: 25, bottom: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 30),
              child: Text(
                'PJM',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 45,
                ),
              ),
            ),
            SizedBox(height: 15),
            DeveloperPage(),
            SizedBox(height: 30),
            Container(
              padding: EdgeInsets.only(left: 40, right: 40),
              child: ReusableCard(
                margin: 0,
                colour: Color(0xFFabca46),
                cardChild: Container(
                  padding: EdgeInsets.all(15),
                  child: Text(
                    'Change RTO',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                onPress: logout,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.only(left: 60, right: 60),
              child: ReusableCard(
                margin: 0,
                colour: Color(0xFFabca46),
                cardChild: Container(
                  padding: EdgeInsets.all(15),
                  child: Text(
                    'Logout',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                onPress: logout,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
