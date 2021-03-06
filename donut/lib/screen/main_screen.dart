import 'package:donut/screen/detail/done_list_detail.dart';
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

  UserServerApi userServerApi = UserServerApi();
  bool? isComment, isFriend;

  final PageController _pageController = PageController(initialPage: 0);

  bool isPageMain = false;

  int? kakaoId;

  getUserInfo() async {
    UserResponse userResponse = await userServerApi.getMyInfo();
    kakaoId = userResponse.userId;
  }

  @override
  void initState() {
    setState(() {
      userServerApi.getMyInfo().then((value) {
        setState(() {
          kakaoId = value.userId;
          isComment = value.isComment;
          isFriend = value.isFriend;
        });
      });
    });
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
                  onPressed: () async {
                    Scaffold.of(context).openDrawer();
                  },
                  color: const Color(0xff2C2C2C),
                  iconSize: 35,
                ),
              )
          )
        ),
      ),
      drawer: SideMenuWidget(kakaoId: kakaoId ?? 0, isComment: isComment ?? true, isFriend: isFriend ?? true,),
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