import 'dart:convert';

import 'package:cooperation/DB/point.dart';
import 'package:http/http.dart' as http;

import 'keys.dart';

class CartoDB {
  static final String _username = "julenminer";
  static final String _api_key = Keys.carto_api_key;
  static final String _database_url =
      'https://' + _username + '.carto.com/api/v2/sql?api_key=' + _api_key;

  static final String _query_start = '&q=';

  static final String _database_query = _database_url + _query_start;

  static Future<List<dynamic>> getHelpPoints() async {
    var query = "SELECT * FROM help_points_tfm WHERE show=true";
    var response = await http.get(_database_query + query);
    if (response.statusCode == 200) {
      var responseJson = json.decode(response.body);
      return responseJson['rows'];
    } else {
      print(response.body);
      return null;
    }
  }

  static Future<List<dynamic>> getUsersHelpPoints(String uid) async {
    var query = "SELECT * FROM help_points_tfm WHERE creator_uid='" + uid + "'";
    var response = await http.get(_database_query + query);
    if (response.statusCode == 200) {
      var responseJson = json.decode(response.body);
      return responseJson['rows'];
    } else {
      print(response.body);
      return null;
    }
  }

  static Future<List<dynamic>> getOfferPoints() async {
    var query = "SELECT * FROM offer_points_tfm WHERE show=true";
    var response = await http.get(_database_query + query);
    if (response.statusCode == 200) {
      var responseJson = json.decode(response.body);
      return responseJson['rows'];
    } else {
      print(response.body);
      return null;
    }
  }

  static Future<String> setHelpShow(int id, bool newValue) async {
    var query = "UPDATE help_points_tfm SET show=" +
        newValue.toString() +
        " WHERE cartodb_id=" +
        id.toString();
    var response = await http.get(_database_query + query);
    return response.body;
  }

  static Future<String> setOfferShow(int id, bool newValue) async {
    var query = "UPDATE offer_points_tfm SET show=" +
        newValue.toString() +
        " WHERE cartodb_id=" +
        id.toString();
    var response = await http.get(_database_query + query);
    return response.body;
  }

  static Future<List<dynamic>> getUsersOfferPoints(String uid) async {
    var query = "SELECT * FROM offer_points_tfm WHERE creator_uid='" + uid + "'";
    var response = await http.get(_database_query + query);
    if (response.statusCode == 200) {
      var responseJson = json.decode(response.body);
      return responseJson['rows'];
    } else {
      print(response.body);
      return null;
    }
  }

  static Future<dynamic> insertHelpPoint(Point point) async {
    var sql_statement = "INSERT INTO help_points_tfm " +
        "(the_geom, name, description, latitude, longitude, show, creator_uid, creator_name) VALUES " +
        "(ST_SetSRID(ST_Point(" +
        point.longitude.toString() +
        ", " +
        point.latitude.toString() +
        "), 4326), '" +
        point.title +
        "', '" +
        point.description +
        "', " +
        point.latitude.toString() +
        ", " +
        point.longitude.toString() +
        ", true, '" +
        point.creatorUid +
        "', '" +
        point.creatorName +
        "') RETURNING cartodb_id";
    var response = await http.get(_database_query + sql_statement);
    if (response.statusCode == 200) {
      var responseJson = json.decode(response.body);
      return responseJson['rows'][0]['cartodb_id'];
    } else {
      print(response.body);
      return null;
    }
  }

  static Future<int> insertOfferPoint(Point point) async {
    var sql_statement = "INSERT INTO offer_points_tfm " +
        "(the_geom, name, description, latitude, longitude, show, creator_uid, creator_name) VALUES " +
        "(ST_SetSRID(ST_Point(" +
        point.longitude.toString() +
        ", " +
        point.latitude.toString() +
        "), 4326), '" +
        point.title +
        "', '" +
        point.description +
        "', " +
        point.latitude.toString() +
        ", " +
        point.longitude.toString() +
        ", true, '" +
        point.creatorUid +
        "', '" +
        point.creatorName +
        "') RETURNING cartodb_id";
    var response = await http.get(_database_query + sql_statement);
    if (response.statusCode == 200) {
      var responseJson = json.decode(response.body);
      return responseJson['rows'][0]['cartodb_id'];
    } else {
      print(response.body);
      return null;
    }
  }
}
