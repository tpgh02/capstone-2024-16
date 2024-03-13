import 'package:dodo/components/m_state.dart';
import 'package:dodo/components/m_title.dart';
import 'package:dodo/components/m_todo.dart';
import 'package:dodo/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class mainPage extends StatefulWidget {
  const mainPage({super.key});

  @override
  State<mainPage> createState() => _mainPageState();
}

class _mainPageState extends State<mainPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;
  String? user_name = '거북이도도';
  //List? user_romm;

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return Scaffold(
      backgroundColor: LIGHTGREY,
      bottomNavigationBar: SizedBox(
        height: 60,
        child: TabBar(
          indicatorColor: PRIMARY_COLOR,
          labelColor: Colors.black,
          controller: _tabController,
          tabs: [
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
      body: _selectedIndex == 0
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                //color: Colors.black,
                child: Column(
                  children: [
                    m_title('$user_name'),
                    const m_state("목표까지 얼마 안남았어요!"),
                    const SizedBox(
                      height: 20,
                    ),
                    m_todo()
                  ],
                ),
              ),
            )
          : _selectedIndex == 1
              ? Text("2")
              : _selectedIndex == 2
                  ? Text("3")
                  : _selectedIndex == 3
                      ? Text("4")
                      : Text("5"),
    );
  }
}
