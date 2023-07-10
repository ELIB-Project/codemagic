import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // intl 패키지 추가

class EditInfoPage extends StatefulWidget {
  const EditInfoPage({super.key});
  @override
  _EditInfoPageState createState() => _EditInfoPageState();
}

class _EditInfoPageState extends State<EditInfoPage> {
  String phone_number = "010-2863-0882";
  late DateTime date;
  @override
  void initState() {
    super.initState();
    date = DateTime.now();
  }

  void updateDate(DateTime selectedDate) {
    setState(() {
      date = selectedDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double Query_fontSize = MediaQuery.of(context).size.width * 0.05;
    final double lineLength = MediaQuery.of(context).size.width * 0.7;
    return MaterialApp(
        theme: ThemeData(useMaterial3: true),
        home: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: () {
                Navigator.pop(context); // 뒤로가기 버튼 클릭 이벤트 처리
              },
            ),
            title: const Text(
              "회원 정보 수정",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: SafeArea(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                child: SizedBox(height: 20), // 여백 추가
              ),
              Expanded(
                  child: Column(
                children: [
                  Expanded(
                    child: Container(
                      width: 100,
                      height: 100,
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
                ],
              )),
              Expanded(
                  flex: 5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.1),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: MediaQuery.of(context).size.width *
                                          0.05),
                                  child: Text(
                                    "이메일",
                                    style: TextStyle(
                                        color:
                                            Color.fromRGBO(171, 171, 171, 1.0),
                                        fontSize: (Query_fontSize - 5)),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                Text(
                                  "elib@kakao.com",
                                  style: TextStyle(
                                      color: Color.fromRGBO(171, 171, 171, 1.0),
                                      fontSize: (Query_fontSize)),
                                ),
                              ],
                            )),
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "이름",
                                  style: TextStyle(
                                      color: Color.fromRGBO(171, 171, 171, 1.0),
                                      fontSize: (Query_fontSize - 5)),
                                  textAlign: TextAlign.left,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "@@@",
                                      style: TextStyle(
                                          color: Color.fromRGBO(
                                              171, 171, 171, 1.0),
                                          fontSize: (Query_fontSize)),
                                    ),
                                    Container(
                                      width: lineLength,
                                      height: 2.0,
                                      color: Colors.black, // 원하는 색상으로 변경
                                      margin:
                                          EdgeInsets.symmetric(vertical: 8.0),
                                    ),
                                  ],
                                ),
                              ],
                            )),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                      bottom: 0, // 아래쪽 여백을 0으로 설정
                                    ),
                                    child: Text(
                                      "휴대전화",
                                      style: TextStyle(
                                        color:
                                            Color.fromRGBO(171, 171, 171, 1.0),
                                        fontSize: (Query_fontSize - 5),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                          right: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.3,
                                        ),
                                        child: Text(
                                          phone_number,
                                          style: TextStyle(
                                            color: Color.fromRGBO(
                                                171, 171, 171, 1.0),
                                            fontSize: Query_fontSize,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          // 휴대전화 변경 페이지
                                        },
                                        icon: Icon(
                                            Icons.arrow_forward_ios_rounded),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "생년월일",
                                  style: TextStyle(
                                      color: Color.fromRGBO(171, 171, 171, 1.0),
                                      fontSize: (Query_fontSize - 5)),
                                  textAlign: TextAlign.left,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        final selectedDate =
                                            await showDatePicker(
                                          context:
                                              context, // 팝업으로 띄우기 때문에 context 전달
                                          initialDate:
                                              date, // 달력을 띄웠을 때 선택된 날짜. 위에서 date 변수에 오늘 날짜를 넣었으므로 오늘 날짜가 선택돼서 나옴
                                          firstDate: DateTime(1950), // 시작 년도
                                          lastDate: DateTime
                                              .now(), // 마지막 년도. 오늘로 지정하면 미래의 날짜는 선택할 수 없음
                                        );
                                        if (selectedDate != null) {
                                          updateDate(selectedDate);
                                        }
                                      },
                                      child: Text(
                                        DateFormat('yyyy-MM-dd')
                                            .format(date), // 날짜를 지정된 형식으로 포맷팅
                                        style: TextStyle(
                                            color: Color.fromRGBO(
                                                171, 171, 171, 1.0),
                                            fontSize: (Query_fontSize)),
                                      ),
                                    ),
                                    Container(
                                      width: lineLength,
                                      height: 2.0,
                                      color: Colors.black, // 원하는 색상으로 변경
                                      margin:
                                          EdgeInsets.symmetric(vertical: 8.0),
                                    ),
                                  ],
                                ),
                              ],
                            )),
                            Expanded(
                              flex: 1,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left:
                                            MediaQuery.of(context).size.width *
                                                0.25),
                                    child: ButtonBar(
                                      children: [
                                        ElevatedButton(
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                          Color>(
                                                      Colors.grey), // 회색 바탕색
                                              foregroundColor:
                                                  MaterialStateProperty.all<
                                                          Color>(
                                                      Colors.white), // 흰색 글씨
                                              shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10), // 모서리를 둥글게 함
                                                ),
                                              ),
                                            ),
                                            onPressed: () {},
                                            child: const Text('수정하기')) //
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  )),
            ],
          )),
        ));
  }
}
