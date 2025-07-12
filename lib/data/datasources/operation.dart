enum OperationType { create, update, delete }

class PendingOperation {
  final String id;
  final String endpoint;
  final OperationType type;
  final Map<String, dynamic>? payload;
  final DateTime timestamp;

  PendingOperation({
    required this.id,
    required this.endpoint,
    required this.type,
    this.payload,
    DateTime? ts,
  }) : timestamp = ts ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'id': id,
    'endpoint': endpoint,
    'type': type.name,
    'payload': payload,
    'timestamp': timestamp.toIso8601String(),
  };

  factory PendingOperation.fromJson(Map<String, dynamic> j) => PendingOperation(
    id: j['id'] as String,
    endpoint: j['endpoint'] as String,
    type: OperationType.values.firstWhere((e) => e.name == j['type']),
    payload: (j['payload'] as Map?)?.cast<String, dynamic>(),
    ts: DateTime.parse(j['timestamp'] as String),
  );
}
