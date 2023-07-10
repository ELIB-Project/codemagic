import 'package:flutter/material.dart';
import '../pages/home_page.dart';
import '../pages/membermanagement_page.dart';
import '../pages/plus_page.dart';
import '../pages/tool_manage.dart';

class BulidBottomAppBar extends StatelessWidget {
  const BulidBottomAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 5, // 그림자 확산 범위
              blurRadius: 10, // 그림자 흐림 정도
              offset: const Offset(0, -2), // 그림자 위치
            )
          ],
          border: Border(
            top: BorderSide(color: Colors.grey, width: 2.0), // 테두리 선 설정
          ),
        ),
        child: BottomAppBar(
          color: Colors.white,
          elevation: 1, //그림자 효과
          child: SizedBox(
            height: kBottomNavigationBarHeight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Expanded(
                  child: InkWell(
                    onTap: () {
                      _navigateToToolManagementPage(context);
                    },
                    child: const Column(
                      children: <Widget>[
                        Icon(
                          Icons.construction,
                        ),
                        Text("도구관리")
                      ],
                    ),
                  ),
                ),
                //훈련관리
                Expanded(
                  child: InkWell(
                    onTap: () {
                      _navigateToTrainingManagementPage(context);
                    },
                    child: const Column(
                      children: <Widget>[
                        Icon(
                          Icons.edit_document,
                        ),
                        Text("훈련관리")
                      ],
                    ),
                  ),
                ),
                //홈화면
                Expanded(
                  child: InkWell(
                    onTap: () {
                      _navigateToHomePage(context);
                    },
                    child: const Column(
                      children: <Widget>[
                        Icon(
                          Icons.home,
                        ),
                        Text("홈")
                      ],
                    ),
                  ),
                ),
                //구성원관리
                Expanded(
                  child: InkWell(
                    onTap: () {
                      _navigateToMemberManagementPage(context);
                    },
                    child: const Column(
                      children: <Widget>[
                        Icon(
                          Icons.groups,
                        ),
                        Text("구성원관리")
                      ],
                    ),
                  ),
                ),
                //더보기 페이지
                Expanded(
                  child: InkWell(
                    onTap: () {
                      _navigateToPlusPage(context);
                    },
                    child: const Column(
                      children: <Widget>[
                        Icon(
                          Icons.more_horiz,
                        ),
                        Text("더보기")
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void _navigateToToolManagementPage(BuildContext context) {
    // 도구관리 페이지
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => toolManagePage(
            // title: 'management',
            ),
      ),
    );
  }

  void _navigateToTrainingManagementPage(BuildContext context) {
    // TODO: 훈련관리 페이지로 화면 전환
    //  Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => TrainingPage(
    //       title: 'management',
    //     ),
    //   ),
    // );
  }

  void _navigateToHomePage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const HomePage(
            // title: 'home',
            ),
      ),
    );
  }

  void _navigateToMemberManagementPage(BuildContext context) {
    //구성원 관리
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MemberManagementPage(),
      ),
    );
  }

  void _navigateToPlusPage(BuildContext context) {
    // TODO: 더보기 페이지로 화면 전환
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlusPage(
          title: 'plus',
        ),
      ),
    );
  }
}
