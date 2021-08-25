import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String? _token;
  String? _expiryDate;
  Timer? _authTimer;

  String? get token {
    if (_expiryDate != null &&
        _token != null &&
        DateTime.parse(_expiryDate.toString()).isAfter(DateTime.now()))
      return _token;
    return null;
  }

  bool get isAuth {
    return token != null;
  }

  Future<void> logIn(String email, String password) async {
    final url = Uri.parse("http://192.236.154.136/api/Accounts/Login");
    final headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json'
      // 'Authorization': 'Bearer $token',
    };
    final body = jsonEncode({
      "Username": email,
      "Password": password,
    });
    print("LogIn");
    final response = await http.post(url, headers: headers, body: body);
    final responseData = json.decode(response.body);
    if (responseData['error'] != null) {
      if (responseData["error"][0]["message"]
          .toString()
          .contains("incorrect")) {
        throw HttpException("تاكد من اسم المستخدم و كلمة المرور");
      }
    }
    _token = responseData["data"]["token"];
    print(_token);

    _expiryDate = responseData["data"]["expiration"];
    print(_expiryDate);
    autoLogout();
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    final userData = json.encode({
      "token": _token,
      "expiryDate": _expiryDate,
    });
    prefs.setString("userData", userData);
  }

  Future<bool> resetPassword(
      String? oldP, String? newP, String? confirmP) async {
    final url = Uri.parse("http://192.236.154.136/api/Accounts/ResetPassword");
    final headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final body = jsonEncode({
      "oldPassword": oldP,
      "newPassword": newP,
      "confirmNewPassword": confirmP,
    });
    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode >= 400) return false;
    return true;
  }

  Future<void> autoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("userData")) return;
    final extractedData = json.decode(prefs.getString("userData").toString())
        as Map<String, dynamic>;
    final expiryDate = DateTime.parse(extractedData["expiryDate"]);
    if (expiryDate.isBefore(DateTime.now())) return;
    _token = extractedData["token"].toString();
    _expiryDate = extractedData["expiryDate"];
    autoLogout();
    print(_token);
    notifyListeners();
  }

  Future<void> logout() async {
    _token = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    notifyListeners();
    print("object");
  }

  Future<void> autoLogout() async {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final timeToExpire = DateTime.parse(_expiryDate.toString())
        .difference(DateTime.now())
        .inSeconds;
    print(timeToExpire);
    _authTimer = Timer(Duration(seconds: timeToExpire), logout);
  }
}
