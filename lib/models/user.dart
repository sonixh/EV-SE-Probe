import 'package:flutter/material.dart';

class User extends ChangeNotifier {
  String _username;
  String _token;
  String _name;
  String _role;
  String _url;
  List _evseList;
  List _evList;
  String _type;
  List _evseStatusList;
  List _evStatusList;
  List _evseSwVerList;
  String _iso;
  String _version;
  String _buildNumber;

  User(
      this._username,
      this._token,
      this._name,
      this._role,
      this._evseList,
      this._evList,
      this._url,
      this._iso,
      this._version,
      this._evseSwVerList,
      this._buildNumber);

  setUsername(String username) {
    _username = username;
    notifyListeners();
  }

  setBuildNumber(String buildNumber) {
    _buildNumber = buildNumber;
    notifyListeners();
  }

  setVersion(String version) {
    _version = version;
    notifyListeners();
  }

  setToken(String token) {
    _token = token;
    notifyListeners();
  }

  setName(String name) {
    _name = name;
    notifyListeners();
  }

  seturl(String url) {
    _url = url;
    notifyListeners();
  }

  setEVSEList(List evseList) {
    _evseList = evseList;
    notifyListeners();
  }

  setEVSESwVerList(List evseSwVerList) {
    _evseSwVerList = evseSwVerList;
    notifyListeners();
  }

  setEVList(List evList) {
    _evList = evList;
    notifyListeners();
  }

  setEVSEStatusList(List evseStatusList) {
    _evseStatusList = evseStatusList;
    notifyListeners();
  }

  setEVStatusList(List evStatusList) {
    _evStatusList = evStatusList;
    notifyListeners();
  }

  setRole(String role) {
    _role = role;
    notifyListeners();
  }

  setType(String type) {
    _type = type;
    notifyListeners();
  }

  setIso(String iso) {
    _iso = iso;
    notifyListeners();
  }

  String get version {
    return _version;
  }

  String get buildNumber {
    return _buildNumber;
  }

  String get iso {
    return _iso;
  }

  String get username {
    return _username;
  }

  List get evseStatusList {
    return _evseStatusList;
  }

  List get evseSwVerList {
    return _evseSwVerList;
  }

  List get evStatusList {
    return _evStatusList;
  }

  String get url {
    return _url;
  }

  String get token {
    return _token;
  }

  String get name {
    return _name;
  }

  String get role {
    return _role;
  }

  List get evseList {
    return _evseList;
  }

  List get evList {
    return _evList;
  }

  String get type {
    return _type;
  }
}
