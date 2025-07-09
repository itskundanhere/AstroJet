import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:game_jet/my_game.dart';

class GameOverOverlays extends StatefulWidget {
  final MyGame game;
  const GameOverOverlays({super.key, required this.game});


  @override
  State<GameOverOverlays> createState() => _GameOverOverlaysState();
}

class _GameOverOverlaysState extends State<GameOverOverlays> {
  double _opacity = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(
      const Duration(milliseconds: 0),
      (){
        setState(() {
          _opacity = 1.0;
        });
      }
    );
  }
  @override
  Widget build(BuildContext context) {
    return  AnimatedOpacity(
      onEnd: (){
        if(_opacity == 0.0){
          widget.game.overlays.remove('GameOver');
        }
      },
      opacity: _opacity,
      duration: const Duration(milliseconds: 500),
      child: Container(
        color: Colors.black.withAlpha(150),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:[
            Text('GAME OVER',
            style: TextStyle(
              color: Colors.white,
              fontSize: 48,
              fontWeight: FontWeight.bold,
            ),
            ),
            const SizedBox(height: 30),
            TextButton(onPressed: (){
              widget.game.audioManager.playSound('click');
              widget.game.restartGame();
              setState(() {
                _opacity = 0.0;
              });
            }, style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 25 ),
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
            ), child: Text('PLAY AGAIN',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
            ),
            ),
            ),
      
            const SizedBox(height: 15,),
            TextButton(onPressed: (){
              widget.game.audioManager.playSound('click');
              widget.game.quiteGame(); 
              setState(() {
                _opacity = 0.0;
              });
            }, style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 25 ),
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
            ), child: Text('GAME OVER',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
            ),
            ),
            ),
          ],
          
        ),
        
        
      
      ),
    );
  }
}