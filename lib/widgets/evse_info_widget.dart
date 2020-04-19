import 'package:flutter/material.dart';
import 'package:v2g/models/evse.dart';
import '../constants.dart';

class EVSEInfoWidget extends StatelessWidget {
  EVSEInfoWidget({@required this.future});
  final EVSE future;

  @override
  Widget build(BuildContext context) {
    //prints out 'instance of EVSE'
    //print(future);
    return Container(
      padding: EdgeInsets.only(top: 20, bottom: 30, left: 30, right: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (future.address != '')
            Container(
              child: RichText(
                text: TextSpan(
                  style: kLabelTextStyle,
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Address ',
                      style: kLabelTextStyle,
                    ),
                    TextSpan(
                      text: '${future.address}',
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
                    text: 'Latitude, Longitude ',
                    style: kLabelTextStyle,
                  ),
                  TextSpan(
                    text: '${future.latitude}, ${future.longitude}',
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
                    text: 'RTO/Utility ',
                    style: kLabelTextStyle,
                  ),
                  TextSpan(
                    text: '${future.iso}/${future.utility}',
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
                    text: 'Manufacturer,Model ',
                    style: kLabelTextStyle,
                  ),
                  TextSpan(
                    text: '${future.manufacturer},${future.model}',
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
                    text: 'Meter Type ',
                    style: kLabelTextStyle,
                  ),
                  TextSpan(
                    text: '${future.meterType}',
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
                    text: 'Connector ',
                    style: kLabelTextStyle,
                  ),
                  TextSpan(
                    text: '${future.connector}',
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
                    text: 'Protocol ',
                    style: kLabelTextStyle,
                  ),
                  TextSpan(
                    text: '${future.protocols}',
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
                    text: 'Hardware Version ',
                    style: kLabelTextStyle,
                  ),
                  TextSpan(
                    text: '${future.hardwareVersion}',
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
                    text: 'Part Number ',
                    style: kLabelTextStyle,
                  ),
                  TextSpan(
                    text: '${future.partNumber}',
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
                    text: 'Vel Version ',
                    style: kLabelTextStyle,
                  ),
                  TextSpan(
                    text: '${future.velVersion}',
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
                    text: 'Nominal Voltage, Phase ',
                    style: kLabelTextStyle,
                  ),
                  TextSpan(
                    text: '${future.nominalVoltage} V, ${future.phase} ɸ',
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
                    text: 'Max Charge ',
                    style: kLabelTextStyle,
                  ),
                  TextSpan(
                    text: '${future.maxc} A',
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
                    text: 'Max Discharge ',
                    style: kLabelTextStyle,
                  ),
                  TextSpan(
                    text: '${future.maxd} A',
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
                    text: 'Reverse Feeding Permitted ',
                    style: kLabelTextStyle,
                  ),
                  TextSpan(
                    text: '${future.reverse}',
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
                    text: 'RCD ',
                    style: kLabelTextStyle,
                  ),
                  TextSpan(
                    text: '${future.rcd}',
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
                    text: 'Meter Version ',
                    style: kLabelTextStyle,
                  ),
                  TextSpan(
                    text: '${future.meterVersion}',
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
