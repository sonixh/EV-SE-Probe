import 'package:flutter/material.dart';
import 'package:v2g/models/network_handler.dart';
import 'package:v2g/models/user.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String username;
  String password;
  String iso;
  String url;
  bool passwordEntered = false;
  bool usernameEntered = false;
  bool isoEntered = false;
  bool urlEntered = false;
  bool loginError = false;
  bool rtoError = false;
  NetworkHandler nH = new NetworkHandler();

  void login() async {
    List temp = [];
    if (isoEntered) {
      url = iso + '.nuvve.com';
    }
    temp = await nH.login(username, password, url);
    if (temp == null) {
      setState(() {
        rtoError = true;
      });
    } else if (temp[3] == 'success') {
      Provider.of<User>(context, listen: false).setName(temp[0]);
      Provider.of<User>(context, listen: false).setToken(temp[1]);
      Provider.of<User>(context, listen: false).setRole(temp[2]);
      Provider.of<User>(context, listen: false).setUsername(username);
      Provider.of<User>(context, listen: false).seturl(url);
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      print(temp[3]);
      setState(() {
        loginError = true;
      });
    }
  }

  bool determineDisabled() {
    if (usernameEntered && passwordEntered && (isoEntered || urlEntered)) {
      return true;
    }
    return false;
  }

  bool determineDisabledNameField() {
    if (isoEntered) {
      return true;
    }
    return false;
  }

  bool determineDisabledURLField() {
    if (urlEntered) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(
          top: 70,
          right: 40,
          left: 40,
        ),
        child: Column(
          children: <Widget>[
            Text(
              'V2G',
              style: TextStyle(
                fontSize: 30,
              ),
            ),
            SizedBox(
              height: 40,
            ),
            TextField(
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Username',
              ),
              onChanged: (value) {
                username = value;
                setState(() {
                  usernameEntered = true;
                });
              },
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10),
            ),
            TextField(
              textAlign: TextAlign.center,
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
              onChanged: (value) {
                //TODO: secure
                password = value;
                setState(() {
                  passwordEntered = true;
                });
              },
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10),
            ),
            TextField(
              enabled: !determineDisabledURLField(),
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'TSO/RTO',
              ),
              onChanged: (value) {
                iso = value;
                if (value == '') {
                  setState(() {
                    isoEntered = false;
                  });
                } else {
                  setState(() {
                    isoEntered = true;
                  });
                }
              },
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10),
            ),
            Text('OR'),
            Padding(
              padding: EdgeInsets.only(bottom: 10),
            ),
            TextField(
              enabled: !determineDisabledNameField(),
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'URL',
              ),
              onChanged: (value) {
                url = value;
                if (value == '') {
                  setState(() {
                    urlEntered = false;
                  });
                } else {
                  setState(() {
                    urlEntered = true;
                  });
                }
              },
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10),
            ),
            FlatButton(
              child: Text('Login'),
              onPressed: !determineDisabled() ? null : login,
            ),
            if (loginError)
              Text(
                'Invalid username or password',
                style: TextStyle(color: Colors.red[500]),
              ),
            if (rtoError)
              Text(
                'Invalid TSO/RTO Entered',
                style: TextStyle(color: Colors.red[500]),
              ),
          ],
        ),
      ),
    );
  }
}
