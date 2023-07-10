import 'dart:async';
import 'dart:convert';
import 'dart:developer' show log;
import 'package:elib_project/auth_dio.dart';
import 'package:elib_project/pages/test_page_jh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:url_launcher/url_launcher.dart';

class GlobalData {
  static double queryWidth = 0.0;
  static double queryHeight = 0.0;
  static double lat = 0.0;
  static double lon = 0.0;
  static String updated = "";
}

class MemberInfoPage extends StatelessWidget {
  final int pageNum;
  final int userId;
  const MemberInfoPage({Key? key, required this.pageNum, required this.userId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    GlobalData.queryHeight = MediaQuery.of(context).size.height;
    GlobalData.queryWidth = MediaQuery.of(context).size.width;

    return FutureBuilder<LocationInfo>(
      future: loadFamilyLocation(userId),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          LocationInfo location = snapshot.data!;
          GlobalData.lat = location.lat;
          GlobalData.lon = location.lon;
          GlobalData.updated = location.updated;
          // 여기서 location 객체의 속성을 사용하여 필요한 작업을 수행할 수 있습니다.

          return MaterialApp(
            theme: ThemeData(
              scaffoldBackgroundColor: Colors.white,
              useMaterial3: true,
            ),
            home: DefaultTabController(
              initialIndex: pageNum,
              length: 4,
              child: Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back_ios_new_rounded),
                    onPressed: () {
                      Navigator.pop(context); // 뒤로가기 버튼 클릭 이벤트 처리
                    },
                  ),
                  title: Text(
                    "구성원 조회",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  bottom: PreferredSize(
                    preferredSize: Size.fromHeight(48),
                    child: Material(
                      child: Theme(
                        data: ThemeData().copyWith(splashColor: Colors.green),
                        child: const TabBar(
                          labelColor: Colors.black,
                          unselectedLabelColor: Color.fromRGBO(
                            171,
                            171,
                            171,
                            1,
                          ),
                          tabs: <Widget>[
                            Tab(
                              child: Text(
                                '도구 현황',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Tab(
                              child: Text(
                                '훈련 현황',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Tab(
                              child: Text(
                                '최근 위치',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Tab(
                              child: Text(
                                '긴급 연락',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                body: TabBarView(
                  children: <Widget>[
                    const Center(
                      child: Text("It's cloudy here"),
                    ),
                    const Center(
                      child: Text("It's rainy here"),
                    ),
                    const Center(
                      child: LocationBuildPage(),
                    ),
                    EmergencyCall(),
                  ],
                ),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class EmergencyCall extends StatelessWidget {
  const EmergencyCall({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(fit: StackFit.expand, children: [
      Container(
        width: GlobalData.queryWidth,
        height: GlobalData.queryHeight,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/image/eliblogo.png'),
            colorFilter: ColorFilter.matrix([
              // 희미한 효과를 주는 컬러 매트릭스
              0.1, 0, 0, 0, 0,
              0, 0.9, 0, 0, 0,
              0, 0, 0.1, 0, 0,
              0, 0, 0, 0.1, 0,
            ]),
          ),
        ),
      ),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
              GlobalData.queryWidth * 0.1,
              GlobalData.queryHeight * 0.03,
              GlobalData.queryWidth * 0.1,
              GlobalData.queryHeight * 0.03),
          child: const Text(
            "국가 기관",
            style: TextStyle(
                color: Color.fromRGBO(171, 171, 171, 1),
                fontWeight: FontWeight.bold),
          ),
        ),
        // 119 소방대원
        InkWell(
          onTap: () async {
            final url = Uri.parse('tel:119');
            if (await canLaunchUrl(url)) {
              launchUrl(url);
            } else {
              // ignore: avoid_print
              print("Can't launch $url");
            }
          },
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  height: GlobalData.queryHeight * 0.1, // 세로 크기 조정
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                    image: DecorationImage(
                        image: AssetImage('assets/image/firestationlogo.png'),
                        fit: BoxFit.fill),
                  ),
                ),
              ),
              const Expanded(
                  flex: 2,
                  child: Text(
                    '119',
                    style: TextStyle(
                        color: Color.fromRGBO(131, 131, 131, 1),
                        fontWeight: FontWeight.bold,
                        fontSize: 25),
                  )),
              const Expanded(
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 30,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        Padding(
            padding: EdgeInsets.fromLTRB(0, GlobalData.queryHeight * 0.02, 0,
                GlobalData.queryHeight * 0.02)),
        // 112 경찰
        InkWell(
          onTap: () async {
            final url = Uri.parse('tel:112');
            if (await canLaunchUrl(url)) {
              launchUrl(url);
            } else {
              // ignore: avoid_print
              print("Can't launch $url");
            }
          },
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  height: GlobalData.queryHeight * 0.1, // 세로 크기 조정
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                    image: DecorationImage(
                        image: AssetImage('assets/image/policelogo.png'),
                        fit: BoxFit.fill),
                  ),
                ),
              ),
              const Expanded(
                  flex: 2,
                  child: Text(
                    '112',
                    style: TextStyle(
                        color: Color.fromRGBO(131, 131, 131, 1),
                        fontWeight: FontWeight.bold,
                        fontSize: 25),
                  )),
              const Expanded(
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 30,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            top: GlobalData.queryHeight * 0.05,
          ),
          child: Divider(
              thickness: 1, height: 1, color: Color.fromRGBO(131, 131, 131, 1)),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(
              GlobalData.queryWidth * 0.1,
              GlobalData.queryHeight * 0.03,
              GlobalData.queryWidth * 0.1,
              GlobalData.queryHeight * 0.03),
          child: Text(
            "연락하기",
            style: TextStyle(
                color: Color.fromRGBO(171, 171, 171, 1),
                fontWeight: FontWeight.bold),
          ),
        ),
        InkWell(
          onTap: () {},
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  height: GlobalData.queryHeight * 0.1, // 세로 크기 조정
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                    image: DecorationImage(
                        image: AssetImage('assets/image/firestationlogo.png'),
                        fit: BoxFit.fill),
                  ),
                ),
              ),
              const Expanded(
                  flex: 2,
                  child: Text(
                    '전화걸기',
                    style: TextStyle(
                        color: Color.fromRGBO(131, 131, 131, 1),
                        fontWeight: FontWeight.bold,
                        fontSize: 25),
                  )),
              const Expanded(
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 30,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        Padding(
            padding: EdgeInsets.fromLTRB(0, GlobalData.queryHeight * 0.02, 0,
                GlobalData.queryHeight * 0.02)),
        // 112 경찰
        InkWell(
          onTap: () {},
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  height: GlobalData.queryHeight * 0.1, // 세로 크기 조정
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                    image: DecorationImage(
                        image: AssetImage('assets/image/policelogo.png'),
                        fit: BoxFit.fill),
                  ),
                ),
              ),
              const Expanded(
                  flex: 2,
                  child: Text(
                    '알림 보내기',
                    style: TextStyle(
                        color: Color.fromRGBO(131, 131, 131, 1),
                        fontWeight: FontWeight.bold,
                        fontSize: 25),
                  )),
              const Expanded(
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 30,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ]),
    ]);
  }
}

class LocationBuildPage extends StatefulWidget {
  const LocationBuildPage({Key? key}) : super(key: key);

  @override
  State<LocationBuildPage> createState() => LocationBuildPageState();
}

class LocationBuildPageState extends State<LocationBuildPage> {
  late NaverMapController _mapController;
  final Completer<NaverMapController> mapControllerCompleter = Completer();

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final pixelRatio = mediaQuery.devicePixelRatio;
    final mapSize = Size(mediaQuery.size.width, mediaQuery.size.height);
    final physicalSize =
        Size(mapSize.width * pixelRatio, mapSize.height * pixelRatio);

    print("physicalSize: $physicalSize");

    return Scaffold(
      backgroundColor: const Color(0xFF343945),
      body: Center(
          child: SizedBox(
              width: mapSize.width,
              height: mapSize.height,
              // color: Colors.greenAccent,
              child: _naverMapSection())),
    );
  }

  Widget _naverMapSection() => NaverMap(
        forceGesture: true,
        options: NaverMapViewOptions(
          initialCameraPosition: NCameraPosition(
              target: NLatLng(GlobalData.lat, GlobalData.lon),
              zoom: 18,
              bearing: 0,
              tilt: 0),
          indoorEnable: true,
          locationButtonEnable: true,
          consumeSymbolTapEvents: false,
          rotationGesturesEnable: true,
          scrollGesturesEnable: true,
          tiltGesturesEnable: true,
          zoomGesturesEnable: true,
          stopGesturesEnable: true,
          scrollGesturesFriction: 1.0,
          zoomGesturesFriction: 1.0,
        ),
        onMapReady: (controller) async {
          _mapController = controller;
          mapControllerCompleter.complete(controller);
          log("onMapReady", name: "onMapReady");
          _addMarker();
        },
      );
  void _addMarker() {
    final marker = NMarker(
      id: 'userPosition',
      position: NLatLng(GlobalData.lat, GlobalData.lon),
    );

    _mapController.addOverlay(marker);
    final onMarkerInfoWindow = NInfoWindow.onMarker(
        id: marker.info.id, text: '마지막 접속 일시: ${GlobalData.updated}');
    marker.openInfoWindow(onMarkerInfoWindow);
  }
}

// loadFamilyLocation(userId)
Future<LocationInfo> loadFamilyLocation(int id) async {
  // 헤더에 access토큰 첨부를 위해 토큰 불러오기
  final storage = FlutterSecureStorage();
  final accessToken = await storage.read(key: 'ACCESS_TOKEN');
  var dio = await authDio();
  dio.options.headers['Authorization'] = '$accessToken';
  final response = await dio.get('/api/v1/family/locate/$id');

  if (response.statusCode == 200) {
    return LocationInfo.fromJson(response.data);
  } else {
    throw Exception('fail');
  }
}

class LocationInfo {
  final double lat;
  final double lon;
  final String updated;
  LocationInfo({required this.lat, required this.lon, required this.updated});
  factory LocationInfo.fromJson(Map<String, dynamic> json) {
    return LocationInfo(
        lat: json['lat'], lon: json['lon'], updated: json['updated']);
  }
}
