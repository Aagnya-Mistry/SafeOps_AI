import 'dart:convert';

class IncidentAlert {
  const IncidentAlert({
    required this.id,
    required this.severity,
    required this.requiresAlert,
    required this.alertMessage,
    required this.raw,
  });

  final String id;
  final String severity;
  final bool requiresAlert;
  final String alertMessage;
  final Map<String, dynamic> raw;

  bool get shouldTriggerAlarm {
    final normalizedSeverity = severity.toLowerCase();
    return requiresAlert &&
        (normalizedSeverity == 'high' || normalizedSeverity == 'critical');
  }

  String get dedupeKey {
    final timestamp = _readString(
      raw,
      const ['timestamp', 'created_at', 'occurred_at', 'detected_at'],
    );

    if (id.isNotEmpty) {
      return id;
    }

    return [
      severity.toLowerCase(),
      alertMessage,
      timestamp,
    ].join('|');
  }

  static List<IncidentAlert> parseResponseBody(String body) {
    if (body.trim().isEmpty) {
      return const [];
    }

    final decoded = jsonDecode(body);
    return parsePayload(decoded);
  }

  static List<IncidentAlert> parsePayload(dynamic payload) {
    return _extractIncidentMaps(payload).map(IncidentAlert.fromJson).toList();
  }

  factory IncidentAlert.fromJson(Map<String, dynamic> json) {
    return IncidentAlert(
      id: _readString(json, const ['id', '_id', 'incident_id', 'event_id']),
      severity: _readString(json, const ['severity', 'level']).toLowerCase(),
      requiresAlert: _readBool(
        json,
        const ['requires_alert', 'requiresAlert', 'trigger_alarm'],
      ),
      alertMessage: _readString(
        json,
        const ['alert_message', 'alertMessage', 'message', 'description'],
      ),
      raw: json,
    );
  }

  factory IncidentAlert.fromAlarmRow(Map<String, dynamic> row) {
    final normalized = Map<String, dynamic>.from(row);
    final isFire = _readBool(normalized, const ['is_fire']);
    final isFall = _readBool(normalized, const ['is_fall']);
    final location =
        _readString(normalized, const ['location']).isEmpty
        ? 'Unknown location'
        : _readString(normalized, const ['location']);

    final alertMessage = switch ((isFire, isFall)) {
      (true, true) =>
        'Fire and fall detected at $location. Immediate response required.',
      (true, false) => 'Fire detected at $location. Immediate response required.',
      (false, true) =>
        'Worker fall detected at $location. Immediate response required.',
      (false, false) => '',
    };

    return IncidentAlert(
      id: _readString(normalized, const ['id']),
      severity: isFire ? 'critical' : (isFall ? 'high' : 'low'),
      requiresAlert: isFire || isFall,
      alertMessage: alertMessage,
      raw: normalized,
    );
  }

  static Iterable<Map<String, dynamic>> _extractIncidentMaps(dynamic payload) sync* {
    if (payload is List) {
      for (final item in payload) {
        yield* _extractIncidentMaps(item);
      }
      return;
    }

    if (payload is! Map) {
      return;
    }

    final normalized = Map<String, dynamic>.from(payload);

    if (_looksLikeIncident(normalized)) {
      yield normalized;
      return;
    }

    for (final key in const [
      'incident',
      'incidents',
      'event',
      'events',
      'data',
      'result',
      'results',
    ]) {
      if (normalized.containsKey(key)) {
        yield* _extractIncidentMaps(normalized[key]);
      }
    }
  }

  static bool _looksLikeIncident(Map<String, dynamic> json) {
    return json.containsKey('requires_alert') ||
        json.containsKey('requiresAlert') ||
        json.containsKey('alert_message') ||
        json.containsKey('alertMessage') ||
        json.containsKey('severity');
  }

  static bool _readBool(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];
      if (value is bool) {
        return value;
      }
      if (value is String) {
        final normalized = value.toLowerCase().trim();
        if (normalized == 'true') {
          return true;
        }
        if (normalized == 'false') {
          return false;
        }
      }
      if (value is num) {
        return value != 0;
      }
    }
    return false;
  }

  static String _readString(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];
      if (value == null) {
        continue;
      }
      final text = value.toString().trim();
      if (text.isNotEmpty) {
        return text;
      }
    }
    return '';
  }
}
