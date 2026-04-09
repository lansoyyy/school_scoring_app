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
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      slink: json['slink']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      section: json['section']?.toString() ?? '',
      grade: json['grade']?.toString() ?? '',
    );
  }
}

class StatGradeGroup {
  final String header;
  final List<StatItem> students;

  const StatGradeGroup({required this.header, required this.students});
}

class SubjectStatistics {
  final String subject;
  final List<StatGradeGroup> gradeGroups;

  const SubjectStatistics({required this.subject, required this.gradeGroups});
}

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  List<SubjectStatistics> _subjects = const <SubjectStatistics>[];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchStatistics();
  }

  Future<void> _fetchStatistics() async {
    try {
      final response = await http
          .get(Uri.parse('${AppConstants.apiBaseUrl}/statistics'))
          .timeout(
            const Duration(milliseconds: AppConstants.connectionTimeout),
          );

      if (!mounted) {
        return;
      }

      if (response.statusCode == 200) {
        final dynamic decodedBody = json.decode(response.body);
        final subjects = _parseSubjects(decodedBody);

        setState(() {
          _subjects = subjects;
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() => _isLoading = false);
    }
  }

  List<SubjectStatistics> _parseSubjects(dynamic decodedBody) {
    if (decodedBody is! List) {
      return const <SubjectStatistics>[];
    }

    final subjects = <SubjectStatistics>[];

    for (final item in decodedBody) {
      if (item is! List || item.isEmpty) {
        continue;
      }

      final header = item.first;
      if (header is! Map) {
        continue;
      }

      final headerMap = Map<String, dynamic>.from(header);
      final subject = _extractHeaderValue(headerMap, preferredKey: 'subject');
      if (subject.isEmpty) {
        continue;
      }

      final gradeGroups = <StatGradeGroup>[];

      for (final group in item.skip(1)) {
        if (group is! List || group.isEmpty) {
          continue;
        }

        final gradeHeader = group.first;
        if (gradeHeader is! Map) {
          continue;
        }

        final gradeHeaderMap = Map<String, dynamic>.from(gradeHeader);
        final gradeLabel = _extractHeaderValue(
          gradeHeaderMap,
          preferredKey: 'grade',
        );
        if (gradeLabel.isEmpty) {
          continue;
        }

        final students = group
            .skip(1)
            .whereType<Map>()
            .map(
              (student) =>
                  StatItem.fromJson(Map<String, dynamic>.from(student)),
            )
            .toList();

        gradeGroups.add(StatGradeGroup(header: gradeLabel, students: students));
      }

      subjects.add(
        SubjectStatistics(subject: subject, gradeGroups: gradeGroups),
      );
    }

    return subjects;
  }

  String _extractHeaderValue(
    Map<String, dynamic> data, {
    required String preferredKey,
  }) {
    final preferredValue = data[preferredKey]?.toString().trim() ?? '';
    if (preferredValue.isNotEmpty) {
      return preferredValue;
    }

    for (final value in data.values) {
      final text = value?.toString().trim() ?? '';
      if (text.isNotEmpty) {
        return text;
      }
    }

    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFFD4A017)),
      );
    }

    if (_subjects.isEmpty) {
      return _buildEmptyState('No statistics found');
    }

    return DefaultTabController(
      key: ValueKey(_subjects.map((subject) => subject.subject).join('|')),
      length: _subjects.length,
      child: Column(
        children: [
          Container(
            color: Colors.white,
            child: TabBar(
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
              tabs: _subjects
                  .map((subject) => Tab(text: subject.subject))
                  .toList(),
            ),
          ),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          Expanded(
            child: TabBarView(
              children: _subjects
                  .map((subject) => _buildRankList(subject.gradeGroups))
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

  Widget _buildRankList(List<StatGradeGroup> gradeGroups) {
    if (gradeGroups.isEmpty) {
      return _buildEmptyState('No statistics found');
    }

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: gradeGroups.length,
      itemBuilder: (context, i) {
        final gradeGroup = gradeGroups[i];
        final gradeStudents = gradeGroup.students;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: const Color(0xFFF5F5F5),
              child: Text(
                gradeGroup.header,
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
                                    _initialsFor(s.name),
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
            }),
            if (i < gradeGroups.length - 1)
              const Divider(height: 1, color: Color(0xFFEEEEEE)),
          ],
        );
      },
    );
  }

  String _initialsFor(String name) {
    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();

    if (parts.isEmpty) {
      return '?';
    }

    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }

    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.bar_chart_outlined, size: 56, color: Colors.grey[300]),
          const SizedBox(height: 12),
          Text(
            message,
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
