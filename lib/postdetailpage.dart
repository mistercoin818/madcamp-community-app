import 'package:flutter/material.dart';
import 'package:flutter_application/join.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter_application/User.dart';

import 'package:flutter_application/newpostpage.dart';

class PostDetailPage extends StatefulWidget {
  final dynamic post;

  PostDetailPage({required this.post});

  @override
  _PostDetailPageState createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  final TextEditingController _commentController = TextEditingController();
  List<String> _comments = [];
  List<String> _authors = [];
  List<int> _cid = [];

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
    final postId = widget.post['id'];
    final url = Uri.parse('http://172.10.5.118:443/comment/getcomments');

    try {
      final response = await http.post(
        url,
        body: {'kakaoId': MyUser.copyKakaoId, 'postId': postId.toString()},
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final comments = jsonData['comments'];

        setState(() {
          _comments = List<String>.from(comments.map((comment) => comment['contents']));
          _authors = List<String>.from(comments.map((comment) => comment['authorName']));
          _cid = List<int>.from(comments.map((comment) => comment['id']));
        });
      }
    } catch (e) {
      print('Failed to fetch comments: $e');
    }
  }

  void _addComment() async {
    final String comment = _commentController.text;

    // Send the comment data to the backend
    final url = Uri.parse('http://172.10.5.118:443/comment/createcomment');

    try {
      final response = await http.post(
        url,
        body: {
          'kakaoId': MyUser.copyKakaoId,
          'postId': widget.post['id'].toString(),
          'contents': comment,
        },
      );

      if (response.statusCode == 200) {
        // Comment added successfully
        print('Comment added successfully');
        final newCommentId = json.decode(response.body)['commentId'];

        setState(() {
          _comments.add(comment);
          _authors.add(MyUser.copyName); // Assume the author is the current user
          _cid.add(newCommentId);
        });
      } else {
        // Failed to add comment
        print('Failed to add comment');
      }
    } catch (e) {
      print('Error: $e');
      // Handle error
    }

    _commentController.clear();
  }

  void _editComment(int index) async {
    final String comment = _commentController.text;
    final int commentId = _cid[index];

    // Send the updated comment data to the backend
    final url = Uri.parse('http://172.10.5.118:443/comment/updatecomment');

    try {
      final response = await http.post(
        url,
        body: {
          'kakaoId': MyUser.copyKakaoId,
          'commentId': commentId.toString(),
          'contents': comment,
        },
      );

      if (response.statusCode == 200) {
        // Comment updated successfully
        print('Comment updated successfully');

        setState(() {
          _comments[index] = comment;
        });
      } else {
        // Failed to update comment
        print(response.statusCode);

        print('Failed to update comment');
      }
    } catch (e) {
      print('Error: $e');
      // Handle error
    }

    _commentController.clear();
  }

  void _deleteComment(int index) async {
    final int commentId = _cid[index];

    // Send the comment ID to be deleted to the backend
    final url = Uri.parse('http://172.10.5.118:443/comment/deletecomment');

    try {
      final response = await http.post(
        url,
        body: {
          'kakaoId': MyUser.copyKakaoId,
          'commentId': commentId.toString(),
        },
      );

      if (response.statusCode == 200) {
        // Comment deleted successfully
        print('Comment deleted successfully');

        setState(() {
          _comments.removeAt(index);
          _authors.removeAt(index);
          _cid.removeAt(index);
        });
      } else {
        // Failed to delete comment
        print('Failed to delete comment');
      }
    } catch (e) {
      print('Error: $e');
      // Handle error
    }
  }

  Future<void> deletePost() async{
    final url = Uri.parse('http://172.10.5.118:443/post_all/deletepost');
    try{
      final response = await http.post(
        url,
        body: {'postId': widget.post['id'].toString(), 'kakaoId': MyUser.copyKakaoId}
      );

      if (response.statusCode == 200){
        Navigator.pop(context);
      }
      else{
        showSnackBar(context, Text("넌 삭제할 수 없어."));
        print("삭제 안 됐어!!!!!");
      }
    }catch(e){
      print(e);
      print("삭제 catch 으잉!?!?!?!");
    }
  }

  @override
  Widget build(BuildContext context) {
    final id = widget.post['id'];
    final title = widget.post['title'];
    final content = widget.post['contents'];
    final author = widget.post['authorName'];
    final timestamp = widget.post['createdAt'];

    // Parse the UTC timestamp
    final utcTimestamp = DateTime.parse(timestamp);

    // Convert to local time in South Korea
    final koreaTime = utcTimestamp.toLocal();

    // Format the local time as a string
    final formattedTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(koreaTime);

    return Scaffold(
      appBar: AppBar(
        title: Text('게시글 상세보기'),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context)=>NewPostPage());
              // )
            },
            icon: Icon(Icons.edit),
          ),
          IconButton(
            onPressed: deletePost,
            icon: Icon(Icons.delete),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${id}: ${title}',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
            SizedBox(height: 8.0),
            Text(
              '내용: ${content}',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 8.0),
            Text(
              '쓰니: $author',
              style: TextStyle(color: Colors.grey[600]),
            ),
            SizedBox(height: 16.0),
            Text(
              '<댓글>',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: _comments.isNotEmpty
                  ? ListView.builder(
                itemCount: _comments.length,
                itemBuilder: (context, index) {
                  final comment = _comments[index];
                  final author = _authors[index];
                  final commentId = _cid[index];

                  return Padding(
                    padding: EdgeInsets.only(bottom: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          author,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4.0),
                        Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(comment),
                              SizedBox(height: 4.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    iconSize: 18.0,
                                    onPressed: () {
                                      setState(() {
                                        _commentController.text = comment;
                                        _editComment(index);
                                      });
                                    },
                                    icon: Icon(Icons.edit),
                                  ),
                                  IconButton(
                                    iconSize: 18.0,
                                    onPressed: () {
                                      _deleteComment(index);
                                    },
                                    icon: Icon(Icons.delete),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              )
                  : Center(
                child: Text('댓글이 없습니다.'),
              ),
            ),
            SizedBox(height: 8.0),
            TextField(
              controller: _commentController,
              decoration: InputDecoration(
                hintText: '댓글 작성...',
              ),
            ),
            SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: _addComment,
              child: Text('댓글 작성'),
            ),
          ],
        ),
      ),
    );
  }
}
