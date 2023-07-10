import 'package:elib_project/pages/edit_info_page.dart';
import 'package:flutter/material.dart';

class SetPage extends StatelessWidget {
  const SetPage({super.key});

  @override
  Widget build(BuildContext context) {
    final double Query_fontSize =
        MediaQuery.of(context).size.width * 0.05; // 디바이스 너비에 따라 폰트 크기 계산
    return MaterialApp(
        theme: ThemeData(useMaterial3: true),
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
              "설정",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            // 나머지 AppBar 설정
          ),
          body: SafeArea(
            minimum: EdgeInsets.only(left: 20.0),
            child: Column(
              children: [
                Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            flex: 1,
                            child: Text(
                              "내정보",
                              style: TextStyle(
                                  color: Color.fromRGBO(171, 171, 171, 1.0),
                                  fontSize: (Query_fontSize - 5)),
                            )),
                        Expanded(
                            flex: 3,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "연동 계정 관리",
                                  style: TextStyle(
                                      color: Color.fromRGBO(131, 131, 131, 1.0),
                                      fontWeight: FontWeight.bold,
                                      fontSize: Query_fontSize),
                                ),
                                IconButton(
                                    padding: EdgeInsets.only(right: 10.0),
                                    onPressed: () {
                                      //연동계정관리페이지로 넘김
                                    },
                                    icon: Icon(Icons.arrow_forward_ios_rounded))
                              ],
                            )),
                        Expanded(
                            flex: 2,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "회원 정보 수정",
                                  style: TextStyle(
                                      color: Color.fromRGBO(131, 131, 131, 1.0),
                                      fontWeight: FontWeight.bold,
                                      fontSize: Query_fontSize),
                                ),
                                IconButton(
                                    padding: EdgeInsets.only(right: 10.0),
                                    onPressed: () {
                                      //회원정보수정페이지로 넘김
                                      _navigateToEditInfoPage(context);
                                    },
                                    icon: Icon(Icons.arrow_forward_ios_rounded))
                              ],
                            )),
                      ],
                    )),
                Expanded(
                    flex: 4,
                    child: Column(
                      children: [
                        Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: SizedBox(),
                                ),
                                Text("설정",
                                    style: TextStyle(
                                        color:
                                            Color.fromRGBO(171, 171, 171, 1.0),
                                        fontSize: (Query_fontSize - 5))),
                                Expanded(
                                    flex: 1,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "알림설정",
                                          style: TextStyle(
                                              color: Color.fromRGBO(
                                                  131, 131, 131, 1.0),
                                              fontWeight: FontWeight.bold,
                                              fontSize: Query_fontSize),
                                        ),
                                        IconButton(
                                            padding:
                                                EdgeInsets.only(right: 10.0),
                                            onPressed: () {
                                              //알림설정페이지로 전환환
                                            },
                                            icon: Icon(Icons
                                                .arrow_forward_ios_rounded))
                                      ],
                                    )),
                                Expanded(
                                    flex: 1,
                                    child: InkWell(
                                      onTap: () {
                                        //로그아웃 페이지로이동
                                        LogOutBottonSheet(context);
                                      },
                                      child: Row(
                                        children: [
                                          Text(
                                            "로그아웃",
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    131, 131, 131, 1.0),
                                                fontWeight: FontWeight.bold,
                                                fontSize: Query_fontSize),
                                          ),
                                        ],
                                      ),
                                    )),
                                Expanded(
                                    flex: 1,
                                    child: InkWell(
                                      onTap: () {
                                        //회원탈퇴 페이지로이동
                                      },
                                      child: Row(
                                        children: [
                                          Text(
                                            "회원탈퇴",
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    131, 131, 131, 1.0),
                                                fontWeight: FontWeight.bold,
                                                fontSize: Query_fontSize),
                                          ),
                                        ],
                                      ),
                                    )),
                                Expanded(
                                  flex: 7,
                                  child: Container(), // 하단 공간을 차지하는 빈 컨테이너
                                ),
                              ],
                            )),
                      ],
                    )),
              ],
            ),
          ),
        ));
  }

//로그아웃 BottomSheet
  void LogOutBottonSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 300,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(flex: 1, child: Container()),
                const Expanded(
                    flex: 1,
                    child: Text(
                      '로그아웃 하시겠습니까?',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    )),
                Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(flex: 1, child: Container()),
                        Expanded(
                            flex: 3,
                            child: Container(
                              child: ElevatedButton(
                                child: const Text('예'),
                                onPressed: () => Navigator.pop(context),
                              ),
                            )),
                        Expanded(flex: 1, child: Container()),
                        Expanded(
                            flex: 3,
                            child: Container(
                              child: ElevatedButton(
                                child: const Text('아니오'),
                                onPressed: () => Navigator.pop(context),
                              ),
                            )),
                        Expanded(flex: 1, child: Container()),
                      ],
                    )),
                Expanded(flex: 1, child: Container()),
              ],
            ),
          ),
        );
      },
    );
  }
}

void _navigateToEditInfoPage(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => EditInfoPage(),
    ),
  );
}
