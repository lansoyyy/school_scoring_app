import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:school_scoring_app/core/constants/app_constants.dart';
import 'package:intl/intl.dart';
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
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      glink: json['glink']?.toString() ?? '',
      eventPlace: json['event_place']?.toString() ?? '',
      gameDate: json['game_date']?.toString() ?? '',
      gameTime: json['game_time']?.toString() ?? '',
      team1: json['team1']?.toString() ?? '',
      team2: json['team2']?.toString() ?? '',
      team1Score: json['team1_score']?.toString() ?? '',
      team2Score: json['team2_score']?.toString() ?? '',
      timeRem: json['time_rem']?.toString() ?? '',
      gameQtr: json['game_qtr']?.toString() ?? '',
      team1Pic: json['team1_pic']?.toString() ?? '',
      team2Pic: json['team2_pic']?.toString() ?? '',
      gameStatus: json['game_status']?.toString() ?? '',
    );
  }
}

class SportsScreen extends StatefulWidget {
  const SportsScreen({super.key});

  @override
  State<SportsScreen> createState() => _SportsScreenState();
}

class _SportsScreenState extends State<SportsScreen> {
  final DateFormat _apiDateFormat = DateFormat('MM-dd-yyyy');
  final DateFormat _monthLabelFormat = DateFormat('MMMM yyyy');
  final Map<String, GlobalKey> _calendarDayKeys = <String, GlobalKey>{};
  DateTime _displayedMonth = DateTime(
    DateTime.now().year,
    DateTime.now().month,
  );
  DateTime? _selectedDate = DateUtils.dateOnly(DateTime.now());
  List<GameItem> _allGames = [];
  bool _isLoadingGames = true;
  String? _gamesError;

  List<GameItem> get _visibleEvents {
    return _allGames;
  }

  List<DateTime> get _monthDays {
    final totalDays = DateUtils.getDaysInMonth(
      _displayedMonth.year,
      _displayedMonth.month,
    );

    return List.generate(
      totalDays,
      (index) =>
          DateTime(_displayedMonth.year, _displayedMonth.month, index + 1),
    );
  }

  @override
  void initState() {
    super.initState();
    _scheduleSelectedDateVisibility(duration: Duration.zero);
    _fetchGames(date: DateUtils.dateOnly(DateTime.now()));
  }

  Future<void> _fetchGames({DateTime? date}) async {
    setState(() {
      _isLoadingGames = true;
      _gamesError = null;
    });

    try {
      final uri = Uri.parse('${AppConstants.apiBaseUrl}/game').replace(
        queryParameters: date == null ? null : {'date': _formatApiDate(date)},
      );

      final response = await http
          .get(uri)
          .timeout(
            const Duration(milliseconds: AppConstants.connectionTimeout),
          );

      if (!mounted) return;

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final games = data
            .whereType<Map>()
            .map((item) => GameItem.fromJson(Map<String, dynamic>.from(item)))
            .toList();
        final resolvedDate = date ?? _resolveInitialDate(games);

        setState(() {
          _allGames = games;
          _isLoadingGames = false;
          _selectedDate = resolvedDate;
          _displayedMonth = DateTime(resolvedDate.year, resolvedDate.month);
        });
        _scheduleSelectedDateVisibility();
      } else {
        setState(() {
          _isLoadingGames = false;
          _gamesError = 'Unable to load games right now.';
        });
      }
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoadingGames = false;
        _gamesError = 'Unable to load games right now.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final events = _visibleEvents;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildHeader(),
          _buildMonthCalendar(),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          Expanded(
            child: _isLoadingGames
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFFD4A017)),
                  )
                : _gamesError != null
                ? _buildErrorState()
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
      height: 100,
      color: const Color(0xFFF5F5F5),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              const Text(
                'GAMES',
                style: TextStyle(
                  fontFamily: 'Urbanist',
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const Spacer(),
              InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: _openMonthPicker,
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 18,
                      color: Color(0xFF1A1A1A),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _monthLabelFormat.format(_displayedMonth),
                      style: const TextStyle(
                        fontFamily: 'Urbanist',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A1A),
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

  Widget _buildMonthCalendar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: List.generate(_monthDays.length, (index) {
            final day = _monthDays[index];
            final isSelected =
                _selectedDate != null &&
                DateUtils.isSameDay(_selectedDate, day);

            return GestureDetector(
              onTap: () => _fetchGames(date: day),
              child: Container(
                key: _calendarKeyForDate(day),
                margin: EdgeInsets.only(
                  right: index < _monthDays.length - 1 ? 16 : 0,
                ),
                child: Column(
                  children: [
                    Text(
                      DateFormat('E').format(day).substring(0, 1),
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
                          '${day.day}',
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

  Future<void> _openMonthPicker() async {
    final pickedMonth = await showDialog<DateTime>(
      context: context,
      builder: (context) => _MonthPickerDialog(initialMonth: _displayedMonth),
    );

    if (pickedMonth == null) {
      return;
    }

    final previousSelection = _selectedDate ?? DateTime.now();
    final maxDay = DateUtils.getDaysInMonth(
      pickedMonth.year,
      pickedMonth.month,
    );
    final nextDay = previousSelection.day > maxDay
        ? maxDay
        : previousSelection.day;
    final nextDate = DateTime(pickedMonth.year, pickedMonth.month, nextDay);

    await _fetchGames(date: nextDate);
  }

  DateTime _resolveInitialDate(List<GameItem> games) {
    final today = DateUtils.dateOnly(DateTime.now());
    final todayKey = _formatApiDate(today);

    if (games.any((game) => game.gameDate == todayKey)) {
      return today;
    }

    for (final game in games) {
      final parsedDate = _tryParseApiDate(game.gameDate);
      if (parsedDate != null) {
        return parsedDate;
      }
    }

    return today;
  }

  void _scheduleSelectedDateVisibility({
    Duration duration = const Duration(milliseconds: 250),
  }) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _selectedDate == null) {
        return;
      }

      final selectedContext =
          _calendarDayKeys[_calendarDateKey(_selectedDate!)]?.currentContext;
      if (selectedContext == null) {
        return;
      }

      Scrollable.ensureVisible(
        selectedContext,
        alignment: 0.5,
        duration: duration,
        curve: duration == Duration.zero ? Curves.linear : Curves.easeOutCubic,
      );
    });
  }

  GlobalKey _calendarKeyForDate(DateTime date) {
    return _calendarDayKeys.putIfAbsent(
      _calendarDateKey(date),
      () => GlobalKey(),
    );
  }

  String _calendarDateKey(DateTime date) {
    return '${date.year}-${date.month}-${date.day}';
  }

  String _formatApiDate(DateTime date) => _apiDateFormat.format(date);

  DateTime? _tryParseApiDate(String value) {
    try {
      return _apiDateFormat.parseStrict(value);
    } catch (_) {
      return null;
    }
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cloud_off_outlined, size: 56, color: Colors.grey[300]),
            const SizedBox(height: 12),
            Text(
              _gamesError ?? 'Unable to load games right now.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Urbanist',
                fontSize: 15,
                color: Colors.grey[500],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _fetchGames(date: _selectedDate),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A1A1A),
                foregroundColor: Colors.white,
              ),
              child: const Text(
                'Try Again',
                style: TextStyle(fontFamily: 'Urbanist'),
              ),
            ),
          ],
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
            _selectedDate == null
                ? 'No games available'
                : 'No games scheduled for ${_formatApiDate(_selectedDate!)}',
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

class _MonthPickerDialog extends StatefulWidget {
  final DateTime initialMonth;

  const _MonthPickerDialog({required this.initialMonth});

  @override
  State<_MonthPickerDialog> createState() => _MonthPickerDialogState();
}

class _MonthPickerDialogState extends State<_MonthPickerDialog> {
  static const List<String> _monthNames = <String>[
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  late int _visibleYear;

  @override
  void initState() {
    super.initState();
    _visibleYear = widget.initialMonth.year;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Text(
                  'Select Month',
                  style: TextStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => setState(() => _visibleYear--),
                  icon: const Icon(Icons.chevron_left),
                ),
                Text(
                  '$_visibleYear',
                  style: const TextStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                IconButton(
                  onPressed: () => setState(() => _visibleYear++),
                  icon: const Icon(Icons.chevron_right),
                ),
              ],
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _monthNames.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 2.3,
              ),
              itemBuilder: (context, index) {
                final monthNumber = index + 1;
                final isSelected =
                    _visibleYear == widget.initialMonth.year &&
                    monthNumber == widget.initialMonth.month;

                return InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () => Navigator.pop(
                    context,
                    DateTime(_visibleYear, monthNumber),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF1A1A1A)
                          : const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      _monthNames[index],
                      style: TextStyle(
                        fontFamily: 'Urbanist',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? Colors.white
                            : const Color(0xFF1A1A1A),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    fontFamily: 'Urbanist',
                    color: Color(0xFF666666),
                  ),
                ),
              ),
            ),
          ],
        ),
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
