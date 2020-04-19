import 'network_handler.dart';

class EV {
  NetworkHandler nH = new NetworkHandler(type: EV);

  final String id;
  final String make;
  final String model;
  final String year;
  final String color;
  final String defaultIso;
  final String name;
  final String minRange;
  final String maxRange;

  EV(
      {this.make,
      this.model,
      this.year,
      this.defaultIso,
      this.id,
      this.color,
      this.name,
      this.minRange,
      this.maxRange});

  factory EV.fromJson(Map<String, dynamic> json) {
    return EV(
      id: json['vin'],
      make: json['make'],
      model: json['model'],
      year: json['year'],
      color: json['color'],
      defaultIso: json['default_iso'],
      name: json['name'],
      minRange: json['min_range'],
      maxRange: json['max_range'],
    );
  }

  Future<EV> fetchEV(
      {String username,
      String name,
      String vin,
      String token,
      String url}) async {
    return await nH.fetch(
        'https://$url/api/get_info?user=$username&name=$name&token=$token&vin=$vin');
  }

  Future<List> fetchDetailedEVList(
      {String username, String name, String token, String url}) async {
    NetworkHandler nH = new NetworkHandler(type: EV);
    return await nH.fetchList(
        'https://$url/api/get_info?user=$username&name=$name&token=$token');
  }
}
