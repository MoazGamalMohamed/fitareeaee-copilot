// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'support_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SupportTicket _$SupportTicketFromJson(Map<String, dynamic> json) {
  return _SupportTicket.fromJson(json);
}

/// @nodoc
mixin _$SupportTicket {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String? get tripId => throw _privateConstructorUsedError;
  TicketCategory get category => throw _privateConstructorUsedError;
  TicketStatus get status => throw _privateConstructorUsedError;
  String get subject => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  List<String>? get attachments => throw _privateConstructorUsedError;
  String? get assignedTo => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  DateTime? get resolvedAt => throw _privateConstructorUsedError;

  /// Serializes this SupportTicket to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SupportTicket
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SupportTicketCopyWith<SupportTicket> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SupportTicketCopyWith<$Res> {
  factory $SupportTicketCopyWith(
    SupportTicket value,
    $Res Function(SupportTicket) then,
  ) = _$SupportTicketCopyWithImpl<$Res, SupportTicket>;
  @useResult
  $Res call({
    String id,
    String userId,
    String? tripId,
    TicketCategory category,
    TicketStatus status,
    String subject,
    String description,
    List<String>? attachments,
    String? assignedTo,
    DateTime createdAt,
    DateTime? updatedAt,
    DateTime? resolvedAt,
  });
}

/// @nodoc
class _$SupportTicketCopyWithImpl<$Res, $Val extends SupportTicket>
    implements $SupportTicketCopyWith<$Res> {
  _$SupportTicketCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SupportTicket
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? tripId = freezed,
    Object? category = null,
    Object? status = null,
    Object? subject = null,
    Object? description = null,
    Object? attachments = freezed,
    Object? assignedTo = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? resolvedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            tripId: freezed == tripId
                ? _value.tripId
                : tripId // ignore: cast_nullable_to_non_nullable
                      as String?,
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as TicketCategory,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as TicketStatus,
            subject: null == subject
                ? _value.subject
                : subject // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            attachments: freezed == attachments
                ? _value.attachments
                : attachments // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            assignedTo: freezed == assignedTo
                ? _value.assignedTo
                : assignedTo // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            resolvedAt: freezed == resolvedAt
                ? _value.resolvedAt
                : resolvedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SupportTicketImplCopyWith<$Res>
    implements $SupportTicketCopyWith<$Res> {
  factory _$$SupportTicketImplCopyWith(
    _$SupportTicketImpl value,
    $Res Function(_$SupportTicketImpl) then,
  ) = __$$SupportTicketImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String userId,
    String? tripId,
    TicketCategory category,
    TicketStatus status,
    String subject,
    String description,
    List<String>? attachments,
    String? assignedTo,
    DateTime createdAt,
    DateTime? updatedAt,
    DateTime? resolvedAt,
  });
}

/// @nodoc
class __$$SupportTicketImplCopyWithImpl<$Res>
    extends _$SupportTicketCopyWithImpl<$Res, _$SupportTicketImpl>
    implements _$$SupportTicketImplCopyWith<$Res> {
  __$$SupportTicketImplCopyWithImpl(
    _$SupportTicketImpl _value,
    $Res Function(_$SupportTicketImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SupportTicket
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? tripId = freezed,
    Object? category = null,
    Object? status = null,
    Object? subject = null,
    Object? description = null,
    Object? attachments = freezed,
    Object? assignedTo = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? resolvedAt = freezed,
  }) {
    return _then(
      _$SupportTicketImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        tripId: freezed == tripId
            ? _value.tripId
            : tripId // ignore: cast_nullable_to_non_nullable
                  as String?,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as TicketCategory,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as TicketStatus,
        subject: null == subject
            ? _value.subject
            : subject // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        attachments: freezed == attachments
            ? _value._attachments
            : attachments // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        assignedTo: freezed == assignedTo
            ? _value.assignedTo
            : assignedTo // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        resolvedAt: freezed == resolvedAt
            ? _value.resolvedAt
            : resolvedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SupportTicketImpl extends _SupportTicket {
  const _$SupportTicketImpl({
    required this.id,
    required this.userId,
    this.tripId,
    required this.category,
    required this.status,
    required this.subject,
    required this.description,
    final List<String>? attachments,
    this.assignedTo,
    required this.createdAt,
    this.updatedAt,
    this.resolvedAt,
  }) : _attachments = attachments,
       super._();

  factory _$SupportTicketImpl.fromJson(Map<String, dynamic> json) =>
      _$$SupportTicketImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String? tripId;
  @override
  final TicketCategory category;
  @override
  final TicketStatus status;
  @override
  final String subject;
  @override
  final String description;
  final List<String>? _attachments;
  @override
  List<String>? get attachments {
    final value = _attachments;
    if (value == null) return null;
    if (_attachments is EqualUnmodifiableListView) return _attachments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? assignedTo;
  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;
  @override
  final DateTime? resolvedAt;

  @override
  String toString() {
    return 'SupportTicket(id: $id, userId: $userId, tripId: $tripId, category: $category, status: $status, subject: $subject, description: $description, attachments: $attachments, assignedTo: $assignedTo, createdAt: $createdAt, updatedAt: $updatedAt, resolvedAt: $resolvedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SupportTicketImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.tripId, tripId) || other.tripId == tripId) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.subject, subject) || other.subject == subject) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(
              other._attachments,
              _attachments,
            ) &&
            (identical(other.assignedTo, assignedTo) ||
                other.assignedTo == assignedTo) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.resolvedAt, resolvedAt) ||
                other.resolvedAt == resolvedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    userId,
    tripId,
    category,
    status,
    subject,
    description,
    const DeepCollectionEquality().hash(_attachments),
    assignedTo,
    createdAt,
    updatedAt,
    resolvedAt,
  );

  /// Create a copy of SupportTicket
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SupportTicketImplCopyWith<_$SupportTicketImpl> get copyWith =>
      __$$SupportTicketImplCopyWithImpl<_$SupportTicketImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SupportTicketImplToJson(this);
  }
}

abstract class _SupportTicket extends SupportTicket {
  const factory _SupportTicket({
    required final String id,
    required final String userId,
    final String? tripId,
    required final TicketCategory category,
    required final TicketStatus status,
    required final String subject,
    required final String description,
    final List<String>? attachments,
    final String? assignedTo,
    required final DateTime createdAt,
    final DateTime? updatedAt,
    final DateTime? resolvedAt,
  }) = _$SupportTicketImpl;
  const _SupportTicket._() : super._();

  factory _SupportTicket.fromJson(Map<String, dynamic> json) =
      _$SupportTicketImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String? get tripId;
  @override
  TicketCategory get category;
  @override
  TicketStatus get status;
  @override
  String get subject;
  @override
  String get description;
  @override
  List<String>? get attachments;
  @override
  String? get assignedTo;
  @override
  DateTime get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  DateTime? get resolvedAt;

  /// Create a copy of SupportTicket
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SupportTicketImplCopyWith<_$SupportTicketImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TicketMessage _$TicketMessageFromJson(Map<String, dynamic> json) {
  return _TicketMessage.fromJson(json);
}

/// @nodoc
mixin _$TicketMessage {
  String get id => throw _privateConstructorUsedError;
  String get ticketId => throw _privateConstructorUsedError;
  String get senderId => throw _privateConstructorUsedError;
  String get senderName => throw _privateConstructorUsedError;
  bool get isStaff => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  List<String>? get attachments => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this TicketMessage to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TicketMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TicketMessageCopyWith<TicketMessage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TicketMessageCopyWith<$Res> {
  factory $TicketMessageCopyWith(
    TicketMessage value,
    $Res Function(TicketMessage) then,
  ) = _$TicketMessageCopyWithImpl<$Res, TicketMessage>;
  @useResult
  $Res call({
    String id,
    String ticketId,
    String senderId,
    String senderName,
    bool isStaff,
    String message,
    List<String>? attachments,
    DateTime createdAt,
  });
}

/// @nodoc
class _$TicketMessageCopyWithImpl<$Res, $Val extends TicketMessage>
    implements $TicketMessageCopyWith<$Res> {
  _$TicketMessageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TicketMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? ticketId = null,
    Object? senderId = null,
    Object? senderName = null,
    Object? isStaff = null,
    Object? message = null,
    Object? attachments = freezed,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            ticketId: null == ticketId
                ? _value.ticketId
                : ticketId // ignore: cast_nullable_to_non_nullable
                      as String,
            senderId: null == senderId
                ? _value.senderId
                : senderId // ignore: cast_nullable_to_non_nullable
                      as String,
            senderName: null == senderName
                ? _value.senderName
                : senderName // ignore: cast_nullable_to_non_nullable
                      as String,
            isStaff: null == isStaff
                ? _value.isStaff
                : isStaff // ignore: cast_nullable_to_non_nullable
                      as bool,
            message: null == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                      as String,
            attachments: freezed == attachments
                ? _value.attachments
                : attachments // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TicketMessageImplCopyWith<$Res>
    implements $TicketMessageCopyWith<$Res> {
  factory _$$TicketMessageImplCopyWith(
    _$TicketMessageImpl value,
    $Res Function(_$TicketMessageImpl) then,
  ) = __$$TicketMessageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String ticketId,
    String senderId,
    String senderName,
    bool isStaff,
    String message,
    List<String>? attachments,
    DateTime createdAt,
  });
}

/// @nodoc
class __$$TicketMessageImplCopyWithImpl<$Res>
    extends _$TicketMessageCopyWithImpl<$Res, _$TicketMessageImpl>
    implements _$$TicketMessageImplCopyWith<$Res> {
  __$$TicketMessageImplCopyWithImpl(
    _$TicketMessageImpl _value,
    $Res Function(_$TicketMessageImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TicketMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? ticketId = null,
    Object? senderId = null,
    Object? senderName = null,
    Object? isStaff = null,
    Object? message = null,
    Object? attachments = freezed,
    Object? createdAt = null,
  }) {
    return _then(
      _$TicketMessageImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        ticketId: null == ticketId
            ? _value.ticketId
            : ticketId // ignore: cast_nullable_to_non_nullable
                  as String,
        senderId: null == senderId
            ? _value.senderId
            : senderId // ignore: cast_nullable_to_non_nullable
                  as String,
        senderName: null == senderName
            ? _value.senderName
            : senderName // ignore: cast_nullable_to_non_nullable
                  as String,
        isStaff: null == isStaff
            ? _value.isStaff
            : isStaff // ignore: cast_nullable_to_non_nullable
                  as bool,
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        attachments: freezed == attachments
            ? _value._attachments
            : attachments // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TicketMessageImpl implements _TicketMessage {
  const _$TicketMessageImpl({
    required this.id,
    required this.ticketId,
    required this.senderId,
    required this.senderName,
    required this.isStaff,
    required this.message,
    final List<String>? attachments,
    required this.createdAt,
  }) : _attachments = attachments;

  factory _$TicketMessageImpl.fromJson(Map<String, dynamic> json) =>
      _$$TicketMessageImplFromJson(json);

  @override
  final String id;
  @override
  final String ticketId;
  @override
  final String senderId;
  @override
  final String senderName;
  @override
  final bool isStaff;
  @override
  final String message;
  final List<String>? _attachments;
  @override
  List<String>? get attachments {
    final value = _attachments;
    if (value == null) return null;
    if (_attachments is EqualUnmodifiableListView) return _attachments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'TicketMessage(id: $id, ticketId: $ticketId, senderId: $senderId, senderName: $senderName, isStaff: $isStaff, message: $message, attachments: $attachments, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TicketMessageImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.ticketId, ticketId) ||
                other.ticketId == ticketId) &&
            (identical(other.senderId, senderId) ||
                other.senderId == senderId) &&
            (identical(other.senderName, senderName) ||
                other.senderName == senderName) &&
            (identical(other.isStaff, isStaff) || other.isStaff == isStaff) &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality().equals(
              other._attachments,
              _attachments,
            ) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    ticketId,
    senderId,
    senderName,
    isStaff,
    message,
    const DeepCollectionEquality().hash(_attachments),
    createdAt,
  );

  /// Create a copy of TicketMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TicketMessageImplCopyWith<_$TicketMessageImpl> get copyWith =>
      __$$TicketMessageImplCopyWithImpl<_$TicketMessageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TicketMessageImplToJson(this);
  }
}

abstract class _TicketMessage implements TicketMessage {
  const factory _TicketMessage({
    required final String id,
    required final String ticketId,
    required final String senderId,
    required final String senderName,
    required final bool isStaff,
    required final String message,
    final List<String>? attachments,
    required final DateTime createdAt,
  }) = _$TicketMessageImpl;

  factory _TicketMessage.fromJson(Map<String, dynamic> json) =
      _$TicketMessageImpl.fromJson;

  @override
  String get id;
  @override
  String get ticketId;
  @override
  String get senderId;
  @override
  String get senderName;
  @override
  bool get isStaff;
  @override
  String get message;
  @override
  List<String>? get attachments;
  @override
  DateTime get createdAt;

  /// Create a copy of TicketMessage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TicketMessageImplCopyWith<_$TicketMessageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FAQItem _$FAQItemFromJson(Map<String, dynamic> json) {
  return _FAQItem.fromJson(json);
}

/// @nodoc
mixin _$FAQItem {
  String get id => throw _privateConstructorUsedError;
  String get question => throw _privateConstructorUsedError;
  String get answer => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  int get helpfulCount => throw _privateConstructorUsedError;
  int get notHelpfulCount => throw _privateConstructorUsedError;

  /// Serializes this FAQItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FAQItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FAQItemCopyWith<FAQItem> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FAQItemCopyWith<$Res> {
  factory $FAQItemCopyWith(FAQItem value, $Res Function(FAQItem) then) =
      _$FAQItemCopyWithImpl<$Res, FAQItem>;
  @useResult
  $Res call({
    String id,
    String question,
    String answer,
    String category,
    int helpfulCount,
    int notHelpfulCount,
  });
}

/// @nodoc
class _$FAQItemCopyWithImpl<$Res, $Val extends FAQItem>
    implements $FAQItemCopyWith<$Res> {
  _$FAQItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FAQItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? question = null,
    Object? answer = null,
    Object? category = null,
    Object? helpfulCount = null,
    Object? notHelpfulCount = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            question: null == question
                ? _value.question
                : question // ignore: cast_nullable_to_non_nullable
                      as String,
            answer: null == answer
                ? _value.answer
                : answer // ignore: cast_nullable_to_non_nullable
                      as String,
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String,
            helpfulCount: null == helpfulCount
                ? _value.helpfulCount
                : helpfulCount // ignore: cast_nullable_to_non_nullable
                      as int,
            notHelpfulCount: null == notHelpfulCount
                ? _value.notHelpfulCount
                : notHelpfulCount // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FAQItemImplCopyWith<$Res> implements $FAQItemCopyWith<$Res> {
  factory _$$FAQItemImplCopyWith(
    _$FAQItemImpl value,
    $Res Function(_$FAQItemImpl) then,
  ) = __$$FAQItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String question,
    String answer,
    String category,
    int helpfulCount,
    int notHelpfulCount,
  });
}

/// @nodoc
class __$$FAQItemImplCopyWithImpl<$Res>
    extends _$FAQItemCopyWithImpl<$Res, _$FAQItemImpl>
    implements _$$FAQItemImplCopyWith<$Res> {
  __$$FAQItemImplCopyWithImpl(
    _$FAQItemImpl _value,
    $Res Function(_$FAQItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FAQItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? question = null,
    Object? answer = null,
    Object? category = null,
    Object? helpfulCount = null,
    Object? notHelpfulCount = null,
  }) {
    return _then(
      _$FAQItemImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        question: null == question
            ? _value.question
            : question // ignore: cast_nullable_to_non_nullable
                  as String,
        answer: null == answer
            ? _value.answer
            : answer // ignore: cast_nullable_to_non_nullable
                  as String,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String,
        helpfulCount: null == helpfulCount
            ? _value.helpfulCount
            : helpfulCount // ignore: cast_nullable_to_non_nullable
                  as int,
        notHelpfulCount: null == notHelpfulCount
            ? _value.notHelpfulCount
            : notHelpfulCount // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FAQItemImpl implements _FAQItem {
  const _$FAQItemImpl({
    required this.id,
    required this.question,
    required this.answer,
    required this.category,
    this.helpfulCount = 0,
    this.notHelpfulCount = 0,
  });

  factory _$FAQItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$FAQItemImplFromJson(json);

  @override
  final String id;
  @override
  final String question;
  @override
  final String answer;
  @override
  final String category;
  @override
  @JsonKey()
  final int helpfulCount;
  @override
  @JsonKey()
  final int notHelpfulCount;

  @override
  String toString() {
    return 'FAQItem(id: $id, question: $question, answer: $answer, category: $category, helpfulCount: $helpfulCount, notHelpfulCount: $notHelpfulCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FAQItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.question, question) ||
                other.question == question) &&
            (identical(other.answer, answer) || other.answer == answer) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.helpfulCount, helpfulCount) ||
                other.helpfulCount == helpfulCount) &&
            (identical(other.notHelpfulCount, notHelpfulCount) ||
                other.notHelpfulCount == notHelpfulCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    question,
    answer,
    category,
    helpfulCount,
    notHelpfulCount,
  );

  /// Create a copy of FAQItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FAQItemImplCopyWith<_$FAQItemImpl> get copyWith =>
      __$$FAQItemImplCopyWithImpl<_$FAQItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FAQItemImplToJson(this);
  }
}

abstract class _FAQItem implements FAQItem {
  const factory _FAQItem({
    required final String id,
    required final String question,
    required final String answer,
    required final String category,
    final int helpfulCount,
    final int notHelpfulCount,
  }) = _$FAQItemImpl;

  factory _FAQItem.fromJson(Map<String, dynamic> json) = _$FAQItemImpl.fromJson;

  @override
  String get id;
  @override
  String get question;
  @override
  String get answer;
  @override
  String get category;
  @override
  int get helpfulCount;
  @override
  int get notHelpfulCount;

  /// Create a copy of FAQItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FAQItemImplCopyWith<_$FAQItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Dispute _$DisputeFromJson(Map<String, dynamic> json) {
  return _Dispute.fromJson(json);
}

/// @nodoc
mixin _$Dispute {
  String get id => throw _privateConstructorUsedError;
  String get tripId => throw _privateConstructorUsedError;
  String get complainantId => throw _privateConstructorUsedError;
  String get respondentId => throw _privateConstructorUsedError;
  String get reason => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  TicketStatus get status => throw _privateConstructorUsedError;
  String? get resolution => throw _privateConstructorUsedError;
  String? get resolvedBy => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get resolvedAt => throw _privateConstructorUsedError;

  /// Serializes this Dispute to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Dispute
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DisputeCopyWith<Dispute> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DisputeCopyWith<$Res> {
  factory $DisputeCopyWith(Dispute value, $Res Function(Dispute) then) =
      _$DisputeCopyWithImpl<$Res, Dispute>;
  @useResult
  $Res call({
    String id,
    String tripId,
    String complainantId,
    String respondentId,
    String reason,
    String? description,
    TicketStatus status,
    String? resolution,
    String? resolvedBy,
    DateTime createdAt,
    DateTime? resolvedAt,
  });
}

/// @nodoc
class _$DisputeCopyWithImpl<$Res, $Val extends Dispute>
    implements $DisputeCopyWith<$Res> {
  _$DisputeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Dispute
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tripId = null,
    Object? complainantId = null,
    Object? respondentId = null,
    Object? reason = null,
    Object? description = freezed,
    Object? status = null,
    Object? resolution = freezed,
    Object? resolvedBy = freezed,
    Object? createdAt = null,
    Object? resolvedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            tripId: null == tripId
                ? _value.tripId
                : tripId // ignore: cast_nullable_to_non_nullable
                      as String,
            complainantId: null == complainantId
                ? _value.complainantId
                : complainantId // ignore: cast_nullable_to_non_nullable
                      as String,
            respondentId: null == respondentId
                ? _value.respondentId
                : respondentId // ignore: cast_nullable_to_non_nullable
                      as String,
            reason: null == reason
                ? _value.reason
                : reason // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as TicketStatus,
            resolution: freezed == resolution
                ? _value.resolution
                : resolution // ignore: cast_nullable_to_non_nullable
                      as String?,
            resolvedBy: freezed == resolvedBy
                ? _value.resolvedBy
                : resolvedBy // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            resolvedAt: freezed == resolvedAt
                ? _value.resolvedAt
                : resolvedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DisputeImplCopyWith<$Res> implements $DisputeCopyWith<$Res> {
  factory _$$DisputeImplCopyWith(
    _$DisputeImpl value,
    $Res Function(_$DisputeImpl) then,
  ) = __$$DisputeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String tripId,
    String complainantId,
    String respondentId,
    String reason,
    String? description,
    TicketStatus status,
    String? resolution,
    String? resolvedBy,
    DateTime createdAt,
    DateTime? resolvedAt,
  });
}

/// @nodoc
class __$$DisputeImplCopyWithImpl<$Res>
    extends _$DisputeCopyWithImpl<$Res, _$DisputeImpl>
    implements _$$DisputeImplCopyWith<$Res> {
  __$$DisputeImplCopyWithImpl(
    _$DisputeImpl _value,
    $Res Function(_$DisputeImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Dispute
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tripId = null,
    Object? complainantId = null,
    Object? respondentId = null,
    Object? reason = null,
    Object? description = freezed,
    Object? status = null,
    Object? resolution = freezed,
    Object? resolvedBy = freezed,
    Object? createdAt = null,
    Object? resolvedAt = freezed,
  }) {
    return _then(
      _$DisputeImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        tripId: null == tripId
            ? _value.tripId
            : tripId // ignore: cast_nullable_to_non_nullable
                  as String,
        complainantId: null == complainantId
            ? _value.complainantId
            : complainantId // ignore: cast_nullable_to_non_nullable
                  as String,
        respondentId: null == respondentId
            ? _value.respondentId
            : respondentId // ignore: cast_nullable_to_non_nullable
                  as String,
        reason: null == reason
            ? _value.reason
            : reason // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as TicketStatus,
        resolution: freezed == resolution
            ? _value.resolution
            : resolution // ignore: cast_nullable_to_non_nullable
                  as String?,
        resolvedBy: freezed == resolvedBy
            ? _value.resolvedBy
            : resolvedBy // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        resolvedAt: freezed == resolvedAt
            ? _value.resolvedAt
            : resolvedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DisputeImpl implements _Dispute {
  const _$DisputeImpl({
    required this.id,
    required this.tripId,
    required this.complainantId,
    required this.respondentId,
    required this.reason,
    this.description,
    required this.status,
    this.resolution,
    this.resolvedBy,
    required this.createdAt,
    this.resolvedAt,
  });

  factory _$DisputeImpl.fromJson(Map<String, dynamic> json) =>
      _$$DisputeImplFromJson(json);

  @override
  final String id;
  @override
  final String tripId;
  @override
  final String complainantId;
  @override
  final String respondentId;
  @override
  final String reason;
  @override
  final String? description;
  @override
  final TicketStatus status;
  @override
  final String? resolution;
  @override
  final String? resolvedBy;
  @override
  final DateTime createdAt;
  @override
  final DateTime? resolvedAt;

  @override
  String toString() {
    return 'Dispute(id: $id, tripId: $tripId, complainantId: $complainantId, respondentId: $respondentId, reason: $reason, description: $description, status: $status, resolution: $resolution, resolvedBy: $resolvedBy, createdAt: $createdAt, resolvedAt: $resolvedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DisputeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.tripId, tripId) || other.tripId == tripId) &&
            (identical(other.complainantId, complainantId) ||
                other.complainantId == complainantId) &&
            (identical(other.respondentId, respondentId) ||
                other.respondentId == respondentId) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.resolution, resolution) ||
                other.resolution == resolution) &&
            (identical(other.resolvedBy, resolvedBy) ||
                other.resolvedBy == resolvedBy) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.resolvedAt, resolvedAt) ||
                other.resolvedAt == resolvedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    tripId,
    complainantId,
    respondentId,
    reason,
    description,
    status,
    resolution,
    resolvedBy,
    createdAt,
    resolvedAt,
  );

  /// Create a copy of Dispute
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DisputeImplCopyWith<_$DisputeImpl> get copyWith =>
      __$$DisputeImplCopyWithImpl<_$DisputeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DisputeImplToJson(this);
  }
}

abstract class _Dispute implements Dispute {
  const factory _Dispute({
    required final String id,
    required final String tripId,
    required final String complainantId,
    required final String respondentId,
    required final String reason,
    final String? description,
    required final TicketStatus status,
    final String? resolution,
    final String? resolvedBy,
    required final DateTime createdAt,
    final DateTime? resolvedAt,
  }) = _$DisputeImpl;

  factory _Dispute.fromJson(Map<String, dynamic> json) = _$DisputeImpl.fromJson;

  @override
  String get id;
  @override
  String get tripId;
  @override
  String get complainantId;
  @override
  String get respondentId;
  @override
  String get reason;
  @override
  String? get description;
  @override
  TicketStatus get status;
  @override
  String? get resolution;
  @override
  String? get resolvedBy;
  @override
  DateTime get createdAt;
  @override
  DateTime? get resolvedAt;

  /// Create a copy of Dispute
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DisputeImplCopyWith<_$DisputeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
