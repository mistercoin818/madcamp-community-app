import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application/allpage.dart';
import 'package:flutter_application/classpage.dart';
import 'package:flutter_application/schedulepage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application/User.dart';

class MainPage extends StatefulWidget {
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  List<Widget?> _widgetOptions = [];

  @override
  void initState() {
    super.initState();
    _widgetOptions = List<Widget?>.filled(3, null);
    _widgetOptions[_selectedIndex] = AllPage(null);
    fetchDataAndBuildWidgets();
  }

  void fetchDataAndBuildWidgets() async {
    String url = '';
    if (_selectedIndex == 0) {
      url = 'http://172.10.5.118:443/post_all/getposts';
    } else if (_selectedIndex == 1) {
      url = 'http://172.10.5.118:443/post_group/getposts';
    } else {
      url = 'http://172.10.5.118:443/schedule/getschedules';
    }

    try {
      final response = await http.post(Uri.parse(url), body: {'kakaoId': MyUser.copyKakaoId});
      if (response.statusCode == 200) {
        final jjsonData = json.decode(response.body);
        dynamic jsonData;
        if(_selectedIndex == 0 || _selectedIndex == 1){
          jsonData = jjsonData['posts'];
          print(jsonData);
        }
        if(_selectedIndex == 2){
          jsonData = jjsonData['schedules'];
          print(jsonData);
        }
        setState(() {
          _widgetOptions = buildWidgetsFromJson(jsonData);
        });
      } else {
        print("게시글 불러오기 실패!");
      }
    } catch (e) {
      print("게시글 불러오기 실패!");
    }
  }

  List<Widget> buildWidgetsFromJson(dynamic jsonData) {
    List<Widget> widgets = [];
    for (int i = 0; i < 3; i++) {
      if (i == _selectedIndex) {
        if (jsonData != null) {
          if (i == 0) {
            widgets.add(AllPage(jsonData));
          } else if (i == 1) {
            widgets.add(ClassPage(jsonData));
          } else {
            widgets.add(SchedulePage(jsonData));
          }
        } else {
          widgets.add(Container()); // 비어있는 컨테이너 추가
        }
      } else {
        widgets.add(Container()); // 비어있는 컨테이너 추가
      }
    }
    return widgets;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      fetchDataAndBuildWidgets();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _widgetOptions.elementAt(_selectedIndex)!,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '전체 게시판',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.text_snippet),
            label: '분반 게시판',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule),
            label: '일정 게시판',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueAccent,
        onTap: _onItemTapped,
      ),
    );
  }
}
