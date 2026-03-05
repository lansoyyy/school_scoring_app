import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:school_scoring_app/core/constants/app_constants.dart';

class StatItem {
  final int id;
  final String slink;
  final String name;
  final String section;
  final String grade;

  StatItem({
    required this.id,
    required this.slink,
    required this.name,
    required this.section,
    required this.grade,
  });

  factory StatItem.fromJson(Map<String, dynamic> json) {
    return StatItem(
      id: json['id'] as int,
      slink: json['slink'] as String,
      name: json['name'] as String,
      section: json['section'] as String,
      grade: json['grade'] as String,
    );
  }
}

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _subjects = [
    'ALL',
    'ENGLISH',
    'SCIENCE',
    'FILIPINO',
    'PE',
  ];

  Map<String, List<StatItem>> _data = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _subjects.length, vsync: this);
    _fetchStatistics();
  }

  Future<void> _fetchStatistics() async {
    try {
      final response = await http
          .get(Uri.parse('${AppConstants.apiBaseUrl}/statistics'))
          .timeout(
            const Duration(milliseconds: AppConstants.connectionTimeout),
          );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        Map<String, List<StatItem>> parsedData = {};

        for (var item in data) {
          if (item is List && item.length > 1) {
            // item[0] is subject map, item[1] onwards are grade arrays
            final subjectMap = item[0] as Map<String, dynamic>;
            final subject = subjectMap['subject'] as String;
            final stats = <StatItem>[];

            // Process each grade array
            for (var i = 1; i < item.length; i++) {
              if (item[i] is List) {
                final gradeArray = item[i] as List;
                // gradeArray[0] is grade map, gradeArray[1] onwards are stat objects
                for (var j = 1; j < gradeArray.length; j++) {
                  if (gradeArray[j] is Map) {
                    stats.add(StatItem.fromJson(gradeArray[j]));
                  }
                }
              }
            }

            parsedData[subject] = stats;
          }
        }

        setState(() {
          _data = parsedData;
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<StatItem> _listFor(String subject) => _data[subject] ?? [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildHeader(),
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              labelStyle: const TextStyle(
                fontFamily: 'Urbanist',
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
              unselectedLabelStyle: const TextStyle(
                fontFamily: 'Urbanist',
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              labelColor: const Color(0xFF1A1A1A),
              unselectedLabelColor: const Color(0xFF888888),
              indicatorColor: const Color(0xFFD4A017),
              indicatorWeight: 3,
              indicatorSize: TabBarIndicatorSize.label,
              tabs: _subjects.map((s) => Tab(text: s)).toList(),
            ),
          ),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFFD4A017)),
                  )
                : TabBarView(
                    controller: _tabController,
                    children: _subjects
                        .map((s) => _buildRankList(_listFor(s)))
                        .toList(),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      color: const Color(0xFFF5F5F5),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: const Text(
            'STATISTICS',
            style: TextStyle(
              fontFamily: 'Urbanist',
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1A1A),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRankList(List<StatItem> students) {
    // Group students by grade/level
    final groupedStudents = <String, List<StatItem>>{};
    for (var s in students) {
      final section = s.section;
      final gradeMatch = RegExp(r'(Grade \d+)').firstMatch(section);
      final grade = gradeMatch != null ? gradeMatch.group(1)! : 'Other';

      if (!groupedStudents.containsKey(grade)) {
        groupedStudents[grade] = [];
      }
      groupedStudents[grade]!.add(s);
    }

    final sortedGrades = groupedStudents.keys.toList()
      ..sort((a, b) {
        if (a == 'Other') return 1;
        if (b == 'Other') return -1;
        final numA = int.parse(a.split(' ')[1]);
        final numB = int.parse(b.split(' ')[1]);
        return numB.compareTo(numA); // Descending order (Grade 12 -> Grade 9)
      });

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: sortedGrades.length,
      itemBuilder: (context, i) {
        final grade = sortedGrades[i];
        final gradeStudents = groupedStudents[grade]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: const Color(0xFFF5F5F5),
              child: Text(
                grade,
                style: const TextStyle(
                  fontFamily: 'Urbanist',
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF555555),
                ),
              ),
            ),
            ...gradeStudents.asMap().entries.map((entry) {
              final index = entry.key;
              final s = entry.value;
              final rank = index + 1;

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 24,
                          child: Text(
                            '$rank',
                            style: const TextStyle(
                              fontFamily: 'Urbanist',
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1A1A1A),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          width: 44,
                          height: 44,
                          decoration: const BoxDecoration(
                            color: Color(0xFFE8E8E8),
                            shape: BoxShape.circle,
                          ),
                          child: ClipOval(
                            child: Image.network(
                              s.slink,
                              width: 44,
                              height: 44,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                  child: Text(
                                    s.name.split(' ').first[0] +
                                        s.name.split(' ').last[0],
                                    style: const TextStyle(
                                      fontFamily: 'Urbanist',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF555555),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                s.name,
                                style: const TextStyle(
                                  fontFamily: 'Urbanist',
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1A1A1A),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                s.section,
                                style: const TextStyle(
                                  fontFamily: 'Urbanist',
                                  fontSize: 12,
                                  color: Color(0xFF888888),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          s.grade,
                          style: const TextStyle(
                            fontFamily: 'Urbanist',
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }).toList(),
            if (i < sortedGrades.length - 1)
              const Divider(height: 1, color: Color(0xFFEEEEEE)),
          ],
        );
      },
    );
  }
}
