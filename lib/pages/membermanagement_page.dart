import "dart:convert";
import "package:elib_project/pages/alarm_page.dart";
import "package:elib_project/pages/member_info_page.dart";
import "package:elib_project/pages/member_invite_page.dart";
import "package:flutter_secure_storage/flutter_secure_storage.dart";
import 'package:http/http.dart' as http;
import "package:flutter/material.dart";
import "package:kakao_flutter_sdk/kakao_flutter_sdk.dart";
import "../auth_dio.dart";
import "../models/bottom_app_bar.dart";
import 'package:elib_project/auth_dio.dart';

class GlobalData {
  static double queryWidth = 0.0;
  static double queryHeight = 0.0;
}

class MemberManagementPage extends StatefulWidget {
  const MemberManagementPage({
    Key? key,
  }) : super(key: key);

  @override
  _MemberManagementPageState createState() => _MemberManagementPageState();
}

class _MemberManagementPageState extends State<MemberManagementPage> {
  List<String> entries = <String>[];

  @override
  Widget build(BuildContext context) {
    GlobalData.queryHeight = MediaQuery.of(context).size.height;
    GlobalData.queryWidth = MediaQuery.of(context).size.width;
    // 여기에 위젯을 구성하는 코드를 작성합니다.
    // 예: Scaffold, Column, ListView 등을 사용하여 화면을 구성합니다.
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title:
              Title(color: Color.fromRGBO(87, 87, 87, 1), child: Text("구성원관리")),
          actions: [
            IconButton(
              icon: Icon(Icons.send),
              onPressed: () {
                _navigateToInvitePage(context);
              },
            ),
            IconButton(
              icon: Icon(Icons.notifications_none),
              onPressed: () {
                _navigateToAlarmPage(context);
              },
            ),
          ],
        ),
        body: SafeArea(
            child: Column(
          children: [
            Container(
              height: 2.0,
              color: Color.fromRGBO(171, 171, 171, 0.5),
            ),
            Expanded(child: ListBuild(context)),
          ],
        )),
        bottomNavigationBar: const BulidBottomAppBar(),
        extendBodyBehindAppBar: true, // AppBar가 배경 이미지를 가리지 않도록 설정
      ),
    );
  }
}

Future<List<familyName>> getEntries() async {
  List<familyName> entries = await loadFamilyInfo();
  return entries;
}

Widget ListBuild(BuildContext context) {
  return FutureBuilder<List<familyName>>(
    future: getEntries(), // entries를 얻기 위해 Future를 전달
    builder: (BuildContext context, AsyncSnapshot<List<familyName>> snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        // 데이터를 아직 받아오는 중이면 로딩 표시를 보여줌
        return CircularProgressIndicator();
      } else if (snapshot.hasError) {
        // 데이터를 받아오는 도중 에러가 발생하면 에러 메시지를 보여줌
        return Text('Error: ${snapshot.error}');
      } else {
        // 데이터를 정상적으로 받아왔을 경우
        List<familyName> entries = snapshot.data!; // 해결된 데이터를 얻음

        return Container(
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
          child: ListView.separated(
            padding: const EdgeInsets.all(8),
            itemCount: entries.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                //color: const Color.fromARGB(255, 230, 229, 228),
                child: Center(
                  child: OutlinedCardExample(
                    username: index,
                    entries: entries, // entries 전달
                  ),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
          ),
        );
      }
    },
  );
}

class OutlinedCardExample extends StatelessWidget {
  final int username;
  final List<familyName> entries; // entries 변수 추가
  const OutlinedCardExample({
    Key? key,
    required this.username,
    required this.entries, // 생성자에 entries 추가
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: GlobalData.queryWidth,
        height: GlobalData.queryHeight * 0.2,
        child: InkWell(
          onTap: () => showDetail(context),
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
              Expanded(
                  flex: 2,
                  child: Text(
                    '${entries[username].name}님',
                    style: const TextStyle(
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
      ),
    );
  }

  Future<String?> showDetail(BuildContext context) {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white, // 배경색 지정
          title: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end, // 오른쪽 정렬
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.close),
                  ),
                ],
              ),
              Column(
                children: [
                  Container(
                    height: GlobalData.queryHeight * 0.1,
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
                    '${entries[username].name}님',
                  )
                ],
              ),
            ],
          ),
          content: SizedBox(
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height * 0.33,
            child: Column(
              children: <Widget>[
                InkWell(
                  onTap: () {
                    _navigateToMemberInfoPage(context, 0, entries[username].id);
                  },
                  child: ListTile(
                    //leading. 타일 앞에 표시되는 위젯. 참고로 타일 뒤에는 trailing 위젯으로 사용 가능
                    leading: Icon(Icons.construction),
                    title: Text(
                      '재난도구 보유 현황',
                      style: TextStyle(
                          color: Color.fromRGBO(131, 131, 131, 1),
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    _navigateToMemberInfoPage(context, 1, entries[username].id);
                  },
                  child: ListTile(
                    leading: Icon(
                      Icons.edit_document,
                    ),
                    title: Text(
                      '재난훈련 이수 현황',
                      style: TextStyle(
                          color: Color.fromRGBO(131, 131, 131, 1),
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    _navigateToMemberInfoPage(context, 2, entries[username].id);
                  },
                  child: ListTile(
                    leading: Icon(Icons.place_outlined),
                    title: Text(
                      '최근 위치 정보',
                      style: TextStyle(
                          color: Color.fromRGBO(131, 131, 131, 1),
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    _navigateToMemberInfoPage(context, 3, entries[username].id);
                  },
                  child: ListTile(
                    leading: Icon(Icons.phone),
                    title: Text(
                      '긴급연락',
                      style: TextStyle(
                          color: Color.fromRGBO(131, 131, 131, 1),
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Center(
              child: ElevatedButton(
                onPressed: () {
                  print('Elevated button');
                },
                child: Text('구성원 삭제'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Color.fromRGBO(255, 92, 92, 1.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 0.0,
                ),
              ),
            )
          ],
        );
      },
    );
  }
}

Future<List<familyName>> loadFamilyInfo() async {
  // 헤더에 access토큰 첨부를 위해 토큰 불러오기
  final storage = FlutterSecureStorage();
  final accessToken = await storage.read(key: 'ACCESS_TOKEN');
  var dio = await authDio();
  dio.options.headers['Authorization'] = '$accessToken';
  final response = await dio.get('/api/v1/family/all');

  if (response.statusCode == 200) {
    List<dynamic> data = response.data;
    List<familyName> list =
        data.map((dynamic e) => familyName.fromJson(e)).toList();
    return list;
    // print(list?[i].name);
  } else {
    throw Exception('fail');
  }
}

class familyName {
  final String name;
  final int id;
  familyName({required this.name, required this.id});

  factory familyName.fromJson(Map<String, dynamic> json) {
    return familyName(name: json['name'], id: json['id']);
  }
}

void _navigateToInvitePage(BuildContext context) {
  // TODO: 더보기 페이지로 화면 전환
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => MemberInvitePage(),
    ),
  );
}

void _navigateToAlarmPage(BuildContext context) {
  // TODO: 더보기 페이지로 화면 전환
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => AlarmPage(),
    ),
  );
}

void _navigateToMemberInfoPage(BuildContext context, int pageNum, int id) {
  // TODO: 더보기 페이지로 화면 전환
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => MemberInfoPage(pageNum: pageNum, userId: id),
    ),
  );
}
