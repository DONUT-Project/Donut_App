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

  String date = DateFormat("yyyy-MM-dd").format(DateTime.now());

  UserServerApi userServerApi = UserServerApi();
  DoneServerApi doneServerApi = DoneServerApi();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: height * 0.2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: FutureBuilder<UserResponse> (
                      future: userServerApi.getMyInfo(),
                      builder: (context, snapshot) {
                        if(snapshot.hasData == false) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }else {
                          return
                            Container(
                              margin: EdgeInsets.only(top: height * 0.2, right: 20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                              ),
                              width: width * 0.4,
                              height: width * 0.4,
                              child: Image.network(snapshot.data!.profileUrl),
                            );
                        }
                      },
                    ),
                  ),
                  Expanded(
                    child: Container(
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
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              width: 100,
              height: 50,
              child: RaisedButton(
                onPressed: () async {
                  await doneServerApi.writeDone("test", "test", true);
                },
                child: const Text(
                  '작성',
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                      color: Color(0xff2C2C2C)
                  ),
                ),
              ),
            ),
          ],
        ),
        Container(
          margin: EdgeInsets.only(top: height * 0.4),
          child: FutureBuilder<List<DoneResponse>> (
            future: doneServerApi.getMyDonesByWriteAt(date),
            builder: (context, snapshot) {
              if(snapshot.hasData == false) {
                return const Center(
                    child: CircularProgressIndicator()
                );
              }else {
                List<DoneResponse> list = snapshot.data!;

                if(snapshot.data!.isEmpty) {
                  return ListTile(
                    title: Text('List가 없습니다.')
                  );
                }else {
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
              }
            },
          ),
        )
      ],
    );
  }

}