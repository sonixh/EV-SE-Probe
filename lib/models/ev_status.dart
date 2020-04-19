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

  EVStatus(
      {this.name,
      this.evseName,
      this.peerConnected,
      this.soc,
      this.miles,
      this.credit,
      this.primaryStatus,
      this.vin,
      this.id,
      this.secondaryStatus});

  factory EVStatus.fromJson(Map<String, dynamic> json) {
    return EVStatus(
        name: json['car_name'],
        evseName: json['evse_name'],
        peerConnected: json['peer_connected'],
        soc: json['soc'],
        miles: json['miles'],
        credit: json['credit'],
        primaryStatus: json['primary_status'],
        vin: json['vin'],
        id: json['vin'],
        secondaryStatus: json['secondary_status']);
  }

  Future<EVStatus> fetchEVStatus(
      {String username,
      String name,
      String vin,
      String token,
      String url}) async {
    NetworkHandler nH = new NetworkHandler(type: EVStatus);
    return await nH.fetch(
        'https://$url/api/get_status?user=$username&name=$name&token=$token&vin=$vin');
  }

  Future<List> fetchDetailedEVStatusList(
      {String username, String name, String token, String url}) async {
    NetworkHandler nH = new NetworkHandler(type: EVStatus);
    return await nH.fetchList(
        'https://$url/api/get_status?user=$username&name=$name&token=$token');
  }
}
