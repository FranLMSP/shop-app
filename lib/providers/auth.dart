import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String _userId;
  String _token;
  DateTime _expireDate;
  Timer _authTimer;

  bool get isAuth {
    return _token != null;
  }

  String get token {
    if (_token != null && _expireDate != null && _expireDate.isAfter(DateTime.now())) {
      return _token;
    }
    return null;
  }
  
  String get userId {
    return _userId;
  }

  Future<void> _authenticate(String urlSegment, String email, String password) async {
    final url = 'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=[key]';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expireDate = DateTime.now().add(Duration(seconds: int.parse(responseData['expiresIn'])));
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expireDate': _expireDate.toIso8601String(),
      });
      prefs.setString('userData', userData);
      _autoLogout();
      notifyListeners();
    } catch(error) {
      throw error;
    }
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final storedData = prefs.getString('userData');
    if (storedData == null) {
      return false;
    }
    final extractedUserData = json.decode(storedData) as Map<String, Object>;
    final expireDate = DateTime.parse(extractedUserData['expireDate']);
    if (expireDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expireDate = extractedUserData['expireDate'];
    notifyListeners();
    _autoLogout();
    return true;
    
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate('signUp', email, password);
  }

  Future<void> login(String email, String password) async {
    return _authenticate('signInWithPassword', email, password);
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expireDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }


  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    final timeToExpire = _expireDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpire), logout);
  }
}