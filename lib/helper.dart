import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:finalproject/Global.dart';

class Helper{
  var host = Global.getHost();
  Future<int> getUserIdByToken(String token) async{
    var url1 = Uri.parse("$host/HRRSFinal/getUser.php");
    // var headers = {"Authorization":"Bearer ${token}"};
    // print(headers['Authorization']);
    var userResponse = await  http.get(url1, headers: { 'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'});
    print(userResponse.statusCode);
    var userResult = userResponse.body;
    print(userResult);
    var userObj = jsonDecode(userResult) as Map<String, dynamic>;
    var user_id = userObj['user_id'];
    return user_id;
  }

  void logout(BuildContext context){
    Global.setToken("");
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
  }
}