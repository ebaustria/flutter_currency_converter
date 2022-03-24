class Conversion {
  final double conversionRate;

  const Conversion({
    required this.conversionRate,
  });

  factory Conversion.fromJson(Map<String, dynamic> json) {
    return Conversion(
      conversionRate: json[json.keys.first],
    );
  }
}