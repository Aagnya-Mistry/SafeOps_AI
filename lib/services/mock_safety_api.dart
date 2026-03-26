import 'package:flutter/material.dart';

import '../models/compliance_point.dart';
import '../models/dashboard_snapshot.dart';
import '../models/feature_item.dart';
import '../models/kpi_metric.dart';
import '../models/violation_event.dart';
import '../theme/app_colors.dart';

class MockSafetyApi {
  Future<List<FeatureItem>> fetchFeatures() async {
    await Future<void>.delayed(const Duration(milliseconds: 420));

    return const [
      FeatureItem(
        title: 'Real-time detection',
        description:
            'Continuously score PPE adherence from every live camera stream.',
        icon: Icons.radar_rounded,
        tone: AppColors.accent,
      ),
      FeatureItem(
        title: 'Risk scoring',
        description:
            'Prioritize incidents with weighted risk by zone, shift, and task.',
        icon: Icons.speed_rounded,
        tone: AppColors.warning,
      ),
      FeatureItem(
        title: 'Zone-based alerts',
        description:
            'Escalate immediately when workers enter restricted corridors.',
        icon: Icons.location_searching_rounded,
        tone: AppColors.danger,
      ),
      FeatureItem(
        title: 'Temporal tracking',
        description:
            'Track repeated exposure patterns across hours, shifts, and crews.',
        icon: Icons.timeline_rounded,
        tone: AppColors.accentBright,
      ),
      FeatureItem(
        title: 'Lighting adaptive',
        description:
            'Maintain detection fidelity across low-light, glare, and dust.',
        icon: Icons.wb_incandescent_rounded,
        tone: AppColors.warning,
      ),
      FeatureItem(
        title: 'Privacy first',
        description:
            'Edge-side anonymization protects identity while preserving safety signals.',
        icon: Icons.privacy_tip_rounded,
        tone: AppColors.success,
      ),
      FeatureItem(
        title: 'Edge deployable',
        description:
            'Ship the stack on-site for low-latency monitoring and local failover.',
        icon: Icons.memory_rounded,
        tone: AppColors.accent,
      ),
      FeatureItem(
        title: 'Multi-channel alerts',
        description:
            'Route alerts to control rooms, handheld devices, and radios.',
        icon: Icons.notifications_active_rounded,
        tone: AppColors.danger,
      ),
    ];
  }

  Future<DashboardSnapshot> fetchDashboardSnapshot() async {
    await Future<void>.delayed(const Duration(milliseconds: 520));

    return const DashboardSnapshot(
      metrics: [
        KpiMetric(
          label: 'Compliance rate',
          value: '94.2%',
          supportingText: '+2.8% vs last month',
          tone: AppColors.success,
        ),
        KpiMetric(
          label: 'Active workers',
          value: '128',
          supportingText: '17 zones monitored',
          tone: AppColors.accent,
        ),
        KpiMetric(
          label: 'Violations today',
          value: '12',
          supportingText: '4 require escalation',
          tone: AppColors.danger,
        ),
        KpiMetric(
          label: 'Avg response time',
          value: '01:42',
          supportingText: 'Down 18 seconds',
          tone: AppColors.warning,
        ),
      ],
      monthlyCompliance: [
        CompliancePoint(label: 'Jan', value: 83),
        CompliancePoint(label: 'Feb', value: 86),
        CompliancePoint(label: 'Mar', value: 88),
        CompliancePoint(label: 'Apr', value: 87),
        CompliancePoint(label: 'May', value: 90),
        CompliancePoint(label: 'Jun', value: 92),
        CompliancePoint(label: 'Jul', value: 91),
        CompliancePoint(label: 'Aug', value: 94),
        CompliancePoint(label: 'Sep', value: 95),
        CompliancePoint(label: 'Oct', value: 93),
        CompliancePoint(label: 'Nov', value: 96),
        CompliancePoint(label: 'Dec', value: 94),
      ],
      recentViolations: [
        ViolationEvent(
          title: 'Safety Helmet',
          zone: 'Assembly Line A',
          timestamp: 'Today, 08:35 AM',
          description: 'Forgot to wear helmet before entering the work area.',
          severity: ViolationSeverity.critical,
        ),
        ViolationEvent(
          title: 'Safety Gloves',
          zone: 'Packaging Unit 2',
          timestamp: 'Today, 11:10 AM',
          description: 'Gloves were not detected during machine handling.',
          severity: ViolationSeverity.high,
        ),
        ViolationEvent(
          title: 'Reflective Vest',
          zone: 'Warehouse Gate 3',
          timestamp: 'Yesterday, 04:25 PM',
          description: 'Entered the loading area without reflective vest.',
          severity: ViolationSeverity.medium,
        ),
        ViolationEvent(
          title: 'Safety Goggles',
          zone: 'Cutting Section',
          timestamp: 'Yesterday, 02:05 PM',
          description: 'Goggles were missing during cutting-floor activity.',
          severity: ViolationSeverity.high,
        ),
      ],
    );
  }
}
