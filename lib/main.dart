import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:transparent_image/transparent_image.dart';

void main() {
  /* runApp(MaterialApp(
      home: MyHome(),

  ));
*/
  runApp(new MaterialApp(
      home: new MyHome(),
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        primarySwatch: Colors.green,
      )));
}

class MyHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MyHomeState();
}

class MyHomeState extends State<MyHome> {
  // Base URL for our wordpress API
  final String apiUrl = "https://2018.kanpur.wordcamp.org/wp-json/wp/v2/";

  // Empty list for our posts
  List posts;

  // Function to fetch list of posts
  Future<String> getPosts() async {
    var res = await http.get(Uri.encodeFull(apiUrl + "posts?_embed"),
        headers: {"Accept": "application/json"});

    // fill our posts list with results and update state
    setState(() {
      var resBody = json.decode(res.body);
      posts = resBody;
    });

    return "Success!";
  }

  @override
  void initState() {
    super.initState();
    this.getPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("WCKANPUR-2018 "),
        backgroundColor: Colors.redAccent,
          actions: <Widget>[
            new IconButton( // action button
              icon: new Icon(Icons.directions_car),
              onPressed: () {
                print("direction")
              },
            ),
            new IconButton( // action button
              icon: new Icon(Icons.add_alert),
              onPressed: () {
                print("updates")
              },
            ),
          ]
      ),
      body: ListView.builder(
        itemCount: posts == null ? 0 : posts.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: <Widget>[
              Card(
                child: Column(
                  children: <Widget>[
                    //Center(child: LinearProgressIndicator()),
                    //Center(child: CircularProgressIndicator()),

                    //new Image.network(posts[index]["_embedded"]["wp:featuredmedia"][0]["source_url"]),
                    FadeInImage.memoryNetwork(
                      placeholder: kTransparentImage,
                      image: (posts[index]["_embedded"]["wp:featuredmedia"][0]
                          ["source_url"]),
                    ),

                    new Padding(
                      padding: EdgeInsets.all(10.0),
                      child: new ListTile(
                        title: new Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: new Text(
                              posts[index]["title"]["rendered"],
                              // textAlign: TextAlign.justify,
                              style: new TextStyle(
                                  fontSize: 17.0, fontWeight: FontWeight.bold),
                            )),
                        subtitle: new Text(
                          posts[index]["content"]["rendered"]
                              .replaceAll(new RegExp(r'<[^>]+>'), ''),
                          //filtering html elements using regular expression
                          // posts[index]["excerpt"]["rendered"] //raw data
                          textAlign: TextAlign.justify,
                          style: new TextStyle(
                              fontStyle: FontStyle.normal, fontSize: 14.0),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
