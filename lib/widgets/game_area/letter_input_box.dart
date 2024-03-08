
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wordle/utils/enums.dart';
import 'package:flutter_wordle/utils/methods.dart';

class LetterInputBox extends StatefulWidget {

  final String correspondingLetter;
  const LetterInputBox(this.correspondingLetter, {super.key});

  @override
  State<LetterInputBox> createState() => LetterInputBoxState();
}

class LetterInputBoxState extends State<LetterInputBox> {

  FlipCardController flipCtrl = FlipCardController();
  Color revealColor = Colors.black;

  void revealWords(Color color){

    setState(() {
      revealColor = color;
    });
    flipCtrl.toggleCard();
  }

  Widget theBox(bool isRevealed){

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 56,
      width: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        shape: BoxShape.rectangle,
        border: Border.all(
          color: isRevealed ?  revealColor : (AdaptiveTheme.of(context).mode.isLight ? Colors.black : Colors.white),
          width: 2
        ),
        color: isRevealed ? revealColor : null
      ),
      child: Center(
        child: Text(
          getUpperCaseLetter(widget.correspondingLetter),
          style: TextStyle(
            fontSize: 28, 
            fontWeight: FontWeight.bold,
            fontFamily: TextFonts.kanit.value,
            color: isRevealed ? Colors.black : null 
          ),
          textAlign: TextAlign.center,
        )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    
    return FlipCard(
      controller: flipCtrl,
      flipOnTouch: false,
      direction: FlipDirection.VERTICAL,
      back: theBox(true),
      front: theBox(false),
    );
  }
}