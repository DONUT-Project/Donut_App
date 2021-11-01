import 'package:donut/server/apis.dart';
import 'package:donut/server/response.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DoneListPage extends StatefulWidget {
  @override
  _DoneListState createState() => _DoneListState();
}

class _DoneListState extends State<DoneListPage> {
  late SharedPreferences sharedPreferences;
  late UserResponse userResponse;

  String date = DateFormat("yyyy-MM-dd").format(DateTime.now());

  UserServerApi userServerApi = UserServerApi();
  DoneServerApi doneServerApi = DoneServerApi();

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

    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(top: height * 0.2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(top: height * 0.2, right: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                ),
                width: width * 0.4,
                height: width * 0.4,
                child: Image.network(userResponse.profileUrl),
              ),
              Container(
                child: TextButton(
                    onPressed: () async {
                      DateTime dateTime = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100)
                      ) ?? DateTime.now();

                      setState(() {
                        date = DateFormat("yyyy-MM-dd").format(dateTime);
                      });
                    },
                    child: Text(
                      date,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                          color: Color(0xff2C2C2C)
                      ),
                    ),
                ),
              ),
            ],
          ),
        ),
        Container(
          child: RaisedButton(
            onPressed: () async {
              await doneServerApi.writeDone("test", "test", true, sharedPreferences.getString("accessToken") ?? "");
            },
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: height * 0.4),
          child: FutureBuilder<List<DoneResponse>> (
            future: doneServerApi.getMyDonesByWriteAt(date, sharedPreferences.getString("accessToken") ?? ""),
            builder: (context, snapshot) {
              if(snapshot.hasData == false) {
                return const Center(
                    child: CircularProgressIndicator()
                );
              }else {
                List<DoneResponse> list = snapshot.data!;

                return Center(
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          '${list[index].title}\n${list[index].writeAt}',
                          style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: Color(0xff2C2C2C)
                          ),
                        ),
                        leading: const Icon(
                          Icons.check_circle_outline,
                          size: 20,
                          color: Color(0xff2C2C2C),
                        ),
                      );
                    },
                  ),
                );
              }
            },
          ),
        )
      ],
    );
  }

}