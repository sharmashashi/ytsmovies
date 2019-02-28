import 'package:flutter/material.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: appBar(),
      ),
    );
  }

  Widget appBar() {
    return AppBar(
      backgroundColor: Colors.blue,
      actions: <Widget>[
        Material(
          borderRadius: BorderRadius.circular(32.0),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: Row(
              children: <Widget>[
                Flexible(
                  child: TextField(),
                ),
                IconButton(
                  icon: Icon(Icons.search, color: Colors.blue, size: 25.0),
                  onPressed: () {
                    //TODO
                  },
                ),
              ],
            ),
          ),
        )
      ],
    );
  }


}
