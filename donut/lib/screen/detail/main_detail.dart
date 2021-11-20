import 'package:donut/server/apis.dart';
import 'package:donut/server/response.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class MainDetailPage extends StatefulWidget {
  @override
  _MainDetailState createState() => _MainDetailState();
}

class _MainDetailState extends State<MainDetailPage> {
  late SharedPreferences sharedPreferences;
  late UserResponse userResponse;

  var slidingController = PanelController();

  UserServerApi userServerApi = UserServerApi();
  FriendServerApi friendApi = FriendServerApi();

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return SlidingUpPanel(
      maxHeight: height,
      minHeight: height * 0.32,
      controller: slidingController,
      boxShadow: [],
      color: const Color(0xffD4B886),
      borderRadius: BorderRadius.circular(20),
      panel: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(

              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(top: 40, left: 30),
                child: const Text(
                  "친구목록",
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 25,
                      color: Colors.white
                  ),
                ),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(),
            child: FutureBuilder<List<UserResponse>> (
              future: friendApi.getMyFriends(),
              builder: (context, snapshot) {
                print("friends" + snapshot.data.toString());
                var item = snapshot.data ?? [];
                return GridView.builder(
                  shrinkWrap: true,
                  itemCount: item.length,
                  itemBuilder: (context, index) {
                    if(item.isEmpty) {
                      return const Center(
                        child: Text(
                          "친구가 없습니다.",
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                              color: Color(0xff2C2C2C)
                          ),
                        ),
                      );
                    }else {
                      return Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top: 20),
                                  width: width * 0.35,
                                  height: width * 0.35,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        image: NetworkImage(item[index].profileUrl),
                                        fit: BoxFit.fill
                                    )
                                  ),
                                ),
                                Container(
                                    margin: EdgeInsets.only(top: 15),
                                    child: Text(
                                      item[index].name,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 20,
                                          color: Colors.white
                                      ),
                                    )
                                )
                              ],
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          FutureBuilder<UserResponse> (
            future: userServerApi.getMyInfo(),
            builder: (context, snapshot) {
              if(snapshot.hasData == false) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }else {
                userResponse = snapshot.data!;
                return Center(
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: height * 0.08),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: NetworkImage(userResponse.profileUrl),
                                fit: BoxFit.fill
                            )
                        ),
                        width: width * 0.4,
                        height: width * 0.4,
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        child: Text(
                          userResponse.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                              color: Color(0xff2c2c2c)
                          ),
                        ),
                      )
                    ],
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
