import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:donut/screen/main_screen.dart';
import 'package:donut/server/response.dart';
import 'package:flutter/cupertino.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String url = "http://220.90.237.33:7788";
Dio dio = Dio();
late SharedPreferences sharedPreferences;

class AuthServerApi {

  AuthServerApi(SharedPreferences s) {
    sharedPreferences = s;
  }

  void auth(int kakaoId, String nickName, String profileUrl, BuildContext context) async {
    try {
      final response = await dio.post(
        url + "/auth",
        options: Options(
          headers: {
            HttpHeaders.contentTypeHeader: "application/json"
          }
        ),
        data: jsonEncode(
          <String, dynamic> {
            "kakaoId" : kakaoId,
            "nickName" : nickName,
            "profileUrl" : profileUrl
          }
        )
      );

      print("login : ${response.statusCode} - ${response.data.toString()}");

      TokenResponse tokenResponse = TokenResponse.fromJson(response.data);

      sharedPreferences.setString("accessToken", tokenResponse.accessToken);
      sharedPreferences.setString("refreshToken", tokenResponse.refreshToken);
      sharedPreferences.setBool("isLogin", true);

      Navigator.of(context).pushAndRemoveUntil(
        PageTransition(
            child: MainPage(),
            type: PageTransitionType.fade
        ),
          (route) => false
      );
    }on DioError catch(e) {
      print("login error : ${e.response!.statusCode} - ${e.response!.data}");

       if(e.response!.statusCode == 403) {
         print("user not found");
         UserServerApi().signUp(kakaoId, nickName, profileUrl);
       }
    }
  }

  void refreshToken(String refreshToken) async {
    try {
      final response = await dio.put(
        url + "/auth",
        options: Options(
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            "X-Refresh-Token" : refreshToken
          }
        )
      );
      print("refreshToken : ${response.statusCode} - ${response.data.toString()}");

      TokenResponse tokenResponse = TokenResponse.fromJson(response.data);

      sharedPreferences.setString("accessToken", tokenResponse.accessToken);
      sharedPreferences.setString("refreshToken", tokenResponse.refreshToken);
      sharedPreferences.setBool("isLogin", true);
    }on DioError catch(e) {
      print("refreshToken error : ${e.response!.statusCode} - ${e.response!.data}");

      if(e.response!.statusCode == 403) {

      }
    }
  }
}

class UserServerApi {

  Future<UserResponse?> getMyInfo(String token) async {
    try {
      final response = await dio.get(
        url + "/user",
        options: Options(
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            HttpHeaders.authorizationHeader: token
          }
        )
      );

      print("getMyInfo : ${response.statusCode} - ${response.data.toString()}");

      return UserResponse.fromJson(response.data);
    }on DioError catch(e) {
      print("getMyInfo error : ${e.response!.statusCode} - ${e.response!.data}");

      return null;
    }
  }

  void signUp(int kakaoId, String nickName, String profileUrl) async {
    try {
      final response = await dio.post(
        url + '/user',
        options: Options(
          headers: {
            HttpHeaders.contentTypeHeader: "application/json"
          }
        ),
        data: jsonEncode(
          <String, dynamic> {
            "kakaoId" : kakaoId,
            "nickName" : nickName,
            "profileUrl" : profileUrl
          }
        )
      );

      print("signUp : ${response.statusCode} - ${response.data.toString()}");
    }on DioError catch(e) {
      print("singUp error : $e");
    }
  }
}

class DoneServerApi {

  Future<List<DoneResponse>> getMyDonesByWriteAt(String writeAt, String token) async {
    try {
      final response = await dio.get(
        url + '/done/search',
        options: Options(
            headers: {
              HttpHeaders.contentTypeHeader: "application/json",
              HttpHeaders.authorizationHeader: token
            }
        ),
        queryParameters: {
          "writeAt" : writeAt
        }
      );

      return (response.data as List).map((e) => DoneResponse.fromJson(e)).toList();
    }on DioError catch(e) {
      print("error : ${e.response!.statusCode} - ${e.response!.statusMessage}");

      if(e.response!.statusCode == 403) {
        var s = await SharedPreferences.getInstance();
        AuthServerApi(s).refreshToken(s.getString("refreshToken") ?? "");
        return await retry(s.getString("accessToken") ?? "", writeAt);
      }

      return [];
    }
  }

  Future<dynamic> retry(String token, String writeAt) async {
    try {
      final response = await dio.get(
          url + '/done/search',
          options: Options(
              headers: {
                HttpHeaders.contentTypeHeader: "application/json",
                HttpHeaders.authorizationHeader: token
              }
          ),
          queryParameters: {
            "writeAt" : writeAt
          }
      );

      return (response.data as List).map((e) => DoneResponse.fromJson(e)).toList();
    }on DioError catch(e) {
      print("error : ${e.response!.statusCode} - ${e.response!.statusMessage}");

      return [];
    }
  }

  writeDone(String title, String content, bool isPublic, String token) async {
    try {
      final response = await dio.post(
          url + '/done',
          options: Options(
              headers: {
                HttpHeaders.contentTypeHeader: "application/json",
                HttpHeaders.authorizationHeader: token
              }
          ),
          data: <String, dynamic> {
            'title' : title,
            'content' : content,
            'isPublic' : isPublic
          }
      );

      print(response.data);
    }on DioError catch(e) {
      print("error : ${e.response!.statusCode} - ${e.response!.statusMessage}");
      if(e.response!.statusCode == 403) {
        var s = await SharedPreferences.getInstance();
        AuthServerApi(s).refreshToken(s.getString("refreshToken") ?? "");
        retryWriteDone(title, content, isPublic, s.getString("accessToken") ?? "");
      }
    }
  }

  retryWriteDone(String title, String content, bool isPublic, String token) async {
    try {
      final response = await dio.post(
          url + '/done',
          options: Options(
              headers: {
                HttpHeaders.contentTypeHeader: "application/json",
                HttpHeaders.authorizationHeader: token
              }
          ),
          data: <String, dynamic> {
            'title' : title,
            'content' : content,
            'isPublic' : isPublic
          }
      );

      print(response.data);
    }on DioError catch(e) {
      print("error : ${e.response!.statusCode} - ${e.response!.statusMessage}");
    }
  }
}