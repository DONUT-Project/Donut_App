import 'package:donut/screen/detail/done_list_detail.dart';
import 'package:donut/screen/detail/main_detail.dart';
import 'package:donut/server/apis.dart';
import 'package:donut/server/response.dart';
import 'package:donut/side_menu/side_menu_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'detail/done_detail.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  UserServerApi userServerApi = UserServerApi();

  final PageController _pageController = PageController(initialPage: 0);

  bool isPageMain = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xffffffff),
        toolbarHeight: 60,
        centerTitle: false,
        title: const Text(
            "My Donut",
          style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 26,
              color: Color(0xff2C2C2C)
          ),
        ),
        titleSpacing: 15,
        leading: Container(
          child: Builder(
              builder: (context) => Container(
                margin: const EdgeInsets.only(left: 10),
                child: IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                  color: const Color(0xff2C2C2C),
                  iconSize: 35,
                ),
              )
          )
        ),
      ),
      drawer: SideMenuWidget(),
      body: PageView(
        controller: _pageController,
        children: [
          MainDetailPage(),
          DoneListPage()
        ],
      ),
    );
  }
}