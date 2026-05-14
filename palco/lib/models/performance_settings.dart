class PerformanceSettings {
  final int transposeSteps;
  final double fontSize;
  final bool autoScroll;
  final double scrollSpeed;
  final int capo;

  const PerformanceSettings({
    this.transposeSteps = 0,
    this.fontSize = 18.0,
    this.autoScroll = false,
    this.scrollSpeed = 30.0,
    this.capo = 0,
  });

  PerformanceSettings copyWith({
    int? transposeSteps,
    double? fontSize,
    bool? autoScroll,
    double? scrollSpeed,
    int? capo,
  }) {
    return PerformanceSettings(
      transposeSteps: transposeSteps ?? this.transposeSteps,
      fontSize: fontSize ?? this.fontSize,
      autoScroll: autoScroll ?? this.autoScroll,
      scrollSpeed: scrollSpeed ?? this.scrollSpeed,
      capo: capo ?? this.capo,
    );
  }
}
