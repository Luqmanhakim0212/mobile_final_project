import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class PostScreen extends StatefulWidget {
  PostScreen({Key? key, required this.name}) : super(key: key);

  final String name;

  final WebSocketChannel channel =
      IOWebSocketChannel.connect('ws://besquare-demo.herokuapp.com');

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {

  final channel =
      IOWebSocketChannel.connect('ws://besquare-demo.herokuapp.com');
  List post = [];

  final _formkey = GlobalKey<FormState>();

  String title = '';
  String description = '';
  String url = '';
  String Username = '';

  void newPost(title, description, url) {
    channel.stream.listen((posts) {
      final decodedMessage = jsonDecode(posts);
    });
    channel.sink.add('{"type":"sign_in", "data":{"name": "${widget.name}"}}');
    channel.sink.add(
        '{"type": "create_post", "data": {"title": "$title", "description": "$description","image":"$url"}}');
  }

  void initState() {
    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Text('Title'),
                    TextField(
                      onChanged: (String? value) {
                        setState(() {
                          title = value!;
                        });
                      },
                      
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter the title',
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Text('Description'),
                    TextField(
                      onChanged: (String? value) {
                        setState(() {
                          description = value!;
                        });
                      },
                      
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter the description',
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Text('Image URL'),
                    TextField(
                      onChanged: (String? value) {
                        setState(() {
                          url = value!;
                        });
                      },
                      
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter the URL',
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.red)),
                      onPressed: () {
                        newPost(title, description, url);
                        Navigator.pop(context);
                      
                      },
                      child: Text('Create Post'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.red)),
                      onPressed: () {},
                      child: Text('Cancel'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
