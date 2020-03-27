//Test

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:v2g/screens/home_page.dart';
import 'package:v2g/screens/login_page.dart';
import 'constants.dart';
import 'models/user.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return ChangeNotifierProvider(
      create: (context) => User(null, null, null, null, null, null, null),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          primaryColor: kBackgroundColor,
          scaffoldBackgroundColor: kBackgroundColor,
        ),
        home: LoginPage(),
        routes: {
          '/login': (_) => LoginPage(),
          '/home': (_) => HomePage(),
        },
      ),
    );
  }
}
