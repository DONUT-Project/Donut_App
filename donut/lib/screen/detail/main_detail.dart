import 'package:donut/server/apis.dart';
import 'package:donut/server/response.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainDetailPage extends StatefulWidget {
  @override
  _MainDetailState createState() => _MainDetailState();
}

class _MainDetailState extends State<MainDetailPage> {
  late SharedPreferences sharedPreferences;
  late UserResponse userResponse;

  UserServerApi userServerApi = UserServerApi();

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        FutureBuilder<UserResponse> (
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
                      margin: EdgeInsets.only(top: height * 0.2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      width: width * 0.4,
                      height: width * 0.4,
                      child: Image.network(userResponse.profileUrl),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 40),
                      child: Text(
                        userResponse.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            color: Color(0xff2C2C2C)
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
    );
  }

}