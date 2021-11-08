import 'dart:convert';

import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_final_project/about.dart';
import 'package:mobile_final_project/page/postscreen.dart';
import 'package:mobile_final_project/page/postdetails.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:io';

final channel = IOWebSocketChannel.connect('ws://besquare-demo.herokuapp.com');
List post = [];
bool sortType = true;
List favorite = [];

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key, required this.name}) : super(key: key);

  final String name;

  @override
  // _MainScreenState createState() => _MainScreenState();
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  void sorting() {
    if (sortType == true) {
      setState(() {
        post.sort((a, b) {
          var aDate = a['date'];
          var bDate = b['date'];
          return aDate.compareTo(bDate);
        });
        sortType = false;
      });
    } else if (sortType == false) {
      setState(() {
        post.sort((b, a) {
          var aDate = a['date'];
          var bDate = b['date'];
          return aDate.compareTo(bDate);
        });
        sortType = true;
      });
    }
  }

  void getPost() {
    channel.stream.listen((posting) {
      final decodedMessage = jsonDecode(posting);

      setState(() {
        post = decodedMessage['data']['posts'];
      });
      print(post);
      channel.sink.close();
    });
    channel.sink.add('{"type": "get_posts"}');
  }

  @override
  void initState() {
    super.initState();
    getPost();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[100],
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        leading: IconButton(
            icon: const Icon(
              Icons.info,
              size: 30.0,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AboutUs()),
              );
            }),
        title: const Text("POST"),
      ),
      body: Column(
        children: <Widget>[
          Row(
            children: [
              IconButton(
                  icon: const Icon(
                    Icons.sort,
                    color: Colors.pinkAccent,
                    size: 35.0,
                  ),
                  onPressed: () {
                    sorting();
                  }),
              Container(
                width: 150,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.8),
                      spreadRadius: 5,
                      blurRadius: 5,
                      offset: Offset(0, 7),
                    ),
                  ],
                  color: Colors.blue[100],
                ),
                child: Text('Username: ${widget.name}'),
              ),
              const Spacer(),
              IconButton(
                  icon: const Icon(
                    Icons.create,
                    color: Colors.pinkAccent,
                    size: 35.0,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PostScreen(name: widget.name)),
                    );
                  }),
              IconButton(
                icon: const Icon(
                  Icons.favorite,
                  color: Colors.pinkAccent,
                  size: 35.0,
                ),
                onPressed: () {},
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: post.length,
              itemBuilder: (context, index) {
                return Container(
                  child: Card(
                    color: Colors.purple[50],
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PostDetails(
                                  title: post[index]['title'],
                                  description: post[index]['description'],
                                  url: post[index]['image'],
                                  author: post[index]['author'],
                                  date: post[index]['date'])),
                        );
                      },
                      child: Row(
                        children: [
                          Container(
                            child: Expanded(
                              flex: 2,
                              child: SizedBox(
                                  width: 60,
                                  height: 60,
                                  child: Image(
                                    image: NetworkImage(Uri.parse(
                                                '${post[index]["image"]}')
                                            .isAbsolute
                                        ? '${post[index]["image"]}'
                                        : 'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
                                    fit: BoxFit.contain,
                                  )),
                            ),
                          ),
                          Container(
                            child: Expanded(
                              flex: 4,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '${post[index]["title"]}',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          '${post[index]["description"]}',
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 3,
                                          style: TextStyle(fontSize: 15),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20),
                                  Row(
                                    children: [
                                      Text(
                                        '${post[index]["date"].toString().characters.take(10)}',
                                        style: TextStyle(fontSize: 15),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            child: Column(
                              children: [
                                // IconButton(
                                //   icon: Icon(Icons.favorite),
                                //   onPressed: () {},
                                // ),
                                IconButton(
                                        icon: Icon(Icons.favorite),
                                        color: favorite.contains(post[index])
                                            ? Colors.red
                                            : Colors.grey,
                                        onPressed: () {
                                          if (favorite
                                              .contains(post[index])) {
                                            setState(() {
                                              favorite.remove(post[index]);
                                            });
                                          } else {
                                            setState(() {
                                              favorite.add(post[index]);
                                            });
                                          }
                                        },
                                      ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
