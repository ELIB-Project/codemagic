import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:elib_project/pages/edit_info_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../auth_dio.dart';

class GlobalData {
  static double queryWidth = 0.0;
  static double queryHeight = 0.0;
}

class MemberInvitePage extends StatefulWidget {
  const MemberInvitePage({super.key});

  @override
  State<MemberInvitePage> createState() => _MemberInvitePageState();
}

class _MemberInvitePageState extends State<MemberInvitePage> {
  final TextEditingController numberinputController = TextEditingController();
  String number = '';

  void numberChange() {
    number = numberinputController.text;
  }

  @override
  void initState() {
    super.initState();
    // myController에 리스너 추가

    numberinputController.addListener(numberChange);
  }

  // _MyCustomFormState가 제거될 때 호출
  @override
  void dispose() {
    // 텍스트에디팅컨트롤러를 제거하고, 등록된 리스너도 제거된다.

    numberinputController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    GlobalData.queryHeight = MediaQuery.of(context).size.height;
    GlobalData.queryWidth = MediaQuery.of(context).size.width;
    final double Query_fontSize =
        MediaQuery.of(context).size.width * 0.05; // 디바이스 너비에 따라 폰트 크기 계산
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () {
              Navigator.pop(context); // 뒤로가기 버튼 클릭 이벤트 처리
            },
          ),
          title: const Text(
            "구성원 초대",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          // 나머지 AppBar 설정
        ),
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
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
            GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: SingleChildScrollView(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                                GlobalData.queryWidth * 0.1,
                                GlobalData.queryHeight * 0.05,
                                GlobalData.queryWidth * 0.01,
                                GlobalData.queryHeight * 0.01),
                            child: const Text(
                              "전화번호",
                              style: TextStyle(
                                  color: Color.fromRGBO(57, 57, 57, 1),
                                  fontSize: 15),
                            ),
                          ),
                          SizedBox(
                            height: GlobalData.queryHeight * 0.05,
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(
                                  GlobalData.queryWidth * 0.1,
                                  0,
                                  GlobalData.queryWidth * 0.1,
                                  0),
                              child: TextField(
                                  controller: numberinputController,
                                  decoration: const InputDecoration(
                                    hintText: '핸드폰 번호를 입력하세요',
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                      borderSide: BorderSide(
                                          width: 1, color: Colors.grey),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                      borderSide: BorderSide(
                                          width: 1, color: Colors.grey),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 5.0, horizontal: 10.0),
                                    // 디자인 관련
                                    border: OutlineInputBorder(), //테두리
                                  ),
                                  keyboardType: TextInputType.phone, // 번호 자판 지정
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ]
                                  //변수 값 넣기
                                  ),
                            ),
                          ),
                          //분류 지정
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                                GlobalData.queryWidth * 0.1,
                                GlobalData.queryHeight * 0.05,
                                GlobalData.queryWidth * 0.01,
                                GlobalData.queryHeight * 0.01),
                            child: const Text(
                              "분류",
                              style: TextStyle(
                                  color: Color.fromRGBO(57, 57, 57, 1),
                                  fontSize: 15),
                            ),
                          ),
                          SizedBox(
                            height: GlobalData.queryHeight * 0.05,
                            child: Padding(
                                padding: EdgeInsets.fromLTRB(
                                    GlobalData.queryWidth * 0.1,
                                    0,
                                    GlobalData.queryWidth * 0.1,
                                    0),
                                child: RelationshipBulilder()),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: GlobalData.queryHeight * 0.4),
                            child: Center(
                              child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            const Color.fromRGBO(
                                                56, 174, 93, 1)), // 버튼의 배경색
                                    textStyle:
                                        MaterialStateProperty.all<TextStyle>(
                                            const TextStyle(
                                                color: Colors
                                                    .white)), // 버튼 안의 텍스트 스타일
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            10.0), // 버튼의 모서리를 둥글게 설정
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    if (number.length == 11) {
                                      memberInvite(number);
                                      printmessage(context, 1);
                                    } else if (number.length < 1) {
                                      printmessage(context, 2);
                                    } else if (number.length != 11) {
                                      printmessage(context, 3);
                                    }
                                  },
                                  child: const Text(
                                    "초대하기",
                                    style: TextStyle(color: Colors.white),
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> memberInvite(String inviteNumber) async {
  // 헤더에 access토큰 첨부를 위해 토큰 불러오기
  final storage = FlutterSecureStorage();
  final accessToken = await storage.read(key: 'ACCESS_TOKEN');
  var dio = await authDio();
  dio.options.headers['Authorization'] = '$accessToken';
  final response = await dio.post('/api/v1/family',
      data: jsonEncode({'phone': inviteNumber}));

  try {
    if (response.statusCode == 200) {
      print("요청 성공");
      return;
    }
  } catch (e) {
    print(e);
  }
}

class RelationshipBulilder extends StatefulWidget {
  const RelationshipBulilder({
    super.key,
  });

  @override
  _RelationshipState createState() => _RelationshipState();
}

class _RelationshipState extends State<RelationshipBulilder> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: GlobalData.queryWidth * 0.9,
      child: DropdownButtonHideUnderline(
        child: DropdownButton2(
          isExpanded: true,
          items: itemsRelationship
              .map((item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ))
              .toList(),
          value: selectedValueRelationship,
          onChanged: (value) {
            setState(() {
              selectedValueRelationship = value as String;
            });
          },
          icon: const Icon(
            Icons.arrow_drop_down,
          ),
          //iconSize: 14,
          iconEnabledColor: Color.fromRGBO(83, 83, 83, 1),
          iconDisabledColor: Colors.grey,
          // buttonWidth: 100,
          // buttonPadding: const EdgeInsets.only(
          //     left: 12, right: 14),
          buttonDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.grey,
            ),
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          buttonElevation: 2,
          itemHeight: 50,
          itemPadding: const EdgeInsets.only(left: 14, right: 14),
          dropdownMaxHeight: 200,
          dropdownPadding: null,
          dropdownDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            //color: Colors.redAccent,
          ),
          dropdownElevation: 8,
          scrollbarRadius: const Radius.circular(40),
          scrollbarThickness: 6,
          scrollbarAlwaysShow: true,
          offset: const Offset(0, 0),
        ),
      ),
    );
  }
}

String? selectedValueRelationship;
List<String> itemsRelationship = ['부모', '자녀', '친구', '기타'];

Future<dynamic> printmessage(BuildContext context, int check) {
  String message = '';
  if (check == 1) {
    message = '구성원 요청을 보냈습니다';
  } else if (check == 2) {
    message = '번호를 입력해 주세요';
  } else if (check == 3) {
    message = '번호가 올바르지 않습니다\n 다시 입력해 주세요';
  }
  return showDialog(
      context: context,
      //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          //Dialog Main Title
          // title: Column(
          //   children: <Widget>[
          //     Text("경고"),
          //   ],
          // ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                message,
              ),
            ],
          ),
          contentPadding: EdgeInsets.fromLTRB(0, 10.0, 0, 0), //왼 위 오 아
          actions: <Widget>[
            TextButton(
              child: Text("확인"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
          actionsPadding: EdgeInsets.only(bottom: 10.0),
        );
      });
}
