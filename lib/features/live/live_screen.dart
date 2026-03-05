import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:school_scoring_app/core/constants/app_constants.dart';
import 'package:url_launcher/url_launcher.dart';

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

class LiveGameItem {
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

  LiveGameItem({
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

  factory LiveGameItem.fromJson(Map<String, dynamic> json) {
    return LiveGameItem(
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

class LiveScreen extends StatefulWidget {
  const LiveScreen({super.key});

  @override
  State<LiveScreen> createState() => _LiveScreenState();
}

class _LiveScreenState extends State<LiveScreen> {
  List<LiveGameItem> _liveGames = [];
  bool _isLoadingGames = true;

  @override
  void initState() {
    super.initState();
    _fetchLiveGames();
  }

  Future<void> _fetchLiveGames() async {
    try {
      final response = await http
          .get(Uri.parse('${AppConstants.apiBaseUrl}/live'))
          .timeout(
            const Duration(milliseconds: AppConstants.connectionTimeout),
          );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _liveGames = data.map((item) => LiveGameItem.fromJson(item)).toList();
          _isLoadingGames = false;
        });
      } else {
        setState(() => _isLoadingGames = false);
      }
    } catch (e) {
      setState(() => _isLoadingGames = false);
    }
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
            child: _isLoadingGames
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFFD4A017)),
                  )
                : _liveGames.isEmpty
                ? _buildEmpty()
                : ListView.separated(
                    padding: EdgeInsets.zero,
                    itemCount: _liveGames.length,
                    separatorBuilder: (_, __) =>
                        const Divider(height: 1, color: Color(0xFFEEEEEE)),
                    itemBuilder: (context, i) =>
                        _ScheduleCard(game: _liveGames[i]),
                  ),
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
          Icon(Icons.sports_outlined, size: 56, color: Colors.grey[300]),
          const SizedBox(height: 12),
          Text(
            'No live games',
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
}

class _ScheduleCard extends StatelessWidget {
  final LiveGameItem game;
  const _ScheduleCard({required this.game});

  @override
  Widget build(BuildContext context) {
    final isLive = game.gameStatus == 'live';

    // Live game layout
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Teams and Scores
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Team 1
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: const BoxDecoration(
                            color: Color(0xFFF5F5F5),
                            shape: BoxShape.circle,
                          ),
                          child: ClipOval(
                            child: Image.network(
                              game.team1Pic,
                              width: 64,
                              height: 64,
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
                    width: 110,
                    child: Column(
                      children: [
                        const SizedBox(height: 12),
                        if (isLive)
                          Column(
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
                              const SizedBox(height: 14),
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
                          width: 64,
                          height: 64,
                          decoration: const BoxDecoration(
                            color: Color(0xFFF5F5F5),
                            shape: BoxShape.circle,
                          ),
                          child: ClipOval(
                            child: Image.network(
                              game.team2Pic,
                              width: 64,
                              height: 64,
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
                        if (isLive) ...[
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
