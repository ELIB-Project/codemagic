import 'dart:convert';
import 'package:elib_project/models/bottom_app_bar.dart';
import 'package:elib_project/pages/set_page.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:url_launcher/url_launcher.dart';

import '../auth_dio.dart';

class PlusPage extends StatelessWidget {
  const PlusPage({super.key, required String title});
  @override
  Widget build(BuildContext context) {
    // Future<Position> position = _getUserLocation();
    // position.then((value) {
    //   if (value != null) {
    //     double latitude = value.latitude;
    //     double longitude = value.longitude;
    //     sendUserLocation(latitude, longitude);
    //     print("Latitude: $latitude, Longitude: $longitude");
    //   } else {
    //     print("Failed to get the position.");
    //   }
    // }).catchError((error) {
    //   print("Error: $error");
    // });

    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
        ),
        body: Column(
          children: <Widget>[
            Image.asset(
              'assets/image/eliblogo.png',
              width: 95.95,
              height: 50,
            ),
            const Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: OutlinedCardExample(),
            ),
            Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: Container(
                    width: 500,
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1, // 그림자 확산 범위
                        blurRadius: 10, // 그림자 흐림 정도
                        offset: const Offset(0, -2), // 그림자 위치
                      )
                    ]),
                    child: const Divider(color: Colors.grey, thickness: 3.0))),
            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Text(
                    'more',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  )),
            ),
            Row(
              children: [
                Padding(padding: EdgeInsets.all(15)),
                Icon(Icons.link, size: 24),
                SizedBox(width: 10),
                InkWell(
                    onTap: () {
                      launchUrl(
                        Uri.parse('http://www.elibin.com'),
                      );
                    },
                    child: const Text(
                      'ELIB 바로가기',
                      style: TextStyle(fontSize: 18),
                    )),
              ],
            ),
            const Row(
              children: [
                Padding(padding: EdgeInsets.all(15)),
                Icon(Icons.help_outline, size: 24),
                SizedBox(width: 10),
                Text(
                  '도움말',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            // const Column(
            //   children: [
            //     Divider(
            //         color: Colors.grey, thickness: 2.0), // 바텀 네비게이션 바 위에 구분선 추가
            //     BulidBottomAppBar(),
            //   ],
            // ),
          ],
        ),
        bottomNavigationBar: const BulidBottomAppBar(),
      ),
    );
  }
}

class OutlinedCardExample extends StatelessWidget {
  const OutlinedCardExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Theme.of(context).colorScheme.outline,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        child: SizedBox(
          width: 350,
          height: 150,
          child: Row(
            children: [
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              const Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("@@@님"),
                    Text("010-1234-5678"),
                  ],
                ),
              ),
              Expanded(
                child: InkWell(
                    onTap: () {
                      _navigateToSettingPage(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                      ),
                      child: const Icon(
                        Icons.settings,
                        size: 50,
                        color: Colors.grey,
                      ),
                    )),
              ),
              const SizedBox(width: 10),
            ],
          ),
        ),
      ),
    );
  }
}

Future<String?> sendData(String data, String path) async {
  final httpsUri = Uri.http('test.elibtest.r-e.kr:8080', path, {'limit': '10'});
  http.Response res =
      await http.post(httpsUri, body: jsonEncode({'id': data.toString()}));
  return res.headers['authorization'];
}

void _navigateToSettingPage(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => SetPage(),
    ),
  );
}

// 위치정보 받아오는 함수 구현
Future<Position> _getUserLocation() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
}

Future<void> sendUserLocation(double lat, double lon) async {
  // 헤더에 access토큰 첨부를 위해 토큰 불러오기
  final storage = FlutterSecureStorage();
  final accessToken = await storage.read(key: 'ACCESS_TOKEN');
  var dio = await authDio();
  dio.options.headers['Authorization'] = '$accessToken';
  final response = await dio
      .patch('/api/v1/user/locate', queryParameters: {'lat': lat, 'lon': lon});

  if (response.statusCode == 200) {
    print(response.data);
  } else {
    throw Exception('fail');
  }
}
