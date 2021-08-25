import 'package:flutter/cupertino.dart';

class RestaurantProduct {
  final int? dataID;
  final int? productID;
  final String? barcode;
  final String? productName;
  final double? totalSales;
  final double? totalQuantity;

  RestaurantProduct(
      {@required this.dataID,
      @required this.productID,
      @required this.barcode,
      @required this.productName,
      @required this.totalSales,
      @required this.totalQuantity});
}
