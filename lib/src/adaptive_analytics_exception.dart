/// Thrown when the Adaptive Analytics SDK encounters a platform-level error.
class AdaptiveAnalyticsException implements Exception {
  final String code;
  final String message;

  const AdaptiveAnalyticsException({
    required this.code,
    required this.message,
  });

  @override
  String toString() => 'AdaptiveAnalyticsException[$code]: $message';
}
