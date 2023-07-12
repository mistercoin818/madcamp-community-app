import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application/User.dart';
import 'package:flutter_application/join.dart';
import 'package:flutter_application/profiledata.dart';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Profile2Page extends StatefulWidget {
  final dynamic data;
  const Profile2Page({Key? key, required this.data}) : super(key:key);

  @override
  State<Profile2Page> createState() => _Profile2PageState();
}

class _Profile2PageState extends State<Profile2Page> {
  TextEditingController controller = TextEditingController(text:"${MyProfile.nickname}");

  TextEditingController controller2 = TextEditingController(text:"${MyProfile.instaAcct}");

  TextEditingController controller3 = TextEditingController(text:"${MyProfile.githubAcct}");

  TextEditingController controller4 = TextEditingController(text:"${MyProfile.linkedinAcct}");

  bool isUpdated = false;

  Future<void> sendUpdatedProfile() async{
    String nickname = controller.text;
    String insta = controller2.text;
    String github = controller3.text;
    String linkedin = controller4.text;

    final url = Uri.parse('http://172.10.5.118:443/profile/updateinfo');
    print("!?!?!?!?!!");
    try{
      print("!?!?!?!?!!222222");
      final response = await http.post(
        url,
        body:{'kakaoId': MyUser.copyKakaoId, 'instaAcct': insta, 'instaPub': 'true', 'githubAcct': github, 'githubPub': 'true', 'linkedinAcct': linkedin, 'linkedinPub': 'true'}
      );
      print("!?!?!?!?!!3333");

      MyProfile.nickname = nickname;
      print(MyProfile.nickname);

      MyProfile.instaAcct = insta;
      print(MyProfile.instaAcct);

      MyProfile.githubAcct = github;
      print(MyProfile.githubAcct);

      MyProfile.linkedinAcct = linkedin;
      print(MyProfile.linkedinAcct);

      if (response.statusCode == 200){
        setState(() {
          isUpdated = true;
        });
        showSnackBar(context, Text('프로필 수정 완료.'));
        Navigator.pop(context);
      }

    }catch(e){
      print("프로필 수정이 안 됐대!!!!!!");
    }

  }


  @override
  Widget build(BuildContext context) {
    final profileData = widget.data;

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        elevation: 0.0,
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: ListView(
          children: <Widget>[
            imageProfile(profileData.profileImg),
            SizedBox(height:20),
            Row(
              children: <Widget>[
                Icon(Icons.check_circle_outline),
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  '이름: ',
                  style: TextStyle(fontSize: 16.0, letterSpacing: 1.0),
                ),
                Text(
                  profileData.userName,
                  style: TextStyle(fontSize: 16.0, letterSpacing: 1.0),
                )
              ],
            ),
            SizedBox(height:20),
            Row(
              children: <Widget>[
                Icon(Icons.check_circle_outline),
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  '분반: ',
                  style: TextStyle(fontSize: 16.0, letterSpacing: 1.0),
                ),
                Text(
                  profileData.group.toString(),
                  style: TextStyle(fontSize: 16.0, letterSpacing: 1.0),
                )
              ],
            ),
            SizedBox(height:20),
            Row(
              children: <Widget>[
                Icon(Icons.check_circle_outline),
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  '학교: ',
                  style: TextStyle(fontSize: 16.0, letterSpacing: 1.0),
                ),
                Text(
                  profileData.school,
                  style: TextStyle(fontSize: 16.0, letterSpacing: 1.0),
                )
              ],
            ),
            SizedBox(height:20),
            Row(
              children: <Widget>[
                Icon(Icons.check_circle_outline),
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  'KAIST 학번: ',
                  style: TextStyle(fontSize: 16.0, letterSpacing: 1.0),
                ),
                Text(
                  profileData.studentId.toString(),
                  style: TextStyle(fontSize: 16.0, letterSpacing: 1.0),
                )
              ],
            ),
            SizedBox(height:20),
            // nicknameTextField(),
            Row(
              children: <Widget>[
                Icon(Icons.check_circle_outline),
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  '닉네임: ',
                  style: TextStyle(fontSize: 16.0, letterSpacing: 1.0),
                ),
                Text(
                  profileData.nickname,
                  style: TextStyle(fontSize: 16.0, letterSpacing: 1.0),
                )
              ],
            ),
            SizedBox(height:20),
            instagramField(),
            SizedBox(height:20),
            githubField(),
            SizedBox(height:20),
            linkedInField(),
            SizedBox(height:20),
            ElevatedButton(
                onPressed: (){
                  sendUpdatedProfile();
                  print('프로필 수정완료!');
                }
                ,
                child: Text('수정하기')
            ),

          ],
        ),
      ),
    );
  }

  Widget imageProfile(String profileImg){
    return Center(
      child: Stack(
        children: <Widget>[
          CircleAvatar(
            radius: 80,
            backgroundImage:
               NetworkImage(profileImg)
          ),
        ],
      )
    );
  }

  Widget nicknameTextField(){
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.pink
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black,
            width: 2,
          ),
        ),
        prefixIcon: Icon(
          Icons.person,
          color: Colors.blueAccent,
        ),
        labelText: 'NickName',
        hintText: 'Input your nickname'
      ),
    );
  }

  Widget instagramField(){
    return TextFormField(
      controller: controller2,
      decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(
                color: Colors.pink
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
              width: 2,
            ),
          ),
          prefixIcon: Icon(
            FontAwesomeIcons.instagram,
            color: Colors.pink
          ),
          labelText: 'Instagram ID',
          hintText: 'Input your Instagram ID'
      ),
    );
  }

  Widget githubField(){
    return TextFormField(
      controller: controller3,
      decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(
                color: Colors.pink
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
              width: 2,
            ),
          ),
          prefixIcon: Icon(
              FontAwesomeIcons.github,
              color: Colors.black
          ),
          labelText: 'GitHub ID',
          hintText: 'Input your GitHub ID'
      ),
    );
  }

  Widget linkedInField(){
    return TextFormField(
      controller: controller4,
      decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(
                color: Colors.pink
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
              width: 2,
            ),
          ),
          prefixIcon: Icon(
              FontAwesomeIcons.linkedin,
              color: Colors.blue
          ),
          labelText: 'LinkedIn ID',
          hintText: 'Input your LinkedIn ID'
      ),
    );
  }
}
