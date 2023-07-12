import 'package:flutter/material.dart';
import 'package:flutter_application/User.dart';
import 'package:http/http.dart' as http; // http 패키지 추가

class NewPostPage extends StatelessWidget {
  TextEditingController controller = TextEditingController();
  TextEditingController controller2 = TextEditingController();

  Future<void> sendPostToServer(BuildContext context) async{
    String title = controller.text;
    String content = controller2.text;

    final url = Uri.parse('http://172.10.5.118:443/post_all/createpost');
    try{
      final response = await http.post(
        url,
        body:{'kakaoId': MyUser.copyKakaoId, 'title': title, 'contents': content}
      );

      if (response.statusCode == 200){
        Navigator.pop(context);
      }
    }catch(e){
      print("게시글 등록이 안 됐다는데!?!?!");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('전제 게시판 새 글 작성'),
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
            SizedBox(height: 16.0),
            TextField(
              controller: controller2,
              maxLines: 10,
              decoration: InputDecoration(
                labelText: '내용',
              ),
            ),
            SizedBox(height: 16.0),
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
