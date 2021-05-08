class ProgressState {
  final double progress;
  final String info;

  ProgressState(this.progress, this.info);

  int get progressPercent => (progress * 100).toInt();
}
