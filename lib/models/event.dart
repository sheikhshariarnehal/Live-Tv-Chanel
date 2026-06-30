/// Team data within an event
class Team {
  final String name;
  final String? flag;

  const Team({required this.name, this.flag});

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      name: json['name'] as String? ?? 'TBD',
      flag: json['flag'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {'name': name, 'flag': flag};
}

/// Data model for a sporting event
class SportEvent {
  final String id;
  final String sport;
  final String league;
  final Team homeTeam;
  final Team awayTeam;
  final DateTime startTime;
  final String status; // 'live', 'upcoming', 'finished'
  final List<String> channels;
  final String? banner;
  final bool isFeatured;

  const SportEvent({
    required this.id,
    required this.sport,
    required this.league,
    required this.homeTeam,
    required this.awayTeam,
    required this.startTime,
    this.status = 'upcoming',
    this.channels = const [],
    this.banner,
    this.isFeatured = false,
  });

  bool get isLive => status == 'live';
  bool get isUpcoming => status == 'upcoming';
  bool get isFinished => status == 'finished';

  Duration get timeUntilStart => startTime.difference(DateTime.now());
  Duration get elapsedTime => DateTime.now().difference(startTime);

  factory SportEvent.fromJson(Map<String, dynamic> json) {
    return SportEvent(
      id: json['id'] as String,
      sport: json['sport'] as String,
      league: json['league'] as String,
      homeTeam: json['home_team'] is Map
          ? Team.fromJson(Map<String, dynamic>.from(json['home_team'] as Map))
          : const Team(name: 'TBD'),
      awayTeam: json['away_team'] is Map
          ? Team.fromJson(Map<String, dynamic>.from(json['away_team'] as Map))
          : const Team(name: 'TBD'),
      startTime: DateTime.parse(json['start_time'] as String),
      status: json['status'] as String? ?? 'upcoming',
      channels: json['channels'] is List
          ? (json['channels'] as List).map((e) => e.toString()).toList()
          : [],
      banner: json['banner'] as String?,
      isFeatured: json['is_featured'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'sport': sport,
        'league': league,
        'home_team': homeTeam.toJson(),
        'away_team': awayTeam.toJson(),
        'start_time': startTime.toIso8601String(),
        'status': status,
        'channels': channels,
        'banner': banner,
        'is_featured': isFeatured,
      };
}
