import 'package:cooperation/DB/carto_db.dart';
import 'package:cooperation/DB/point.dart';
import 'package:cooperation/GUI/add_point_gui.dart';

class CartoBL {
  static Future<Map<int, Point>> getOfferPoints() async {
    var rows = await CartoDB.getOfferPoints();
    var returnList = new Map<int, Point>();
    for(var point in rows){
      returnList.addAll({point['cartodb_id']: Point.fromJson(point)});
    }
    return returnList;
  }

  static Future<Map<int, Point>> getHelpPoints() async {
    var rows = await CartoDB.getHelpPoints();
    var returnList = new Map<int, Point>();
    for(var point in rows){
      returnList.addAll({point['cartodb_id']: Point.fromJson(point)});
    }
    return returnList;
  }

  static Future<Set<Point>> getUsersHelpPoints(String uid) async {
    var rows = await CartoDB.getUsersHelpPoints(uid);
    var returnList = new Set<Point>();
    for(var point in rows){
      returnList.add(Point.fromJson(point));
    }
    return returnList;
  }

  static Future<String> setHelpShow(int id, bool newValue) async {
    return await CartoDB.setHelpShow(id, newValue);
  }

  static Future<String> setOfferShow(int id, bool newValue) async {
    return await CartoDB.setOfferShow(id, newValue);
  }

  static Future<Set<Point>> getUsersOfferPoints(String uid) async {
    var rows = await CartoDB.getUsersOfferPoints(uid);
    var returnList = new Set<Point>();
    for(var point in rows){
      returnList.add(Point.fromJson(point));
    }
    return returnList;
  }

  static Future<Point> insertPoint(Point point, PointType pointType) async {
    var response;
    if(pointType == PointType.help) {
      response = await CartoDB.insertHelpPoint(point);
    } else {
      response = await CartoDB.insertOfferPoint(point);
    }
    return new Point(
      id: response,
      title: point.title,
      description: point.description,
      latitude: point.latitude,
      longitude: point.longitude,
      show: true,
      creatorUid: point.creatorUid,
      creatorName: point.creatorName
    );
  }

}