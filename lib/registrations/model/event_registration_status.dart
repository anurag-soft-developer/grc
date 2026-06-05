class EventRegistrationStatus {
  final String status;
  final String? participantId;
  final String? paymentExpiresAt;
  final bool paymentHoldExpired;

  const EventRegistrationStatus({
    required this.status,
    this.participantId,
    this.paymentExpiresAt,
    this.paymentHoldExpired = false,
  });

  static const none = EventRegistrationStatus(status: 'none');

  bool get isNone => status == 'none';
  bool get isDraft => status == 'draft';
  bool get isPendingPayment => status == 'pending_payment';
  bool get isSubmitted => status == 'submitted';
  bool get isCancelled => status == 'cancelled';

  bool get isTicket => isSubmitted && participantId != null;

  bool canPayNow(bool eventOpen) =>
      eventOpen &&
      isPendingPayment &&
      !paymentHoldExpired &&
      participantId != null;

  bool canContinue(bool eventOpen) =>
      eventOpen && isDraft && participantId != null;

  bool canRegister(bool eventOpen) =>
      eventOpen &&
      (isNone || isCancelled || (isPendingPayment && paymentHoldExpired));

  static EventRegistrationStatus fromMap(Map<String, dynamic> map) {
    return EventRegistrationStatus(
      status: map['status'] as String? ?? 'none',
      participantId: map['participantId'] as String?,
      paymentExpiresAt: map['paymentExpiresAt'] as String?,
      paymentHoldExpired: map['paymentHoldExpired'] == true,
    );
  }
}
