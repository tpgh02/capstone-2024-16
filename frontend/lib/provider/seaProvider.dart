import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CoordinateProvider extends ChangeNotifier {
  double _xCoordinate = 0.0;
  double _yCoordinate = 0.0;

  double get xCoordinate => _xCoordinate;
  double get yCoordinate => _yCoordinate;

  void setCoordinates(double x, double y) {
    _xCoordinate = x;
    _yCoordinate = y;
    notifyListeners();
  }
}
