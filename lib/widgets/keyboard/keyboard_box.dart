
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_wordle/model/screen_key.dart';
import 'package:flutter_wordle/utils/enums.dart';
import 'package:flutter_wordle/utils/methods.dart';
import 'package:flutter_wordle/utils/providers.dart';

class KeyboardBox extends ConsumerStatefulWidget {

  final String letter;
  final Size boxSize;
  final KeyType keyType;
  const KeyboardBox(this.letter, this.keyType, this.boxSize, {super.key});

  @override
  ConsumerState<KeyboardBox> createState() => _KeyboardBoxState();
}

class _KeyboardBoxState extends ConsumerState<KeyboardBox> {

  GuessLetterStatus status = GuessLetterStatus.notGuessed;
  late Widget displayWidget;

  @override
  void initState() {
    super.initState();
    
    if(widget.keyType == KeyType.backspace){
      
      displayWidget = Icon(
        Icons.backspace,
        size: 28,
        color: status == GuessLetterStatus.notGuessed ? Colors.black : Colors.white,
      );
    }
    else{
      
      displayWidget = Text(
        widget.keyType == KeyType.enter ? widget.letter : getUpperCaseLetter(widget.letter),
        style: TextStyle(
          color: status == GuessLetterStatus.notGuessed ? Colors.black : Colors.white,
          fontFamily: TextFonts.kanit.value,
          fontWeight: FontWeight.bold,
          fontSize: widget.keyType == KeyType.enter ? 20 : 24
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    final map = ref.watch(letterColorMapProvider);
    if(map.containsKey(widget.letter)){
      GuessLetterStatus newStatus = map[widget.letter]!;
      if(status == GuessLetterStatus.notGuessed){
        status = newStatus;
      }
      else{
        if(status == GuessLetterStatus.falsePlace && newStatus == GuessLetterStatus.match){
          status = newStatus;
        }
      }
    }
    
    return InkWell(
      onTap: ()=> ref.read(screenKeyboardTapProvider.notifier).setScreenKey(
        ScreenKey(theKey: widget.letter)
      ),
      child: Container(
        margin: const EdgeInsets.all(4),
        height: widget.boxSize.height,
        width: widget.boxSize.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: status.color
        ),
        child: Center(
          child: displayWidget
        ),
      ),
    );
  }
}