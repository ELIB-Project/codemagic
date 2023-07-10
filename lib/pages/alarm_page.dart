import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../auth_dio.dart';
import '../models/bottom_app_bar.dart';

class AlarmPage extends StatefulWidget {
  const AlarmPage({super.key});

  @override
  State<AlarmPage> createState() => _AlarmPageState();
}

class GlobalData {
  static double queryWidth = 0.0;
  static double queryHeight = 0.0;
}

class _AlarmPageState extends State<AlarmPage> {
  @override
  Widget build(BuildContext context) {
    GlobalData.queryHeight = MediaQuery.of(context).size.height;
    GlobalData.queryWidth = MediaQuery.of(context).size.width;
    return MaterialApp(
        theme: ThemeData(
            scaffoldBackgroundColor: Colors.white, useMaterial3: true),
        home: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: () {
                Navigator.pop(context); // 뒤로가기 버튼 클릭 이벤트 처리
              },
            ),
            title: const Text(
              "알림",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: SafeArea(
            child: Column(children: [Expanded(child: AlarmListBuild(context))]),
          ),
          bottomNavigationBar: const BulidBottomAppBar(),
        ));
  }
}

Future<List<AlarmInfo>> getEntries() async {
  List<AlarmInfo> entries = await loadAlarmInfo();
  return entries;
}

Widget AlarmListBuild(BuildContext context) {
  return FutureBuilder<List<AlarmInfo>>(
    future: getEntries(), // entries를 얻기 위해 Future를 전달
    builder: (BuildContext context, AsyncSnapshot<List<AlarmInfo>> snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        // 데이터를 아직 받아오는 중이면 로딩 표시를 보여줌
        return const CircularProgressIndicator();
      } else if (snapshot.hasError) {
        // 데이터를 받아오는 도중 에러가 발생하면 에러 메시지를 보여줌
        return Text('Error: ${snapshot.error}');
      } else {
        // 데이터를 정상적으로 받아왔을 경우
        List<AlarmInfo> entries = snapshot.data!; // 해결된 데이터를 얻음

        return SizedBox(
          width: GlobalData.queryWidth,
          height: GlobalData.queryHeight,
          child: ListView.builder(
            itemCount: entries.length,
            itemBuilder: (BuildContext context, int index) {
              final reversedIndex = entries.length - 1 - index; // 인덱스를 거꾸로 계산
              String text = '';
              int type = entries[reversedIndex].type;
              if (type == 1) {
                text = '긴급알림';
              } else {
                text = entries[reversedIndex].date;
              }
              return SizedBox(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(GlobalData.queryWidth * 0.05,
                        0, GlobalData.queryWidth * 0.05, 0),
                    child: Row(
                      children: [
                        Visibility(
                          visible: type == 1, // 조건에 따라 아이콘 보이기/숨기기 설정
                          child: const Padding(
                            padding: EdgeInsets.only(right: 10.0),
                            child: Icon(
                              Icons.notifications_active_rounded,
                              color: Colors.red,
                            ),
                          ),
                        ),
                        Text(
                          text,
                          style: const TextStyle(
                            color: Color.fromRGBO(171, 171, 171, 1),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      if (type == 0) {
                        int? alarmType = await reseponseInviteAlarm(
                            context,
                            entries[reversedIndex].myName,
                            entries[reversedIndex].yourName);
                        if (alarmType != null) {
                          responseAlarmServer(
                              entries[reversedIndex].id, alarmType);
                        }
                        //responseAlarm(entries[reversedIndex].id, type);
                        //구성원 초대 알람
                      } else if (type == 1) {
                        reseponseEmergentcyAlarm(
                            context, entries[reversedIndex].yourName);
                        //긴급알림
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(GlobalData.queryWidth * 0.05,
                          0, GlobalData.queryWidth * 0.05, 0),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Container(
                              width: GlobalData.queryWidth * 0.1,
                              height: GlobalData.queryHeight * 0.1,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 1.0,
                                ),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.person,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              type == 2
                                  ? entries[reversedIndex].message
                                  : ('${entries[reversedIndex].yourName}${entries[reversedIndex].message}'),
                              style: const TextStyle(
                                  color: Color.fromRGBO(171, 171, 171, 1),
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ));
            },
          ),
        );
      }
    },
  );
}

Future<List<AlarmInfo>> loadAlarmInfo() async {
  // 헤더에 access토큰 첨부를 위해 토큰 불러오기
  final storage = FlutterSecureStorage();
  final accessToken = await storage.read(key: 'ACCESS_TOKEN');
  var dio = await authDio();
  dio.options.headers['Authorization'] = '$accessToken';
  final response = await dio.get('/api/v1/user/alarm');

  if (response.statusCode == 200) {
    List<dynamic> data = response.data;
    List<AlarmInfo> list =
        data.map((dynamic e) => AlarmInfo.fromJson(e)).toList();
    return list;
    // print(list?[i].name);
  } else {
    throw Exception('fail');
  }
}

class AlarmInfo {
  final int id;
  final int type;
  final String message;
  final bool checked; //내가 알람을 읽은지 안읽은지
  final String date;
  final String myName;
  final String yourName;
  AlarmInfo(
      {required this.id,
      required this.type,
      required this.message,
      required this.checked,
      required this.date,
      required this.myName,
      required this.yourName});

  factory AlarmInfo.fromJson(Map<String, dynamic> json) {
    return AlarmInfo(
        id: json['id'],
        type: json['type'],
        message: json['message'],
        checked: json['checked'],
        date: json['date'],
        myName: json['myName'],
        yourName: json['yourName']);
  }
}

Future<void> responseAlarmServer(int alarmId, int alarmtype) async {
  // 헤더에 access토큰 첨부를 위해 토큰 불러오기
  final storage = FlutterSecureStorage();
  final accessToken = await storage.read(key: 'ACCESS_TOKEN');
  var dio = await authDio();
  dio.options.headers['Authorization'] = '$accessToken';
  final response = await dio.patch(
    '/api/v1/family/invite/$alarmId/$alarmtype',
  );

  if (response.statusCode == 200) {
    print(response.data);
  } else {
    throw Exception('fail');
  }
}

Future<int?> reseponseInviteAlarm(
    BuildContext context, String myName, String yourName) async {
  final result = await showModalBottomSheet<int>(
    context: context,
    backgroundColor: Colors.white,
    builder: (BuildContext context) {
      return SizedBox(
        height: GlobalData.queryHeight * 0.45,
        width: GlobalData.queryWidth,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.close),
                ),
              ],
            ),
            const Text(
              '구성원 초대',
              style: TextStyle(
                  color: Color.fromRGBO(87, 87, 87, 1),
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: GlobalData.queryHeight * 0.03),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Column(
                        children: [
                          Container(
                            height: GlobalData.queryHeight * 0.1, // 세로 크기 조정
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
                          Text(
                            myName,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(131, 131, 131, 1)),
                          )
                        ],
                      ),
                    ),
                    const Center(
                        child: Icon(Icons.swap_horiz,
                            size: 60, color: Colors.grey)),
                    Expanded(
                      flex: 4,
                      child: Column(
                        children: [
                          Container(
                            height: GlobalData.queryHeight * 0.1, // 세로 크기 조정
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
                          Text(
                            yourName,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(131, 131, 131, 1)),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: GlobalData.queryHeight * 0.05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const Color.fromRGBO(56, 174, 93, 1),
                        // button의 모서리 둥근 정도를 바꿀 수 있음
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 0,
                      ),
                      child: const Text('수락하기'),
                      onPressed: () {
                        Navigator.pop(context, 1);
                      }),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const Color.fromRGBO(255, 92, 92, 1),
                        // button의 모서리 둥근 정도를 바꿀 수 있음
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 0,
                      ),
                      child: const Text('거절하기'),
                      onPressed: () {
                        Navigator.pop(context, 0);
                      }),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
  return result;
}

void reseponseEmergentcyAlarm(BuildContext context, String yourName) {
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.white,
    builder: (BuildContext context) {
      return SizedBox(
        height: GlobalData.queryHeight * 0.45,
        width: GlobalData.queryWidth,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.close),
                ),
              ],
            ),
            const Text(
              '긴급알람',
              style: TextStyle(
                  color: Color.fromRGBO(87, 87, 87, 1),
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: GlobalData.queryHeight * 0.03),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Container(
                          height: GlobalData.queryHeight * 0.1, // 세로 크기 조정
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
                        Text(
                          yourName,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(131, 131, 131, 1)),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: GlobalData.queryHeight * 0.05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const Color.fromRGBO(240, 212, 63, 1),
                        // button의 모서리 둥근 정도를 바꿀 수 있음
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 0,
                      ),
                      child: const Text('마지막 위치 확인'),
                      onPressed: () {
                        Navigator.pop(context, 1);
                      }),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const Color.fromRGBO(255, 92, 92, 1),
                        // button의 모서리 둥근 정도를 바꿀 수 있음
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 0,
                      ),
                      child: const Text('전화 연결'),
                      onPressed: () {
                        Navigator.pop(context, 0);
                      }),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}
