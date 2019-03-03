import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'moviecard.dart';

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
                      : movieCard(snapshot);
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

  Future<void> getJsonData() async =>
      //https://yts.am/api/v2/list_movies.json?query_term=${moviename}&limit=${this.state.limit}&sort_by=year`;
      http.get("https://yts.am/api/v2/list_movies.json?limit=40");

//todo when data from future obtained
  onFutureSucceed(int index) {
    Future response = getJsonData();
    response.then((value) {
      jsonBody = convert.jsonDecode(value.body);
      getMovieDetails(index);
    }, onError: (e) {
      titleController.sink.add(e);
      print("yeha error aayo $e");
    });
  }

  List<MovieDetails> movie = [];
  Map details = new Map();
  getMovieDetails(int index) {
    jsonData = jsonBody['data'];
    for (int i = 0; i < jsonData.length; i++) {
      movies.add(jsonData['movies'][i]);
      movie.add(new MovieDetails(movies[i]));
    }

    setDetails(int indexOne) {
      details['title'] = movie[indexOne].title;
      details['genre'] = movie[indexOne].genres;
      details['720'] = movie[indexOne].size720p;
      details['1080'] = movie[indexOne].size1080p;
      details['image'] = movie[indexOne].coverImage;
      details['summary'] = movie[indexOne].summary;
    }

    setDetails(2);
    titleController.sink.add(details);
  }

  //output from stream
  outTitle() => titleController.stream;
}

class MovieDetails {
  String summary;
  String title;
  List genres;
  String size720p;
  String size1080p;
  String coverImage;
  Map details = new Map();
  MovieDetails(this.details) {
    title = details['title'];
    genres = details['genres'];
    size720p = details['torrents'][0]['size'];
    size1080p = details['torrents'][1]['size'];
    coverImage = details['large_cover_image'];
    summary = details['summary'];
  }
}
