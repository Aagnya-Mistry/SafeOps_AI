enum ViolationSeverity { high, medium, critical }

class ViolationEvent {
  const ViolationEvent({
    required this.title,
    required this.zone,
    required this.timestamp,
    required this.description,
    required this.severity,
  });

  final String title;
  final String zone;
  final String timestamp;
  final String description;
  final ViolationSeverity severity;
}
