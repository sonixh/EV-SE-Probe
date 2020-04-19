import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:v2g/models/user.dart';
import 'package:v2g/screens/single_item_page.dart';

import '../constants.dart';

class MultipleAPIDataWidget extends StatefulWidget {
  @override
  _MultipleAPIDataWidgetState createState() => _MultipleAPIDataWidgetState();
}

class _MultipleAPIDataWidgetState extends State<MultipleAPIDataWidget> {
  String userInputValue = '';
  List sortedList;
  int index;
  @override
  Widget build(BuildContext context) {
    List evseStatusList = Provider.of<User>(context).evseStatusList;
    List evStatusList = Provider.of<User>(context).evStatusList;
    String type = Provider.of<User>(context).type;

    if (type == 'ev') {
      sortedList = evStatusList;
    } else {
      sortedList = evseStatusList;
    }

    if (sortedList != null) {
      sortedList.sort((a, b) => b.peerConnected.compareTo(a.peerConnected));

      sortedList = sortedList
          .where((object) =>
              (object.id
                  .toLowerCase()
                  .contains(userInputValue.toLowerCase())) ||
              (object.name
                  .toLowerCase()
                  .contains(userInputValue.toLowerCase())))
          .toList();
    }

    if (sortedList != null) {
      return Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 0, bottom: 5, left: 20, right: 20),
            child: TextField(
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                labelText: 'Search',
              ),
              onChanged: (value) {
                setState(
                  () {
                    userInputValue = value;
                  },
                );
              },
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(top: 0, left: 5, right: 5, bottom: 0),
              child: ListView.builder(
                itemCount: sortedList.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      if (sortedList[index].peerConnected == 'true')
                        Connected(sortedList: sortedList, index: index),
                      if (sortedList[index].peerConnected == 'false')
                        NotConnected(sortedList: sortedList, index: index),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      );
    } else {
      return Center(
        child: SpinKitPulse(
          color: Colors.white,
          size: 100,
        ),
      );
    }
  }
}

class Connected extends StatelessWidget {
  const Connected({
    Key key,
    @required this.sortedList,
    @required this.index,
  }) : super(key: key);

  final List sortedList;
  final int index;

  @override
  Widget build(BuildContext context) {
    String type = Provider.of<User>(context).type;

    BoxDecoration box = new BoxDecoration(
      color: kAccentColor,
      border: Border.all(
        width: 2,
        color: Colors.white,
      ),
    );

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SingleItemPage(iD: sortedList[index].id),
          ),
        );
      },
      child: Container(
        decoration: box,
        margin: EdgeInsets.only(
          left: 7,
          right: 7,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            RichText(
              text: TextSpan(
                style: kLabelTextStyle,
                children: <TextSpan>[
                  TextSpan(
                    text: '${sortedList[index].name}   ',
                    style: nameTextStyle,
                  ),
                  if (type == 'ev')
                    TextSpan(
                      text: 'VIN: ${sortedList[index].id}',
                      style: kLabelTextStyle,
                    ),
                  if (type == 'evse')
                    TextSpan(
                      text: 'ID: ${sortedList[index].id}',
                      style: kLabelTextStyle,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NotConnected extends StatelessWidget {
  const NotConnected({
    Key key,
    @required this.sortedList,
    @required this.index,
  }) : super(key: key);

  final List sortedList;
  final int index;

  @override
  Widget build(BuildContext context) {
    String type = Provider.of<User>(context).type;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SingleItemPage(iD: sortedList[index].id),
          ),
        );
      },
      child: Container(
        color: Colors.grey,
        margin: EdgeInsets.only(
          left: 7,
          right: 7,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            RichText(
              text: TextSpan(
                style: kLabelTextStyle,
                children: <TextSpan>[
                  TextSpan(
                    text: '${sortedList[index].name}   ',
                    style: nameTextStyle,
                  ),
                  if (type == 'ev')
                    TextSpan(
                      text: 'VIN: ${sortedList[index].id}',
                      style: kLabelTextStyle,
                    ),
                  if (type == 'evse')
                    TextSpan(
                      text: 'ID: ${sortedList[index].id}',
                      style: kLabelTextStyle,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
