extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}

String semesterFormatted(semester) {
  switch (semester) {
    case 1:
      return "Termin en";
      break;
    case 2:
      return "Termin to";

    default:
      return "Du er ikke i en termin!";
  }
}
