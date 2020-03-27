import 'package:flutter/material.dart';
import 'package:v2g/models/ev.dart';
import '../constants.dart';

class EVInfoWidget extends StatelessWidget {
  EVInfoWidget({@required this.future});
  final DetailedEV future;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20, bottom: 30, left: 30, right: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: RichText(
              text: TextSpan(
                style: kLabelTextStyle,
                children: <TextSpan>[
                  TextSpan(
                    text: 'VIN ',
                    style: kLabelTextStyle,
                  ),
                  TextSpan(
                    text: '${future.id}',
                    style: kLargeLabelTextStyle,
                  ),
                ],
              ),
            ),
          ),
          Container(
            child: RichText(
              text: TextSpan(
                style: kLabelTextStyle,
                children: <TextSpan>[
                  TextSpan(
                    text: 'Make ',
                    style: kLabelTextStyle,
                  ),
                  TextSpan(
                    text: '${future.make}',
                    style: kLargeLabelTextStyle,
                  ),
                ],
              ),
            ),
          ),
          Container(
            child: RichText(
              text: TextSpan(
                style: kLabelTextStyle,
                children: <TextSpan>[
                  TextSpan(
                    text: 'Model ',
                    style: kLabelTextStyle,
                  ),
                  TextSpan(
                    text: '${future.model}',
                    style: kLargeLabelTextStyle,
                  ),
                ],
              ),
            ),
          ),
          Container(
            child: RichText(
              text: TextSpan(
                style: kLabelTextStyle,
                children: <TextSpan>[
                  TextSpan(
                    text: 'Year ',
                    style: kLabelTextStyle,
                  ),
                  TextSpan(
                    text: '${future.year} V',
                    style: kLargeLabelTextStyle,
                  ),
                ],
              ),
            ),
          ),
          Container(
            child: RichText(
              text: TextSpan(
                style: kLabelTextStyle,
                children: <TextSpan>[
                  TextSpan(
                    text: 'Default ISO ',
                    style: kLabelTextStyle,
                  ),
                  TextSpan(
                    text: '${future.defaultIso}',
                    style: kLargeLabelTextStyle,
                  ),
                ],
              ),
            ),
          ),
          Container(
            child: RichText(
              text: TextSpan(
                style: kLabelTextStyle,
                children: <TextSpan>[
                  TextSpan(
                    text: 'Min Range ',
                    style: kLabelTextStyle,
                  ),
                  TextSpan(
                    text: '${future.minRange}',
                    style: kLargeLabelTextStyle,
                  ),
                ],
              ),
            ),
          ),
          Container(
            child: RichText(
              text: TextSpan(
                style: kLabelTextStyle,
                children: <TextSpan>[
                  TextSpan(
                    text: 'Max Range ',
                    style: kLabelTextStyle,
                  ),
                  TextSpan(
                    text: '${future.maxRange}',
                    style: kLargeLabelTextStyle,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
