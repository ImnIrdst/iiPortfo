extension DateTimeUtils on DateTime {
  int toPosix() => this.toUtc().millisecondsSinceEpoch ~/ 1000;
}
