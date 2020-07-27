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
      home: MyHomePage(title: 'Go'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Stack(
        children: <Widget>[
          Center(
            child: _Board(),
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

class _PieceData {
  const _PieceData({
    this.offset,
    this.team,
  });

  final Offset offset;
  final _Team team;
}

class _Board extends StatefulWidget {
  _Board({
    Key key,
  }) : super(key: key);

  @override
  _BoardState createState() => _BoardState();
}

class _BoardState extends State<_Board> {
  final GlobalKey _dragTargetKey = GlobalKey();
  final List<_PieceData> _pieces = <_PieceData>[];

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      child: DragTarget<_Team>(
        key: _dragTargetKey,
        onAcceptWithDetails: (DragTargetDetails details) {
          final RenderBox renderBox = _dragTargetKey.currentContext.findRenderObject();
          final Offset dragTargetOffset = renderBox.localToGlobal(Offset.zero);
          final Offset offset = details.offset - dragTargetOffset;
          setState(() {
            _pieces.add(_PieceData(
              offset: offset,
              team: details.data,
            ));
          });
        },
        onWillAccept: (_Team team) {
          return true;
        },
        builder: (BuildContext context, List<_Team> candidateData, List rejectedData) {
          return Stack(
            children: <Widget>[
              Image.asset(
                'images/go_board.png',
              ),
              ..._pieces.map((_PieceData pieceData) => Positioned(
                top: pieceData.offset.dy,
                left: pieceData.offset.dx,
                child: _Piece(team: pieceData.team),
              )).toList(),
            ],
          );
        },
      ),
    );
  }
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
    return Draggable<_Team>(
      data: team,
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
