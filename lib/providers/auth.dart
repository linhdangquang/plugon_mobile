import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

const apiUrl = 'http://api.ngs.vn/nspace/account/auth/login';

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
          'domain': 'plugon.ngs.vn',
          'deviceOs': 'android'
        },
        body: json.encode({
          'username': username,
          'password': password,
        }),
      );
      final responseData = json.decode(response.body);
      if (responseData['success'] == true) {
        _accessToken = responseData['data']['access_token'];
        _refreshToken = responseData['data']['refresh_token'];
        _expiresIn = responseData['data']['expires_in'];
        _refreshExpiresIn = responseData['data']['refresh_expires_in'];
        notifyListeners();
      } else {
        throw Exception(responseData['message']);
      }
    } catch (error) {
      print(error);
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
