import 'network_handler.dart';

class EVSEStatus {
  final String name;
  final String status;
  final String timestamp;
  final String energyNet;
  final String realPower;
  final String energyUp;
  final String energyDown;
  final String peerConnected;
  final String gfci;
  final String evState;
  final String evseState;
  final String id;
  final String carName;
  final String vinConnected;
  final String powerFactor;

  EVSEStatus(
      {this.name,
      this.status,
      this.timestamp,
      this.energyNet,
      this.realPower,
      this.energyDown,
      this.energyUp,
      this.peerConnected,
      this.gfci,
      this.evseState,
      this.evState,
      this.id,
      this.carName,
      this.vinConnected,
      this.powerFactor});

  factory EVSEStatus.fromJson(Map<String, dynamic> json) {
    return EVSEStatus(
        name: json['name'],
        status: json['status'],
        timestamp: json['timestamp'],
        energyNet: json['energy_net_kwh'],
        realPower: json['power_flow_real_kw'],
        energyDown: json['energy_down_kwh'],
        energyUp: json['energy_up_kwh'],
        peerConnected: json['peer_connected'],
        gfci: json['gfci_state'],
        evseState: json['evse_state'],
        evState: json['ev_status'],
        id: json['evse_id'],
        vinConnected: json['vin'],
        carName: json['car_name'],
        powerFactor: json['power_factor']);
  }

  Future<EVSEStatus> fetchEVSEStatus(
      {String username,
      String name,
      String evseID,
      String token,
      String url}) async {
    NetworkHandler nH = new NetworkHandler(type: EVSEStatus);
    return await nH.fetch(
        'https://$url/api/get_status?user=$username&name=$name&token=$token&evse=$evseID');
  }

  Future<List> fetchDetailedEVSEStatusList(
      {String username, String name, String token, String url}) async {
    NetworkHandler nH = new NetworkHandler(type: EVSEStatus);
    return await nH.fetchList(
        'https://$url/api/get_status?user=$username&name=$name&token=$token');
  }
}
