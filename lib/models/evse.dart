import 'network_handler.dart';

class EVSE {
  final String id;
  final String name;
  final String owner;
  final String edit;
  final String manufacturer;
  final String model;
  final String connector;
  final String hardwareVersion;
  final String iso;
  final String electricianId;
  final String utilityId;
  final String utilityName;
  final String address;
  final String nominalVoltage;
  final String meterType;
  final String latitude;
  final String longitude;
  final String utility;
  final List protocols;
  final String partNumber;
  final String velVersion;
  final String phase;
  final String maxc;
  final String maxd;
  final String reverse;
  final String rcd;
  final String meterVersion;

  EVSE(
      {this.id,
      this.edit,
      this.owner,
      this.name,
      this.manufacturer,
      this.model,
      this.meterType,
      this.utility,
      this.connector,
      this.hardwareVersion,
      this.iso,
      this.electricianId,
      this.utilityId,
      this.utilityName,
      this.address,
      this.nominalVoltage,
      this.latitude,
      this.longitude,
      this.protocols,
      this.partNumber,
      this.velVersion,
      this.phase,
      this.maxc,
      this.maxd,
      this.reverse,
      this.rcd,
      this.meterVersion});

  factory EVSE.fromJson(Map<String, dynamic> json) {
    return EVSE(
      id: json['evse_id'],
      meterType: json['evse_meter_type'],
      edit: json['editable_p'],
      owner: json['owner'],
      name: json['name'],
      manufacturer: json['manufacturer'],
      model: json['model'],
      connector: json['connector'],
      hardwareVersion: json['hardware_version'],
      iso: json['iso'],
      electricianId: json['electrician_id'],
      utilityId: json['utility_id'],
      utilityName: json['utility_name'],
      address: json['address'],
      nominalVoltage: json['nominal_voltage'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      utility: json['utility_name'],
      protocols: json['protocols'],
      partNumber: json['part_number'],
      velVersion: json['vel_version'],
      phase: json['phase'],
      maxc: json['max_c'],
      maxd: json['max_d'],
      reverse: json['reverse_feeding_permitted_p'],
      rcd: json['??<16>'],
      meterVersion: json['??<17>'],
    );
  }

  Future<EVSE> fetchEVSE(
      {String username,
      String name,
      String evseID,
      String token,
      String url}) async {
    NetworkHandler nH = new NetworkHandler(type: EVSE);
    return await nH.fetch(
        'https://$url/api/get_info?user=$username&name=$name&token=$token&evse=$evseID');
  }

  Future<List> fetchDetailedEVSEList(
      {String username, String name, String token, String url}) async {
    NetworkHandler nH = new NetworkHandler(type: EVSE);
    return await nH.fetchList(
        'https://$url/api/get_info?user=$username&name=$name&token=$token');
  }
}
