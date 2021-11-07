import 'package:donut/screen/auth_screen.dart';
import 'package:donut/server/apis.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SideMenuWidget extends StatelessWidget {

  TextEditingController _editingController = TextEditingController();
  var friendApi = FriendServerApi();

  int kakaoId;

  SideMenuWidget({required this.kakaoId});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Image.asset('assets/image/donut_logo.png'),
                  width: 75,
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(top: 20),
                    child: const Text(
                      'Donut',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                        color: Color(0xff2C2C2C),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              ],
            ),
          ),
          /*const ListTile(
            title: Text(
              '알림설정',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 28,
                color: Color(0xff2C2C2C),
              ),
              textAlign: TextAlign.center,
            ),
            leading: Icon(
              Icons.notifications_rounded,
              size: 20,
              color: Color(0xff2F5DFB),
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 20),
                  child: const Text(
                    '친구 연결 알림',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                      color: Color(0xff2C2C2C),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 20),
                  child: Checkbox(
                    onChanged: (bool? value) {  },
                    value: ,
                  ),
                )
              ],
            ),
          )*/
          const ListTile(
            title: Text(
              '친구관리',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 24,
                color: Color(0xff2C2C2C),
              ),
              textAlign: TextAlign.center,
            ),
            leading: Icon(
              Icons.account_circle_rounded,
              size: 30,
              color: Color(0xff2c2c2c),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 20, top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  child: const Text(
                    '내 코드',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: Color(0xff2C2C2C),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: Text(
                    kakaoId.toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: Color(0xff2C2C2C),
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          ),
          Column(
            children: [
              Container(
                margin: const EdgeInsets.only(left: 20, top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 20),
                      child: const Text(
                        '친구 등록',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: Color(0xff2C2C2C),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                  width: width * 0.65,
                  height: 45,
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                  child: CupertinoTextField(
                    textAlignVertical: TextAlignVertical.top,
                    textInputAction: TextInputAction.done,
                    maxLines: 1,
                    textAlign: TextAlign.start,
                    controller: _editingController,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      color: Color(0xffF4F4F4),
                    ),
                    onSubmitted: (val) async {
                      friendApi.makeFriend(int.parse(val));
                    },
                    placeholder: '친구 코드를 입력하세요!',
                    placeholderStyle: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: Color(0xffD1D1D1)
                    ),
                    padding: const EdgeInsets.only(left: 10, top: 12),
                  )
              ),
            ],
          ),
          ListTile(
            title: const Text(
              '로그아웃',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 24,
                color: Color(0xff2C2C2C),
              ),
              textAlign: TextAlign.center,
            ),
            leading: const Icon(
              Icons.logout,
              size: 28,
              color: Color(0xff2c2c2c),
            ),
            onTap: () {
              showAnimatedDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return ClassicGeneralDialogWidget(
                      titleText: '로그아웃',
                      contentText: '정말 로그아웃 하시겠습니까?',
                      onPositiveClick: () async {
                        Fluttertoast.showToast(msg: "로그아웃 되었습니다!");
                        var s = await SharedPreferences.getInstance();
                        s.remove("accessToken");
                        s.remove("refreshToken");
                        s.remove("isLogin");
                        Navigator.pushAndRemoveUntil(context, PageTransition(child: AuthPage(), type: PageTransitionType.fade), (route) => false);
                      },
                      onNegativeClick: () {
                        Fluttertoast.showToast(msg: "취소");
                        Navigator.of(context).pop();
                      },
                      positiveText: '네..',
                      negativeText: '아니요!',
                      negativeTextStyle: const TextStyle(
                          color: Colors.red,
                          fontFamily: 'NotoSansKR',
                          fontWeight: FontWeight.w500,
                          fontSize: 16
                      ),
                      positiveTextStyle: const TextStyle(
                          color: Color(0xff2F5DFB),
                          fontFamily: 'NotoSansKR',
                          fontWeight: FontWeight.w500,
                          fontSize: 16
                      ),
                    );
                  }
              );
            },
          ),
          ListTile(
            title: const Text(
              '회원탈퇴',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 24,
                color: Color(0xff2C2C2C),
              ),
              textAlign: TextAlign.center,
            ),
            leading: const Icon(
              Icons.delete,
              size: 28,
              color: Color(0xff2c2c2c),
            ),
            onTap: () {
              showAnimatedDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return ClassicGeneralDialogWidget(
                      titleText: '회원탈퇴',
                      contentText: '정말 탈퇴 하시겠습니까?',
                      onPositiveClick: () async {
                        Fluttertoast.showToast(msg: "로그아웃 되었습니다!");
                        var s = await SharedPreferences.getInstance();
                        s.remove("accessToken");
                        s.remove("refreshToken");
                        s.remove("isLogin");
                        await
                        Navigator.pushAndRemoveUntil(context, PageTransition(child: AuthPage(), type: PageTransitionType.fade), (route) => false);
                      },
                      onNegativeClick: () {
                        Fluttertoast.showToast(msg: "취소");
                        Navigator.of(context).pop();
                      },
                      positiveText: '네..',
                      negativeText: '아니요!',
                      negativeTextStyle: const TextStyle(
                          color: Colors.red,
                          fontFamily: 'NotoSansKR',
                          fontWeight: FontWeight.w500,
                          fontSize: 16
                      ),
                      positiveTextStyle: const TextStyle(
                          color: Color(0xff2F5DFB),
                          fontFamily: 'NotoSansKR',
                          fontWeight: FontWeight.w500,
                          fontSize: 16
                      ),
                    );
                  }
              );
            },
          )
        ],
      ),
    );
  }
}