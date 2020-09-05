import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';
void main()=> runApp(MyApp());
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: snakegame(),
    );
  }
}
class snakegame extends StatefulWidget {
  @override
  _snakegameState createState() => _snakegameState();
}

class _snakegameState extends State<snakegame> {
  final int squarespercol = 40;
  final int squaresperrow = 20;
  final fontstyle = TextStyle(
    color: Colors.white,
    fontSize: 20.0,
  );
  final randomgen = Random();
  var snake = [[0,1],[0,0]];
  var food = [0,2];
  var direction = 'up';
  bool isplaying = false;
  void startgame(){
      const durationn = Duration(milliseconds: 300);


      snake=[
        //snake head
        [(squaresperrow/2).floor(),(squarespercol/2).floor()]
      ];
      snake.add([snake.first[0] , snake.first[1]+1]); //snake body

    createfood();
    isplaying = true;
    Timer.periodic(durationn, (Timer timer) {
    movesnake();
    if(checkgameover()){
      timer.cancel();
      endgame();
    }
    }
    );
  }

  void movesnake(){
    setState(() {
      switch(direction){
        case 'up':
          snake.insert(0, [snake.first[0],snake.first[1]-1]);
          break;
        case 'down':
          snake.insert(0, [snake.first[0],snake.first[1]+1]);
          break;
        case 'left':
          snake.insert(0, [snake.first[0]-1,snake.first[1]]);
          break;
        case 'right':
          snake.insert(0, [snake.first[0]+1,snake.first[1]]);
          break;

      }
      if(snake.first[0]!=food[0] || snake.first[1]!=food[1]){
        snake.removeLast();
      }else{
          createfood();
      }
    });
  }

  void createfood() {
    food = [
      randomgen.nextInt(squaresperrow),
      randomgen.nextInt(squarespercol)
    ];
  }
    bool checkgameover(){
      if(!isplaying
      || snake.first[1] < 0
      || snake.first[1] >= squarespercol
      || snake.first[0] < 0
      || snake.first[0] > squaresperrow
      ){
        return true;
      }


      for(var i=1;i<snake.length; ++i){
        if(snake[i][0] == snake.first[0] && snake[i][1] == snake.first[1]){
          return true;
        }
      }

      return false;
    }
    void endgame(){
    isplaying=false;


    showDialog(
        context: context,
      builder: (BuildContext context){
          return AlertDialog(
           title: Text('GAME OVER'),
           content: Text('Score : ${snake.length - 2}',
           style: TextStyle(fontSize: 20),

           ),
            actions: [
              FlatButton(
              onPressed: (){
                Navigator.of(context).pop();
              },
                child: Text('Close'),
        ),
            ],

          );
      }
    );
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
              child: GestureDetector(
                onVerticalDragUpdate: (details){
                  if(direction!='up' && details.delta.dy>0)
                    {
                      direction = 'down';
                    }else if(direction!= 'down' && details.delta.dy<0){
                    direction = 'up';
                  }
                },
                onHorizontalDragUpdate: (details){
                    if(direction!='left' && details.delta.dx>0){
                      direction ='right';
                    }else if(direction!='right' && details.delta.dx<0){
                      direction = 'left';
                    }
                },
                child: AspectRatio(aspectRatio: squaresperrow / (squarespercol+5),
                child: GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: squaresperrow),
                  itemCount: squaresperrow * squarespercol,

                  itemBuilder: (BuildContext context , int index){
                    var color;
                    var x = index % squaresperrow;
                    var y = (index/squaresperrow).floor();
                    bool issnakebody = false;
                    for(var pos in snake){
                      if(pos[0]==x && pos[1]==y)
                        {
                          issnakebody = true;
                          break;
                        }
                    }
                    if(snake.first[0] == x && snake.first[1] == y){
                      color = Colors.green;

                    }else if(issnakebody){
                      color = Colors.green[200];
                    }else if(food[0]==x && food[1]==y){
                      color = Colors.red;
                    }else{
                      color = Colors.grey[800];
                    }

                    return Container(
                      margin: EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,

                      ),
                    );

                  },
                ),
                ),
              ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,

              children: [
                  FlatButton(
                    onPressed: (){
                      if(isplaying){
                        isplaying = false;
                      }else{
                        startgame();
                      }
                    },
                    child: Text(
                      isplaying ? 'END' : 'START',
                      style: fontstyle,
                    ),
                    color: isplaying ? Colors.red : Colors.blue,

                  ),
                Text(
                  'Score : ${snake.length - 2}',
                  style: fontstyle,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

