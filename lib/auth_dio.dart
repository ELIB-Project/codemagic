import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:elib_project/main.dart';
import 'package:elib_project/pages/test_page_jh.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Dio> authDio() async {
  var dio = Dio(BaseOptions(baseUrl: "http://test.elibtest.r-e.kr:8080"));

  final storage = FlutterSecureStorage();

  dio.interceptors.clear();

  dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) async {
    // 기기에 저장된 AccessToken 로드
    final accessToken = await storage.read(key: 'ACCESS_TOKEN');

    // 매 요청마다 헤더에 AccessToken을 포함
    options.headers['Authorization'] = '$accessToken';
    return handler.next(options);
  }, onError: (error, handler) async {
    // 인증 오류가 발생했을 경우: AccessToken의 만료
    if (error.response?.statusCode == 401) {
      print("AccesToken Expired-----------------------------------");

      // 기기에 저장된  RefreshToken 로드
      final refreshToken = await storage.read(key: 'REFRESH_TOKEN');

      // 토큰 갱신 요청을 담당할 dio 객체 구현 후 그에 따른 interceptor 정의
      var refreshDio =
          Dio(BaseOptions(baseUrl: "http://test.elibtest.r-e.kr:8080"));

      refreshDio.interceptors.clear();

      // 로그인 페이지로 이동하는거 구현하면 사용가능 할 듯
      // refreshDio.interceptors.add(InterceptorsWrapper(onError: (error, handler) async {

      //   // 다시 인증 오류가 발생했을 경우: RefreshToken의 만료
      //   if (error.response?.statusCode == 401) {
      //     print("RefreshToken Expired-----------------------------------");
      //     // 기기의 자동 로그인 정보 삭제
      //     await storage.deleteAll();

      //     // . . .
      //     // 로그인 만료 dialog 발생 후 로그인 페이지로 이동
      //     // . . .
      //   }
      //   return handler.next(error);
      // }));

      // 토큰 갱신 API 요청 헤더 AccessToken(만료), RefreshToken를 헤더로
      refreshDio.options.headers['Authorization'] = '$refreshToken';

      // 토큰 갱신 API 요청
      final refreshResponse = await refreshDio.post('/login/refresh');

      if (refreshResponse.statusCode == 200) {
        final newAccessToken =
            await refreshResponse.headers['Authorization']![0];

        var exp = RegExp(r"((?:[^,]|, )+)");
        final Iterable<RegExpMatch> matches =
            await exp.allMatches(refreshResponse.headers["set-cookie"]![0]);

        for (final m in matches) {
          // 쿠키 한개에 대한 디코딩 처리
          Cookie refreshCookie = Cookie.fromSetCookieValue(m[0]!);
          var newRefresh = refreshCookie.value;
          final newRefreshToken = "Bearer " + newRefresh.substring(7);

          // 기기에 저장된 AccessToken과 RefreshToken 갱신
          await storage.write(key: 'ACCESS_TOKEN', value: newAccessToken);
          await storage.write(key: 'REFRESH_TOKEN', value: newRefreshToken);
        } // for
      } else {
        //refresh Token도 만료된 경우
        print(
            'Refresh Error--------------------------------------------------');
      }

      // AccessToken의 만료로 수행하지 못했던 API 요청에 담겼던 AccessToken 갱신
      error.requestOptions.headers['Authorization'] =
          await storage.read(key: 'ACCESS_TOKEN');

      // 수행하지 못했던 API 요청 복사본 생성
      final clonedRequest = await dio.request(error.requestOptions.path,
          options: Options(
              method: error.requestOptions.method,
              headers: error.requestOptions.headers),
          data: error.requestOptions.data,
          queryParameters: error.requestOptions.queryParameters);

      // API 복사본으로 재요청
      return handler.resolve(clonedRequest);
    }

    return handler.next(error);
  }));

  return dio;
}
