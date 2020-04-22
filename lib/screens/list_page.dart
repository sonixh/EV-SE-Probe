import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:v2g/models/user.dart';
import 'package:v2g/widgets/ev_evse_lists.dart';

class ListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String type = ' ';
    type = Provider.of<User>(context).type;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Column(
          children: <Widget>[
            if (type != null) Text('${type.toUpperCase()} List'),
          ],
        ),
      ),
      body: EVEVSELists(),
    );
  }
}
