import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/incident_alert.dart';
import 'supabase_auth_service.dart';

class IncidentApiService {
  IncidentApiService({SupabaseClient? client}) : _client = client;

  final SupabaseClient? _client;
  static const _tableName = 'alarms';

  bool get isConfigured => SupabaseConfig.isConfigured;

  Future<List<IncidentAlert>> fetchLatestIncidents() async {
    if (!isConfigured) {
      return const [];
    }

    final client = _client ?? Supabase.instance.client;
    final response = await client.from(_tableName).select();

    return response
        .whereType<Map>()
        .map((row) => IncidentAlert.fromAlarmRow(Map<String, dynamic>.from(row)))
        .where((alert) => alert.requiresAlert)
        .toList();
  }
}
