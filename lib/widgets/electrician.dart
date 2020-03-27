import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:v2g/screens/list_page.dart';
import '../constants.dart';
import 'icon_content.dart';

class ElectricianPage extends StatelessWidget {
  const ElectricianPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void makeListPage() {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => ListPage()));
    }

    return GestureDetector(
      child: Container(
        color: kAccentColor,
        padding: EdgeInsets.only(top: 15, bottom: 15),
        child: IconContent(
            icon: FontAwesomeIcons.chargingStation, label: 'EVSE List'),
      ),
      onTap: makeListPage,
    );
  }
}
