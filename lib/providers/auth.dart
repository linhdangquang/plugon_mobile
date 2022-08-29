import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

const apiUrl = 'https://api.plugon.vn/nspace/account/auth/login';

class Auth with ChangeNotifier {
  String? _accessToken;
  late String _refreshToken;
  late int _expiresIn;
  late int _refreshExpiresIn;

  bool get isAuth {
    return accessToken.isNotEmpty;
  }

  String get accessToken {
    return _accessToken ?? '';
  }

  Future<void> signIn(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'username': username,
          'password': password,
        }),
      );
      final responseData = json.decode(response.body);
      if (responseData['success'] == true) {
        _accessToken = responseData['data']['accessToken'];
        _refreshToken = responseData['data']['refreshToken'];
        _expiresIn = responseData['data']['expiresIn'];
        _refreshExpiresIn = responseData['data']['refreshExpiresIn'];
        notifyListeners();
      } else {
        throw Exception(responseData['message']);
      }
    } catch (error) {
      rethrow;
    }
  }

  // Future<void> autoLogin() async {

  // }

  Future<void> setNewToken() async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: json.encode({
          'refreshToken': _refreshToken,
        }),
      );
      final responseData = json.decode(response.body);
      if (responseData['success'] == true) {
        _accessToken = responseData['data']['accessToken'];
        _refreshToken = responseData['data']['refreshToken'];
        _expiresIn = responseData['data']['expiresIn'];
        _refreshExpiresIn = responseData['data']['refreshExpiresIn'];
        notifyListeners();
      } else {
        throw responseData['message'];
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    _accessToken = '';
    _refreshToken = '';
    _expiresIn = 0;
    _refreshExpiresIn = 0;
    Fluttertoast.showToast(
      msg: 'Đăng xuất thành công',
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.SNACKBAR,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    notifyListeners();
  }
}
