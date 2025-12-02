// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'support_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SupportTicketImpl _$$SupportTicketImplFromJson(Map<String, dynamic> json) =>
    _$SupportTicketImpl(
      id: json['id'] as String,
      oderId: json['oderId'] as String,
      tripId: json['tripId'] as String?,
      category: $enumDecode(_$TicketCategoryEnumMap, json['category']),
      status: $enumDecode(_$TicketStatusEnumMap, json['status']),
      subject: json['subject'] as String,
      description: json['description'] as String,
      attachments: (json['attachments'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      assignedTo: json['assignedTo'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      resolvedAt: json['resolvedAt'] == null
          ? null
          : DateTime.parse(json['resolvedAt'] as String),
    );

Map<String, dynamic> _$$SupportTicketImplToJson(_$SupportTicketImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'oderId': instance.oderId,
      'tripId': instance.tripId,
      'category': _$TicketCategoryEnumMap[instance.category]!,
      'status': _$TicketStatusEnumMap[instance.status]!,
      'subject': instance.subject,
      'description': instance.description,
      'attachments': instance.attachments,
      'assignedTo': instance.assignedTo,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'resolvedAt': instance.resolvedAt?.toIso8601String(),
    };

const _$TicketCategoryEnumMap = {
  TicketCategory.payment: 'payment',
  TicketCategory.trip: 'trip',
  TicketCategory.account: 'account',
  TicketCategory.safety: 'safety',
  TicketCategory.technical: 'technical',
  TicketCategory.other: 'other',
};

const _$TicketStatusEnumMap = {
  TicketStatus.open: 'open',
  TicketStatus.inProgress: 'inProgress',
  TicketStatus.resolved: 'resolved',
  TicketStatus.closed: 'closed',
};

_$TicketMessageImpl _$$TicketMessageImplFromJson(Map<String, dynamic> json) =>
    _$TicketMessageImpl(
      id: json['id'] as String,
      ticketId: json['ticketId'] as String,
      senderId: json['senderId'] as String,
      senderName: json['senderName'] as String,
      isStaff: json['isStaff'] as bool,
      message: json['message'] as String,
      attachments: (json['attachments'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$TicketMessageImplToJson(_$TicketMessageImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'ticketId': instance.ticketId,
      'senderId': instance.senderId,
      'senderName': instance.senderName,
      'isStaff': instance.isStaff,
      'message': instance.message,
      'attachments': instance.attachments,
      'createdAt': instance.createdAt.toIso8601String(),
    };

_$FAQItemImpl _$$FAQItemImplFromJson(Map<String, dynamic> json) =>
    _$FAQItemImpl(
      id: json['id'] as String,
      question: json['question'] as String,
      answer: json['answer'] as String,
      category: json['category'] as String,
      helpfulCount: (json['helpfulCount'] as num?)?.toInt() ?? 0,
      notHelpfulCount: (json['notHelpfulCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$FAQItemImplToJson(_$FAQItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'question': instance.question,
      'answer': instance.answer,
      'category': instance.category,
      'helpfulCount': instance.helpfulCount,
      'notHelpfulCount': instance.notHelpfulCount,
    };

_$DisputeImpl _$$DisputeImplFromJson(Map<String, dynamic> json) =>
    _$DisputeImpl(
      id: json['id'] as String,
      tripId: json['tripId'] as String,
      complainantId: json['complainantId'] as String,
      respondentId: json['respondentId'] as String,
      reason: json['reason'] as String,
      description: json['description'] as String?,
      status: $enumDecode(_$TicketStatusEnumMap, json['status']),
      resolution: json['resolution'] as String?,
      resolvedBy: json['resolvedBy'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      resolvedAt: json['resolvedAt'] == null
          ? null
          : DateTime.parse(json['resolvedAt'] as String),
    );

Map<String, dynamic> _$$DisputeImplToJson(_$DisputeImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tripId': instance.tripId,
      'complainantId': instance.complainantId,
      'respondentId': instance.respondentId,
      'reason': instance.reason,
      'description': instance.description,
      'status': _$TicketStatusEnumMap[instance.status]!,
      'resolution': instance.resolution,
      'resolvedBy': instance.resolvedBy,
      'createdAt': instance.createdAt.toIso8601String(),
      'resolvedAt': instance.resolvedAt?.toIso8601String(),
    };
