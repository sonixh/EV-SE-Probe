import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:v2g/constants.dart';
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
  int selectItemIndex = -1;
  FocusNode tsoNode = FocusNode();
  FocusNode urlNode = FocusNode();
  List loginInfo = [null, null, null, null];
  bool loggingIn = false;
  bool serverNRError = false;
  bool noInternetError = false;
  String version;

  @override
  void initState() {
    super.initState();
    //try autologging in first
    autoLogin();
  }

  String getRTOName(int index) {
    if (index == 0) {
      return 'pjm';
    } else if (index == 1) {
      return 'caiso';
    } else if (index == 2) {
      return 'denmark';
    } else if (index == 3) {
      return 'france';
    } else if (index == 4) {
      return 'unitedkingdom';
    } else if (index == 5) {
      return 'custom';
    } else {
      return 'pjm';
    }
  }

  void displaySpinner() {
    this.setState(() {
      isoEntered = true;
      iso = 'pjm';
    });
    showModalBottomSheet(
      isDismissible: false,
      context: context,
      builder: (BuildContext builder) {
        return Container(
          color: Color.fromRGBO(5, 27, 27, 60),
          height: MediaQuery.of(context).copyWith().size.height / 2.5,
          child: Container(
            decoration: BoxDecoration(
              color: kBackgroundColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40.0),
                topRight: Radius.circular(40.0),
              ),
            ),
            child: Column(
              children: [
                Container(
                  height: 250,
                  child: CupertinoPicker(
                      itemExtent: 50,
                      onSelectedItemChanged: (int index) {
                        this.setState(() {
                          selectItemIndex = index;
                          //print(selectItemIndex);
                          iso = getRTOName(selectItemIndex);
                          //print(iso);
                        });
                      },
                      children: [
                        Center(
                          child: Text(
                            'PJM',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                        Center(
                          child: Text('CAISO',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20)),
                        ),
                        Center(
                          child: Text('Denmark',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20)),
                        ),
                        Center(
                          child: Text('France',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20)),
                        ),
                        Center(
                          child: Text('United Kingdom',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20)),
                        ),
                        Center(
                          child: Text('Custom',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20)),
                        ),
                      ]),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.green,
                  ),
                  child: FlatButton(
                      onPressed: () {
                        if (passwordEntered &&
                            usernameEntered &&
                            iso != 'custom') {
                          login();
                        }
                        Navigator.pop(context);
                        FocusScope.of(context).requestFocus(urlNode);
                      },
                      child: Text('Done')),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void autoLogin() async {
    //print('here in autologin');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    //print("got prefs");
    final String userId = prefs.getString('username');
    final pass = await _storage.read(key: 'password');
    //print('got password');
    final String i = prefs.getString('iso');
    List temp = [null, null, null, null];

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
      if (i == 'pjm') {
        //print('i is pjm');
        url = i + '.nuvve.com';
      } else if (i == 'caiso') {
        url = i + '.nuvve.com';
      } else if (i == 'denmark') {
        url = 'aggregator.nuvve.dk';
      } else if (i == 'france') {
        url = 'aggregator.nuvve.fr';
      } else if (i == 'unitedkingdom') {
        url = 'aggregator.nuvve.co.uk';
      } else {
        url = i + '.nuvve.com';
      }

      setState(() {
        isLoggedIn = true;
        username = userId;
        password = pass;
        iso = i;
      });
      //print('here right before connectivity');
      var result = await Connectivity().checkConnectivity();
      //  print('got connectivity');
      if (result == ConnectivityResult.none) {
        //print('no internet connection');
        temp[3] = 'NIC';
      } else {
        noInternetError = false;
        //print('here right before login');
        //Send request to API to login
        temp = await nH.login(username, password, url);
        //print('logged in from nH');

        PackageInfo packageInfo = await PackageInfo.fromPlatform();
        //print('got package version');
        setState(() {
          version = packageInfo.version;
        });
      }

      if (loginInfo[3] == 'NIC') {
        setState(() {
          noInternetError = true;
        });
      } else if (temp == null) {
        setState(() {
          rtoError = true;
        });
      } else if (temp[3] == 'success') {
        //print('success from temp[3]');
        //Set all user parameters
        Provider.of<User>(context, listen: false).setName(temp[0]);
        Provider.of<User>(context, listen: false).setToken(temp[1]);
        Provider.of<User>(context, listen: false).setRole(temp[2]);
        Provider.of<User>(context, listen: false).setUsername(username);
        Provider.of<User>(context, listen: false).seturl(url);
        Provider.of<User>(context, listen: false).setIso(iso);
        Provider.of<User>(context, listen: false).setVersion(version);
        //print('pushing home screen');
        Navigator.pushReplacementNamed(context, '/home');
      } else if (temp[3] == 'SNR') {
        //print(temp[3]);
        //print(temp);
        setState(() {
          loginError = true;
        });
      } else {
        //print(temp[3]);
        //print(temp);
        setState(() {
          loginError = true;
        });
      }
    }
  }

  void login() async {
    if (isoEntered && !urlEntered) {
      if (iso == 'pjm') {
        url = iso + '.nuvve.com';
      } else if (iso == 'caiso') {
        url = iso + '.nuvve.com';
      } else if (iso == 'denmark') {
        url = 'aggregator.nuvve.dk';
      } else if (iso == 'france') {
        url = 'aggregator.nuvve.fr';
      } else if (iso == 'unitedkingdom') {
        url = 'aggregator.nuvve.co.uk';
      } else {
        url = iso + '.nuvve.com';
      }
    } else if (urlEntered) {
      //print(url);
      //print(iso);
    }

    setState(() {
      loggingIn = true;
    });

    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      print('no internet connection');
      loginInfo[3] = 'NIC';
    } else {
      noInternetError = false;
      loginInfo = await nH.login(username, password, url);

      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      setState(() {
        version = packageInfo.version;
      });
    }

    setState(() {
      loggingIn = false;
    });

    if (loginInfo[3] == 'NIC') {
      //temp is set to null in NH
      setState(() {
        noInternetError = true;
      });
    } else if (loginInfo[3] == 'SNR') {
      //temp is set to null in NH
      setState(() {
        serverNRError = true;
      });
    } else if (loginInfo == null) {
      setState(() {
        rtoError = true;
      });
    } else if (loginInfo[3] == 'success') {
      setState(() {
        print('got successfull response from server');
        isLoggedIn = true;
      });
      //Set storage
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('username', username);
      await _storage.write(key: 'password', value: password);
      prefs.setString('iso', iso);

      print('Success logging in');
      Provider.of<User>(context, listen: false).setName(loginInfo[0]);
      Provider.of<User>(context, listen: false).setToken(loginInfo[1]);
      Provider.of<User>(context, listen: false).setRole(loginInfo[2]);
      Provider.of<User>(context, listen: false).setUsername(username);
      Provider.of<User>(context, listen: false).setIso(iso);
      Provider.of<User>(context, listen: false).seturl(url);
      Provider.of<User>(context, listen: false).setVersion(version);

      Navigator.pushReplacementNamed(context, '/home');
    } else {
      print(loginInfo[3]);
      setState(() {
        loginError = true;
        rtoError = false;
        serverNRError = false;
      });
    }
  }

  bool determineDisabled() {
    if (usernameEntered &&
        passwordEntered &&
        ((isoEntered && iso != 'custom') || (isoEntered && urlEntered))) {
      return true;
    }
    return false;
  }

  bool determineDisabledNameField() {
    if (iso != 'custom') {
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

  double getMarginWidth() {
    double width = MediaQuery.of(context).copyWith().size.width;
    if (width > 430) {
      return width / 4.25;
    } else {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoggedIn) {
      return Scaffold(
          body: Container(child: SpinKitPulse(color: Colors.white, size: 100)));
    } else {
      getMarginWidth();
      return Scaffold(
        body: Container(
          margin:
              EdgeInsets.only(left: getMarginWidth(), right: getMarginWidth()),
          padding: EdgeInsets.only(
            top: 70,
            right: 40,
            left: 40,
          ),
          child: SingleChildScrollView(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'EV/SE Probe',
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
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => FocusScope.of(context).unfocus(),
                      textAlign: TextAlign.left,
                      enabled: false,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: username,
                      ),
                    ),
                  if (!rtoChange)
                    TextField(
                      autocorrect: false,
                      textInputAction: TextInputAction.next,
                      onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                      textAlign: TextAlign.left,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Username',
                      ),
                      onTap: () {
                        setState(() {
                          loginError = false;

                          rtoError = false;
                          serverNRError = false;
                        });
                      },
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
                      textAlign: TextAlign.left,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: '***********',
                      ),
                    ),
                  if (!rtoChange)
                    TextField(
                      textInputAction: TextInputAction.next,
                      onSubmitted: (_) {
                        displaySpinner();
                        FocusScope.of(context).requestFocus(tsoNode);
                      },
                      autocorrect: false,
                      textAlign: TextAlign.left,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                      ),
                      onTap: () {
                        setState(() {
                          loginError = false;
                          rtoError = false;
                          serverNRError = false;
                        });
                      },
                      onChanged: (value) {
                        password = value;
                        setState(() {
                          loginError = false;
                          passwordEntered = true;
                        });
                      },
                    ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                  ),
                  TextField(
                    focusNode: tsoNode,
                    autocorrect: false,
                    controller: TextEditingController(
                        text: iso != null ? iso.toUpperCase() : ''),
                    //enabled: !determineDisabledURLField(),
                    textInputAction: TextInputAction.done,
                    textAlign: TextAlign.left,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'TSO/RTO',
                    ),
                    readOnly: true,
                    onTap: () {
                      displaySpinner();
                      loginError = false;
                      rtoError = false;
                      serverNRError = false;
                      setState(() {
                        urlEntered = false;
                      });
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
                    focusNode: urlNode,
                    autocorrect: false,
                    enabled: !determineDisabledNameField(),
                    textAlign: TextAlign.left,
                    onTap: () {
                      setState(() {
                        loginError = false;
                        rtoError = false;
                        serverNRError = false;
                      });
                    },
                    onSubmitted: (_) => {login()},
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
                  if (loggingIn == true)
                    SpinKitPulse(
                      color: Colors.green,
                      size: 50,
                      duration: Duration(seconds: 1),
                    ),
                  if (loggingIn == false)
                    Container(
                      child: FlatButton(
                        padding: EdgeInsets.all(15),
                        disabledColor: kBackgroundColor,
                        color: Colors.green,
                        child: Text(
                          'Login',
                          style: TextStyle(fontSize: 22),
                        ),
                        onPressed: !determineDisabled() ? null : login,
                      ),
                    ),
                  SizedBox(height: 10),
                  //Begin Error Messages
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
                  if (serverNRError)
                    Text(
                      'Server not responding with URL: "https://$url"',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.red[500]),
                    ),
                  if (noInternetError)
                    Text(
                      'No internet connection',
                      style: TextStyle(color: Colors.red[500]),
                    ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }
}
