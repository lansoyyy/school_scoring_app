import 'package:flutter/material.dart';

class SportsScreen extends StatefulWidget {
  const SportsScreen({super.key});

  @override
  State<SportsScreen> createState() => _SportsScreenState();
}

class _SportsScreenState extends State<SportsScreen> {
  int _selectedDayIndex = 0;
  final DateTime _baseDate = DateTime(2026, 2, 16);

  final List<Map<String, dynamic>> _allEvents = [
    {
      'day': 0,
      'sport': 'Basketball',
      'time': '8:00 AM',
      'section1': 'Saint Claire',
      'section2': 'Saint Mark',
      'venue': 'Main Gym',
      'status': 'Completed',
      'score1': '72',
      'score2': '68',
      'color': 0xFFFF6B35,
      'icon': Icons.sports_basketball,
    },
    {
      'day': 0,
      'sport': 'Volleyball',
      'time': '10:00 AM',
      'section1': 'Grade 9-Rizal',
      'section2': 'Grade 9-Bonifacio',
      'venue': 'Court A',
      'status': 'Completed',
      'score1': '3',
      'score2': '1',
      'color': 0xFF00A896,
      'icon': Icons.sports_volleyball,
    },
    {
      'day': 1,
      'sport': 'Basketball',
      'time': '9:00 AM',
      'section1': 'Grade 11-STEM',
      'section2': 'Grade 11-ABM',
      'venue': 'Main Gym',
      'status': 'Upcoming',
      'score1': '-',
      'score2': '-',
      'color': 0xFFFF6B35,
      'icon': Icons.sports_basketball,
    },
    {
      'day': 1,
      'sport': 'Badminton',
      'time': '1:00 PM',
      'section1': 'Grade 7-Einstein',
      'section2': 'Grade 7-Newton',
      'venue': 'Covered Court',
      'status': 'Upcoming',
      'score1': '-',
      'score2': '-',
      'color': 0xFF00B4D8,
      'icon': Icons.sports,
    },
    {
      'day': 2,
      'sport': 'Volleyball',
      'time': '8:30 AM',
      'section1': 'Grade 8-Sampaguita',
      'section2': 'Grade 8-Rosal',
      'venue': 'Court B',
      'status': 'Upcoming',
      'score1': '-',
      'score2': '-',
      'color': 0xFF00A896,
      'icon': Icons.sports_volleyball,
    },
    {
      'day': 3,
      'sport': 'Basketball',
      'time': '7:30 AM',
      'section1': 'Grade 10-Aguinaldo',
      'section2': 'Grade 10-Mabini',
      'venue': 'Main Gym',
      'status': 'Upcoming',
      'score1': '-',
      'score2': '-',
      'color': 0xFFFF6B35,
      'icon': Icons.sports_basketball,
    },
    {
      'day': 4,
      'sport': 'Football',
      'time': '2:00 PM',
      'section1': 'Grade 6-Sampaguita',
      'section2': 'Grade 6-Ilang-Ilang',
      'venue': 'Football Field',
      'status': 'Upcoming',
      'score1': '-',
      'score2': '-',
      'color': 0xFF0077B6,
      'icon': Icons.sports_soccer,
    },
    {
      'day': 5,
      'sport': 'Basketball',
      'time': '9:00 AM',
      'section1': 'Grade 12-HUMSS',
      'section2': 'Grade 12-GAS',
      'venue': 'Main Gym',
      'status': 'Upcoming',
      'score1': '-',
      'score2': '-',
      'color': 0xFFFF6B35,
      'icon': Icons.sports_basketball,
    },
    {
      'day': 6,
      'sport': 'Volleyball',
      'time': '10:00 AM',
      'section1': 'Grade 5-Jasmine',
      'section2': 'Grade 5-Adelfa',
      'venue': 'Court A',
      'status': 'Upcoming',
      'score1': '-',
      'score2': '-',
      'color': 0xFF00A896,
      'icon': Icons.sports_volleyball,
    },
  ];

  List<Map<String, dynamic>> get _todayEvents =>
      _allEvents.where((e) => e['day'] == _selectedDayIndex).toList();

  String _dayLabel(int offset) {
    final date = _baseDate.add(Duration(days: offset));
    const days = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
    return days[date.weekday % 7];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          _buildHeader(),
          _buildCalendar(),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text(
                  _todayEvents.isEmpty
                      ? 'No events'
                      : '${_todayEvents.length} Event${_todayEvents.length > 1 ? 's' : ''}',
                  style: const TextStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _todayEvents.isEmpty
                ? _buildEmpty()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: _todayEvents.length,
                    itemBuilder: (context, i) =>
                        _EventCard(event: _todayEvents[i]),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0D2137), Color(0xFF1A3F6F), Color(0xFF2E6AAD)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(0),
          bottomRight: Radius.circular(0),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sports Schedule',
                    style: TextStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'February 2026',
                    style: TextStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 13,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.filter_list_rounded,
                        color: Colors.white, size: 16),
                    SizedBox(width: 6),
                    Text(
                      'Filter',
                      style: TextStyle(
                        fontFamily: 'Urbanist',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    return Container(
      color: const Color(0xFF1A3F6F),
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
      child: Column(
        children: [
          Row(
            children: List.generate(7, (i) {
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedDayIndex = i),
                  child: Column(
                    children: [
                      Text(
                        _dayLabel(i),
                        style: TextStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _selectedDayIndex == i
                              ? Colors.white
                              : Colors.white54,
                        ),
                      ),
                      const SizedBox(height: 6),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: _selectedDayIndex == i
                              ? Colors.white
                              : Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${_baseDate.add(Duration(days: i)).day}',
                            style: TextStyle(
                              fontFamily: 'Urbanist',
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: _selectedDayIndex == i
                                  ? const Color(0xFF1A3F6F)
                                  : Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: 5,
                        height: 5,
                        decoration: BoxDecoration(
                          color: _allEvents
                                  .any((e) => e['day'] == i)
                              ? const Color(0xFFF5A623)
                              : Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_busy_outlined,
              size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'No events scheduled',
            style: TextStyle(
              fontFamily: 'Urbanist',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  final Map<String, dynamic> event;

  const _EventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    final isCompleted = event['status'] == 'Completed';
    final accentColor = Color(event['color'] as int);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.1),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Icon(event['icon'] as IconData, color: accentColor, size: 18),
                const SizedBox(width: 8),
                Text(
                  event['sport'],
                  style: TextStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: accentColor,
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    Icon(Icons.access_time_outlined,
                        size: 13, color: Colors.grey[500]),
                    const SizedBox(width: 4),
                    Text(
                      event['time'],
                      style: TextStyle(
                        fontFamily: 'Urbanist',
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 10),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? const Color(0xFFD1FAE5)
                        : const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    event['status'],
                    style: TextStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: isCompleted
                          ? const Color(0xFF10B981)
                          : const Color(0xFFF59E0B),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event['section1'],
                        style: const TextStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1A2E),
                        ),
                      ),
                      if (isCompleted) ...[
                        const SizedBox(height: 4),
                        Text(
                          event['score1'],
                          style: TextStyle(
                            fontFamily: 'Urbanist',
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: accentColor,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        isCompleted ? 'FINAL' : 'VS',
                        style: TextStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: isCompleted
                              ? const Color(0xFF10B981)
                              : const Color(0xFF6B7280),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      event['venue'],
                      style: const TextStyle(
                        fontFamily: 'Urbanist',
                        fontSize: 10,
                        color: Color(0xFF9CA3AF),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        event['section2'],
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1A2E),
                        ),
                      ),
                      if (isCompleted) ...[
                        const SizedBox(height: 4),
                        Text(
                          event['score2'],
                          style: TextStyle(
                            fontFamily: 'Urbanist',
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: accentColor,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
