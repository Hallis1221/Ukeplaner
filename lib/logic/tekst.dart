// Utvider string. Det gjør at vi kan skrive feks "".capitalize();
extension StringExtension on String {
  // gjør den første bokstaven i teksten stor
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }

  // fjerner alle andre karakterer enn de tre første i teksten
  String onlyThreeFirst() {
    String newString = "";

    int ranTrough = 0;
    // for hver karakter i teksten
    this.runes.forEach((char) {
      ranTrough += 1;
      String character = new String.fromCharCode(char);
      if (ranTrough <= 3) {
        newString = newString + character;
      } else {
        return;
      }
    });
    return newString;
  }
}

String semesterFormatted(semester) {
  switch (semester) {
    case 1:
      return "Termin 1";
      break;
    case 2:
      return "Termin 2";

    default:
      return "Du er ikke i en termin!";
  }
}

String convertDoubleToTime(double _double) {
  String _string = _double.toString();
  String beforeResult = "";
  String afterResult = "";
  List charactersBeforeSeperator = [];
  List charactersAfterSeperator = [];
  bool beforeSeperator = true;
  for (var i = 0; i < _string.length; i++) {
    try {
      int.parse(_string[i]);
    } catch (e) {
      beforeSeperator = false;
      continue;
    }
    if (beforeSeperator) {
      charactersBeforeSeperator.add(_string[i]);
    } else if (!beforeSeperator) {
      charactersAfterSeperator.add(_string[i]);
    }
  }
  if (charactersBeforeSeperator.length <= 1) {
    for (var character in charactersBeforeSeperator) {
      beforeResult = beforeResult + "0" + character;
    }
  } else {
    for (var character in charactersBeforeSeperator) {
      beforeResult = beforeResult + character;
    }
  }
  if (charactersAfterSeperator.length <= 1) {
    for (var character in charactersAfterSeperator) {
      afterResult = afterResult + character + "0";
    }
  } else {
    for (var character in charactersAfterSeperator) {
      afterResult = afterResult + character;
    }
  }

  String result = "$beforeResult:$afterResult";
  return result;
}
