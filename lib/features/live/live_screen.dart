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
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  children: [
                    const Icon(
                      Icons.sports_basketball,
                      size: 48,
                      color: Color(0xFFCC0000),
                    ),
                    const SizedBox(height: 8),
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
                  ],
                ),
              ),
              Text(
                '$_score1',
                style: const TextStyle(
                  fontFamily: 'Urbanist',
                  fontSize: 64,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  '-',
                  style: TextStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 48,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFFCCCCCC),
                  ),
                ),
              ),
              Text(
                '$_score2',
                style: const TextStyle(
                  fontFamily: 'Urbanist',
                  fontSize: 64,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    const Icon(
                      Icons.sports_basketball,
                      size: 48,
                      color: Color(0xFF1A65CC),
                    ),
                    const SizedBox(height: 8),
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
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(32),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.play_circle_outline,
                  size: 24,
                  color: Color(0xFFCC0000),
                ),
                const SizedBox(width: 8),
                Text(
                  timer,
                  style: const TextStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 4,
                  height: 4,
                  decoration: const BoxDecoration(
                    color: Color(0xFFCCCCCC),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  '2nd Quarter',
                  style: TextStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF555555),
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
