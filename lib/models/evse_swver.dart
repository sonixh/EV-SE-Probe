import 'network_handler.dart';

class EVSESwVer {
  final String id;
  final String agentRevision;
  final String velRevision;
  final String rCDVersion;
  final String meterVersion;

  EVSESwVer(
      {this.id,
      this.agentRevision,
      this.velRevision,
      this.rCDVersion,
      this.meterVersion});

  factory EVSESwVer.fromJson(Map<String, dynamic> json) {
    return EVSESwVer(
        id: json['id'],
        agentRevision: json['agent_revision'],
        velRevision: json['vel_revision'],
        rCDVersion: json['vel_values']['??<16>'],
        meterVersion: json['vel_values']['??<17>']);
  }

  static Future<List> fetchEVSESwVerList(
      {String username, String name, String token, String url}) async {
    NetworkHandler nH = new NetworkHandler(type: EVSESwVer);
    return await nH.fetchList(
        'https://$url/api/config/get?user=$username&name=$name&token=$token');
  }
}
