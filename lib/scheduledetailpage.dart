import 'package:flutter/material.dart';
import 'package:flutter_application/join.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_application/User.dart';


class ScheduleDetailPage extends StatefulWidget {
  final dynamic schedules;

  ScheduleDetailPage({required this.schedules});

  @override
  _ScheduleDetailPageState createState() => _ScheduleDetailPageState();
}

class _ScheduleDetailPageState extends State<ScheduleDetailPage> {
  final TextEditingController _commentController = TextEditingController();
  List<String> _names = [];
  String group = '';

  @override
  void initState() {
    super.initState();
    fetchComments();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void fetchComments() async {
    final scheduleId = widget.schedules['id'];
    final url = Uri.parse('http://172.10.5.118:443/schedule/getoneschedule');

    try {
      // print("!!!!!!!!!!!");
      final response = await http.post(
        url,
        body: {'scheduleId':scheduleId.toString(), 'kakaoId': MyUser.copyKakaoId },
      );
      // print("@@@@@@@@@@@@@@@@@");

      final tempjsonData = json.decode(response.body);
      group = tempjsonData['schedule']['group'].toString();
      if(group == '0'){
        group = '전체 분반';
      }
      else{
        group += '분반';
      }
      // if(group == 0){
      //   groupToString = '모든 분반';
      // }
      // else if
      // group == 0 ? groupToString = '모든 분반' : groupToString = "${group.toString()}분반";
      // print(tempjsonData);
      print(tempjsonData);
      final jsonData = tempjsonData['participants'];

      if (response.statusCode == 200) {
        print(jsonData);
        setState(() {
          for(int i = 0; i < jsonData.length; i++){
            _names.add(jsonData[i]['participantName']);
          }
        });
      }
    } catch (e) {
      print('Failed to fetch comments: $e');
    }
  }

  Future<void> attend() async{
    final url = Uri.parse('http://172.10.5.118:443/schedule/attend');

    try{
      final response = await http.post(
        url,
        body: {'kakaoId': MyUser.copyKakaoId, 'scheduleId': widget.schedules['id'].toString()}
      );
      if(response.statusCode == 200){

        showSnackBar(context, Text("참가하기가 신청되었습니다."));
      }
      else{
        showSnackBar(context, Text("이미 신청하셨습니다."));
      }
    }catch(e){
      print("참가하기 안 된대!!!!!");
    }
  }

  void cancel() async{
    final url = Uri.parse('http://172.10.5.118:443/schedule/attendcancel');

    try{
      final response = await http.post(
          url,
          body: {'kakaoId': MyUser.copyKakaoId, 'scheduleId': widget.schedules['id'].toString()}
      );
      if(response.statusCode == 200){

        showSnackBar(context, Text("일정이 취소되었습니다."));
      }
      else{
        showSnackBar(context, Text("취소 실패!!"));
      }
    }catch(e){
      print("취소도 안 돼!?!?!?!!?!!!!!");
    }
  }


  @override
  Widget build(BuildContext context) {
    final id = widget.schedules['id'];
    final title = widget.schedules['title'];
    final content = widget.schedules['contents'];
    final author = widget.schedules['authorName'];
    final timestamp = widget.schedules['dueDate'];

    // Parse the UTC timestamp
    final utcTimestamp = DateTime.parse(timestamp);

    // Convert to local time in South Korea
    final koreaTime = utcTimestamp.toLocal();

    // Format the local time as a string
    final formattedTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(koreaTime);

    return Scaffold(
      appBar: AppBar(
        title: Text('일정 상세보기'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$id. $title',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
            SizedBox(height: 8.0),
            Text(
              '내용: $content',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 8.0),
            Text(
              '쓰니: $author',
              style: TextStyle(color: Colors.grey[600]),
            ),
            SizedBox(height: 8.0),
            Text(
              '참여 가능 분반: $group',
              style: TextStyle(color: Colors.grey[600]),
            ),
            SizedBox(height: 8.0),
            Text(
              '마감: $formattedTime',
              style: TextStyle(fontSize: 16.0),
            ),

            SizedBox(height: 16.0),
            ElevatedButton(
                onPressed: (){
                  fetchComments();
              print("참가자 목록 클릭!");
            }, child: Text('참가자 목록')
            ),
            Expanded(
              child: _names.isNotEmpty
                  ? ListView.builder(
                itemCount: _names.length,
                  itemBuilder: (context, index){
                    final name = _names[index];

                    return Padding(
                      padding: EdgeInsets.only(bottom:5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 4.0),
                        ],
                      ),
                    );
                  },
              ) : Center(
                child: Text("참가자가 없습니다.")
              )
              ),
            SizedBox(height: 8.0),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(onPressed: (){
                  attend();
                }, child: Text('참가하기')),
                SizedBox(width: 10.0),
                ElevatedButton(onPressed: (){
                  cancel();
                }, child: Text('참가취소')),
              ],
            )
        ]
        ),
      ),
    );
  }
}
