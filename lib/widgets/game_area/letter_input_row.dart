
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_wordle/model/letter_status.dart';
import 'package:flutter_wordle/utils/enums.dart';
import 'package:flutter_wordle/utils/methods.dart';
import 'package:flutter_wordle/utils/providers.dart';
import 'package:flutter_wordle/utils/values.dart';
import 'package:flutter_wordle/widgets/game_area/letter_input_box.dart';

class LetterInputRow extends ConsumerStatefulWidget {

  final int rowNum;
  final int length;
  final bool enabled;
  final VoidCallback onGameEnd;
  const LetterInputRow(this.rowNum, this.length, this.enabled, this.onGameEnd, {super.key});

  @override
  ConsumerState<LetterInputRow> createState() => _LetterInputRowState();
}

class _LetterInputRowState extends ConsumerState<LetterInputRow> {
  
  String currentRowText = "";
  FocusNode fNode = FocusNode();
  bool evaluating = false;

  List<GuessLetter> guessLetters = [];
  List<bool> correctLetterProcessed = [];
  List<GlobalKey<LetterInputBoxState>> globalKeys = [];

  Map<String, GuessLetterStatus> letterColorMap = {};

  @override
  void initState(){
    super.initState();

    guessLetters = List.generate(widget.length, (index) => GuessLetter(index: index, letter: '', status: GuessLetterStatus.notGuessed));
    correctLetterProcessed = List.generate(widget.length, (index) => false);
    globalKeys = List.generate(widget.length, (index) => GlobalKey(debugLabel: '${widget.rowNum}-$index'));
  }

  bool checkWord(String currentRowText) {

    ScaffoldMessengerState messengerState = ScaffoldMessenger.of(context);

    if(availableWords.contains(currentRowText)){
      return true;
    }
    
    messengerState.showSnackBar(
      SnackBar(
        content: Text(
          "Sözlükte böyle bir kelime yok!",
          style: TextStyle(
            color: Colors.white,
            fontFamily: TextFonts.kanit.value
          ),
        ),
        backgroundColor: Colors.red,
      )
    );
    return false;
  }

  void updateColorMap(String letter, GuessLetterStatus letterStatus){
    if(!letterColorMap.containsKey(letter)){
      letterColorMap.addAll({
        letter : letterStatus
      });
    }
  }

  void syncText(){
    
    for(int i = 0;  i < currentRowText.length;  i++){
      guessLetters[i].letter = currentRowText[i];
    }
  }
  
  void findCorrects(String correctWord){

    for(int i = 0;  i < widget.length;  i++){
      if(correctWord[i] == currentRowText[i]){
        guessLetters[i].status = GuessLetterStatus.match;
        updateColorMap(currentRowText[i], GuessLetterStatus.match);
        correctLetterProcessed[i] = true;
      }
    }
  }

  void findFalsePlaces(String correctWord){
    
    for(int i = 0;  i < widget.length;  i++){
      if(guessLetters[i].status == GuessLetterStatus.notGuessed){
        for(int k = 0;  k < widget.length;  k++){
          if(guessLetters[i].letter == correctWord[k] && !correctLetterProcessed[k]){
            guessLetters[i].status = GuessLetterStatus.falsePlace;
            updateColorMap(guessLetters[i].letter, GuessLetterStatus.falsePlace);
            correctLetterProcessed[k] = true;
            break;
          }
        }
      }
      else{
        //skip letter as it is processed before
      }
    }
  }

  void setRemainingLetters(){

    for(int i = 0;  i < widget.length;  i++){
      if(guessLetters[i].status == GuessLetterStatus.notGuessed){
        updateColorMap(guessLetters[i].letter, GuessLetterStatus.nonMatch);
        guessLetters[i].status = GuessLetterStatus.nonMatch;
      }
    }
  }

  Future<void> evaluateWord() async {

    evaluating = true;
    String correctWord = ref.read(wordProvider);
    letterColorMap.clear();
    
    syncText();
    findCorrects(correctWord);
    findFalsePlaces(correctWord);
    setRemainingLetters();
  
    int wordRevealCount = 0;
    Timer.periodic(const Duration(milliseconds: 450), (timer) { 
      if(wordRevealCount != widget.length){
        globalKeys[wordRevealCount].currentState?.revealWords(guessLetters[wordRevealCount].status.color);
        wordRevealCount++;
      }
      else{
        timer.cancel();
      }
    });

    await Future.delayed(Duration(milliseconds: (450 * (widget.length+1)) + 250));

    ref.read(letterColorMapProvider.notifier).setLetterColorMap(letterColorMap);
  }

  void handleKeyPress(String pressedKey, String letter) async {

    if(evaluating){
      return;
    }

    if(pressedKey.compareTo("Enter") == 0){

      ScaffoldMessengerState messengerState = ScaffoldMessenger.of(context);
      messengerState.clearSnackBars();

      if(currentRowText.length == widget.length){

        bool wordValid = checkWord(currentRowText);
        if(!wordValid){
          return;
        }

        ref.read(guessesProvider.notifier).update((state) => state = [...state, currentRowText]);
        await evaluateWord();

        if(currentRowText.compareTo(ref.read(wordProvider)) == 0){
          ref.read(gameOverProvider.notifier).update((state) => state = GameStatus.won);
          fNode.unfocus();
        }
        else{
          ref.read(guessCountProvider.notifier).update((state) => state = state + 1);
          fNode.nextFocus();
        }
      }
      else{
        //give warning
        messengerState.showSnackBar(
          SnackBar(content: Text(
            "${widget.length} uzunluğunda bir kelime girmelisiniz!"
          ))
        );
      }
      return;
    }
    else if(pressedKey.compareTo("Backspace") == 0){
      if(currentRowText.isNotEmpty){
        setState(() {
          currentRowText = currentRowText.substring(0, currentRowText.length - 1);
        });
      }
      return;
    }
    else{
      if(pressedKey.startsWith("Key")){
        if(letter == 'x' || letter == 'w' || letter == 'q'){
          return;
        }
        
        if(currentRowText.length < widget.length){
          setState(() {
            currentRowText = "$currentRowText$letter";
          });
        }
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    ref.listen(screenKeyboardTapProvider, (previous, next) {
      
      if(!widget.enabled || next == null){
        return;
      }

      String tappedKey = next.theKey;
      
      if(tappedKey == 'Enter' || tappedKey == 'Backspace'){
        handleKeyPress(tappedKey, "");
      }
      else{
        handleKeyPress("Key ${getUpperCaseLetter(tappedKey)}", tappedKey);
      }
    });

    ref.listen(guessCountProvider, (previous, next) { 
      if(next == 6 && widget.enabled){
        ref.read(gameOverProvider.notifier).update((state) => state = GameStatus.lost);
      }
    });

    ref.listen<GameStatus>(gameOverProvider, (previous, next) {
      if(next != GameStatus.continues && widget.enabled){
        widget.onGameEnd();
      }
    });

    return GestureDetector(
      onTap: !widget.enabled ? null : ()=> fNode.requestFocus(),
      child: RawKeyboardListener(
        focusNode: fNode,
        includeSemantics: true,
        onKey: (value) {
          if(value.runtimeType.toString() == 'RawKeyUpEvent'){
            String? pressedKey = value.data.logicalKey.debugName;
            if(pressedKey != null){
              handleKeyPress(pressedKey, value.data.keyLabel);
            }
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.length, 
            (index){

              String displayLetter;
              try{
                displayLetter = currentRowText[index];
              }
              catch(exp){
                displayLetter = '';
              }

              return LetterInputBox(displayLetter, key: globalKeys[index]);
            }
          )
        ),
      ),
    );
  }
}