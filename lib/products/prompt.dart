import 'dart:io';

mixin Prompt {
  static String enter(String message) {
    print(message);
    return stdin.readLineSync()?.trim() ?? '';
  }
}
