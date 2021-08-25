import 'package:flutter/cupertino.dart';

class RestaurantReport{
  final int? dataID;
  final DateTime? targetDate;
final double? totalQuantity;
final double? totalSales;

  RestaurantReport({ @required this.dataID, @required this.targetDate, @required this.totalQuantity,@required this.totalSales});
  
}