import 'package:flutter_test/flutter_test.dart';
import 'package:safeguard/models/incident_alert.dart';

void main() {
  test('parses a single incident object and marks alertable severity', () {
    final incidents = IncidentAlert.parsePayload({
      'id': 'incident-1',
      'severity': 'critical',
      'requires_alert': true,
      'alert_message': 'Helmet missing in Zone A',
    });

    expect(incidents, hasLength(1));
    expect(incidents.first.shouldTriggerAlarm, isTrue);
    expect(incidents.first.alertMessage, 'Helmet missing in Zone A');
  });

  test('parses multiple incidents from nested list payload', () {
    final incidents = IncidentAlert.parsePayload({
      'incidents': [
        {
          'id': 'incident-2',
          'severity': 'low',
          'requires_alert': true,
          'alert_message': 'Gloves missing',
        },
        {
          'id': 'incident-3',
          'severity': 'high',
          'requires_alert': true,
          'alert_message': 'Vest missing in Bay 4',
        },
      ],
    });

    expect(incidents, hasLength(2));
    expect(incidents.last.shouldTriggerAlarm, isTrue);
    expect(incidents.last.dedupeKey, 'incident-3');
  });

  test('maps Supabase alarm row into a triggerable alert', () {
    final incident = IncidentAlert.fromAlarmRow({
      'id': 'alarm-1',
      'location': 'Boiler Room',
      'is_fire': true,
      'is_fall': false,
    });

    expect(incident.requiresAlert, isTrue);
    expect(incident.shouldTriggerAlarm, isTrue);
    expect(incident.severity, 'critical');
    expect(incident.alertMessage, contains('Boiler Room'));
  });
}
