
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_wordle/utils/enums.dart';
import 'package:flutter_wordle/utils/methods.dart';
import 'package:flutter_wordle/utils/providers.dart';
import 'package:flutter_wordle/utils/styling.dart';
import 'package:flutter_wordle/widgets/general/vertical_space.dart';

class GameDialog extends ConsumerStatefulWidget {

  final VoidCallback onNewGameTap;
  const GameDialog(this.onNewGameTap, {super.key});

  @override
  ConsumerState<GameDialog> createState() => _GameDialogState();
}

class _GameDialogState extends ConsumerState<GameDialog> {

  late GameStatus gameStatus;

  List<Widget> getWidgetFromStatus(){

    if(gameStatus == GameStatus.continues){
      return [
        Text(
        "Oyun Devam Ediyor",
          style: TextStyle(
            fontFamily: TextFonts.kanit.value,
            fontWeight: FontWeight.normal,
            fontSize: 18
          ),
        ),
      ];
    }

    bool won = gameStatus == GameStatus.won;
    String correctWord = ref.read(wordProvider);

    return [
      Text(
        "Aranan Kelime",
        style: TextStyle(
          fontFamily: TextFonts.kanit.value,
          fontWeight: FontWeight.normal,
          fontSize: 18
        ),
      ),
      const VerticalSpace(4),
      Text(
        getUpperCaseText(correctWord),
        style: TextStyle(
          color: won ? wordleGreen : wordleRed,
          fontFamily: TextFonts.kanit.value,
          fontWeight: FontWeight.bold,
          fontSize: 32
        ),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {

    gameStatus = ref.watch(gameOverProvider);
    
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12)
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const VerticalSpace(12),
            ...getWidgetFromStatus(),
            const VerticalSpace(24),
            ElevatedButton(
              onPressed: (){
                Navigator.of(context).pop();
                widget.onNewGameTap();
              },
              style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(
                  side: BorderSide()
                ),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 36),
              ),
              child: Text(
                "Yeni Oyun",
                style: TextStyle(
                  fontFamily: TextFonts.kanit.value,
                  fontSize: 18,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            const VerticalSpace(12),
          ],
        ),
      ),
    );
  }
}