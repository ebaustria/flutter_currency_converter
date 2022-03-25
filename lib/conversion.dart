class Conversion {
  final Map<String, dynamic> conversionRate;

  const Conversion({
    required this.conversionRate,
  });

  factory Conversion.fromJson(Map<String, dynamic> json) {
    return Conversion(
      conversionRate: json[json.keys.first],
    );
  }
}