import "dart:convert";
import "package:dropdown_button2/custom_dropdown_button2.dart";
import "package:dropdown_button2/dropdown_button2.dart";
import "package:flutter/material.dart";
import "package:flutter_secure_storage/flutter_secure_storage.dart";
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:elib_project/auth_dio.dart';

final currentYear = DateTime.now().year;

String name = '';
String number = '';
String birth = '';
String authNumber = '';
bool isButtonPressed = false;

class NameAuthPage extends StatefulWidget {
  const NameAuthPage({Key? key}) : super(key: key);

  @override
  _NameAuthPageState createState() => _NameAuthPageState();
}

class _NameAuthPageState extends State<NameAuthPage> {
  // person class 생성자 생성
  final TextEditingController nameinputController = TextEditingController();
  final TextEditingController numberinputController = TextEditingController();
  final TextEditingController authinputController = TextEditingController();
  bool authcheck = false;

  void nameChange() {
    name = nameinputController.text;
  }

  void numberChange() {
    number = numberinputController.text;
  }

  void authChange() {
    authNumber = authinputController.text;
  }

  @override
  void initState() {
    super.initState();
    // myController에 리스너 추가
    nameinputController.addListener(nameChange);
    numberinputController.addListener(numberChange);
    authinputController.addListener(authChange);
  }

  // _MyCustomFormState가 제거될 때 호출
  @override
  void dispose() {
    // 텍스트에디팅컨트롤러를 제거하고, 등록된 리스너도 제거된다.
    nameinputController.dispose();
    numberinputController.dispose();
    authinputController.dispose();
    super.dispose();
  }

  // myController의 텍스트를 콘솔에 출력하는 메소드
  @override
  Widget build(BuildContext context) {
    double queryHeight = MediaQuery.of(context).size.height;
    double queryWidth = MediaQuery.of(context).size.width;
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: Scaffold(
          body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
              child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          top: queryHeight * 0.1, bottom: queryHeight * 0.02),
                      child: Image.asset('assets/image/eliblogo.png',
                          width: 100, height: 50),
                    ),
                    Container(
                      width: queryWidth * 0.9,
                      height: 2.0,
                      color: Colors.grey, // 원하는 색상으로 변경
                      margin: EdgeInsets.symmetric(vertical: 10.0),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                          queryWidth * 0.1, 0, queryWidth * 0.1, 0),
                      child: const Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "실명확인",
                              style: TextStyle(
                                color: Color.fromRGBO(57, 57, 57, 1),
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "회원가입을 완료하기 위해 실명 인증을 완료해주세요",
                              style: TextStyle(
                                color: Color.fromRGBO(87, 87, 87, 1),
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                              queryWidth * 0.1,
                              queryHeight * 0.05,
                              queryWidth * 0.01,
                              queryHeight * 0.01),
                          child: const Text(
                            "성명",
                            style: TextStyle(
                                color: Color.fromRGBO(57, 57, 57, 1),
                                fontSize: 15),
                          ),
                        ),
                        SizedBox(
                          height: queryHeight * 0.05,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(
                                queryWidth * 0.1, 0, queryWidth * 0.1, 0),
                            child: TextFormField(
                              autovalidateMode: AutovalidateMode.always,
                              controller: nameinputController,
                              decoration: const InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  borderSide:
                                      BorderSide(width: 1, color: Colors.grey),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  borderSide:
                                      BorderSide(width: 1, color: Colors.grey),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 5.0, horizontal: 10.0),
                                // 디자인 관련
                                border: OutlineInputBorder(), //테두리
                              ),
                              //변수 값 넣기
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                              queryWidth * 0.1,
                              queryHeight * 0.02,
                              queryWidth * 0.1,
                              queryHeight * 0.01),
                          child: const Text(
                            "생년월일",
                            style: TextStyle(
                                color: Color.fromRGBO(57, 57, 57, 1),
                                fontSize: 15),
                          ),
                        ),
                        SizedBox(
                            width: queryWidth,
                            height: queryHeight * 0.05,
                            child: Row(
                              children: [
                                Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        queryWidth * 0.1,
                                        0,
                                        queryWidth * 0.1,
                                        0),
                                    //년도 지정
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: queryWidth * 0.22,
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton2(
                                              isExpanded: true,
                                              items: itemsYear
                                                  .map((item) =>
                                                      DropdownMenuItem<String>(
                                                        value: item,
                                                        child: Text(
                                                          item,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.grey,
                                                          ),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ))
                                                  .toList(),
                                              value: selectedValueYear,
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedValueYear =
                                                      value as String;
                                                });
                                              },
                                              icon: const Icon(
                                                Icons.arrow_drop_down,
                                              ),
                                              //iconSize: 14,
                                              iconEnabledColor:
                                                  Color.fromRGBO(83, 83, 83, 1),
                                              iconDisabledColor: Colors.grey,
                                              //크기지정 크기지정크기지정크기지정크기지정크기지정크기지정크기지정크기지정크기지정크기지정크기지정
                                              //buttonWidth: 100,
                                              // buttonPadding:
                                              //     const EdgeInsets.only(
                                              //         left: 5, right: 5),
                                              buttonDecoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                  color: Colors.grey,
                                                ),
                                                color: Theme.of(context)
                                                    .scaffoldBackgroundColor,
                                              ),
                                              buttonElevation: 2,
                                              itemHeight: 50,
                                              itemPadding:
                                                  const EdgeInsets.only(
                                                      left: 14, right: 14),
                                              dropdownMaxHeight: 200,
                                              dropdownPadding: null,
                                              dropdownDecoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(14),
                                                //color: Colors.redAccent,
                                              ),
                                              dropdownElevation: 8,
                                              scrollbarRadius:
                                                  const Radius.circular(40),
                                              scrollbarThickness: 6,
                                              scrollbarAlwaysShow: true,
                                              offset: const Offset(0, 0),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: queryWidth * 0.01,
                                              right: queryWidth * 0.02),
                                          child: const Text(
                                            "년",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Color.fromRGBO(
                                                    57, 57, 57, 1),
                                                fontSize: 15),
                                          ),
                                        ),

                                        // 월 지정
                                        SizedBox(
                                          width: queryWidth * 0.2,
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton2(
                                              isExpanded: true,
                                              items: itemsMonth
                                                  .map((item) =>
                                                      DropdownMenuItem<String>(
                                                        value: item,
                                                        child: Text(
                                                          item,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.grey,
                                                          ),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ))
                                                  .toList(),
                                              value: selectedValueMonth,
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedValueMonth =
                                                      value as String;
                                                });
                                              },
                                              icon: const Icon(
                                                Icons.arrow_drop_down,
                                              ),
                                              //iconSize: 14,
                                              iconEnabledColor:
                                                  Color.fromRGBO(83, 83, 83, 1),
                                              iconDisabledColor: Colors.grey,
                                              // buttonWidth: 100,
                                              // buttonPadding: const EdgeInsets.only(
                                              //     left: 12, right: 14),
                                              buttonDecoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                  color: Colors.grey,
                                                ),
                                                color: Theme.of(context)
                                                    .scaffoldBackgroundColor,
                                              ),
                                              buttonElevation: 2,
                                              itemHeight: 50,
                                              itemPadding:
                                                  const EdgeInsets.only(
                                                      left: 14, right: 14),
                                              dropdownMaxHeight: 200,
                                              dropdownPadding: null,
                                              dropdownDecoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(14),
                                                //color: Colors.redAccent,
                                              ),
                                              dropdownElevation: 8,
                                              scrollbarRadius:
                                                  const Radius.circular(40),
                                              scrollbarThickness: 6,
                                              scrollbarAlwaysShow: true,
                                              offset: const Offset(-20, 0),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: queryWidth * 0.01,
                                              right: queryWidth * 0.02),
                                          child: const Text(
                                            "월",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Color.fromRGBO(
                                                    57, 57, 57, 1),
                                                fontSize: 15),
                                          ),
                                        ),

                                        // 일 지정
                                        SizedBox(
                                          width: queryWidth * 0.2,
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton2(
                                              isExpanded: true,
                                              items: itemsDay
                                                  .map((item) =>
                                                      DropdownMenuItem<String>(
                                                        value: item,
                                                        child: Text(
                                                          item,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.grey,
                                                          ),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ))
                                                  .toList(),
                                              value: selectedValueDay,
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedValueDay =
                                                      value as String;
                                                });
                                              },
                                              icon: const Icon(
                                                Icons.arrow_drop_down,
                                              ),
                                              //iconSize: 14,
                                              iconEnabledColor:
                                                  Color.fromRGBO(83, 83, 83, 1),
                                              iconDisabledColor: Colors.grey,
                                              buttonWidth: 100,
                                              buttonPadding:
                                                  const EdgeInsets.only(
                                                      left: 12, right: 14),
                                              buttonDecoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                  color: Colors.grey,
                                                ),
                                                color: Theme.of(context)
                                                    .scaffoldBackgroundColor,
                                              ),
                                              buttonElevation: 2,
                                              itemHeight: 50,
                                              itemPadding:
                                                  const EdgeInsets.only(
                                                      left: 14, right: 14),
                                              dropdownMaxHeight: 200,
                                              dropdownPadding: null,
                                              dropdownDecoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(14),
                                                //color: Colors.redAccent,
                                              ),
                                              dropdownElevation: 8,
                                              scrollbarRadius:
                                                  const Radius.circular(40),
                                              scrollbarThickness: 6,
                                              scrollbarAlwaysShow: true,
                                              offset: const Offset(-20, 0),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: queryWidth * 0.01),
                                          child: const Text(
                                            "일",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Color.fromRGBO(
                                                    57, 57, 57, 1),
                                                fontSize: 15),
                                          ),
                                        ),
                                      ],
                                    )),
                              ],
                            )),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                              queryWidth * 0.1,
                              queryHeight * 0.02,
                              queryWidth * 0.1,
                              queryHeight * 0.01),
                          child: const Text(
                            "핸드폰",
                            style: TextStyle(
                                color: Color.fromRGBO(57, 57, 57, 1),
                                fontSize: 15),
                          ),
                        ),
                        SizedBox(
                          height: queryHeight * 0.05,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(
                                queryWidth * 0.1, 0, queryWidth * 0.1, 0),
                            child: TextFormField(
                              controller: numberinputController,
                              decoration: const InputDecoration(
                                hintText: '휴대전화번호',
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  borderSide:
                                      BorderSide(width: 1, color: Colors.grey),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  borderSide:
                                      BorderSide(width: 1, color: Colors.grey),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 1.0, horizontal: 10.0),
                                // 디자인 관련
                                border: OutlineInputBorder(), //테두리
                              ),
                              keyboardType: TextInputType.phone, // 번호 자판 지정
                              //변수 값 넣기
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                              queryWidth * 0.1,
                              queryHeight * 0.03,
                              queryWidth * 0.1,
                              queryHeight * 0.01),
                          child: SizedBox(
                            height: queryHeight * 0.04,
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: TextFormField(
                                    autovalidateMode: AutovalidateMode.always,
                                    controller: authinputController,
                                    decoration: const InputDecoration(
                                      hintText: '인증번호',
                                      hintStyle: TextStyle(
                                        color: Colors.grey,
                                      ),
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
                                          vertical: 1.0, horizontal: 10.0),
                                      // 디자인 관련
                                      border: OutlineInputBorder(), //테두리
                                    ), //변수 값 넣기
                                  ),
                                ),
                                Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        queryWidth * 0.03,
                                        0,
                                        queryWidth * 0.03,
                                        0)),
                                Expanded(
                                    child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                      isButtonPressed
                                          ? Colors.blue
                                          : Colors.grey,
                                    ),
                                    textStyle:
                                        MaterialStateProperty.all<TextStyle>(
                                      TextStyle(color: Colors.white),
                                    ),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                  ),
                                  onPressed: () async {
                                    // 여기서 추가적인 작업 수행 가능
                                    if (isButtonPressed != true) {
                                      setState(() {
                                        isButtonPressed = true;
                                      });
                                      authNumbersendData(number);
                                    } else {
                                      authcheck =
                                          await configAuthsendData(authNumber);
                                      if (authcheck == true) {
                                        printmessage(context, 1);
                                      } else {
                                        printmessage(context, 2);
                                      }
                                    }
                                  },
                                  child: Text(
                                    isButtonPressed ? "인증확인" : "인증요청",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                              queryWidth * 0.1, 0, queryWidth * 0.1, 0),
                          child: SizedBox(
                              height: queryHeight * 0.1,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "개인정보 수집, 이용방침",
                                    style: TextStyle(
                                      color: Color.fromRGBO(113, 113, 113, 1),
                                    ),
                                  ),
                                  // Padding(
                                  //     padding: EdgeInsets.fromLTRB(
                                  //         queryWidth * 0.03,
                                  //         0,
                                  //         queryWidth * 0.1,
                                  //         0)),
                                  TextButton(
                                      onPressed: () {},
                                      child: Text(
                                        "확인하기",
                                        style: TextStyle(
                                            color:
                                                Color.fromRGBO(30, 83, 219, 1)),
                                      ))
                                ],
                              )),
                        ),
                        Center(
                          child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        const Color.fromRGBO(
                                            56, 174, 93, 1)), // 버튼의 배경색
                                textStyle: MaterialStateProperty.all<TextStyle>(
                                    const TextStyle(
                                        color: Colors.white)), // 버튼 안의 텍스트 스타일
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        10.0), // 버튼의 모서리를 둥글게 설정
                                  ),
                                ),
                              ),
                              onPressed: () {
                                if (name.length < 1 ||
                                    number.length < 1 ||
                                    authcheck == false) {
                                  printmessage(context, 3);
                                } else {
                                  birth =
                                      ('$selectedValueYear-$selectedValueMonth-$selectedValueDay');
                                  nameAuthsendData(name, number, birth);
                                }

                                // inputTextName = inputController.text;
                                // print(inputTextName);
                              },
                              child: const Text(
                                "회원가입",
                                style: TextStyle(color: Colors.white),
                              )),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          )),
        ),
      )),
    );
  }

  Future<dynamic> printmessage(BuildContext context, int check) {
    String message = '';
    if (check == 1) {
      message = '인증되었습니다';
    } else if (check == 2) {
      message = '인증번호를 다시 확인해주세요';
    } else if (check == 3) {
      message = '양식을 작성해주세요';
    }
    return showDialog(
        context: context,
        //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
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
            actions: <Widget>[
              TextButton(
                child: Text("확인"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }
}

String? selectedValueYear;
final List<String> itemsYear = List.generate(
  currentYear - (currentYear - 100),
  (index) => (currentYear - index).toString(),
);

String? selectedValueMonth;
final List<String> itemsMonth =
    List.generate(12, (index) => (index + 1).toString());

String? selectedValueDay;
final List<String> itemsDay =
    List.generate(31, (index) => (index + 1).toString());

Future<void> nameAuthsendData(
    String name, String f_number, String birth) async {
  final storage = FlutterSecureStorage();
  final accessToken = await storage.read(key: 'ACCESS_TOKEN');
  var dio = await authDio();
  dio.options.headers['Authorization'] = '$accessToken';
  final response = await dio.post('/api/v1/user/detail',
      data: jsonEncode({'name': name, 'phone': f_number, 'birth': birth}));
  if (response.statusCode == 200) {
    print(response.data);
  }
  // final headers = {'Authorization': token};
  // return response.body;
}

Future<void> authNumbersendData(String f_number) async {
  final storage = FlutterSecureStorage();
  final accessToken = await storage.read(key: 'ACCESS_TOKEN');
  var dio = await authDio();
  dio.options.headers['Authorization'] = '$accessToken';
  final response =
      await dio.post('/api/v1/user/sms', queryParameters: {'number': f_number});
  if (response.statusCode == 200) {
    print(response.data);
  }
}

Future<bool> configAuthsendData(String authNumber) async {
  final storage = FlutterSecureStorage();
  final accessToken = await storage.read(key: 'ACCESS_TOKEN');
  var dio = await authDio();
  dio.options.headers['Authorization'] = '$accessToken';
  final response =
      await dio.get('/api/v1/user/sms', queryParameters: {'code': authNumber});
  if (response.statusCode == 200) {
    print(response.data);
  }
  return response.data;
}
