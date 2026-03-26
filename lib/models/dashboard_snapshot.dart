import 'compliance_point.dart';
import 'kpi_metric.dart';
import 'violation_event.dart';

class DashboardSnapshot {
  const DashboardSnapshot({
    required this.metrics,
    required this.monthlyCompliance,
    required this.recentViolations,
  });

  final List<KpiMetric> metrics;
  final List<CompliancePoint> monthlyCompliance;
  final List<ViolationEvent> recentViolations;
}
