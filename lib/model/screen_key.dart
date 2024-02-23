
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@immutable
class ScreenKey {

  final String theKey;
  const ScreenKey({
    required this.theKey,
  });
  

  ScreenKey copyWith({
    String? theKey,
  }) {
    return ScreenKey(
      theKey: theKey ?? this.theKey,
    );
  }

  @override
  bool operator ==(covariant ScreenKey other) {
    if (identical(this, other)) return true;
  
    return 
      other.theKey == theKey;
  }

  @override
  int get hashCode => theKey.hashCode;
} 

class ScreenKeyNotifier extends StateNotifier<ScreenKey?> {

  ScreenKeyNotifier(): super(null);
  
  // Since the state is immutable, we need to change state object with a new ScreenKey object every time
  // No need to call "notifyListeners" or anything similar, "state =" will automatically rebuild the UI when necessary.
  void setScreenKey(ScreenKey screenKey){
    state = screenKey;
  }

  void clearScreenKey(){
    state = null;
  }
}