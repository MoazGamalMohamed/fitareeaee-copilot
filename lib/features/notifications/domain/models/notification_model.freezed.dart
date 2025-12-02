// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

NotificationModel _$NotificationModelFromJson(Map<String, dynamic> json) {
  return _NotificationModel.fromJson(json);
}

/// @nodoc
mixin _$NotificationModel {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  NotificationType get type => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get body => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  Map<String, dynamic>? get data => throw _privateConstructorUsedError;
  String? get actionUrl => throw _privateConstructorUsedError;
  bool get isRead => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get readAt => throw _privateConstructorUsedError;

  /// Serializes this NotificationModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NotificationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NotificationModelCopyWith<NotificationModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationModelCopyWith<$Res> {
  factory $NotificationModelCopyWith(
    NotificationModel value,
    $Res Function(NotificationModel) then,
  ) = _$NotificationModelCopyWithImpl<$Res, NotificationModel>;
  @useResult
  $Res call({
    String id,
    String userId,
    NotificationType type,
    String title,
    String body,
    String? imageUrl,
    Map<String, dynamic>? data,
    String? actionUrl,
    bool isRead,
    DateTime createdAt,
    DateTime? readAt,
  });
}

/// @nodoc
class _$NotificationModelCopyWithImpl<$Res, $Val extends NotificationModel>
    implements $NotificationModelCopyWith<$Res> {
  _$NotificationModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NotificationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? type = null,
    Object? title = null,
    Object? body = null,
    Object? imageUrl = freezed,
    Object? data = freezed,
    Object? actionUrl = freezed,
    Object? isRead = null,
    Object? createdAt = null,
    Object? readAt = freezed,
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
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as NotificationType,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            body: null == body
                ? _value.body
                : body // ignore: cast_nullable_to_non_nullable
                      as String,
            imageUrl: freezed == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            data: freezed == data
                ? _value.data
                : data // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
            actionUrl: freezed == actionUrl
                ? _value.actionUrl
                : actionUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            isRead: null == isRead
                ? _value.isRead
                : isRead // ignore: cast_nullable_to_non_nullable
                      as bool,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            readAt: freezed == readAt
                ? _value.readAt
                : readAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$NotificationModelImplCopyWith<$Res>
    implements $NotificationModelCopyWith<$Res> {
  factory _$$NotificationModelImplCopyWith(
    _$NotificationModelImpl value,
    $Res Function(_$NotificationModelImpl) then,
  ) = __$$NotificationModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String userId,
    NotificationType type,
    String title,
    String body,
    String? imageUrl,
    Map<String, dynamic>? data,
    String? actionUrl,
    bool isRead,
    DateTime createdAt,
    DateTime? readAt,
  });
}

/// @nodoc
class __$$NotificationModelImplCopyWithImpl<$Res>
    extends _$NotificationModelCopyWithImpl<$Res, _$NotificationModelImpl>
    implements _$$NotificationModelImplCopyWith<$Res> {
  __$$NotificationModelImplCopyWithImpl(
    _$NotificationModelImpl _value,
    $Res Function(_$NotificationModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of NotificationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? type = null,
    Object? title = null,
    Object? body = null,
    Object? imageUrl = freezed,
    Object? data = freezed,
    Object? actionUrl = freezed,
    Object? isRead = null,
    Object? createdAt = null,
    Object? readAt = freezed,
  }) {
    return _then(
      _$NotificationModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as NotificationType,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        body: null == body
            ? _value.body
            : body // ignore: cast_nullable_to_non_nullable
                  as String,
        imageUrl: freezed == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        data: freezed == data
            ? _value._data
            : data // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
        actionUrl: freezed == actionUrl
            ? _value.actionUrl
            : actionUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        isRead: null == isRead
            ? _value.isRead
            : isRead // ignore: cast_nullable_to_non_nullable
                  as bool,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        readAt: freezed == readAt
            ? _value.readAt
            : readAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$NotificationModelImpl extends _NotificationModel {
  const _$NotificationModelImpl({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.body,
    this.imageUrl,
    final Map<String, dynamic>? data,
    this.actionUrl,
    this.isRead = false,
    required this.createdAt,
    this.readAt,
  }) : _data = data,
       super._();

  factory _$NotificationModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$NotificationModelImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final NotificationType type;
  @override
  final String title;
  @override
  final String body;
  @override
  final String? imageUrl;
  final Map<String, dynamic>? _data;
  @override
  Map<String, dynamic>? get data {
    final value = _data;
    if (value == null) return null;
    if (_data is EqualUnmodifiableMapView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final String? actionUrl;
  @override
  @JsonKey()
  final bool isRead;
  @override
  final DateTime createdAt;
  @override
  final DateTime? readAt;

  @override
  String toString() {
    return 'NotificationModel(id: $id, userId: $userId, type: $type, title: $title, body: $body, imageUrl: $imageUrl, data: $data, actionUrl: $actionUrl, isRead: $isRead, createdAt: $createdAt, readAt: $readAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.actionUrl, actionUrl) ||
                other.actionUrl == actionUrl) &&
            (identical(other.isRead, isRead) || other.isRead == isRead) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.readAt, readAt) || other.readAt == readAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    userId,
    type,
    title,
    body,
    imageUrl,
    const DeepCollectionEquality().hash(_data),
    actionUrl,
    isRead,
    createdAt,
    readAt,
  );

  /// Create a copy of NotificationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationModelImplCopyWith<_$NotificationModelImpl> get copyWith =>
      __$$NotificationModelImplCopyWithImpl<_$NotificationModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$NotificationModelImplToJson(this);
  }
}

abstract class _NotificationModel extends NotificationModel {
  const factory _NotificationModel({
    required final String id,
    required final String userId,
    required final NotificationType type,
    required final String title,
    required final String body,
    final String? imageUrl,
    final Map<String, dynamic>? data,
    final String? actionUrl,
    final bool isRead,
    required final DateTime createdAt,
    final DateTime? readAt,
  }) = _$NotificationModelImpl;
  const _NotificationModel._() : super._();

  factory _NotificationModel.fromJson(Map<String, dynamic> json) =
      _$NotificationModelImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  NotificationType get type;
  @override
  String get title;
  @override
  String get body;
  @override
  String? get imageUrl;
  @override
  Map<String, dynamic>? get data;
  @override
  String? get actionUrl;
  @override
  bool get isRead;
  @override
  DateTime get createdAt;
  @override
  DateTime? get readAt;

  /// Create a copy of NotificationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NotificationModelImplCopyWith<_$NotificationModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

NotificationPreferences _$NotificationPreferencesFromJson(
  Map<String, dynamic> json,
) {
  return _NotificationPreferences.fromJson(json);
}

/// @nodoc
mixin _$NotificationPreferences {
  bool get bookingNotifications => throw _privateConstructorUsedError;
  bool get chatNotifications => throw _privateConstructorUsedError;
  bool get paymentNotifications => throw _privateConstructorUsedError;
  bool get tripNotifications => throw _privateConstructorUsedError;
  bool get ratingNotifications => throw _privateConstructorUsedError;
  bool get promoNotifications => throw _privateConstructorUsedError;
  bool get systemNotifications => throw _privateConstructorUsedError;
  bool get soundEnabled => throw _privateConstructorUsedError;
  bool get vibrationEnabled => throw _privateConstructorUsedError;

  /// Serializes this NotificationPreferences to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NotificationPreferences
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NotificationPreferencesCopyWith<NotificationPreferences> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationPreferencesCopyWith<$Res> {
  factory $NotificationPreferencesCopyWith(
    NotificationPreferences value,
    $Res Function(NotificationPreferences) then,
  ) = _$NotificationPreferencesCopyWithImpl<$Res, NotificationPreferences>;
  @useResult
  $Res call({
    bool bookingNotifications,
    bool chatNotifications,
    bool paymentNotifications,
    bool tripNotifications,
    bool ratingNotifications,
    bool promoNotifications,
    bool systemNotifications,
    bool soundEnabled,
    bool vibrationEnabled,
  });
}

/// @nodoc
class _$NotificationPreferencesCopyWithImpl<
  $Res,
  $Val extends NotificationPreferences
>
    implements $NotificationPreferencesCopyWith<$Res> {
  _$NotificationPreferencesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NotificationPreferences
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bookingNotifications = null,
    Object? chatNotifications = null,
    Object? paymentNotifications = null,
    Object? tripNotifications = null,
    Object? ratingNotifications = null,
    Object? promoNotifications = null,
    Object? systemNotifications = null,
    Object? soundEnabled = null,
    Object? vibrationEnabled = null,
  }) {
    return _then(
      _value.copyWith(
            bookingNotifications: null == bookingNotifications
                ? _value.bookingNotifications
                : bookingNotifications // ignore: cast_nullable_to_non_nullable
                      as bool,
            chatNotifications: null == chatNotifications
                ? _value.chatNotifications
                : chatNotifications // ignore: cast_nullable_to_non_nullable
                      as bool,
            paymentNotifications: null == paymentNotifications
                ? _value.paymentNotifications
                : paymentNotifications // ignore: cast_nullable_to_non_nullable
                      as bool,
            tripNotifications: null == tripNotifications
                ? _value.tripNotifications
                : tripNotifications // ignore: cast_nullable_to_non_nullable
                      as bool,
            ratingNotifications: null == ratingNotifications
                ? _value.ratingNotifications
                : ratingNotifications // ignore: cast_nullable_to_non_nullable
                      as bool,
            promoNotifications: null == promoNotifications
                ? _value.promoNotifications
                : promoNotifications // ignore: cast_nullable_to_non_nullable
                      as bool,
            systemNotifications: null == systemNotifications
                ? _value.systemNotifications
                : systemNotifications // ignore: cast_nullable_to_non_nullable
                      as bool,
            soundEnabled: null == soundEnabled
                ? _value.soundEnabled
                : soundEnabled // ignore: cast_nullable_to_non_nullable
                      as bool,
            vibrationEnabled: null == vibrationEnabled
                ? _value.vibrationEnabled
                : vibrationEnabled // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$NotificationPreferencesImplCopyWith<$Res>
    implements $NotificationPreferencesCopyWith<$Res> {
  factory _$$NotificationPreferencesImplCopyWith(
    _$NotificationPreferencesImpl value,
    $Res Function(_$NotificationPreferencesImpl) then,
  ) = __$$NotificationPreferencesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool bookingNotifications,
    bool chatNotifications,
    bool paymentNotifications,
    bool tripNotifications,
    bool ratingNotifications,
    bool promoNotifications,
    bool systemNotifications,
    bool soundEnabled,
    bool vibrationEnabled,
  });
}

/// @nodoc
class __$$NotificationPreferencesImplCopyWithImpl<$Res>
    extends
        _$NotificationPreferencesCopyWithImpl<
          $Res,
          _$NotificationPreferencesImpl
        >
    implements _$$NotificationPreferencesImplCopyWith<$Res> {
  __$$NotificationPreferencesImplCopyWithImpl(
    _$NotificationPreferencesImpl _value,
    $Res Function(_$NotificationPreferencesImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of NotificationPreferences
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bookingNotifications = null,
    Object? chatNotifications = null,
    Object? paymentNotifications = null,
    Object? tripNotifications = null,
    Object? ratingNotifications = null,
    Object? promoNotifications = null,
    Object? systemNotifications = null,
    Object? soundEnabled = null,
    Object? vibrationEnabled = null,
  }) {
    return _then(
      _$NotificationPreferencesImpl(
        bookingNotifications: null == bookingNotifications
            ? _value.bookingNotifications
            : bookingNotifications // ignore: cast_nullable_to_non_nullable
                  as bool,
        chatNotifications: null == chatNotifications
            ? _value.chatNotifications
            : chatNotifications // ignore: cast_nullable_to_non_nullable
                  as bool,
        paymentNotifications: null == paymentNotifications
            ? _value.paymentNotifications
            : paymentNotifications // ignore: cast_nullable_to_non_nullable
                  as bool,
        tripNotifications: null == tripNotifications
            ? _value.tripNotifications
            : tripNotifications // ignore: cast_nullable_to_non_nullable
                  as bool,
        ratingNotifications: null == ratingNotifications
            ? _value.ratingNotifications
            : ratingNotifications // ignore: cast_nullable_to_non_nullable
                  as bool,
        promoNotifications: null == promoNotifications
            ? _value.promoNotifications
            : promoNotifications // ignore: cast_nullable_to_non_nullable
                  as bool,
        systemNotifications: null == systemNotifications
            ? _value.systemNotifications
            : systemNotifications // ignore: cast_nullable_to_non_nullable
                  as bool,
        soundEnabled: null == soundEnabled
            ? _value.soundEnabled
            : soundEnabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        vibrationEnabled: null == vibrationEnabled
            ? _value.vibrationEnabled
            : vibrationEnabled // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$NotificationPreferencesImpl implements _NotificationPreferences {
  const _$NotificationPreferencesImpl({
    this.bookingNotifications = true,
    this.chatNotifications = true,
    this.paymentNotifications = true,
    this.tripNotifications = true,
    this.ratingNotifications = true,
    this.promoNotifications = false,
    this.systemNotifications = true,
    this.soundEnabled = true,
    this.vibrationEnabled = true,
  });

  factory _$NotificationPreferencesImpl.fromJson(Map<String, dynamic> json) =>
      _$$NotificationPreferencesImplFromJson(json);

  @override
  @JsonKey()
  final bool bookingNotifications;
  @override
  @JsonKey()
  final bool chatNotifications;
  @override
  @JsonKey()
  final bool paymentNotifications;
  @override
  @JsonKey()
  final bool tripNotifications;
  @override
  @JsonKey()
  final bool ratingNotifications;
  @override
  @JsonKey()
  final bool promoNotifications;
  @override
  @JsonKey()
  final bool systemNotifications;
  @override
  @JsonKey()
  final bool soundEnabled;
  @override
  @JsonKey()
  final bool vibrationEnabled;

  @override
  String toString() {
    return 'NotificationPreferences(bookingNotifications: $bookingNotifications, chatNotifications: $chatNotifications, paymentNotifications: $paymentNotifications, tripNotifications: $tripNotifications, ratingNotifications: $ratingNotifications, promoNotifications: $promoNotifications, systemNotifications: $systemNotifications, soundEnabled: $soundEnabled, vibrationEnabled: $vibrationEnabled)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationPreferencesImpl &&
            (identical(other.bookingNotifications, bookingNotifications) ||
                other.bookingNotifications == bookingNotifications) &&
            (identical(other.chatNotifications, chatNotifications) ||
                other.chatNotifications == chatNotifications) &&
            (identical(other.paymentNotifications, paymentNotifications) ||
                other.paymentNotifications == paymentNotifications) &&
            (identical(other.tripNotifications, tripNotifications) ||
                other.tripNotifications == tripNotifications) &&
            (identical(other.ratingNotifications, ratingNotifications) ||
                other.ratingNotifications == ratingNotifications) &&
            (identical(other.promoNotifications, promoNotifications) ||
                other.promoNotifications == promoNotifications) &&
            (identical(other.systemNotifications, systemNotifications) ||
                other.systemNotifications == systemNotifications) &&
            (identical(other.soundEnabled, soundEnabled) ||
                other.soundEnabled == soundEnabled) &&
            (identical(other.vibrationEnabled, vibrationEnabled) ||
                other.vibrationEnabled == vibrationEnabled));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    bookingNotifications,
    chatNotifications,
    paymentNotifications,
    tripNotifications,
    ratingNotifications,
    promoNotifications,
    systemNotifications,
    soundEnabled,
    vibrationEnabled,
  );

  /// Create a copy of NotificationPreferences
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationPreferencesImplCopyWith<_$NotificationPreferencesImpl>
  get copyWith =>
      __$$NotificationPreferencesImplCopyWithImpl<
        _$NotificationPreferencesImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NotificationPreferencesImplToJson(this);
  }
}

abstract class _NotificationPreferences implements NotificationPreferences {
  const factory _NotificationPreferences({
    final bool bookingNotifications,
    final bool chatNotifications,
    final bool paymentNotifications,
    final bool tripNotifications,
    final bool ratingNotifications,
    final bool promoNotifications,
    final bool systemNotifications,
    final bool soundEnabled,
    final bool vibrationEnabled,
  }) = _$NotificationPreferencesImpl;

  factory _NotificationPreferences.fromJson(Map<String, dynamic> json) =
      _$NotificationPreferencesImpl.fromJson;

  @override
  bool get bookingNotifications;
  @override
  bool get chatNotifications;
  @override
  bool get paymentNotifications;
  @override
  bool get tripNotifications;
  @override
  bool get ratingNotifications;
  @override
  bool get promoNotifications;
  @override
  bool get systemNotifications;
  @override
  bool get soundEnabled;
  @override
  bool get vibrationEnabled;

  /// Create a copy of NotificationPreferences
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NotificationPreferencesImplCopyWith<_$NotificationPreferencesImpl>
  get copyWith => throw _privateConstructorUsedError;
}
