import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  bool isLoggedIn = false;
  bool rtoChange = false;
  final _storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    autoLogin();
  }

  void autoLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String userId = prefs.getString('username');
    final pass = await _storage.read(key: 'password');
    final String i = prefs.getString('iso');

    if (userId != null && pass != null && i == null) {
      //change RTO
      username = userId;
      password = pass;
      this.setState(() {
        rtoChange = true;
      });

      usernameEntered = true;
      passwordEntered = true;
    }

    if (userId != null && pass != null && i != null) {
      url = i + '.nuvve.com';
      setState(() {
        isLoggedIn = true;
        username = userId;
        password = pass;
        iso = i;
      });

      List temp = await nH.login(username, password, url);
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
  }

  void login() async {
    if (isoEntered) {
      url = iso + '.nuvve.com';
    }

    List temp = await nH.login(username, password, url);
    if (temp == null) {
      //temp is set to null in NH
      setState(() {
        rtoError = true;
      });
      print(rtoError);
    } else if (temp[3] == 'success') {
      setState(() {
        isLoggedIn = true;
      });
      //Set storage
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('username', username);
      await _storage.write(key: 'password', value: password);
      prefs.setString('iso', iso);

      print('Success logging in');
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
        rtoError = false;
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
    if (isLoggedIn) {
      return Scaffold(
          body: Container(child: SpinKitPulse(color: Colors.white, size: 100)));
    } else {
      return Scaffold(
        body: Container(
          padding: EdgeInsets.only(
            top: 70,
            right: 40,
            left: 40,
          ),
          child: SingleChildScrollView(
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
                if (rtoChange)
                  TextField(
                    autocorrect: false,
                    textAlign: TextAlign.center,
                    enabled: false,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: username,
                    ),
                  ),
                if (!rtoChange)
                  TextField(
                    autocorrect: false,
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
                if (rtoChange)
                  TextField(
                    autocorrect: false,
                    enabled: false,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '***********',
                    ),
                  ),
                if (!rtoChange)
                  TextField(
                    autocorrect: false,
                    textAlign: TextAlign.center,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                    ),
                    onChanged: (value) {
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
                  autocorrect: false,
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
                  autocorrect: false,
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
                    'Invalid username or password entered',
                    style: TextStyle(color: Colors.red[500]),
                  ),
                if (rtoError)
                  Text(
                    'Invalid TSO/RTO entered',
                    style: TextStyle(color: Colors.red[500]),
                  ),
              ],
            ),
          ),
        ),
      );
    }
  }
}
