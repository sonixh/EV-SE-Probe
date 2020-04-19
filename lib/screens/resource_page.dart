import 'package:flutter/material.dart';
import 'package:v2g/widgets/resource_list.dart';

class ResourcePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Column(
          children: <Widget>[
            Text('Resource List'),
          ],
        ),
      ),
      body: ResourceList(),
    );
  }
}
