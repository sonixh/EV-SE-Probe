import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:v2g/models/user.dart';
import 'package:v2g/screens/single_item_page.dart';
import '../constants.dart';

class EVEVSELists extends StatefulWidget {
  @override
  _EVEVSEListsState createState() => _EVEVSEListsState();
}

class _EVEVSEListsState extends State<EVEVSELists> {
  String userInputValue = '';
  List sortedList;
  List sortedConnected;
  int index;
  bool refreshing = true;

  double getMarginWidth() {
    double width = MediaQuery.of(context).copyWith().size.width;
    if (width > 430) {
      return width / 6.25;
    } else {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    List evseStatusList = Provider.of<User>(context).evseStatusList;
    List evStatusList = Provider.of<User>(context).evStatusList;
    String type = Provider.of<User>(context).type;

    if (type == 'ev') {
      sortedList = evStatusList;
      sortedConnected = evStatusList;
    } else {
      sortedList = evseStatusList;
      sortedConnected = evseStatusList;
    }

    if (sortedList != null) {
      if (type == 'evse') {
        sortedConnected.sort((b, a) => b.status.compareTo(a.status));
        sortedList = sortedConnected;
      }

      sortedList.sort((a, b) => b.peerConnected.compareTo(a.peerConnected));

      //User search implementation
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

    if (refreshing == true) {
      this.setState(() {
        refreshing = false;
      });
      return Center(
        child: SpinKitPulse(
          color: Colors.white,
          size: 100,
          duration: Duration(seconds: 1),
        ),
      );
    } else if (sortedList != null && refreshing == false) {
      return Container(
        margin:
            EdgeInsets.only(left: getMarginWidth(), right: getMarginWidth()),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 0, bottom: 5, left: 20, right: 20),
              child: TextField(
                autocorrect: false,
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
            if (sortedList.length != 0)
              Expanded(
                child: Container(
                  padding:
                      EdgeInsets.only(top: 0, left: 5, right: 5, bottom: 0),
                  child: ListView.builder(
                    itemCount: sortedList.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          if (sortedList[index].peerConnected == 'true')
                            ConnectedItem(sortedList: sortedList, index: index),
                          if (type == 'evse')
                            if (sortedList[index].peerConnected == 'false' &&
                                sortedList[index].status == 'Connected')
                              NotConnectedItem(
                                  sortedList: sortedList, index: index),
                          if (type == 'ev')
                            if (sortedList[index].peerConnected == 'false')
                              NotConnectedItem(
                                  sortedList: sortedList, index: index),
                          if (type == 'evse')
                            if (sortedList[index].status == 'NotConnected')
                              NotConnectedandOfflineItem(
                                  sortedList: sortedList, index: index),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            if (sortedList.length == 0)
              Center(
                child: Text(
                  'Nothing to display for this user',
                  style: TextStyle(fontSize: 22),
                ),
              )
          ],
        ),
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

class ConnectedItem extends StatelessWidget {
  const ConnectedItem({
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

class NotConnectedItem extends StatelessWidget {
  const NotConnectedItem({
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

class NotConnectedandOfflineItem extends StatelessWidget {
  const NotConnectedandOfflineItem({
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
        color: Colors.black12,
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
