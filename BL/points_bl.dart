
import 'package:cooperation/DB/point.dart';

import 'carto_bl.dart';

class PointsBL {
  static Map<int, Point> helpPoints;
  static Map<int, Point> offerPoints;

  static Future<void> initHelpPoints() async {
    print("Loading help points");
    helpPoints = await CartoBL.getHelpPoints();
  }

  static Future<void> initOfferPoints() async {
    print("Loading offer points");
    offerPoints = await CartoBL.getOfferPoints();
  }

  static Future<void> initHelpPointsIfEmpty() async {
    if(helpPoints == null) {
      await initHelpPoints();
    }
  }

  static Future<void> initOfferPointsIfEmpty() async {
    if(offerPoints == null) {
      await initOfferPoints();
    }
  }
}