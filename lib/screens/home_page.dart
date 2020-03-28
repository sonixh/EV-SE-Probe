import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:v2g/models/network_handler.dart';
import 'package:v2g/models/user.dart';
import 'package:v2g/widgets/developer.dart';
import 'package:v2g/widgets/electrician.dart';
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

      Navigator.pushReplacementNamed(context, '/login');

      if (logoutResponse == 'success') {
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        print('error logging out');
      }
    }

    String role = Provider.of<User>(context).role;

    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(right: 60, left: 60, top: 50, bottom: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 30),
              child: Text(
                'PJM',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 60,
                ),
              ),
            ),
            SizedBox(height: 20),
            if (role == 'electrician') ElectricianPage(),
            if (role == 'developer') DeveloperPage(),
            SizedBox(height: 50),
            Container(
              padding: EdgeInsets.only(left: 60, right: 60),
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
