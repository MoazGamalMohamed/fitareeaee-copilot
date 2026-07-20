import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// A reusable natural-language trip request stored only on this device.
///
/// Templates deliberately contain no booking state, user identifiers, payment
/// details, or verification data. The request is still reviewed by the user and
/// interpreted as a draft before deterministic matching.
class TripPromptTemplate {
  const TripPromptTemplate({
    required this.id,
    required this.name,
    required this.request,
    required this.updatedAt,
  });

  final String id;
  final String name;
  final String request;
  final DateTime updatedAt;

  Map<String, Object> toJson() => {
    'id': id,
    'name': name,
    'request': request,
    'updatedAt': updatedAt.toUtc().toIso8601String(),
  };

  static TripPromptTemplate? tryFromJson(Object? value) {
    if (value is! Map) return null;
    final id = value['id'];
    final name = value['name'];
    final request = value['request'];
    final updatedAt = value['updatedAt'];
    if (id is! String ||
        id.trim().isEmpty ||
        name is! String ||
        name.trim().isEmpty ||
        request is! String ||
        request.trim().length < 5 ||
        updatedAt is! String) {
      return null;
    }
    final parsedDate = DateTime.tryParse(updatedAt);
    if (parsedDate == null) return null;
    return TripPromptTemplate(
      id: id.trim(),
      name: name.trim(),
      request: request.trim(),
      updatedAt: parsedDate,
    );
  }
}

class TripPromptTemplateStore {
  static const maxTemplates = 8;
  static const maxNameLength = 40;
  static const maxRequestLength = 1200;
  static const _keyPrefix = 'copilot_trip_templates_v1_';

  Future<List<TripPromptTemplate>> load(String ownerId) async {
    final normalizedOwner = _normalizedOwner(ownerId);
    final preferences = await SharedPreferences.getInstance();
    final encoded = preferences.getString('$_keyPrefix$normalizedOwner');
    if (encoded == null || encoded.isEmpty) return const [];
    try {
      final decoded = jsonDecode(encoded);
      if (decoded is! List) return const [];
      final templates = decoded
          .map(TripPromptTemplate.tryFromJson)
          .whereType<TripPromptTemplate>()
          .take(maxTemplates)
          .toList(growable: false);
      return templates;
    } on FormatException {
      return const [];
    }
  }

  Future<List<TripPromptTemplate>> upsert(
    String ownerId,
    TripPromptTemplate template,
  ) async {
    final normalized = _validated(template);
    final existing = await load(ownerId);
    final updated = [
      normalized,
      ...existing.where((item) => item.id != normalized.id),
    ].take(maxTemplates).toList(growable: false);
    await _write(ownerId, updated);
    return updated;
  }

  Future<List<TripPromptTemplate>> delete(
    String ownerId,
    String templateId,
  ) async {
    final existing = await load(ownerId);
    final updated = existing
        .where((item) => item.id != templateId)
        .toList(growable: false);
    await _write(ownerId, updated);
    return updated;
  }

  Future<void> _write(
    String ownerId,
    List<TripPromptTemplate> templates,
  ) async {
    final normalizedOwner = _normalizedOwner(ownerId);
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(
      '$_keyPrefix$normalizedOwner',
      jsonEncode(templates.map((template) => template.toJson()).toList()),
    );
  }

  TripPromptTemplate _validated(TripPromptTemplate template) {
    final id = template.id.trim();
    final name = template.name.trim();
    final request = template.request.trim();
    if (id.isEmpty || id.length > 80) {
      throw const FormatException('Template identifier is invalid.');
    }
    if (name.isEmpty || name.length > maxNameLength) {
      throw const FormatException('Template name must be 1-40 characters.');
    }
    if (request.length < 5 || request.length > maxRequestLength) {
      throw const FormatException('Trip request must be 5-1200 characters.');
    }
    return TripPromptTemplate(
      id: id,
      name: name,
      request: request,
      updatedAt: template.updatedAt,
    );
  }

  String _normalizedOwner(String ownerId) {
    final normalized = Uri.encodeComponent(ownerId.trim());
    if (normalized.isEmpty || normalized.length > 256) {
      throw const FormatException('Template owner is invalid.');
    }
    return normalized;
  }
}
