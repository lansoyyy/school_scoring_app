import 'package:flutter/material.dart';

class SportsScreen extends StatefulWidget {
  const SportsScreen({super.key});

  @override
  State<SportsScreen> createState() => _SportsScreenState();
}

class _SportsScreenState extends State<SportsScreen> {
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
      _allEvents.toList(); // showing combination of all for Current

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildHeader(),
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
                'CURRENT GAMES',
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
    final isLive = event['status'] == 'Live';
    
    IconData sportIcon = Icons.sports_basketball;
    if (event['sport'] == 'Volleyball') sportIcon = Icons.sports_volleyball;
    if (event['sport'] == 'Football') sportIcon = Icons.sports_soccer;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF5F5F5),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(sportIcon, size: 14, color: const Color(0xFF1A1A1A)),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        event['section1'],
                        style: const TextStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                    ),
                  ],
                ),
                if (isFinal || isLive) ...[
                  const SizedBox(height: 8),
                  Text(
                    event['score1'],
                    style: TextStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: isLive ? const Color(0xFFCC0000) : const Color(0xFF1A1A1A),
                    ),
                  ),
                ],
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isLive ? const Color(0xFFFFEBEB) : Colors.transparent,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  isLive ? 'LIVE' : (isFinal ? event['status'] : event['date']),
                  style: TextStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 12,
                    fontWeight: isLive ? FontWeight.w700 : FontWeight.w500,
                    color: isLive
                        ? const Color(0xFFCC0000)
                        : (isFinal ? const Color(0xFF1A1A1A) : const Color(0xFF888888)),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Text(
                        event['section2'],
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 24,
                      height: 24,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF5F5F5),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(sportIcon, size: 14, color: const Color(0xFF1A1A1A)),
                    ),
                  ],
                ),
                if (isFinal || isLive) ...[
                  const SizedBox(height: 8),
                  Text(
                    event['score2'],
                    style: TextStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: isLive ? const Color(0xFFCC0000) : const Color(0xFF1A1A1A),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
