class RazorpayPaymentLinkModel {
  final String id;
  final String shortUrl;
  final String callbackUrl;

  const RazorpayPaymentLinkModel({
    required this.id,
    required this.shortUrl,
    required this.callbackUrl,
  });

  static RazorpayPaymentLinkModel fromMap(Map<String, dynamic> map) {
    return RazorpayPaymentLinkModel(
      id: map['id'] as String,
      shortUrl: map['shortUrl'] as String,
      callbackUrl: map['callbackUrl'] as String,
    );
  }
}
