import 'package:freezed_annotation/freezed_annotation.dart';

part 'support_model.freezed.dart';
part 'support_model.g.dart';

enum TicketStatus { open, inProgress, resolved, closed }

enum TicketCategory { payment, trip, account, safety, technical, other }

@freezed
class SupportTicket with _$SupportTicket {
  const SupportTicket._();

  const factory SupportTicket({
    required String id,
    required String userId,
    String? tripId,
    required TicketCategory category,
    required TicketStatus status,
    required String subject,
    required String description,
    List<String>? attachments,
    String? assignedTo,
    required DateTime createdAt,
    DateTime? updatedAt,
    DateTime? resolvedAt,
  }) = _SupportTicket;

  factory SupportTicket.fromJson(Map<String, dynamic> json) =>
      _$SupportTicketFromJson(json);

  bool get isOpen =>
      status == TicketStatus.open || status == TicketStatus.inProgress;
}

@freezed
class TicketMessage with _$TicketMessage {
  const factory TicketMessage({
    required String id,
    required String ticketId,
    required String senderId,
    required String senderName,
    required bool isStaff,
    required String message,
    List<String>? attachments,
    required DateTime createdAt,
  }) = _TicketMessage;

  factory TicketMessage.fromJson(Map<String, dynamic> json) =>
      _$TicketMessageFromJson(json);
}

@freezed
class FAQItem with _$FAQItem {
  const factory FAQItem({
    required String id,
    required String question,
    required String answer,
    required String category,
    @Default(0) int helpfulCount,
    @Default(0) int notHelpfulCount,
  }) = _FAQItem;

  factory FAQItem.fromJson(Map<String, dynamic> json) =>
      _$FAQItemFromJson(json);
}

@freezed
class Dispute with _$Dispute {
  const factory Dispute({
    required String id,
    required String tripId,
    required String complainantId,
    required String respondentId,
    required String reason,
    String? description,
    required TicketStatus status,
    String? resolution,
    String? resolvedBy,
    required DateTime createdAt,
    DateTime? resolvedAt,
  }) = _Dispute;

  factory Dispute.fromJson(Map<String, dynamic> json) =>
      _$DisputeFromJson(json);
}
