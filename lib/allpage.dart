import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application/User.dart';
import 'package:flutter_application/postdetailpage.dart';
import 'package:flutter_application/profile2page.dart';
import 'package:flutter_application/profiledata.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:flutter_application/newpostpage.dart';

class AllPage extends StatefulWidget {
  final dynamic jsonData;

  AllPage(this.jsonData);

  @override
  _AllPageState createState() => _AllPageState();
}

class _AllPageState extends State<AllPage> {
  List<dynamic> posts = [];

  @override
  void initState() {
    super.initState();
    posts = widget.jsonData;
  }

  Future<void> fetchDataAndNavigateToProfilePage(BuildContext context) async {
    final url = Uri.parse('http://172.10.5.118:443/profile/getuserinfo');

    try {
      final response = await http.post(url, body: {'kakaoId': MyUser.copyKakaoId});

      if (response.statusCode == 200) {
        final jjsonData = json.decode(response.body);
        final jsonData = jjsonData['user'];
        print(jsonData);
        MyProfile.linkedinAcct = jsonData['linkedinAcct'];
        MyProfile.profileImg = jsonData['profileImg'];
        MyProfile.userName = jsonData['userName'];
        MyProfile.nickname = jsonData['nickname'];
        MyProfile.school = jsonData['school'];
        MyProfile.studentId = jsonData['studentId'];
        MyProfile.group = jsonData['group'];
        MyProfile.githubAcct = jsonData['githubAcct'];
        MyProfile.instaAcct = jsonData['instaAcct'];


        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Profile2Page(data: MyProfile)),
        ).then((_) {
          // 프로필 페이지에서 돌아올 때 데이터를 업데이트합니다.
          setState(() {});
        });
      }
    } catch (e) {
      print("프로필 페이지로 이동하지 못했습니다!");
    }

  }

  void navigateToNewPostPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NewPostPage()),
    ).then((_) {
      // 새 글 작성 페이지에서 돌아올 때 데이터를 업데이트합니다.
      setState(() {});
    });
  }

  void navigateToPostDetailPage(BuildContext context, dynamic post) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PostDetailPage(post: post)),
    ).then((_) {
      // 게시글 상세 페이지에서 돌아올 때 데이터를 업데이트합니다.
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('전체 게시판'),
        elevation: 0.0,
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            onPressed: () => navigateToNewPostPage(context),
            icon: Icon(Icons.add),
          ),
          IconButton(
            onPressed: () {
              print("Search button is clicked");
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[posts.length - 1 - index]; // 역순으로 가져오기
          final id = post['id'];
          final title = post['title'];
          final content = post['contents'];
          final author = post['authorName'];
          final timestamp = post['createdAt'];

          // Parse the UTC timestamp
          final utcTimestamp = DateTime.parse(timestamp);

          // Convert to local time in South Korea
          final koreaTime = utcTimestamp.toLocal();

          // Format the local time as a string
          final formattedTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(koreaTime);

          // Truncate the content to 10 characters
          final truncatedContent = content.length > 10 ? content.substring(0, 10) + '...' : content;

          return InkWell(
            onTap: () => navigateToPostDetailPage(context, post), // 게시글 상세 페이지로 이동
            child: Card(
              elevation: 2.0,
              margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: ListTile(

                title: Text(
                  '${id}.${title}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8.0),
                    Text(
                      truncatedContent,
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      '쓰니: $author',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      '작성시각: $formattedTime',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    SizedBox(height: 8.0),
                  ],
                ),
              ),
            ),
          );
        },
      ),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(MyUser.copyImageUrl),
                backgroundColor: Colors.white,
              ),
              accountName: Text(MyUser.copyNickname),
              accountEmail: Text(''),
              decoration: BoxDecoration(
                color: Colors.blue[200],
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40.0),
                  bottomRight: Radius.circular(40.0),
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.person,
                color: Colors.grey[850],
              ),
              title: Text('Profile'),
              onTap: () {
                fetchDataAndNavigateToProfilePage(context);
                print('Profile is clicked');
              },
            ),
          ],
        ),
      ),

    );
  }
}
