import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:v2g/models/info/ev.dart';
import 'info/evse.dart';
import 'status/ev_status.dart';
import 'status/evse_status.dart';
import 'info/evse_swver.dart';
import 'status/meter_status.dart';

class NetworkHandler<T> {
  NetworkHandler({this.type});
  final T type;

  Future<List> login(String username, String password, String url) async {
    try {
      final response = await http
          .get('https://$url/api/auth?user=$username&password=$password');

      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['status'] == 'success') {
          String token = jsonDecode(response.body)['token'];
          String name = jsonDecode(response.body)['name'];
          String role;
          try {
            role = jsonDecode(response.body)['roles'][0];
          } catch (e) {
            print('role string warning: no role set for user');
            role = 'none';
          }

          String status = jsonDecode(response.body)['status'];
          return [name, token, role, status];
        } else {
          return [null, null, null, jsonDecode(response.body)['__errors__']];
        }
      } else {
        throw Exception('Failed to login');
      }
    } catch (e) {
      print('$e Server not responding');
      return [null, null, null, 'SNR'];
    }
  }

  Future logout(String username, String token, String name, String url) async {
    final response = await http
        .get('https://$url/api/logout?user=$username&name=$name&token=$token');

    if (response.statusCode == 200) {
      String status;
      status = jsonDecode(response.body)['status'];
      return status;
    } else {
      throw Exception('Failed to logout');
    }
  }

  // static Future<List> startCharge(
  //     {String url,
  //     String username,
  //     String name,
  //     String token,
  //     String vin,
  //     String miles}) async {
  //   final String longUrl =
  //       'https://$url/api/emergency_charging/get_info?user=$username&name=$name&token=$token&vin=$vin&miles=8&entries=25';
  //   final response = await http.get(longUrl);
  //   int timeNeeded = 5;

  //   if (response.statusCode == 200) {
  //     try {
  //       List chargeTable = jsonDecode(response.body)['charge_table'];

  //       print(chargeTable);
  //       for (int i = 0; i < chargeTable.length; i++) {
  //         if (chargeTable[i][2] == '05' ||
  //             chargeTable[i][2] == '06' ||
  //             chargeTable[i][2] == '04' ||
  //             chargeTable[i][2] == '03' ||
  //             chargeTable[i][2] == '07') {
  //           final String longUrl1 =
  //               'https://$url/api/emergency_charging/get_info?user=$username&name=$name&token=$token&vin=$vin&miles=${chargeTable[i][0]}';
  //           final response1 = await http.get(longUrl1);
  //           print(
  //               'Starting charge: "${jsonDecode(response1.body)['message']}"-----Errors: ${jsonDecode(response1.body)['__errors__']}');
  //           try {
  //             timeNeeded = int.parse(jsonDecode(response1.body)['time_needed']);
  //           } catch (e) {
  //             timeNeeded = 5;
  //           }
  //           print(jsonDecode(response1.body));
  //           return [
  //             timeNeeded,
  //             jsonDecode(response1.body)['__errors__'].toString()
  //           ];
  //         }
  //       }
  //     } catch (e) {
  //       print(e);
  //     }
  //   } else {
  //     print('Bad response code');
  //     return ['Bad response'];
  //   }
  // }

  // static cancelCharge(
  //     {String url,
  //     String username,
  //     String name,
  //     String token,
  //     String vin}) async {
  //   final String longUrl =
  //       'https://$url/api/emergency_charging/cancel?user=$username&name=$name&token=$token&vin=$vin';
  //   final response = await http.get(longUrl);
  //   if (response.statusCode == 200) {
  //     print(
  //         'Cancelling charge: ${jsonDecode(response.body)['message']}: ${jsonDecode(response.body)['__errors__']}');
  //   } else {
  //     print('Bad response code');
  //   }
  // }

  static Future fetchMeterStatus(
      {String token,
      String username,
      String name,
      String url,
      String meterId}) async {
    String poplulatedUrl =
        'https://$url/api/get_status?user=$username&name=$name&token=$token&meter=$meterId';
    final response = await http.get(poplulatedUrl);
    if (response.statusCode == 200) {
      try {
        return MeterStatus.fromJson(
            (json.decode(response.body)['meters_log'])[0]);
      } catch (e) {
        print('here in fetch meter status in nH: $e');
        return MeterStatus(
          meterId: 'null',
        );
      }
    }
  }

  Future fetchEVStatus(String url, String dataUrl) async {
    final response = await http.get(url);
    final dataResponse = await http.get(dataUrl);
    if (response.statusCode == 200 && dataResponse.statusCode == 200) {
      if (jsonDecode(response.body)['status'] == 'success' &&
          jsonDecode(dataResponse.body)['status'] == 'success') {
        try {
          return EVStatus.fromTwoJson(
              (json.decode(response.body)['cars_log'])[0],
              (json.decode(dataResponse.body)['data'])[0]);
        } catch (e) {
          print('here in EV Status and Data in NH: $e');
          return EVStatus(
            name: 'null',
            evseName: 'null',
            peerConnected: 'null',
            soc: 'null',
            primaryStatus: 'null',
            tCellAvg: '0',
            tCellMax: '0',
            tCellMin: '0',
          );
        }
      }
    }
  }

  Future fetchList(String url) async {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      if (jsonDecode(response.body)['status'] == 'success') {
        if (type == EVSE) {
          return (json.decode(response.body)['evses_info'] as List)
              .map((i) => EVSE.fromJson(i))
              .toList();
        } else if (type == EVSEStatus) {
          try {
            //print(json.decode(response.body)['evses_log']);
            return (json.decode(response.body)['evses_log'] as List)
                .map((i) => EVSEStatus.fromJson(i))
                .toList();
          } catch (e) {
            print(e);
          }
        } else if (type == EVStatus) {
          try {
            return (json.decode(response.body)['cars_log'] as List)
                .map((i) => EVStatus.fromJson(i))
                .toList();
          } catch (e) {
            print(e);
          }
        } else if (type == EVSESwVer) {
          try {
            return (json.decode(response.body)['config_info'] as List)
                .map((i) => EVSESwVer.fromJson(i))
                .toList();
          } catch (e) {
            print(e);
          }
        } else {
          return (json.decode(response.body)['cars_info'] as List)
              .map((i) => EV.fromJson(i))
              .toList();
        }
      } else {
        throw Exception('Failed: ${jsonDecode(response.body)['status']}');
      }
    }
    throw Exception('Failed to get a successful response');
  }

  Future fetch(String url) async {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      if (jsonDecode(response.body)['status'] == 'success') {
        if (type == EV) {
          try {
            return EV.fromJson((json.decode(response.body)['cars_info'])[0]);
          } catch (e) {
            print(e);
            return EV(
              id: 'null',
              make: 'null',
              model: 'null',
              year: 'null',
              defaultIso: 'null',
              name: 'null',
              minRange: 'null',
              maxRange: 'null',
            );
          }
        } else if (type == EVSEStatus) {
          //print((json.decode(response.body)['evses_log']));
          try {
            return EVSEStatus.fromJson(
                (json.decode(response.body)['evses_log'])[0]);
          } catch (e) {
            print('here in EVSEStatus in nH: $e');
            return EVSEStatus(
              name: 'null',
              status: 'null',
              timestamp: 'null',
              energyNet: 'null',
              realPower: 'null',
            );
          }
        } else if (type == EVStatus) {
          //print((json.decode(response.body)['cars_log']));
          try {
            return EVStatus.fromJson(
                (json.decode(response.body)['cars_log'])[0]);
          } catch (e) {
            print('here in EVStatus in NH: $e');
            return EVStatus(
              name: 'null',
              evseName: 'null',
              peerConnected: 'null',
              soc: 'null',
              primaryStatus: 'null',
            );
          }
        } else {
          try {
            return EVSE.fromJson((json.decode(response.body)['evses_info'])[0]);
          } catch (e) {
            print(e);
          }
        }
      } else {
        throw Exception(jsonDecode(response.body)['__errors__']);
      }
    } else {
      throw Exception('Failed to get data');
    }
  }
}
