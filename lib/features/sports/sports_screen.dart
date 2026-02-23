import 'package:flutter/material.dart';

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
      'score1': '',
      'score2': '',
      'status': 'Upcoming',
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
      'score1': '',
      'score2': '',
      'status': 'Upcoming',
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
      'score1': '',
      'score2': '',
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
      'status': 'Upcoming',
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
      'status': 'Upcoming',
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
      'status': 'Upcoming',
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

  List<String> get _weekDays => ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

  List<int> get _weekDates => [15, 16, 17, 18, 19, 20, 21];

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
      height: 80,
      color: const Color(0xFFF5F5F5),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(4, 8, 16, 12),
          child: _isSearching
              ? Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _isSearching = false;
                          _searchQuery = '';
                          _searchController.clear();
                        });
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    Expanded(
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
                    if (_searchQuery.isNotEmpty)
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _searchQuery = '';
                            _searchController.clear();
                          });
                        },
                        icon: const Icon(Icons.clear, color: Color(0xFF888888)),
                      ),
                  ],
                )
              : Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'GAMES',
                        style: TextStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => setState(() => _isSearching = true),
                      icon: const Icon(
                        Icons.search,
                        size: 24,
                        color: Color(0xFF555555),
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today_outlined,
                          size: 16,
                          color: Color(0xFF555555),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          'February 2026',
                          style: TextStyle(
                            fontFamily: 'Urbanist',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF555555),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(7, (index) {
          final isSelected = index == _selectedDayIndex;
          return GestureDetector(
            onTap: () => setState(() => _selectedDayIndex = index),
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
          );
        }),
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
    final sportIcon = _getSportIcon(event['sport']);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Game Image
        Container(
          width: double.infinity,
          height: 160,
          color: const Color(0xFF1A1A1A),
          child: Center(
            child: Icon(sportIcon, size: 60, color: const Color(0xFF444444)),
          ),
        ),
        // Game Details
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Venue
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
              const SizedBox(height: 16),
              // Teams and Scores
              Row(
                children: [
                  // Team 1
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: isLive
                                ? const Color(0xFFCC0000)
                                : const Color(0xFFF5F5F5),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            sportIcon,
                            size: 24,
                            color: isLive
                                ? Colors.white
                                : const Color(0xFF1A1A1A),
                          ),
                        ),
                        const SizedBox(height: 8),
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
                        if (isFinal || isLive) ...[
                          const SizedBox(height: 4),
                          Text(
                            event['score1'],
                            style: TextStyle(
                              fontFamily: 'Urbanist',
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: isLive
                                  ? const Color(0xFFCC0000)
                                  : const Color(0xFF1A1A1A),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  // VS / Time
                  Column(
                    children: [
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
                        )
                      else if (isLive)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFEBEB),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'LIVE',
                            style: TextStyle(
                              fontFamily: 'Urbanist',
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFCC0000),
                            ),
                          ),
                        )
                      else
                        Text(
                          event['time'],
                          style: const TextStyle(
                            fontFamily: 'Urbanist',
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                      const SizedBox(height: 4),
                      Text(
                        event['date'],
                        style: const TextStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 12,
                          color: Color(0xFF888888),
                        ),
                      ),
                    ],
                  ),
                  // Team 2
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: isLive
                                ? const Color(0xFF1A65CC)
                                : const Color(0xFFF5F5F5),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            sportIcon,
                            size: 24,
                            color: isLive
                                ? Colors.white
                                : const Color(0xFF1A1A1A),
                          ),
                        ),
                        const SizedBox(height: 8),
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
                        if (isFinal || isLive) ...[
                          const SizedBox(height: 4),
                          Text(
                            event['score2'],
                            style: TextStyle(
                              fontFamily: 'Urbanist',
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: isLive
                                  ? const Color(0xFFCC0000)
                                  : const Color(0xFF1A1A1A),
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
