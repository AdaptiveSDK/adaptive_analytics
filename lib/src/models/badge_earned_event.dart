/// Event data for when a student earns a badge.
class BadgeEarnedEvent {
  final int badgeId;
  final String badgeName;
  final String badgeDescription;

  /// The entity (person or system) that issued the badge.
  final String issuedBy;

  const BadgeEarnedEvent({
    required this.badgeId,
    required this.badgeName,
    required this.badgeDescription,
    required this.issuedBy,
  });

  Map<String, dynamic> toMap() => {
        'badgeId': badgeId,
        'badgeName': badgeName,
        'badgeDescription': badgeDescription,
        'issuedBy': issuedBy,
      };
}
