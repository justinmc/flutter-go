import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(
        children: <Widget>[
          Center(
            child: InteractiveViewer(
              child: Image.asset(
              'images/go_board.png',
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              height: 120.0,
              color: Colors.grey,
              child: Padding(
                padding: EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    _DraggablePiece(
                      team: _Team.black,
                    ),
                    _DraggablePiece(
                      team: _Team.white,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum _Team {
  black,
  white,
}

class _Piece extends StatelessWidget {
  _Piece({
    Key key,
    this.team,
    this.isDragging = false,
  }) : assert(team != null),
       super(key: key);

  final bool isDragging;
  final _Team team;

  @override
  Widget build(BuildContext context) {
    final double opacity = isDragging ? 0.4 : 1.0;
    return Container(
      color: team == _Team.black ? Colors.black.withOpacity(opacity) : Colors.white.withOpacity(opacity),
      width: 40.0,
      height: 40.0,
    );
  }
}

class _DraggablePiece extends StatelessWidget {
  _DraggablePiece({
    Key key,
    this.team,
    this.isDragging = false,
  }) : assert(team != null),
       super(key: key);

  final bool isDragging;
  final _Team team;

  @override
  Widget build(BuildContext context) {
    return Draggable(
      feedback: _Piece(
        isDragging: true,
        team: team,
      ),
      child: _Piece(
        team: team,
      ),
    );
  }
}
