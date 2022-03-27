class CurrencyData {
  final String code;
  final String emoji;
  final String symbol;

  const CurrencyData({
    required this.code,
    required this.emoji,
    required this.symbol,
  });

  factory CurrencyData.fromJson(Map<String, dynamic> json) {
    return CurrencyData(
      code: json['code'],
      emoji: json['emoji'],
      symbol: json['symbol'],
    );
  }
}