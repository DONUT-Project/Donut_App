import 'package:donut/screen/detail/main_detail.dart';
import 'package:donut/server/apis.dart';
import 'package:donut/server/response.dart';
import 'package:donut/side_menu/side_menu_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late SharedPreferences sharedPreferences;
  late UserResponse userResponse;

  UserServerApi userServerApi = UserServerApi();

  PageController _pageController = PageController(initialPage: 0);

  _init() async {
    sharedPreferences = await SharedPreferences.getInstance();
    userResponse = (await userServerApi.getMyInfo(sharedPreferences.getString("accessToken") ?? ""))!;
  }

  @override
  void initState() {
    _init();
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
        titleSpacing: 0,leading: Container(
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
          )),
      ),
      drawer: SideMenuWidget(userResponse.name, userResponse.profileUrl, userResponse.userId),
      body: SingleChildScrollView(
        child: PageView(
          controller: _pageController,
          children: [
            MainDetailPage(),

          ],
        ),
      ),
    );
  }
}