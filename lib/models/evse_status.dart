import 'network_handler.dart';

class EVSEStatus {
  final String name;
  final String status;
  final String timestamp;
  final String energyNet;
  final String energyTotal;
  final String energyUp;
  final String energyDown;
  final String peerConnected;
  final String gfci;
  final String evState;
  final String evseState;
  final String id;
  final String carName;

  EVSEStatus(
      {this.name,
      this.status,
      this.timestamp,
      this.energyNet,
      this.energyTotal,
      this.energyDown,
      this.energyUp,
      this.peerConnected,
      this.gfci,
      this.evseState,
      this.evState,
      this.id,
      this.carName});

  factory EVSEStatus.fromJson(Map<String, dynamic> json) {
    return EVSEStatus(
      name: json['name'],
      status: json['status'],
      timestamp: json['timestamp'],
      energyNet: json['energy_net_kwh'],
      energyTotal: json['power_flow_real_kw'],
      energyDown: json['energy_down_kwh'],
      energyUp: json['energy_up_kwh'],
      peerConnected: json['peer_connected'],
      gfci: json['gfci_state'],
      evseState: json['evse_state'],
      evState: json['ev_status'],
      id: json['evse_id'],
      carName: json['car_name'],
    );
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
