import 'package:flutter/material.dart';

class SportsScreen extends StatefulWidget {
  const SportsScreen({super.key});

  @override
  State<SportsScreen> createState() => _SportsScreenState();
}

class _SportsScreenState extends State<SportsScreen> {
  int _selectedDayIndex = 3;
  final DateTime _baseDate = DateTime(2026, 2, 15);

  static const List<Map<String, dynamic>> _allEvents = [
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
    },
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
      'status': 'Upcoming',
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
    },
  ];

  List<Map<String, dynamic>> get _todayEvents =>
      _allEvents.where((e) => e['day'] == _selectedDayIndex).toList();

  static const List<String> _dayNames = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

  String _dayName(int offset) {
    final date = _baseDate.add(Duration(days: offset));
    return _dayNames[date.weekday % 7];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildHeader(),
          _buildWeekCalendar(),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          Expanded(
            child: _todayEvents.isEmpty
                ? _buildEmpty()
                : ListView.separated(
                    padding: EdgeInsets.zero,
                    itemCount: _todayEvents.length,
                    separatorBuilder: (_, __) =>
                        const Divider(height: 1, color: Color(0xFFEEEEEE)),
                    itemBuilder: (context, i) =>
                        _ScheduleCard(event: _todayEvents[i]),
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
              const Spacer(),
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today_outlined,
                    size: 16,
                    color: Color(0xFF555555),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'February 2026',
                    style: const TextStyle(
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
      color: const Color(0xFFF5F5F5),
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 12),
      child: Row(
        children: List.generate(7, (i) {
          final date = _baseDate.add(Duration(days: i));
          final isSelected = _selectedDayIndex == i;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedDayIndex = i),
              child: Column(
                children: [
                  Text(
                    _dayName(i),
                    style: TextStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF888888),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF1A1A1A)
                          : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${date.day}',
                        style: TextStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 14,
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

  @override
  Widget build(BuildContext context) {
    final isFinal = event['status'] == 'Final';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                if (isFinal)
                  Text(
                    event['score1'],
                    style: const TextStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
              ],
            ),
          ),
          Column(
            children: [
              Text(
                event['time'],
                style: const TextStyle(
                  fontFamily: 'Urbanist',
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                isFinal ? event['status'] : event['date'],
                style: TextStyle(
                  fontFamily: 'Urbanist',
                  fontSize: 12,
                  color: isFinal
                      ? const Color(0xFFCC0000)
                      : const Color(0xFF888888),
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
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                if (isFinal)
                  Text(
                    event['score2'],
                    style: const TextStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1A1A1A),
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
