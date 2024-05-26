import 'package:dodo/components/m_state.dart';
import 'package:dodo/components/m_title.dart';
import 'package:dodo/components/m_todo.dart';
import 'package:dodo/const/colors.dart';
import 'package:dodo/screen/main2_screen.dart';
import 'package:dodo/screen/sea_screen.dart';
import 'package:dodo/screen/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dodo/screen/mypage.dart';
import 'package:dodo/screen/roomlist_screen.dart';

class mainPage extends StatefulWidget {
  final String? token;
  const mainPage({Key? key, this.token}) : super(key: key);
  @override
  State<mainPage> createState() => _mainPageState();
}

class _mainPageState extends State<mainPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;
  String? user_name = '거북이도도';
  int _main_idx = 0;
  PageController _pageController = PageController(initialPage: 0); // 여기서 초기화

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(
        () => setState(() => _selectedIndex = _tabController.index));
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return Scaffold(
      backgroundColor: LIGHTGREY,
      bottomNavigationBar: SizedBox(
        height: 60,
        child: Container(
          color: Colors.white,
          child: TabBar(
            indicatorColor: PRIMARY_COLOR,
            labelColor: PRIMARY_COLOR,
            unselectedLabelColor: Colors.black,
            controller: _tabController,
            tabs: [
              //탭 생성
              Tab(
                icon: Icon(
                  _selectedIndex == 0 ? Icons.home : Icons.home_outlined,
                  color: _selectedIndex == 0 ? PRIMARY_COLOR : Colors.black54,
                ),
                text: "홈",
              ),
              Tab(
                icon: Icon(
                  _selectedIndex == 1 ? Icons.water : Icons.water_outlined,
                  color: _selectedIndex == 1 ? PRIMARY_COLOR : Colors.black54,
                ),
                text: "바다",
              ),
              Tab(
                icon: Icon(
                  _selectedIndex == 2
                      ? Icons.door_front_door
                      : Icons.door_front_door_outlined,
                  color: _selectedIndex == 2 ? PRIMARY_COLOR : Colors.black54,
                ),
                text: "방",
              ),
              Tab(
                icon: Icon(
                  _selectedIndex == 3 ? Icons.search : Icons.search_outlined,
                  color: _selectedIndex == 3 ? PRIMARY_COLOR : Colors.black54,
                ),
                text: "검색",
              ),
              Tab(
                icon: Icon(
                  _selectedIndex == 4 ? Icons.person : Icons.person_outlined,
                  color: _selectedIndex == 4 ? PRIMARY_COLOR : Colors.black54,
                ),
                text: "개인",
              ),
            ],
          ),
        ),
      ),
      body: _selectedIndex == 0
          ? PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _main_idx = index;
                });
              },
              children: [
                _buildMainPageContent(context),
                main2Page(),
              ],
            )
          : _selectedIndex == 1
              ? seaPage()
              : _selectedIndex == 2
                  ? const RoomListPage()
                  : _selectedIndex == 3
                      ? const searchPage()
                      : const MyPage(),
    );
  }

  Widget _buildMainPageContent(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          m_title(),
          m_state(),
          const SizedBox(
            height: 20,
          ),
          const m_todo(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: LIGHTGREY,
                  ),
                  borderRadius:
                      _main_idx == 0 ? null : BorderRadius.circular(50),
                ),
                child: FloatingActionButton(
                  onPressed: () {
                    _main_idx = 0;
                    _pageController.jumpToPage(0);
                  },
                  backgroundColor: _main_idx == 0 ? DARKGREY : LIGHTGREY,
                  hoverColor: LIGHTGREY,
                  elevation: 0,
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: LIGHTGREY,
                  ),
                  borderRadius:
                      _main_idx == 0 ? null : BorderRadius.circular(50),
                ),
                child: FloatingActionButton(
                  onPressed: () {
                    _main_idx = 1;
                    _pageController.jumpToPage(1);
                  },
                  backgroundColor: _main_idx == 1 ? DARKGREY : Colors.white,
                  hoverColor: LIGHTGREY,
                  elevation: 0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
