import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:game_jet/my_game.dart';
import 'package:game_jet/overlays/game_over_overlays.dart';
import 'package:game_jet/overlays/title_overlay.dart';

void main() {
  final MyGame game = MyGame();
  runApp(GameWidget(game: game,
  overlayBuilderMap: {
    'GameOver': (context, MyGame game) => GameOverOverlays(game: game),
    'Title': (context, MyGame game) => TitleOverlay(game: game),
  },
  initialActiveOverlays: const['Title'],
  ),
  );
}

