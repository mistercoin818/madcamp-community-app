class ProfileData{
  late String _userName = '';
  late String _nickname = '';
  late String _school = '';
  late int _studentId = 0;
  late int _group = 6;
  late String _profileImg = '';
  late String _instaAcct = '';
  late String _githubAcct = '';
  late String _linkedinAcct = '';

  String get userName => _userName;

  set userName(String value){
    _userName = value;
  }
  String get nickname => _nickname;

  set nickname(String value){
    _nickname = value;
  }
  String get school => _school;

  set school(String value){
    _school = value;
  }
  int get studentId => _studentId;

  set studentId(int value){
    _studentId = value;
  }
  int get group => _group;

  set group(int value){
    _group = value;
  }
  String get profileImg => _profileImg;

  set profileImg(String value){
    _profileImg = value;
  }
  String get instaAcct => _instaAcct;

  set instaAcct(String value){
    _instaAcct = value;
  }
  String get githubAcct => _githubAcct;

  set githubAcct(String value){
    _githubAcct = value;
  }
  String get linkedinAcct => _linkedinAcct;

  set linkedinAcct(String value){
    _linkedinAcct = value;
  }
}

ProfileData MyProfile = ProfileData();