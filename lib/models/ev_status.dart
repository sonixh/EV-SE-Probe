import 'network_handler.dart';

class EVStatus {
  final String name;
  final String evseName;
  final String peerConnected;
  final String soc;
  final String miles;
  final String credit;
  final String primaryStatus;
  final String vin;
  final String id;
  final String secondaryStatus;
  final String tBatt;
  final String tCellAvg;
  final String tCellMin;
  final String tCellMax;

  EVStatus({
    this.name,
    this.evseName,
    this.peerConnected,
    this.soc,
    this.miles,
    this.credit,
    this.primaryStatus,
    this.vin,
    this.id,
    this.secondaryStatus,
    this.tBatt,
    this.tCellAvg,
    this.tCellMin,
    this.tCellMax,
  });

  factory EVStatus.fromTwoJson(
      Map<String, dynamic> evStatusJson, Map<String, dynamic> evDataJson) {
    return EVStatus(
        name: evStatusJson['car_name'],
        evseName: evStatusJson['evse_name'],
        peerConnected: evStatusJson['peer_connected'],
        soc: evStatusJson['soc'],
        miles: evStatusJson['miles'],
        credit: evStatusJson['credit'],
        primaryStatus: evStatusJson['primary_status'],
        vin: evStatusJson['vin'],
        id: evStatusJson['vin'],
        secondaryStatus: evStatusJson['secondary_status'],
        tBatt: evDataJson['t_batt'],
        tCellAvg: evDataJson['t_cell_avg'],
        tCellMax: evDataJson['t_cell_max'],
        tCellMin: evDataJson['t_cell_min']);
  }

  factory EVStatus.fromJson(Map<String, dynamic> evStatusJson) {
    return EVStatus(
      name: evStatusJson['car_name'],
      evseName: evStatusJson['evse_name'],
      peerConnected: evStatusJson['peer_connected'],
      soc: evStatusJson['soc'],
      miles: evStatusJson['miles'],
      credit: evStatusJson['credit'],
      primaryStatus: evStatusJson['primary_status'],
      vin: evStatusJson['vin'],
      id: evStatusJson['vin'],
      secondaryStatus: evStatusJson['secondary_status'],
    );
  }

  Future<EVStatus> fetchEVStatus(
      {String username,
      String name,
      String vin,
      String token,
      String url}) async {
    NetworkHandler nH = new NetworkHandler(type: EVStatus);
    return await nH.fetchEVStatus(
        'https://$url/api/get_status?user=$username&name=$name&token=$token&vin=$vin',
        'https://$url/api/ev/data/get?user=$username&name=$name&token=$token&vin=$vin');
  }

  Future<List> fetchDetailedEVStatusList(
      {String username, String name, String token, String url}) async {
    NetworkHandler nH = new NetworkHandler(type: EVStatus);
    return await nH.fetchList(
        'https://$url/api/get_status?user=$username&name=$name&token=$token');
  }
}
