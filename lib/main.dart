import 'package:flutter/material.dart';
import 'app.dart';

void main() {
  runApp(App());
}

class MovieCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("Movies"),
        ),
        body: SizedBox(
          width: 230.0,
          height: 370.0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                        height: 200.0,
                        width: 200.0,
                        child: Image.network(
                            'https://yts.am/assets/images/movies/the_indian_fighter_1955/medium-cover.jpg')),
                    Container(
                      height: 10.0,
                    ),
                    Text('Action/Comedy'),
                    Container(
                      height: 5.0,
                    ),
                    Text(
                      'Indian Fighter  ',
                      style: TextStyle(color: Colors.green[800], fontSize: 18.0,fontWeight: FontWeight.bold),
                    ),
                    Divider(
                      height: 1.0,
                    ),
                    Container(
                      height: 10.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        SizedBox(
                          height: 45.0,
                          width: 90.0,
                          child: MaterialButton(
                            splashColor: Colors.white,
                            onPressed: () {},
                            elevation: 3.0,
                            color: Colors.green,
                            child: Text('780 MB (720p)',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15.0,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                        SizedBox(
                          height: 45.0,
                          width: 90.0,
                          child: MaterialButton(
                            splashColor: Colors.white,
                            onPressed: () {},
                            elevation: 3.0,
                            color: Colors.green,
                            child: Text('1.80 GB (1080p)',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontStyle: FontStyle.italic,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
