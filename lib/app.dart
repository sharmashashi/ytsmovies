import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  TextEditingController searchController = new TextEditingController();
  Movies movies = new Movies();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: appBar(),
          body: Container(
            child: Center(
              child: StreamBuilder(
                stream: movies.outTitle(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  return snapshot.hasData == false
                      ? CircularProgressIndicator()
                      : ListView(children: <Widget>[Text('${snapshot.data}')]);
                },
              ),
            ),
          ),
        ));
  }

  Widget appBar() {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Flexible(
            child: TextFormField(
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20.0, height: 1.5),
              cursorColor: Colors.green,
              controller: searchController,
              decoration: InputDecoration.collapsed(
                  hintText: 'e.g. London has fallen',
                  hintStyle: TextStyle(
                    fontSize: 18.0,
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(32.0))),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10.0),
            child: IconButton(
                onPressed: () {
                  movies.onFutureSucceed(0);
                  //search.sink.add(searchController.text);
                },
                icon: Icon(Icons.search, size: 30.0, color: Colors.white)),
          )
        ],
      ),
      centerTitle: true,
      backgroundColor: Colors.green,
    );
  }
}

class Movies {
  Map jsonData;
  var jsonBody;

  StreamController<dynamic> titleController = new StreamController();

  List movies = new List();
  List details = new List();

  Future<void> getJsonData() async =>
      http.get("https://yts.am/api/v2/list_movies.json");

  onFutureSucceed(int index) {
    Future response = getJsonData();
    response.then((value) {
      jsonBody = convert.jsonDecode(value.body);
      print(jsonBody);
      print("yeha aaye");
      getMovieDetails(index);
    });

  }
    outTitle()=> titleController.stream;

  getMovieDetails(int index) {
    jsonData = jsonBody['data'];
    for (int i = 0; i < jsonData.length; i++) {
      movies.add(jsonData['movies'][i]);
    }

    details.add(movies[index]['title']);
    details.add(movies[index]['genres'][0]);
    details.add(movies[index]['torrents'][0]['size']);
    details.add(movies[index]['torrents'][1]['size']);

    print(movies);
    titleController.sink.add(details[0]);
  }
}
