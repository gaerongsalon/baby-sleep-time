int asyyyyMMdd(DateTime input) {
  return input.year * 10000 + input.month * 100 + input.day;
}

int ashhmmss(DateTime input) {
  return input.hour * 10000 + input.minute * 100 + input.second;
}

DateTime fromyyyyMMdd(int input) {
  return DateTime.parse(input.toString());
}

DateTime fromyyyyMMddhhmmss(int yyyyMMdd, int hhmmss) {
  final padded = "0$hhmmss";
  final sixdigit = padded.length == 6 ? padded : padded.substring(1);
  return DateTime.parse("${yyyyMMdd}T$sixdigit");
}
