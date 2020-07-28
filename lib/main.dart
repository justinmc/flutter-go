import 'dart:math' as math;
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Go Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Go Demo'),
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

// The data representing a piece placed on the board.
//
// In this demo, a piece can be placed at any coordinate on the board (not
// necessarily at locations allowed by the rules of go).
class _PieceData {
  const _PieceData({
    this.offset,
    this.team,
  });

  final Offset offset;
  final _Team team;
}

// The game board widget.
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
      child: Stack(
        children: <Widget>[
          Container(
            child: Center(
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  final double dimension = math.min(constraints.maxWidth, constraints.maxHeight);
                  return DragTarget<_Team>(
                    key: _dragTargetKey,
                    onAcceptWithDetails: (DragTargetDetails details) {
                      final RenderBox renderBox = _dragTargetKey.currentContext.findRenderObject();
                      final Offset localOffset = renderBox.globalToLocal(details.offset);
                      final Offset offset = Offset(
                        localOffset.dx / dimension,
                        localOffset.dy / dimension,
                      );
                      setState(() {
                        _pieces.add(_PieceData(
                          offset: offset,
                          team: details.data,
                        ));
                      });
                    },
                    onWillAccept: (_Team team) => true,
                    builder: (BuildContext context, List<_Team> candidateData, List rejectedData) {
                      return Stack(
                        children: <Widget>[
                          Image.asset(
                            // TODO(justinmc): This is a very ugly and inaccurate go board
                            // that I drew :) It would be better to use a real board
                            // image, or even to draw the lines and details
                            // programmatically.
                            'images/go_board.png',
                          ),
                          ..._pieces.map((_PieceData pieceData) => Positioned(
                            left: pieceData.offset.dx * dimension,
                            top: pieceData.offset.dy * dimension,
                            child: _DraggablePiece(
                              height: dimension / 12,
                              onDragStarted: () {
                                setState(() {
                                  _pieces.remove(pieceData);
                                });
                              },
                              team: pieceData.team,
                              width: dimension / 12,
                            ),
                          )).toList(),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// A single game piece.
class _Piece extends StatelessWidget {
  _Piece({
    Key key,
    this.height = 40.0,
    this.isDragging = false,
    this.team,
    this.width = 40.0,
  }) : assert(team != null),
       assert(height != null),
       assert(width != null),
       super(key: key);

  final double height;
  final bool isDragging;
  final _Team team;
  final double width;

  @override
  Widget build(BuildContext context) {
    final double opacity = isDragging ? 0.4 : 1.0;
    return Container(
      color: team == _Team.black ? Colors.black.withOpacity(opacity) : Colors.white.withOpacity(opacity),
      width: width,
      height: height,
    );
  }
}

// A game piece that can be dragged.
class _DraggablePiece extends StatelessWidget {
  _DraggablePiece({
    Key key,
    this.height = 40.0,
    this.isDragging = false,
    this.onDragStarted,
    this.team,
    this.width = 40.0,
  }) : assert(team != null),
       super(key: key);

  final double height;
  final bool isDragging;
  final VoidCallback onDragStarted;
  final double width;
  final _Team team;

  @override
  Widget build(BuildContext context) {
    return Draggable<_Team>(
      data: team,
      // TODO(justinmc): It would be cool if the feedback widget perfectly
      // matched the size of the widget that will be placed on the board when
      // it's dropped, but that might be more work than it's worth.
      feedback: _Piece(
        height: height,
        isDragging: true,
        team: team,
        width: width,
      ),
      onDragStarted: onDragStarted,
      child: _Piece(
        height: height,
        team: team,
        width: width,
      ),
    );
  }
}
