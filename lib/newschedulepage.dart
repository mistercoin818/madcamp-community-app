import 'package:flutter/material.dart';
import 'package:flutter_application/User.dart';
import 'package:http/http.dart' as http; // http 패키지 추가

class NewSchedulePage extends StatefulWidget {

  @override
  State<NewSchedulePage> createState() => _NewSchedulePageState();
}

class _NewSchedulePageState extends State<NewSchedulePage> {
  TextEditingController controller = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  TextEditingController controller3 = TextEditingController();
  TextEditingController controller4 = TextEditingController();

  List<int> dropdownList = [0, 1, 2, 3, 4];
  int selectedDropdown = 1;

  Future<void> sendPostToServer(BuildContext context) async{
    String title = controller.text;
    String content = controller2.text;
    String duedate = controller3.text;
    String startdate = controller4.text;

    final url = Uri.parse('http://172.10.5.118:443/schedule/createschedule');
    try{
      final response = await http.post(
          url,
          body:{'kakaoId': MyUser.copyKakaoId, 'group': selectedDropdown.toString(), 'title': title, 'contents': content, 'dueDate': '2023-07-11T17:10:24.000Z', 'startDate': '2023-07-11T17:10:24.000Z'}
      );

      if (response.statusCode == 200){
        Navigator.pop(context);
      }
    }catch(e){
      print(e);
      print("게시글 등록이 안 됐다는데!?!?!");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('새 글 작성'),
        elevation: 0.0,
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: '제목',
              ),
            ),
            SizedBox(height: 5.0),
            Text('원하는 참가자 분반을 입력해 주세요.(분반 관계 없이 == 0)'),
            DropdownButton(
              value: selectedDropdown,
              items: dropdownList.map((int item) {
                return DropdownMenuItem<int>(
                  child: Text('$item'),
                  value: item,
                );
              }).toList(),
              onChanged: (dynamic value){
                setState((){
                  selectedDropdown = value;
                });
              },
            ),
            SizedBox(height: 5.0),
            TextField(
              controller: controller2,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: '내용',
              ),
            ),
            SizedBox(height: 5.0),
            // TextField(
            //   controller: controller3,
            //   decoration: InputDecoration(
            //     labelText: '마감 날짜(YYYYMMDD)',
            //   ),
            // ),
            // SizedBox(height: 5.0),
            // TextField(
            //   controller: controller4,
            //   decoration: InputDecoration(
            //     labelText: '시작 날짜(YYYYMMDD)',
            //   ),
            // ),
            // SizedBox(height: 5.0),
            ElevatedButton(
              onPressed: () {
                // 작성된 글을 서버에 전송하는 로직을 구현
                sendPostToServer(context);

              },
              child: Text('작성하기'),
            ),
          ],
        ),
      ),
    );
  }
}
