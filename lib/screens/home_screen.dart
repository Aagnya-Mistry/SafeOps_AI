import 'dart:async';

import 'package:flutter/material.dart';

import '../models/dashboard_snapshot.dart';
import '../models/incident_alert.dart';
import '../models/violation_event.dart';
import '../services/alarm_service.dart';
import '../services/incident_api_service.dart';
import '../services/mock_safety_api.dart';
import '../services/supabase_auth_service.dart';
import '../theme/app_colors.dart';
import '../widgets/animated_reveal.dart';
import '../widgets/app_background.dart';
import '../widgets/app_logo.dart';
import '../widgets/glass_panel.dart';
import '../widgets/primary_button.dart';
import '../widgets/section_heading.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _api = MockSafetyApi();
  final _alarmService = AlarmService();
  final _incidentApiService = IncidentApiService();
  final Set<String> _handledIncidentKeys = <String>{};
  late final Future<DashboardSnapshot> _future;
  Timer? _pollTimer;
  bool _isPolling = false;
  bool _isAlertVisible = false;

  @override
  void initState() {
    super.initState();
    _future = _api.fetchDashboardSnapshot();
    _startIncidentPolling();
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    unawaited(_alarmService.dispose());
    super.dispose();
  }

  Future<void> _signOut() async {
    _pollTimer?.cancel();
    unawaited(_alarmService.stopAlarm());
    await SupabaseAuthService.signOut();
    if (!mounted) {
      return;
    }
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }

  void _startIncidentPolling() {
    _pollLatestIncidents();
    _pollTimer = Timer.periodic(
      const Duration(seconds: 3),
      (_) => _pollLatestIncidents(),
    );
  }

  Future<void> _pollLatestIncidents() async {
    if (_isPolling || !_incidentApiService.isConfigured) {
      return;
    }

    _isPolling = true;

    try {
      final incidents = await _incidentApiService.fetchLatestIncidents();
      final nextAlert = incidents.firstWhere(
        (incident) =>
            incident.shouldTriggerAlarm &&
            !_handledIncidentKeys.contains(incident.dedupeKey),
        orElse: () => const IncidentAlert(
          id: '',
          severity: '',
          requiresAlert: false,
          alertMessage: '',
          raw: <String, dynamic>{},
        ),
      );

      if (!nextAlert.shouldTriggerAlarm || _isAlertVisible || !mounted) {
        return;
      }

      _handledIncidentKeys.add(nextAlert.dedupeKey);
      await _showSafetyViolationDialog(nextAlert);
    } catch (_) {
      // Keep polling even when the API is temporarily unavailable.
    } finally {
      _isPolling = false;
    }
  }

  Future<void> _showSafetyViolationDialog(IncidentAlert incident) async {
    _isAlertVisible = true;

    try {
      await _alarmService.startAlarm();
    } catch (_) {
      // Still show the critical alert UI even if audio playback is unavailable.
    }

    if (!mounted) {
      _isAlertVisible = false;
      return;
    }

    await showGeneralDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'Safety violation alert',
      barrierColor: Colors.black.withValues(alpha: 0.78),
      pageBuilder: (dialogContext, _, __) {
        return _SafetyViolationDialog(
          message: incident.alertMessage.isEmpty
              ? 'A high-severity safety violation needs immediate attention.'
              : incident.alertMessage,
          onDismiss: () async {
            await _alarmService.stopAlarm();
            if (dialogContext.mounted) {
              Navigator.of(dialogContext).pop();
            }
          },
        );
      },
    );

    _isAlertVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
            child: Column(
              children: [
                AnimatedReveal(child: _HomeHeader(onSignOut: _signOut)),
                const SizedBox(height: 18),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: FutureBuilder<DashboardSnapshot>(
                      future: _future,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 64),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        final data = snapshot.data!;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const AnimatedReveal(
                              child: SectionHeading(
                                eyebrow: 'PPE HISTORY',
                                title: 'Your missed PPE records',
                                description:
                                    'View your recent records where required PPE was missing during your factory shift.',
                              ),
                            ),
                            const SizedBox(height: 22),
                            AnimatedReveal(
                              delay: const Duration(milliseconds: 120),
                              child: GlassPanel(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Record History',
                                      style:
                                          Theme.of(context).textTheme.headlineMedium,
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      'Location, time, and the equipment you missed',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: AppColors.textSecondary,
                                          ),
                                    ),
                                    const SizedBox(height: 18),
                                    ListView.separated(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: data.recentViolations.length,
                                      separatorBuilder: (_, __) => Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 16,
                                        ),
                                        child: Divider(
                                          color: Colors.white.withValues(
                                            alpha: 0.08,
                                          ),
                                          height: 1,
                                        ),
                                      ),
                                      itemBuilder: (context, index) {
                                        return _PpeHistoryTile(
                                          event: data.recentViolations[index],
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SafetyViolationDialog extends StatelessWidget {
  const _SafetyViolationDialog({
    required this.message,
    required this.onDismiss,
  });

  final String message;
  final Future<void> Function() onDismiss;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Material(
        color: Colors.transparent,
        child: SafeArea(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF4A0000),
                  Color(0xFF7A0D0D),
                  Color(0xFFB71C1C),
                ],
              ),
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(24, 30, 24, 24),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.18),
                    ),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 32,
                        offset: const Offset(0, 18),
                        color: Colors.black.withValues(alpha: 0.3),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.12),
                        ),
                        child: const Icon(
                          Icons.warning_amber_rounded,
                          size: 42,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'ACCIDENT HAZARD',
                        style: Theme.of(context).textTheme.displayMedium
                            ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                            ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        message,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.white.withValues(alpha: 0.92),
                        ),
                      ),
                      const SizedBox(height: 28),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.dangerDark,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            textStyle: Theme.of(context).textTheme.labelLarge
                                ?.copyWith(fontWeight: FontWeight.w800),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: () => onDismiss(),
                          child: const Text('Dismiss'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader({required this.onSignOut});

  final Future<void> Function() onSignOut;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: AppLogo(compact: true)),
        const SizedBox(width: 12),
        AppActionButton(
          label: 'Sign Out',
          icon: Icons.logout_rounded,
          isPrimary: false,
          onPressed: () => onSignOut(),
        ),
      ],
    );
  }
}

class _PpeHistoryTile extends StatelessWidget {
  const _PpeHistoryTile({required this.event});

  final ViolationEvent event;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: Colors.white.withValues(alpha: 0.04),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Equipment: ${event.title}',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          _InfoRow(label: 'Location', value: event.zone),
          const SizedBox(height: 8),
          _InfoRow(label: 'Timestamp', value: event.timestamp),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 92,
          child: Text(
            '$label:',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textMuted,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}
