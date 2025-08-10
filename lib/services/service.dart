import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:fluttertask/models/user_model.dart';

class UserService {
  static Future<List<User>> loadUsers() async {
    final jsonString = await rootBundle.loadString("assets/users.json");
    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((json) => User.fromJson(json)).toList();
  }
}

// class UserService {
//   static Future<List<User>> loadUsers() async {
//     final jsonString = await rootBundle.loadString('assets/users.json');
//     final List<dynamic> jsonList = jsonDecode(jsonString);
//     return jsonList.map((json) => User.fromJson(json)).toList();
//   }
// }
