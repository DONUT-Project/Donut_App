import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SideMenuWidget extends StatelessWidget {
  String name, profileUrl;
  int kakaoId;

  SideMenuWidget(this.name, this.profileUrl, this.kakaoId);

  @override
  Widget build(BuildContext context) {
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
                  child: Image.asset('assets/images/splash.png'),
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
        ],
      ),
    );
  }
}