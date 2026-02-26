import 'package:flutter/material.dart';
import 'package:school_scoring_app/features/live/live_screen.dart';

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

  static const List<Map<String, dynamic>> _allEvents = [
    // Finished games (Feb 15, day 0)
    {
      'day': 0,
      'sport': 'Basketball',
      'time': '8:00 AM',
      'date': 'Sun 02/15',
      'section1': 'Saint Claire',
      'section2': 'Saint Mark',
      'score1': '72',
      'score2': '68',
      'status': 'Final',
      'venue': 'DSI Gymnasium',
      'image': 'basketball',
    },
    {
      'day': 0,
      'sport': 'Volleyball',
      'time': '10:00 AM',
      'date': 'Sun 02/15',
      'section1': 'Grade 9-Rizal',
      'section2': 'Grade 9-Bonifacio',
      'score1': '3',
      'score2': '1',
      'status': 'Final',
      'venue': 'DSI Covered Court',
      'image': 'volleyball',
    },
    // Future games (Feb 16-21)
    {
      'day': 1,
      'sport': 'Basketball',
      'time': '9:00 AM',
      'date': 'Mon 02/16',
      'section1': 'Grade 11-STEM',
      'section2': 'Grade 11-ABM',
      'score1': '72',
      'score2': '68',
      'status': 'Final',
      'venue': 'DSI Gymnasium',
      'image': 'basketball',
    },
    {
      'day': 2,
      'sport': 'Volleyball',
      'time': '8:30 AM',
      'date': 'Tue 02/17',
      'section1': 'Grade 8-Sampaguita',
      'section2': 'Grade 8-Rosal',
      'score1': '72',
      'score2': '68',
      'status': 'Final',
      'venue': 'DSI Covered Court',
      'image': 'volleyball',
    },
    {
      'day': 3,
      'sport': 'Basketball',
      'time': '8:00 AM',
      'date': 'Wed 02/18',
      'section1': 'Rockets',
      'section2': 'Hornets',
      'score1': '22',
      'score2': '25',
      'status': 'Live',
      'venue': 'DSI Gymnasium',
      'image': 'basketball',
    },
    {
      'day': 4,
      'sport': 'Football',
      'time': '2:00 PM',
      'date': 'Thu 02/19',
      'section1': 'Grade 6-Sampaguita',
      'section2': 'Grade 6-Ilang-Ilang',
      'score1': '',
      'score2': '',
      'status': 'Future',
      'venue': 'DSI Football Field',
      'image': 'football',
    },
    {
      'day': 5,
      'sport': 'Basketball',
      'time': '9:00 AM',
      'date': 'Fri 02/20',
      'section1': 'Grade 12-HUMSS',
      'section2': 'Grade 12-GAS',
      'score1': '',
      'score2': '',
      'status': 'Future',
      'venue': 'DSI Gymnasium',
      'image': 'basketball',
    },
    {
      'day': 6,
      'sport': 'Volleyball',
      'time': '10:00 AM',
      'date': 'Sat 02/21',
      'section1': 'Grade 5-Jasmine',
      'section2': 'Grade 5-Adelfa',
      'score1': '',
      'score2': '',
      'status': 'Future',
      'venue': 'DSI Covered Court',
      'image': 'volleyball',
    },
  ];

  List<Map<String, dynamic>> get _todayEvents =>
      _allEvents.where((e) => e['day'] == _selectedDayIndex).toList();

  List<Map<String, dynamic>> get _filteredEvents {
    final events = _todayEvents;
    if (_searchQuery.isEmpty) return events;
    return events
        .where(
          (e) =>
              e['section1']!.toString().toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ) ||
              e['section2']!.toString().toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ) ||
              e['sport']!.toString().toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ),
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
            child: events.isEmpty
                ? _buildEmpty()
                : ListView.separated(
                    padding: EdgeInsets.zero,
                    itemCount: events.length,
                    separatorBuilder: (_, __) =>
                        const Divider(height: 1, color: Color(0xFFEEEEEE)),
                    itemBuilder: (context, i) =>
                        _ScheduleCard(event: events[i]),
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
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: Row(
            children: [
              const Text(
                'GAMES',
                style: TextStyle(
                  fontFamily: 'Urbanist',
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A1A),
                ),
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
              onTap: () => setState(() => _selectedDayIndex = index),
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
  final Map<String, dynamic> event;
  const _ScheduleCard({required this.event});

  IconData _getSportIcon(String sport) {
    switch (sport) {
      case 'Basketball':
        return Icons.sports_basketball;
      case 'Volleyball':
        return Icons.sports_volleyball;
      case 'Football':
        return Icons.sports_soccer;
      default:
        return Icons.sports;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isFinal = event['status'] == 'Final';
    final isLive = event['status'] == 'Live';
    final isFuture = event['status'] == 'Future';
    final sportIcon = _getSportIcon(event['sport']);

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
                        child: Icon(
                          sportIcon,
                          size: 24,
                          color: const Color(0xFF1A1A1A),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        event['section1'],
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
                          event['score1'],
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
                            event['venue'] ?? 'DSI Gymnasium',
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
                        event['time'],
                        style: const TextStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        event['date'],
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
                      if (!isFuture)
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const VideoPlayerScreen(),
                              ),
                            );
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
                        child: Icon(
                          sportIcon,
                          size: 24,
                          color: const Color(0xFF1A1A1A),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        event['section2'],
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
                          event['score2'],
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
                          child: Icon(
                            sportIcon,
                            size: 32,
                            color: const Color(0xFF1A1A1A),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          event['section1'],
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
                          event['score1'],
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
                              event['venue'] ?? 'DSI Gymnasium',
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
                              const Text(
                                '9:00',
                                style: TextStyle(
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
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const VideoPlayerScreen(),
                                    ),
                                  );
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
                          child: Icon(
                            sportIcon,
                            size: 32,
                            color: const Color(0xFF1A1A1A),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          event['section2'],
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
                            event['score2'],
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
