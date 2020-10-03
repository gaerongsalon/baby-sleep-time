String printReadableDuration(Duration duration) {
  if (duration.inHours > 0) {
    return "${duration.inHours}시간 ${duration.inMinutes.remainder(60)}분";
  }
  return "${duration.inMinutes.remainder(60)}분";
}
