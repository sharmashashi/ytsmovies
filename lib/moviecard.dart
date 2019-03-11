import 'package:flutter/material.dart';
import 'widget dilogue.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

TextStyle smallDetailStyle = new TextStyle(
  color: Colors.white,
  fontSize: 15.0,
  fontWeight: FontWeight.bold,
  fontStyle: FontStyle.italic,
);

var httpclient = new http.Client();

//downloader function()
downloader(String url, String filename) async {
  var request = await httpclient.get(Uri.parse(url));
  var bytes = request.bodyBytes;

  String dir = (await getExternalStorageDirectory()).path;
  print('before downlad is $dir');
  final moviedir = new Directory(dir + '/YtsMovies');
  String newdir;
  moviedir.exists().then((exists) {
    if (exists == true) {
      newdir = dir + '/YtsMovies';
      print('new directory $newdir');
    } else {
      new Directory(dir + '/YtsMovies')
          .create(recursive: true)
          .then((Directory directory) {
        newdir = directory.path;
        print('new directory if not exist $newdir');
        return newdir;
      });
    }
  });
  print("file writing with dir: $newdir");

  File file = new File('$dir/YtsMovies/$filename');
  await file.writeAsBytes(bytes);
  print('file write complete');
 return Dialogue();
 // return file;
}

//returns movie card
Widget movieCard(Map snapshot) {
  return SizedBox(
    width: 230.0,
    height: 350.0,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Stack(
            children: <Widget>[
              DecoratedBox(
                  decoration: BoxDecoration(),
                  child: Image.network('${snapshot['image']}')),
              Positioned(
                right: 3.0,
                top: 0.0,
                child: Material(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.elliptical(15.0, 20.0),
                        bottomRight: Radius.elliptical(15.0, 20.0)),
                    elevation: 3.0,
                    color: Colors.green[400],
                    child: SizedBox(
                      height: 310.0,
                      width: 105.0,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Year: ${snapshot['year']}',
                              style: smallDetailStyle,
                            ),
                            Container(
                              height: 10.0,
                            ),
                            Text(
                              'Rating: ${snapshot['rating']}',
                              style: smallDetailStyle,
                            ),
                            Container(
                              height: 10.0,
                            ),
                            Text(
                              'Duration: ${snapshot['runtime']} Mins',
                              style: smallDetailStyle,
                            ),
                            Container(
                              height: 50.0,
                            ),
                            Text('Seeds/Peers',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0)),
                            Divider(
                              color: Colors.white,
                              height: 1.5,
                            ),
                            Container(
                              height: 10.0,
                            ),
                            Text(
                              '720p: ${snapshot['seeds720']}/${snapshot['peers720']}',
                              style: smallDetailStyle,
                            ),
                            Container(height: 10.0),
                            Text(
                              '1080p: ${snapshot['seeds1080']}/${snapshot['peers1080']}',
                              style: smallDetailStyle,
                            ),
                          ],
                        ),
                      ),
                    )),
              ),
              Positioned(
                top: 125.0,
                right: 88.0,
                child: Material(
                  borderRadius: BorderRadius.circular(10.0),
                  elevation: 2.0,
                  child: SizedBox(
                    height: 20.0,
                    width: 40.0,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          CircleAvatar(
                            radius: 5.0,
                            backgroundColor: Colors.green,
                          ),
                          CircleAvatar(
                            radius: 5.0,
                            backgroundColor: Colors.green,
                          )
                        ],
                      ),
                    ),
                  ),
                  color: Colors.yellow,
                ),
              ),
              Positioned(
                bottom: 3.0,
                left: 0.0,
                right: 0.0,
                child: ExpansionTile(
                  //title: Text('Download',
                  //    style: TextStyle(color: Colors.white, fontSize: 17.0)),
                  trailing: Material(
                      borderRadius: BorderRadius.circular(20.0),
                      elevation: 5.0,
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Icon(
                          Icons.file_download,
                          color: Colors.green[700],
                          size: 30.0,
                        ),
                      )),
                  children: <Widget>[
                    Container(
                      color: Colors.white,
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: 22.0,
                            child: ListView(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                children: <Widget>[
                                  Text(
                                    '${snapshot['title']}',
                                    style: TextStyle(
                                        color: Colors.green[800],
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ]),
                          ),
                          Container(
                              height: 16.0,
                              child: ListView(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  children: <Widget>[
                                    Text(
                                      '${snapshot['genre'].join('/')}',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 12.0),
                                    ),
                                  ])),
                          Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Container(
                                height: 110.0,
                                child: ListView(children: <Widget>[
                                  Text('${snapshot['summary']}',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14.0,
                                          fontStyle: FontStyle.italic))
                                ])),
                          ),
                          Column(
                            //mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              MaterialButton(
                                height: 30.0,
                                splashColor: Colors.white,
                                onPressed: () {
                                  downloader('${snapshot['url720p']}',
                                      '${snapshot['title']}.torrent');
                                },
                                elevation: 3.0,
                                color: Colors.green,
                                child: SizedBox(
                                  width: 135.0,
                                  child: Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.file_download,
                                        color: Colors.white,
                                      ),
                                      Text('720p (${snapshot['720']})',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12.0,
                                              fontStyle: FontStyle.italic,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              ),
                              MaterialButton(
                                height: 30.0,
                                splashColor: Colors.white,
                                onPressed: () {
                                  downloader('${snapshot['url1080p']}',
                                      '${snapshot['title']}.torrent');
                                },
                                elevation: 3.0,
                                color: Colors.green,
                                child: SizedBox(
                                  width: 135.0,
                                  child: Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.file_download,
                                        color: Colors.white,
                                      ),
                                      Text('1080p (${snapshot['1080']})',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12.0,
                                              fontStyle: FontStyle.italic,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
