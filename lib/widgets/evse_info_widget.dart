import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:v2g/models/evse.dart';
import 'package:v2g/models/evse_swver.dart';
import '../constants.dart';

class EVSEInfoWidget extends StatelessWidget {
  final EVSE future;
  final EVSESwVer evseSwVer;
  EVSEInfoWidget({@required this.future, @required this.evseSwVer});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20, bottom: 30, left: 30, right: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (future.address != '')
            FittedBox(
              fit: BoxFit.fitWidth,
              child: Container(
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
            ),
          FittedBox(
            fit: BoxFit.fitWidth,
            child: Container(
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
          ),
          Container(
            child: AutoSizeText.rich(
              TextSpan(
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
              minFontSize: 8,
              maxLines: 1,
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
                  if (future.reverse == '1')
                    TextSpan(
                      text: 'True',
                      style: kLargeLabelTextStyle,
                    ),
                  if (future.reverse == '0')
                    TextSpan(
                      text: 'False',
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
          SizedBox(height: 20),
          Container(
            child: RichText(
              text: TextSpan(
                style: kLabelTextStyle,
                children: <TextSpan>[
                  TextSpan(
                    text: 'Agent Version ',
                    style: kLabelTextStyle,
                  ),
                  TextSpan(
                    text: evseSwVer.agentRevision,
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
                    text: 'VEL Version ',
                    style: kLabelTextStyle,
                  ),
                  TextSpan(
                    text: evseSwVer.velRevision,
                    style: kLargeLabelTextStyle,
                  ),
                ],
              ),
            ),
          ),
          if (evseSwVer.rCDVersion != null)
            Container(
              child: RichText(
                text: TextSpan(
                  style: kLabelTextStyle,
                  children: <TextSpan>[
                    TextSpan(
                      text: 'RCD Version ',
                      style: kLabelTextStyle,
                    ),
                    TextSpan(
                      text: evseSwVer.rCDVersion,
                      style: kLargeLabelTextStyle,
                    ),
                  ],
                ),
              ),
            ),
          if (evseSwVer.meterVersion != null)
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
                      text: evseSwVer.meterVersion,
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
