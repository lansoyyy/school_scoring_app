import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:school_scoring_app/core/constants/app_constants.dart';
import 'package:url_launcher/url_launcher.dart';

class GameItem {
  final int id;
  final String glink;
  final String eventPlace;
  final String gameDate;
  final String gameTime;
  final String team1;
  final String team2;
  final String team1Score;
  final String team2Score;
  final String timeRem;
  final String gameQtr;
  final String team1Pic;
  final String team2Pic;
  final String gameStatus;

  GameItem({
    required this.id,
    required this.glink,
    required this.eventPlace,
    required this.gameDate,
    required this.gameTime,
    required this.team1,
    required this.team2,
    required this.team1Score,
    required this.team2Score,
    required this.timeRem,
    required this.gameQtr,
    required this.team1Pic,
    required this.team2Pic,
    required this.gameStatus,
  });

  factory GameItem.fromJson(Map<String, dynamic> json) {
    return GameItem(
      id: json['id'] as int,
      glink: json['glink'] as String? ?? '',
      eventPlace: json['event_place'] as String,
      gameDate: json['game_date'] as String,
      gameTime: json['game_time'] as String,
      team1: json['team1'] as String,
      team2: json['team2'] as String,
      team1Score: json['team1_score'] as String? ?? '',
      team2Score: json['team2_score'] as String? ?? '',
      timeRem: json['time_rem'] as String? ?? '',
      gameQtr: json['game_qtr'] as String? ?? '',
      team1Pic: json['team1_pic'] as String,
      team2Pic: json['team2_pic'] as String,
      gameStatus: json['game_status'] as String,
    );
  }
}

class SportsScreen extends StatefulWidget {
  const SportsScreen({super.key});

  @override
  State<SportsScreen> createState() => _SportsScreenState();
}

class _SportsScreenState extends State<SportsScreen> {
  int _selectedDayIndex = 3;
  final DateTime _baseDate = DateTime(2026, 2, 15);
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  String _searchQuery = '';
  List<GameItem> _allGames = [];
  bool _isLoadingGames = true;
  String? _selectedDate;

  List<GameItem> get _todayEvents {
    if (_selectedDate != null) {
      return _allGames.where((g) => g.gameDate == _selectedDate).toList();
    }
    // Get date for selected day index
    final selectedDate = _baseDate.add(Duration(days: _selectedDayIndex));
    final formattedDate =
        '${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}-${selectedDate.year}';
    return _allGames.where((g) => g.gameDate == formattedDate).toList();
  }

  List<GameItem> get _filteredEvents {
    final events = _todayEvents;
    if (_searchQuery.isEmpty) return events;
    return events
        .where(
          (e) =>
              e.team1.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              e.team2.toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList();
  }

  List<String> get _weekDays => [
    'S',
    'M',
    'T',
    'W',
    'T',
    'F',
    'S',
    'S',
    'M',
    'T',
    'W',
    'T',
    'F',
  ];

  List<int> get _weekDates => [
    15,
    16,
    17,
    18,
    19,
    20,
    21,
    22,
    23,
    24,
    25,
    26,
    27,
  ];

  @override
  void initState() {
    super.initState();
    _fetchGames();
  }

  Future<void> _fetchGames({String? date}) async {
    try {
      String url = '${AppConstants.apiBaseUrl}/game';
      if (date != null) {
        url += '?date=$date';
      }

      final response = await http
          .get(Uri.parse(url))
          .timeout(
            const Duration(milliseconds: AppConstants.connectionTimeout),
          );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _allGames = data.map((item) => GameItem.fromJson(item)).toList();
          _isLoadingGames = false;
          if (date != null) {
            _selectedDate = date;
          }
        });
      } else {
        setState(() => _isLoadingGames = false);
      }
    } catch (e) {
      setState(() => _isLoadingGames = false);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final events = _isSearching ? _filteredEvents : _todayEvents;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildHeader(),
          _buildWeekCalendar(),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          Expanded(
            child: _isLoadingGames
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFFD4A017)),
                  )
                : events.isEmpty
                ? _buildEmpty()
                : ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      return _ScheduleCard(game: events[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: const Color(0xFFF5F5F5),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              const Text(
                'Sports Schedule',
                style: TextStyle(
                  fontFamily: 'Urbanist',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const Spacer(),
              if (!_isSearching)
                IconButton(
                  onPressed: () {
                    setState(() => _isSearching = true);
                  },
                  icon: const Icon(Icons.search, color: Color(0xFF1A1A1A)),
                )
              else
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _isSearching = false;
                          _searchQuery = '';
                          _searchController.clear();
                        });
                      },
                      icon: const Icon(Icons.close, color: Color(0xFF1A1A1A)),
                    ),
                    SizedBox(
                      width: 200,
                      child: TextField(
                        controller: _searchController,
                        onChanged: (v) => setState(() => _searchQuery = v),
                        autofocus: true,
                        decoration: const InputDecoration(
                          hintText: 'Search games...',
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            fontFamily: 'Urbanist',
                            color: Color(0xFF888888),
                          ),
                        ),
                        style: const TextStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeekCalendar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: List.generate(_weekDates.length, (index) {
            final isSelected = index == _selectedDayIndex;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedDayIndex = index;
                  _selectedDate = null;
                });
                // Fetch games for selected date
                final selectedDate = _baseDate.add(Duration(days: index));
                final formattedDateForApi =
                    '${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}-${selectedDate.year}';
                _fetchGames(date: formattedDateForApi);
              },
              child: Container(
                margin: EdgeInsets.only(
                  right: index < _weekDates.length - 1 ? 24 : 0,
                ),
                child: Column(
                  children: [
                    Text(
                      _weekDays[index],
                      style: TextStyle(
                        fontFamily: 'Urbanist',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: isSelected
                            ? const Color(0xFF1A1A1A)
                            : const Color(0xFF888888),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF1A1A1A)
                            : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${_weekDates[index]}',
                          style: TextStyle(
                            fontFamily: 'Urbanist',
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: isSelected
                                ? Colors.white
                                : const Color(0xFF1A1A1A),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.sports_outlined, size: 56, color: Colors.grey[300]),
          const SizedBox(height: 12),
          Text(
            'No games scheduled',
            style: TextStyle(
              fontFamily: 'Urbanist',
              fontSize: 15,
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }
}

class _ScheduleCard extends StatelessWidget {
  final GameItem game;
  const _ScheduleCard({required this.game});

  @override
  Widget build(BuildContext context) {
    final isFinal = game.gameStatus == 'past';
    final isLive = game.gameStatus == 'live';
    final isFuture = game.gameStatus == 'future';

    if (isFinal || !isLive) {
      // Upcoming game layout
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Row(
              children: [
                // Team 1
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: const BoxDecoration(
                          color: Color(0xFFF5F5F5),
                          shape: BoxShape.circle,
                        ),
                        child: ClipOval(
                          child: Image.network(
                            game.team1Pic,
                            width: 48,
                            height: 48,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.sports_basketball,
                                size: 24,
                                color: Color(0xFF1A1A1A),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        game.team1,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      if (!isFuture)
                        Text(
                          game.team1Score,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'Urbanist',
                            fontSize: 35,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                    ],
                  ),
                ),
                // Center Info (Time and Date)
                SizedBox(
                  width: 125,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 14,
                            color: Color(0xFF888888),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            game.eventPlace,
                            style: const TextStyle(
                              fontFamily: 'Urbanist',
                              fontSize: 12,
                              color: Color(0xFF888888),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        game.gameTime,
                        style: const TextStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        game.gameDate,
                        style: const TextStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF888888),
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (isFinal)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'FINAL',
                            style: TextStyle(
                              fontFamily: 'Urbanist',
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1A1A1A),
                            ),
                          ),
                        ),
                      const SizedBox(height: 16),
                      if (!isFuture && game.glink.isNotEmpty)
                        GestureDetector(
                          onTap: () async {
                            final Uri url = Uri.parse(game.glink);
                            if (await canLaunchUrl(url)) {
                              await launchUrl(
                                url,
                                mode: LaunchMode.externalApplication,
                              );
                            }
                          },
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFFCCCCCC),
                                width: 2,
                              ),
                            ),
                            child: const Icon(
                              Icons.play_arrow_rounded,
                              size: 20,
                              color: Color(0xFF888888),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                // Team 2
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: const BoxDecoration(
                          color: Color(0xFFF5F5F5),
                          shape: BoxShape.circle,
                        ),
                        child: ClipOval(
                          child: Image.network(
                            game.team2Pic,
                            width: 48,
                            height: 48,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.sports_basketball,
                                size: 24,
                                color: Color(0xFF1A1A1A),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        game.team2,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      if (!isFuture)
                        Text(
                          game.team2Score,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'Urbanist',
                            fontSize: 35,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
        ],
      );
    }

    // Final or Live game layout
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Team 1
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: const BoxDecoration(
                            color: Color(0xFFF5F5F5),
                            shape: BoxShape.circle,
                          ),
                          child: ClipOval(
                            child: Image.network(
                              game.team1Pic,
                              width: 48,
                              height: 48,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.sports_basketball,
                                  size: 32,
                                  color: Color(0xFF1A1A1A),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          game.team1,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'Urbanist',
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),

                        const SizedBox(height: 12),
                        Text(
                          game.team1Score,
                          style: const TextStyle(
                            fontFamily: 'Urbanist',
                            fontSize: 36,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Center Info
                  SizedBox(
                    width: 120,
                    child: Column(
                      children: [
                        // Venue row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.location_on,
                              size: 14,
                              color: Color(0xFF888888),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              game.eventPlace,
                              style: const TextStyle(
                                fontFamily: 'Urbanist',
                                fontSize: 12,
                                color: Color(0xFF888888),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        if (isFinal)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F5F5),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Text(
                              'FINAL',
                              style: TextStyle(
                                fontFamily: 'Urbanist',
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1A1A1A),
                              ),
                            ),
                          )
                        else if (isLive)
                          Column(
                            children: [
                              Text(
                                game.timeRem,
                                style: const TextStyle(
                                  fontFamily: 'Urbanist',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF1A1A1A),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFEBEB),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Text(
                                  'LIVE',
                                  style: TextStyle(
                                    fontFamily: 'Urbanist',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFFCC0000),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              if (game.glink.isNotEmpty)
                                GestureDetector(
                                  onTap: () async {
                                    final Uri url = Uri.parse(game.glink);
                                    if (await canLaunchUrl(url)) {
                                      await launchUrl(
                                        url,
                                        mode: LaunchMode.externalApplication,
                                      );
                                    }
                                  },
                                  child: Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: const Color(0xFFCCCCCC),
                                        width: 2,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.play_arrow_rounded,
                                      size: 20,
                                      color: Color(0xFF888888),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                      ],
                    ),
                  ),
                  // Team 2
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: const BoxDecoration(
                            color: Color(0xFFF5F5F5),
                            shape: BoxShape.circle,
                          ),
                          child: ClipOval(
                            child: Image.network(
                              game.team2Pic,
                              width: 48,
                              height: 48,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.sports_basketball,
                                  size: 32,
                                  color: Color(0xFF1A1A1A),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          game.team2,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'Urbanist',
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                        if (isFinal || isLive) ...[
                          const SizedBox(height: 12),
                          Text(
                            game.team2Score,
                            style: const TextStyle(
                              fontFamily: 'Urbanist',
                              fontSize: 36,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1A1A1A),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const Divider(height: 1, color: Color(0xFFEEEEEE)),
      ],
    );
  }
}
