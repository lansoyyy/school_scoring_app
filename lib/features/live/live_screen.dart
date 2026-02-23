import 'dart:async';
import 'package:flutter/material.dart';

class VideoPlayerScreen extends StatelessWidget {
  const VideoPlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Live Stream',
          style: TextStyle(fontFamily: 'Urbanist', color: Colors.white),
        ),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.play_circle_outline, size: 80, color: Colors.white54),
            SizedBox(height: 16),
            Text(
              'Video Player',
              style: TextStyle(
                fontFamily: 'Urbanist',
                fontSize: 18,
                color: Colors.white70,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Live game stream will play here',
              style: TextStyle(
                fontFamily: 'Urbanist',
                fontSize: 14,
                color: Colors.white54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LiveScreen extends StatefulWidget {
  const LiveScreen({super.key});

  @override
  State<LiveScreen> createState() => _LiveScreenState();
}

class _LiveScreenState extends State<LiveScreen> {
  int _score1 = 40;
  int _score2 = 55;
  int _minutes = 8;
  int _seconds = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        if (_seconds > 0) {
          _seconds--;
        } else if (_minutes > 0) {
          _minutes--;
          _seconds = 59;
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildHeader(),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildLiveGame(),
                const Divider(height: 1, color: Color(0xFFEEEEEE)),
                _buildOtherGames(),
              ],
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
                'LIVE',
                style: TextStyle(
                  fontFamily: 'Urbanist',
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFFCC0000),
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLiveGame() {
    final timer =
        '${_minutes.toString().padLeft(2, '0')}:${_seconds.toString().padLeft(2, '0')}';
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
      child: Column(
        children: [
          // Event Place
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.location_on, size: 16, color: Color(0xFF888888)),
                SizedBox(width: 6),
                Text(
                  'DSI Gymnasium',
                  style: TextStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF555555),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          // Scores Row - Bigger and Centered
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Team 1 Column
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Red ball logo
                    Container(
                      width: 56,
                      height: 56,
                      decoration: const BoxDecoration(
                        color: Color(0xFFCC0000),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.sports_basketball,
                        size: 32,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Rockets',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Urbanist',
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '$_score1',
                      style: const TextStyle(
                        fontFamily: 'Urbanist',
                        fontSize: 80,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                  ],
                ),
              ),
              // Center Timer
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    timer,
                    style: const TextStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '2nd Quarter',
                    style: TextStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF888888),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Play Button
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const VideoPlayerScreen(),
                      ),
                    ),
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: const BoxDecoration(
                        color: Color(0xFFCC0000),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.play_arrow,
                        size: 36,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              // Team 2 Column
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Blue ball logo
                    Container(
                      width: 56,
                      height: 56,
                      decoration: const BoxDecoration(
                        color: Color(0xFF1A65CC),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.sports_basketball,
                        size: 32,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Hornets',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Urbanist',
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '$_score2',
                      style: const TextStyle(
                        fontFamily: 'Urbanist',
                        fontSize: 80,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOtherGames() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            'OTHER LIVE GAMES',
            style: TextStyle(
              fontFamily: 'Urbanist',
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF888888),
            ),
          ),
        ),
        // Example other live game
        _buildOtherGameCard(
          'Volleyball',
          'Eagles',
          '25',
          'Hawks',
          '22',
          'Set 3',
        ),
      ],
    );
  }

  Widget _buildOtherGameCard(
    String sport,
    String team1,
    String score1,
    String team2,
    String score2,
    String status,
  ) {
    IconData sportIcon = Icons.sports_basketball;
    if (sport == 'Volleyball') sportIcon = Icons.sports_volleyball;
    if (sport == 'Football') sportIcon = Icons.sports_soccer;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: Color(0xFFCC0000),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(sportIcon, size: 18, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    team1,
                    style: const TextStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Row(
                children: [
                  Text(
                    score1,
                    style: const TextStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '-',
                    style: const TextStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 18,
                      color: Color(0xFFCCCCCC),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    score2,
                    style: const TextStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                status,
                style: const TextStyle(
                  fontFamily: 'Urbanist',
                  fontSize: 12,
                  color: Color(0xFFCC0000),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: Text(
                    team2,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: Color(0xFF1A65CC),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(sportIcon, size: 18, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
