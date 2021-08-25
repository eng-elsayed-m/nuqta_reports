import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:nuqta/models/cashier/chashier_statement.dart';
import 'package:nuqta/models/customers_vendors/C_V.dart';
import 'package:nuqta/models/customers_vendors/C_V_statement.dart';
import 'package:nuqta/models/expenses/expense_statement.dart';
import 'package:nuqta/models/expenses/expense_type.dart';
import 'package:nuqta/models/store/store.dart';
import 'package:nuqta/models/store/store_Statement.dart';

class POS extends ChangeNotifier {
  final String? token;
  POS(this.token);
  double totalStoreValue = 0.0;
  double totalExpenseValue = 0.0;

  // Customers ****************************
  List<Customer> _customers = [];
  List<Statement> _cStatements = [];
  List<Customer> get customers => _customers;
  List<Statement> get cStatements => _cStatements;

  // (((((((((((((((((((((())))))))))))))))))))))
  Future<void> fetchCustomers(String query) async {
    if (query.isEmpty) return;
    final url = Uri.parse("http://192.236.154.136/api/POS/Data/Customers");
    // print(url);
    final headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final _response = await http.get(url, headers: headers);
    // print(_response.statusCode);
    final resData = jsonDecode(_response.body) as Map<String, dynamic>;
    if (resData["data"] == null) return;
    final List<dynamic> _reportsList = resData["data"];

    if (_reportsList == []) return;
    List<Customer> _fetchedReports = _reportsList
        .map((customer) => Customer(customer["id"], customer["name"]))
        .toList();
    _customers = _fetchedReports
        .where((element) => element.name.contains(query))
        .toList();
    print(_customers.length);
    notifyListeners();
  }

  Future<void> fetchCustomerStatements(
      [DateTime? sDate, DateTime? eDate, int? id]) async {
    // String fromD = "";
    // String toD = "";
    // // if (sDate != null) {
    String fromD = sDate.toString().split(" ").first;
    // // }
    // // if (eDate != null) {
    String toD = eDate.toString().split(" ").first;
    // // }
    if (id == null) {
      _cStatements = [];
      return;
    }
    final url = Uri.parse(
        "http://192.236.154.136/api/POS/Reports/CustomerStatement?Customerid=$id&from=$fromD&to=$toD");
    // print(url);
    final headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final _response = await http.get(url, headers: headers);
    print(_response.statusCode);

    final resData = jsonDecode(_response.body) as Map<String, dynamic>;
    final List<dynamic> _statementList =
        resData["data"]["data"][0]["reportBody"];
    if (_statementList == []) return;
    _cStatements = _statementList
        .map((st) => Statement(
            dataID: st["dataID"],
            memeberID: st["memeberID"],
            number: st["number"],
            credit: st["credit"],
            debt: st["debt"],
            operationDate: DateTime.parse(st["operationDate"]),
            operationType: st["operationType"]))
        .toList();

    notifyListeners();
  }

  //Vendors *******************************
  List<Customer> _vendors = [];
  List<Statement> _vStatements = [];
  List<Customer> get vendors => _vendors;
  List<Statement> get vStatements => _vStatements;

  //((((((((((((((((((((((()))))))))))))))))))))))

  Future<void> fetchVendors(String query) async {
    if (query.isEmpty) return;
    final url = Uri.parse("http://192.236.154.136/api/POS/Data/Vendors");
    // print(url);
    final headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final _response = await http.get(url, headers: headers);
    final resData = jsonDecode(_response.body) as Map<String, dynamic>;
    if (resData["data"] == null) return;
    final List<dynamic> _vendorsList = resData["data"];

    if (_vendorsList == []) return;
    List<Customer> _fetchedVendors = _vendorsList
        .map((vendor) => Customer(vendor["id"], vendor["name"]))
        .toList();
    _vendors = _fetchedVendors
        .where((element) => element.name.contains(query))
        .toList();

    // print(_customers.length);
    notifyListeners();
  }

  Future<void> fetchVendorStatements(
      [DateTime? sDate, DateTime? eDate, int? id]) async {
    String fromD = sDate.toString().split(" ").first;
    String toD = eDate.toString().split(" ").first;
    // if (sDate != null) {
    //   fromD = "=" + sDate.toString().split(" ").first;
    // }
    // if (eDate != null) {
    //   toD = "=" + eDate.toString().split(" ").first;
    // }
    if (id == null) {
      _vStatements = [];
      return;
    }
    final url = Uri.parse(
        "http://192.236.154.136/api/POS/Reports/VendorStatment?vendorid=$id&from=$fromD&to=$toD");
    // print(url);
    final headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final _response = await http.get(url, headers: headers);
    // print(_response.statusCode);

    final resData = jsonDecode(_response.body) as Map<String, dynamic>;
    final List<dynamic> _statementList = resData["data"]["reportBody"];
    if (_statementList == []) return;
    _vStatements = _statementList
        .map((st) => Statement(
            dataID: st["dataID"],
            memeberID: st["memeberID"],
            number: st["number"],
            credit: st["credit"],
            debt: st["debt"],
            operationDate: DateTime.parse(st["operationDate"]),
            operationType: st["operationType"]))
        .toList();

    notifyListeners();
  }

  //Stores *******************************
  List<Store> _stores = [];
  List<Store> get stores => _stores;
  List<StoreStatement> _sStatements = [];
  List<StoreStatement> get sStatements => _sStatements;

  //(((((((((((((((((((((((((((())))))))))))))))))))))))))))

  Future<List<Store>> fetchStores() async {
    final url = Uri.parse("http://192.236.154.136/api/POS/Data/Stores");
    // print(url);
    final headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final _response = await http.get(url, headers: headers);
    final resData = jsonDecode(_response.body) as Map<String, dynamic>;
    print(resData);
    if (resData["data"] == null) return [];
    final List<dynamic> _storesList = resData["data"];

    if (_storesList == []) return [];
    return _storesList
        .map((store) => Store(store["id"], store["name"]))
        .toList();
  }

  Future<void> fetchStoreStatements([int? storeid]) async {
    final id = storeid == null ? "" : "?storeid=$storeid";
    final url =
        //  Uri.parse("http://192.236.154.136/api/POS/Data/Products")
        Uri.parse("http://192.236.154.136/api/POS/Reports/StoreStatment$id");
    final headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final _response = await http.get(url, headers: headers);
    final resData = jsonDecode(_response.body) as Map<String, dynamic>;
    totalStoreValue =
        resData["data"]["reportFooter"]["reportFields"]["TotalVlaue"];
    final List<dynamic> _statementList = resData["data"]["reportBody"];

    // print(_statementList);
    // print(_statementList);
    _sStatements = _statementList
        .map((st) => StoreStatement(
              productID: st["productID"],
              productName: st["productName"],
              quantity: st["quantity"],
              cost: st["cost"],
              salePrice: st["salePrice"],
              unitName: st["unitName"],
              value: st["value"],
            ))
        .toList();

    // print(_sStatements.length);
    notifyListeners();
  }

  //Profits **********************************

  Future<Map<String, dynamic>> fetchProfits(
      [DateTime? sDate, DateTime? eDate]) async {
    String fromD = "";
    String toD = "";
    if (sDate != null) {
      fromD = "=" + sDate.toString().split(" ").first;
    }
    if (eDate != null) {
      toD = "=" + eDate.toString().split(" ").first;
    }
    print(fromD + toD);
    final url = Uri.parse(
        "http://192.236.154.136/api/POS/Reports/ProfitStatment?from$fromD&to$toD");
    final headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final _response = await http.get(url, headers: headers);
    print(_response.statusCode);

    final resData = jsonDecode(_response.body) as Map<String, dynamic>;
    return resData["data"]["reportBody"][0];
  }

  //Expenses *******************************
  List<ExpenseType> _expensesTypes = [];
  List<ExpenseType> get expensesTypes => _expensesTypes;
  List<ExpenseStatement> _eStatements = [];
  List<ExpenseStatement> get eStatements => _eStatements;
  //((((((((((((((((((((((()))))))))))))))))))))))

  Future<List<ExpenseType>> fetchExpensesTypes() async {
    final url = Uri.parse("http://192.236.154.136/api/POS/Data/ExpensesTypes");
    // print(url);
    final headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final _response = await http.get(url, headers: headers);
    final resData = jsonDecode(_response.body) as Map<String, dynamic>;
    // print(resData);
    if (resData["data"] == null) return [];
    final List<dynamic> _expensesTypesList = resData["data"];

    if (_expensesTypesList == []) return [];
    return _expensesTypesList
        .map((type) => ExpenseType(type["id"], type["name"]))
        .toList();
  }

  Future<void> fetchExpenseStatements(DateTime? sDate, DateTime? eDate) async {
    String fromD = sDate.toString().split(" ").first;
    String toD = eDate.toString().split(" ").first;
    final url = Uri.parse(
        "http://192.236.154.136/api/POS/Reports/ExpensesStatment?from=$fromD&to=$toD");
    final headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final _response = await http.get(url, headers: headers);
    final resData = jsonDecode(_response.body) as Map<String, dynamic>;
    print(resData);
    totalExpenseValue =
        resData["data"]["reportFooter"]["reportFields"]["TotalCredits"];
    final List<dynamic> _statementList = resData["data"]["reportBody"];

    // print(_statementList);
    _eStatements = _statementList
        .map((st) => ExpenseStatement(
              expenseDate: DateTime.parse(st["expenseDate"]),
              expenseTypeID: st["expenseTypeID"],
              expenseTypeName: st["expenseTypeName"],
              notes: st["notes"] ?? "خاليه",
              value: st["value"],
            ))
        .toList();
    notifyListeners();
  }

  //Cashier *************************************
  Future<List<CashierStatement>> fetchCashierStatements(
      DateTime? sDate, DateTime? eDate) async {
    String fromD = sDate.toString().split(" ").first;
    String toD = eDate.toString().split(" ").first;
    final url = Uri.parse(
        "http://192.236.154.136/api/POS/Reports/CashierStatment?from=$fromD&to=$toD");
    final headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final _response = await http.get(url, headers: headers);
    final resData = jsonDecode(_response.body) as Map<String, dynamic>;
    print(resData);

    final List<dynamic> _statementList = resData["data"]["reportBody"];

    // print(_statementList);
    return _statementList
        .map((st) => CashierStatement(
              credit: st["credit"],
              dataID: st["dataID"],
              debt: st["debt"],
              description: st["description"],
              operationDate: DateTime.parse(st["operationDate"]),
              notes: st["notes"],
              number: st["number"],
              operationType: st["operationType"],
            ))
        .toList();
  }

  //Invokies ***************
  Future<List<CashierStatement>> fetchInvokiesStatements(
      DateTime? sDate, DateTime? eDate) async {
    String fromD = sDate.toString().split(" ").first;
    String toD = eDate.toString().split(" ").first;
    final url = Uri.parse(
        "http://192.236.154.136/api/POS/Reports/CashierStatment?from=$fromD&to=$toD");
    final headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final _response = await http.get(url, headers: headers);
    final resData = jsonDecode(_response.body) as Map<String, dynamic>;
    print(resData);

    final List<dynamic> _statementList = resData["data"]["reportBody"];

    // print(_statementList);
    return _statementList
        .map((st) => CashierStatement(
              credit: st["credit"],
              dataID: st["dataID"],
              debt: st["debt"],
              description: st["description"],
              operationDate: DateTime.parse(st["operationDate"]),
              notes: st["notes"],
              number: st["number"],
              operationType: st["operationType"],
            ))
        .toList();
  }
}
