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

  List movieList =
      new List(); //to store list of movies obtained from snapshot in stream

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.grey[200],
          appBar: appBar(),
          body: Container(
            child: Center(
              child: StreamBuilder(
                stream: movies.outTitle(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData == false) {
                    movies.onFutureSucceed();
                    return CircularProgressIndicator();
                  } else {
                    movieList = snapshot.data;
                    return ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: movieList.length,
                      itemBuilder: (BuildContext ctx, int index) {
                        return movieCard(movieList[index]);
                      },
                    );
                  }
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
                  movies.onFutureSucceed();
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
  onFutureSucceed() {
    Future response = getJsonData();
    response.then((value) {
      jsonBody = convert.jsonDecode(value.body);
      print('after jsonBody');
      getMovieDetails();
    }, onError: (e) {
      titleController.sink.add(e);
      print("yeha error aayo $e");
    });
  }

  List<MovieDetails> movie = new List();
  List<Map> details = new List();
  getMovieDetails() {
    jsonData = jsonBody['data'];
    print('after json data assignment');
    for (int i = 0; i < jsonData['movies'].length; i++) {
      print('inside for loop after json data assignment i = $i');
      movies.add(jsonData['movies'][i]);
      print('bich ma');
      movie.add(new MovieDetails(movies[i]));
      print('chheu ma');
    }

//calls for movie details from movie 0-9
    for (int i = 0; i < movie.length; i++) {
      setDetails(i);
    }
    titleController.sink.add(details);
  }

  setDetails(int indexOne) {
    print('setdetails fun bhitra');
    details.add(movie[indexOne].finalDetails);
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
  String year;
  String rating;
  String runtime;
  String seeds720;
  String peers720;
  String seeds1080;
  String peers1080;
  Map details = new Map();
  Map finalDetails = new Map();
  MovieDetails(this.details) {
    title = details['title'];
    genres = details['genres'];
    year = details['year'].toString();
    rating = details['rating'].toString();
    runtime = details['runtime'].toString();
    seeds720 = details['torrents'][0]['seeds'].toString();
    peers720 = details['torrents'][0]['peers'].toString();
    size720p = details['torrents'][0]['size'];
    if (details['torrents'].length >= 2) {
      size1080p = details['torrents'][1]['size'];
      seeds1080 = details['torrents'][1]['seeds'].toString();
      peers1080 = details['torrents'][1]['peers'].toString();
    }
    coverImage = details['large_cover_image'];
    summary = details['description_full'];

    finalDetails['title'] = title;
    finalDetails['genre'] = genres;
    finalDetails['720'] = size720p;
    finalDetails['1080'] = size1080p;
    finalDetails['image'] = coverImage;
    finalDetails['summary'] = summary;
    finalDetails['year'] = year;
    finalDetails['runtime'] = runtime;
    finalDetails['rating'] = rating;
    finalDetails['seeds720'] = seeds720;
    finalDetails['peers720'] = peers720;
    finalDetails['seeds1080'] = seeds1080;
    finalDetails['peers1080'] = peers1080;
  }
}
