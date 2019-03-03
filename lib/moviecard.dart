import 'package:flutter/material.dart';

//returns movie card
Widget movieCard(AsyncSnapshot snapshot) {
  return SizedBox(
    width: 230.0,
    height: 352.0,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Stack(
            children: <Widget>[
              DecoratedBox(
                  decoration: BoxDecoration(),
                  child: Image.network('${snapshot.data['image']}')),
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
                                    '${snapshot.data['title']}',
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
                                      '${snapshot.data['genre'].join('/')}',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 12.0),
                                    ),
                                  ])),
                          Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Container(
                                height: 170.0,
                                child: ListView(children: <Widget>[
                                  Text('${snapshot.data['summary']}',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16.0,
                                          fontStyle: FontStyle.italic))
                                ])),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              SizedBox(
                                height: 35.0,
                                width: 90.0,
                                child: MaterialButton(
                                  splashColor: Colors.white,
                                  onPressed: () {},
                                  elevation: 3.0,
                                  color: Colors.green,
                                  child: Text('720p (${snapshot.data['720']})',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 11.0,
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                              SizedBox(
                                height: 35.0,
                                width: 90.0,
                                child: MaterialButton(
                                  splashColor: Colors.white,
                                  onPressed: () {},
                                  elevation: 3.0,
                                  color: Colors.green,
                                  child: Text(
                                      '1080p (${snapshot.data['1080']})',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontStyle: FontStyle.italic,
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.bold)),
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
