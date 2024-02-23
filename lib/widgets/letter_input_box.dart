
import 'package:adaptive_theme/adaptive_theme.dart';
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

  Color? revealColor;

  void revealWords(Color color){

    setState(() {
      revealColor = color;
    });
  }

    @override
  Widget build(BuildContext context) {
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 450),
      curve: Curves.bounceIn,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 56,
      width: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        shape: BoxShape.rectangle,
        border: Border.all(
          color: revealColor ?? (AdaptiveTheme.of(context).mode.isLight ? Colors.black : Colors.white),
          width: 2
        ),
        color: revealColor
      ),
      child: Center(
        child: Text(
          getUpperCaseLetter(widget.correspondingLetter),
          style: TextStyle(
            fontSize: 28, 
            fontWeight: FontWeight.bold,
            fontFamily: TextFonts.kanit.value,
            color: revealColor != null ? Colors.black : revealColor 
          ),
          textAlign: TextAlign.center,
        )
      ),
    );
  }
}