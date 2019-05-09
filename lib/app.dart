import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'dart:math';

import 'package:flutter/services.dart';

import 'moviecard.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

String url = "https://yts.am/api/v2/list_movies.json";

class _AppState extends State<App> {
  TextEditingController searchController = new TextEditingController();
  Movies movies = new Movies();
  bool active = false;
  List movieList =
      new List(); //to store list of movies obtained from snapshot in stream

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          floatingActionButton: floatingButton(),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          backgroundColor: Colors.grey[200],
          appBar: appBar(),
          body: Container(
            child: Center(
              child: StreamBuilder(
                stream: movies.outTitle(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData == false) {
                    if (active == false) {
                      active = true;
                      movies
                          .onFutureSucceed(url + "?limit=10&page=$pageNumber");
                      return CircularProgressIndicator();
                    } else {
                      return Text('No results found!!!');
                    }
                  } else {
                    movieList = snapshot.data;
                    return ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: movieList.length,
                      itemBuilder: (BuildContext ctx, int index) {
                        return movieCard(movieList[index],context);
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
            child: TextField(
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20.0, height: 1.5),
              cursorColor: Colors.green,
              controller: searchController,
              onChanged: (String value) {
                refreshLists();
                searchController.text == null
                    ? movies.onFutureSucceed(
                        url + "?limit=10&page=${rand.nextInt(1000)}")
                    : movies.onFutureSucceed(
                        url + "?query_term=${searchController.text}");
              },
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
                  refreshLists();
                  searchController.text == null
                      ? movies.onFutureSucceed(
                          url + "?limit=10&page=${rand.nextInt(1000)}")
                      : movies.onFutureSucceed(
                          url + "?query_term=${searchController.text}");

                  SystemChannels.textInput.invokeMethod('TextInput.hide');
                  searchController.clear();
                },
                icon: Icon(Icons.search, size: 30.0, color: Colors.white)),
          )
        ],
      ),
      centerTitle: true,
      backgroundColor: Colors.green,
    );
  }

//clears all list that contains movie details
  void refreshLists() {
    movies.details.clear();
    movies.movies.clear();
    movies.movie.clear();
  }

  static Random rand = new Random();
  int pageNumber = rand.nextInt(1000);
  //floating button to switch between pages
  Widget floatingButton() {
    return Material(
      borderRadius: BorderRadius.circular(20.0),
      color: Colors.green[900],
      shadowColor: Colors.white,
      elevation: 5.0,
      child: SizedBox(
        height: 40.0,
        width: 150.0,
        child: Padding(
          padding: EdgeInsets.only(left: 0.0, right: 0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.keyboard_arrow_left,
                  color: Colors.white,
                ),
                onPressed: () {
                  if (pageNumber > 1) {
                    refreshLists();
                    pageNumber--;
                    movies.onFutureSucceed(url + "?limit=10&page=$pageNumber");
                    setState(() {});
                  }
                },
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.5),
                child: Text('$pageNumber',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold)),
              ),
              IconButton(
                icon: Icon(
                  Icons.keyboard_arrow_right,
                  color: Colors.white,
                ),
                onPressed: () {
                  if (pageNumber >= 1) {
                    refreshLists();
                    pageNumber++;
                    movies.onFutureSucceed(url + "?limit=10&page=$pageNumber");
                    setState(() {});
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Movies {
  Map jsonData;
  var jsonBody;

  StreamController<dynamic> streamController = new StreamController();
  List movies = new List();
  onDispose() {
    streamController.close();
  }

  Future<void> getJsonData(String url1) async => http.get(url1);

//todo when data from future obtained
  onFutureSucceed(String url1) {
    Future response = getJsonData(url1);
    response.then((value) {
      jsonBody = convert.jsonDecode(value.body);
      print('after jsonBody');
      getMovieDetails();
    }, onError: (e) {
      streamController.sink.addError(e);
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
    streamController.sink.add(details);
  }

  setDetails(int indexOne) {
    print('setdetails fun bhitra');
    details.add(movie[indexOne].finalDetails);
  }

  //output from stream
  outTitle() => streamController.stream;
}

class MovieDetails {
  String summary;
  String url720p;
  String url1080p;
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
    url720p = details['torrents'][0]['url'];
    if (details['torrents'].length >= 2) {
      size1080p = details['torrents'][1]['size'];
      seeds1080 = details['torrents'][1]['seeds'].toString();
      peers1080 = details['torrents'][1]['peers'].toString();
      url1080p = details['torrents'][1]['url'];
    }
    coverImage = details['medium_cover_image'];
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
    finalDetails['url720p'] = url720p;
    finalDetails['url1080p'] = url1080p;
  }
}
