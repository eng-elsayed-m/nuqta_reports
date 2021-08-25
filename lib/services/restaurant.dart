import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:nuqta/models/http_exception.dart';
import 'package:nuqta/models/restaurant/report.dart';
import 'package:nuqta/models/restaurant/restaurant_product.dart';

class Restaurant extends ChangeNotifier {
  final String? token;
  List<RestaurantReport> _reports = [];
  List<RestaurantProduct> _products = [];
  int reportsPN = 1;
  int productsPN = 1;
  int? totalReportsPages;
  int? totalProductsPages;

  List<RestaurantReport> get restaurantReports => _reports;
  List<RestaurantProduct> get products => _products;
  Restaurant(this.token);
  Future<void> fetchReports([DateTime? sDate, DateTime? eDate]) async {
    if (_reports.isNotEmpty) return;
    String fromD = "";
    String toD = "";
    if (sDate != null) {
      fromD = "=" + sDate.toString().split(" ").first;
    }
    if (eDate != null) {
      toD = "=" + eDate.toString().split(" ").first;
    }
    final url = Uri.parse(
        "http://192.236.154.136/api/Restaurants/Reports/SalesWithDate?to$toD&from$fromD");
    // print(url);
    final headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final _response = await http.get(url, headers: headers);
    if (_response.statusCode == 403) throw HttpException("Permission Denied !");
    if (_response.statusCode >= 400) return;
    final resData = jsonDecode(_response.body) as Map<String, dynamic>;
    final List<dynamic> _reportsList = resData["data"]["data"][0]["reportBody"];

    if (_reportsList == []) return;
    totalReportsPages = resData["data"]["totalPages"];
    List<RestaurantReport> _fetchedReports = _reportsList
        .map((repo) => RestaurantReport(
            dataID: repo["dataID"],
            targetDate: DateTime.parse(repo["targetDate"]),
            totalQuantity: repo["totalQuantity"],
            totalSales: repo["totalSales"]))
        .toList();
    _reports = _fetchedReports;
    notifyListeners();
  }

  Future<void> fetcNexthReports([DateTime? sDate, DateTime? eDate]) async {
    if (reportsPN == totalReportsPages) return;
    reportsPN++;
    String fromD = "";
    String toD = "";
    if (sDate != null) {
      fromD = "=" + sDate.toString().split(" ").first;
    }
    if (eDate != null) {
      toD = "=" + eDate.toString().split(" ").first;
    }
    final url = Uri.parse(
        "http://192.236.154.136/api/Restaurants/Reports/SalesWithDate?to$toD&from$fromD&PageNumber=$reportsPN");
    // print(url);
    final headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final _response = await http.get(url, headers: headers);
    final resData = json.decode(_response.body) as Map<String, dynamic>;
    if (reportsPN > resData["data"]["totalPages"]) return;
    List<dynamic> _reportsList = resData["data"]["data"][0]["reportBody"];
    if (_reportsList == []) return;
    int lastid = _reports.length;
    List<RestaurantReport> _fetchedReports = _reportsList
        .map((repo) => RestaurantReport(
            dataID: repo["dataID"] + lastid,
            targetDate: DateTime.parse(repo["targetDate"]),
            totalQuantity: repo["totalQuantity"],
            totalSales: repo["totalSales"]))
        .toList();
    _reports.addAll(_fetchedReports);
    // _fetchedReports.forEach((repo) => _reports.add(repo));
    notifyListeners();
  }

  Future<void> fetchSales(DateTime? date) async {
    if (date == null) throw Exception("select day");
    final url = Uri.parse(
        "http://192.236.154.136/api/Restaurants/Reports/SalesDetailsWithDate?date=${date.toString()}");
    final headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final _response = await http.get(url, headers: headers);
    final resData = json.decode(_response.body) as Map<String, dynamic>;
    if (resData["error"] != null) throw HttpException(resData["message"]);
    if (resData["success"] == false) return;

    final List<dynamic> _fetchedProducts =
        resData["data"]["data"][0]["reportBody"];
    if (_fetchedProducts == []) return;
    totalProductsPages = resData["data"]["totalPages"];
    _products = _fetchedProducts
        .map((product) => RestaurantProduct(
            dataID: product["dataID"],
            productID: product["productID"],
            barcode: product["barcode"],
            productName: product["productName"],
            totalSales: product["totalSales"],
            totalQuantity: product["totalQuantity"]))
        .toList();
    notifyListeners();
    // print(resData["message"]);
  }

  Future<void> fetchNextSales(DateTime? date) async {
    if (reportsPN == totalReportsPages) return;
    productsPN++;
    final url = Uri.parse(
        "http://192.236.154.136/api/Restaurants/Reports/SalesDetailsWithDate?date=${date.toString()}&pageNumber=$productsPN");
    final headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final _response = await http.get(url, headers: headers);
    final resData = json.decode(_response.body) as Map<String, dynamic>;
    if (productsPN > resData["data"]["totalPages"]) return;
    final List<dynamic> _productsList =
        resData["data"]["data"][0]["reportBody"];
    int lastid = _products.length;

    List<RestaurantProduct> _fetchedProducts = _productsList
        .map((product) => RestaurantProduct(
            dataID: product["dataID"] + lastid,
            productID: product["productID"],
            barcode: product["barcode"],
            productName: product["productName"],
            totalSales: product["totalSales"],
            totalQuantity: product["totalQuantity"]))
        .toList();
    _fetchedProducts.forEach((prod) => _products.add(prod));
    notifyListeners();
  }
}
