int asyyyyMMdd(DateTime input) {
  return input.year * 10000 + input.month * 100 + input.day;
}

int ashhmmss(DateTime input) {
  return input.hour * 10000 + input.minute * 100 + input.second;
}

DateTime fromyyyyMMdd(int input) {
  return DateTime.parse(input.toString());
}
