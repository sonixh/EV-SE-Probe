import '../network_handler.dart';

class EVStatus {
  final String name;
  final String evseName;
  final String peerConnected;
  final String soc;
  final String socKwh;
  final String primaryStatus;
  final String vin;
  final String id;
  final String secondaryStatus;
  //final String tAmbient;
  final String tCellAvg;
  final String tCellMin;
  final String tCellMax;
  final String powerFlow;
  final String powerCapacityUp;
  final String powerCapacityDown;

  EVStatus({
    this.name,
    this.evseName,
    this.peerConnected,
    this.soc,
    this.primaryStatus,
    this.vin,
    this.id,
    this.secondaryStatus,
    //this.tAmbient,
    this.tCellAvg,
    this.tCellMin,
    this.tCellMax,
    this.powerFlow,
    this.socKwh,
    this.powerCapacityDown,
    this.powerCapacityUp,
  });

  factory EVStatus.fromTwoJson(
      Map<String, dynamic> evStatusJson, Map<String, dynamic> evDataJson) {
    return EVStatus(
      name: evStatusJson['car_name'],
      evseName: evStatusJson['evse_name'],
      peerConnected: evStatusJson['peer_connected'],
      soc: evStatusJson['soc'],
      socKwh: evStatusJson['soc_kwh'],
      primaryStatus: evStatusJson['primary_status'],
      powerFlow: evStatusJson['power_flow'],
      vin: evStatusJson['vin'],
      id: evStatusJson['vin'],
      secondaryStatus: evStatusJson['secondary_status'],
      //tAmbient: evDataJson['t_ambient'],
      tCellAvg: evDataJson['t_cell_avg'],
      tCellMax: evDataJson['t_cell_max'],
      tCellMin: evDataJson['t_cell_min'],
      powerCapacityDown: evStatusJson['power_capacity_down'],
      powerCapacityUp: evStatusJson['power_capacity_up'],
    );
  }

  factory EVStatus.fromJson(Map<String, dynamic> evStatusJson) {
    return EVStatus(
      name: evStatusJson['car_name'],
      evseName: evStatusJson['evse_name'],
      peerConnected: evStatusJson['peer_connected'],
      soc: evStatusJson['soc'],
      primaryStatus: evStatusJson['primary_status'],
      vin: evStatusJson['vin'],
      id: evStatusJson['vin'],
      secondaryStatus: evStatusJson['secondary_status'],
    );
  }

  String _parseTemp() {
    try {
      return '${double.parse(tCellMin).truncate().toString()}, ${double.parse(tCellAvg).truncate().toString()}, ${double.parse(tCellMax).truncate().toString()}';
    } catch (e) {
      return 'null';
    }
  }

  String _parseSoc() {
    try {
      return '${double.parse(soc).truncate().toString()}% / $socKwh kWh';
    } catch (e) {
      return '0.00';
    }
  }

  Map<String, String> get map {
    return {
      'EV Name ': name,
      'VIN ': vin,
      'Peer Connected ': peerConnected,
      'Primary Status ': primaryStatus,
      'Secondary Status ': secondaryStatus,
      'Power Flow (kW) ': powerFlow,
      'Power Cap. Up/Down (kW) ': '$powerCapacityUp / $powerCapacityDown',
      'State of Charge ': _parseSoc(),
      'Bat Module °C (min,avg,max) ': _parseTemp(),
    };
  }

  Future<EVStatus> fetchEVStatus(
      {String username,
      String name,
      String vin,
      String token,
      String url}) async {
    NetworkHandler nH = new NetworkHandler(type: EVStatus);
    if (vin == '') {
      print('here in ev_status: $vin');

      return await nH.fetchEVStatus(
          'https://$url/api/get_status?user=$username&name=$name&token=$token&vin=x',
          'https://$url/api/ev/data/get?user=$username&name=$name&token=$token&vin=x');
    }
    return await nH.fetchEVStatus(
        'https://$url/api/get_status?user=$username&name=$name&token=$token&vin=$vin',
        'https://$url/api/ev/data/get?user=$username&name=$name&token=$token&vin=$vin');
  }

  static Future<List> fetchDetailedEVStatusList(
      {String username, String name, String token, String url}) async {
    NetworkHandler nH = new NetworkHandler(type: EVStatus);
    return await nH.fetchList(
        'https://$url/api/get_status?user=$username&name=$name&token=$token');
  }
}
