class Weight {
  final String imperial;
  final String metric;

  Weight({
    required this.imperial,
    required this.metric,
  });

  factory Weight.fromJson(Map<String, dynamic> json) {
    return Weight(
      imperial: json['imperial'],
      metric: json['metric'],
    );
  }
}
