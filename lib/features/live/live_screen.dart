import 'dart:async';
import 'package:flutter/material.dart';

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
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildHeader(),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          _buildLiveGame(),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          _buildOtherGame(
            'Grade 9-Rizal',
            'Grade 9-Bonifacio',
            '3',
            '1',
            'Final',
          ),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          _buildOtherGame(
            'Grade 11-STEM',
            'Grade 11-ABM',
            '',
            '',
            'Upcoming 1:00 PM',
          ),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          _buildOtherGame(
            'Grade 7-Einstein',
            'Grade 7-Newton',
            '',
            '',
            'Upcoming 3:00 PM',
          ),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
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
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$_score1',
                  style: const TextStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 40,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 4),
                const Icon(
                  Icons.sports_basketball,
                  size: 28,
                  color: Color(0xFFCC0000),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Rockets',
                  style: TextStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Text(
                timer,
                style: const TextStyle(
                  fontFamily: 'Urbanist',
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                '2nd',
                style: TextStyle(
                  fontFamily: 'Urbanist',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF888888),
                ),
              ),
              const SizedBox(height: 6),
              const Icon(
                Icons.play_circle_outline,
                size: 28,
                color: Color(0xFF888888),
              ),
            ],
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '$_score2',
                  style: const TextStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 40,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 4),
                const Icon(
                  Icons.sports_basketball,
                  size: 28,
                  color: Color(0xFF1A65CC),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Hornets',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
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

  Widget _buildOtherGame(
    String team1,
    String team2,
    String s1,
    String s2,
    String status,
  ) {
    final isFinal = status == 'Final';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Expanded(
            child: Text(
              team1,
              style: const TextStyle(
                fontFamily: 'Urbanist',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A1A),
              ),
            ),
          ),
          if (isFinal)
            Text(
              '$s1 - $s2',
              style: const TextStyle(
                fontFamily: 'Urbanist',
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1A1A1A),
              ),
            )
          else
            Text(
              status,
              style: const TextStyle(
                fontFamily: 'Urbanist',
                fontSize: 12,
                color: Color(0xFF888888),
              ),
            ),
          Expanded(
            child: Text(
              team2,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontFamily: 'Urbanist',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A1A),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
