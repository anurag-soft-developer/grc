import 'package:dart_mappable/dart_mappable.dart';

part 'razorpay_order_model.mapper.dart';

@MappableClass()
class RazorpayOrderModel with RazorpayOrderModelMappable {
  final String id;
  final String entity;
  final int amount;
  @MappableField(key: 'amount_paid')
  final int amountPaid;
  @MappableField(key: 'amount_due')
  final int amountDue;
  final String currency;
  final String receipt;
  final String status;
  final int attempts;
  @MappableField(key: 'created_at')
  final int createdAt;

  const RazorpayOrderModel({
    required this.id,
    required this.entity,
    required this.amount,
    required this.amountPaid,
    required this.amountDue,
    required this.currency,
    required this.receipt,
    required this.status,
    required this.attempts,
    required this.createdAt,
  });

  static final fromMap = RazorpayOrderModelMapper.fromMap;
}
