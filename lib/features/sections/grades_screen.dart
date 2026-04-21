import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';

class PerformanceSubject {
  const PerformanceSubject({required this.name, required this.grade});

  final String name;
  final double grade;
}

class StudentPerformanceInfo {
  const StudentPerformanceInfo({
    required this.firstName,
    required this.lastName,
    required this.section,
    required this.picture,
  });

  final String firstName;
  final String lastName;
  final String section;
  final String picture;

  String get fullName {
    final parts = <String>[
      firstName.trim(),
      lastName.trim(),
    ].where((part) => part.isNotEmpty).toList();
    return parts.join(' ');
  }
}

class QuarterPerformance {
  const QuarterPerformance({
    required this.name,
    required this.subjects,
    required this.rating,
    required this.quarterTime,
    required this.sectionImage,
  });

  final String name;
  final List<PerformanceSubject> subjects;
  final String rating;
  final String quarterTime;
  final String sectionImage;

  double get gwa {
    if (subjects.isEmpty) {
      return 0;
    }

    final total = subjects.fold<double>(
      0,
      (sum, subject) => sum + subject.grade,
    );
    return total / subjects.length;
  }
}

class GradesScreen extends StatefulWidget {
  const GradesScreen({super.key, required this.student, required this.section});

  final Map<String, dynamic> student;
  final Map<String, dynamic> section;

  @override
  State<GradesScreen> createState() => _GradesScreenState();
}

class _GradesScreenState extends State<GradesScreen> {
  int _selectedQuarter = 0;
  List<QuarterPerformance> _quarters = const <QuarterPerformance>[];
  StudentPerformanceInfo? _studentInfo;
  bool _isLoadingGrades = true;
  String? _errorMessage;

  QuarterPerformance? get _selectedPerformance {
    if (_quarters.isEmpty || _selectedQuarter >= _quarters.length) {
      return null;
    }

    return _quarters[_selectedQuarter];
  }

  @override
  void initState() {
    super.initState();
    _fetchGrades();
  }

  Future<void> _fetchGrades() async {
    final studentId = widget.student['id']?.toString().trim() ?? '';
    if (studentId.isEmpty) {
      setState(() {
        _isLoadingGrades = false;
        _errorMessage = 'Student information is missing.';
      });
      return;
    }

    try {
      final response = await http
          .get(
            Uri.parse('${AppConstants.apiBaseUrl}/grade').replace(
              queryParameters: <String, String>{'studentId': studentId},
            ),
          )
          .timeout(
            const Duration(milliseconds: AppConstants.connectionTimeout),
          );

      if (response.statusCode != 200) {
        setState(() {
          _isLoadingGrades = false;
          _errorMessage = 'Unable to load performance details.';
        });
        return;
      }

      final decoded = json.decode(response.body);
      final payload = decoded is Map<String, dynamic>
          ? decoded
          : Map<String, dynamic>.from(decoded as Map);
      final quarters = _parseQuarters(payload['student_quarters']);

      setState(() {
        _studentInfo = _parseStudentInfo(payload['student_info']);
        _quarters = quarters;
        _selectedQuarter = 0;
        _isLoadingGrades = false;
        _errorMessage = quarters.isEmpty
            ? 'No performance data available.'
            : null;
      });
    } catch (_) {
      setState(() {
        _isLoadingGrades = false;
        _errorMessage = 'Unable to load performance details.';
      });
    }
  }

  StudentPerformanceInfo? _parseStudentInfo(dynamic rawStudentInfo) {
    if (rawStudentInfo is! List || rawStudentInfo.isEmpty) {
      return null;
    }

    final firstItem = rawStudentInfo.first;
    if (firstItem is! Map) {
      return null;
    }

    final student = Map<String, dynamic>.from(firstItem);
    return StudentPerformanceInfo(
      firstName: _formatPersonName(student['first_name']?.toString() ?? ''),
      lastName: _formatPersonName(student['last_name']?.toString() ?? ''),
      section: student['section']?.toString().trim() ?? '',
      picture: student['picture']?.toString().trim() ?? '',
    );
  }

  List<QuarterPerformance> _parseQuarters(dynamic rawQuarters) {
    if (rawQuarters is! List) {
      return const <QuarterPerformance>[];
    }

    final quarters = <QuarterPerformance>[];
    for (final quarterEntry in rawQuarters) {
      if (quarterEntry is! Map) {
        continue;
      }

      final quarterMap = Map<String, dynamic>.from(quarterEntry);
      final quarterName = quarterMap['name']?.toString().trim() ?? '';
      if (quarterName.isEmpty) {
        continue;
      }

      final subjectIndexes =
          quarterMap.keys
              .map((key) => RegExp(r'^subject_(\d+)$').firstMatch(key))
              .whereType<RegExpMatch>()
              .map((match) => int.tryParse(match.group(1) ?? ''))
              .whereType<int>()
              .toList()
            ..sort();

      final subjects = <PerformanceSubject>[];
      for (final index in subjectIndexes) {
        final rawSubject =
            quarterMap['subject_$index']?.toString().trim() ?? '';
        if (rawSubject.isEmpty) {
          continue;
        }

        subjects.add(
          PerformanceSubject(
            name: _formatSubjectName(rawSubject),
            grade: _parseGradeValue(quarterMap['grade_$index']),
          ),
        );
      }

      quarters.add(
        QuarterPerformance(
          name: quarterName,
          subjects: subjects,
          rating: quarterMap['rating']?.toString().trim() ?? '',
          quarterTime: _formatQuarterTime(
            quarterMap['quarter_time']?.toString() ?? '',
          ),
          sectionImage: quarterMap['section_img']?.toString().trim() ?? '',
        ),
      );
    }

    return quarters;
  }

  double _parseGradeValue(dynamic rawValue) {
    if (rawValue == null) {
      return 0;
    }

    return double.tryParse(rawValue.toString().trim()) ?? 0;
  }

  String _formatPersonName(String rawValue) {
    final trimmed = rawValue.trim();
    if (trimmed.isEmpty) {
      return '';
    }

    return trimmed.split(RegExp(r'\s+')).map(_capitalizeWord).join(' ');
  }

  String _formatSubjectName(String rawValue) {
    final trimmed = rawValue.trim();
    if (trimmed.isEmpty) {
      return '';
    }

    return trimmed
        .split(RegExp(r'\s+'))
        .map((word) {
          final normalized = word.trim();
          if (normalized.isEmpty) {
            return normalized;
          }

          if (normalized.length <= 3) {
            return normalized;
          }

          return normalized;
        })
        .join(' ');
  }

  String _formatQuarterTime(String rawValue) {
    final trimmed = rawValue.trim();
    if (trimmed.isEmpty) {
      return 'No period available';
    }

    final parts = trimmed.split('-');
    if (parts.length != 2) {
      return _formatPersonName(trimmed);
    }

    return '${_capitalizeWord(parts[0].trim())} - ${_capitalizeWord(parts[1].trim())}';
  }

  String _capitalizeWord(String value) {
    if (value.isEmpty) {
      return value;
    }

    return value[0].toUpperCase() + value.substring(1).toLowerCase();
  }

  String _buildInitials(String value) {
    final parts = value
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();

    if (parts.isEmpty) {
      return 'NA';
    }
    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }

    return '${parts.first.substring(0, 1)}${parts.last.substring(0, 1)}'
        .toUpperCase();
  }

  String _formatGrade(double grade) {
    if (grade == grade.roundToDouble()) {
      return grade.toInt().toString();
    }

    return grade.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    final selectedPerformance = _selectedPerformance;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildHeader(context),
          _buildStudentInfo(),
          _buildQuarterTabs(),
          _buildSummaryCard(selectedPerformance),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          Expanded(
            child: _isLoadingGrades
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  )
                : _errorMessage != null
                ? _buildStateMessage(_errorMessage!)
                : selectedPerformance == null ||
                      selectedPerformance.subjects.isEmpty
                ? _buildStateMessage('No subject grades available.')
                : ListView.separated(
                    padding: EdgeInsets.zero,
                    itemCount: selectedPerformance.subjects.length,
                    separatorBuilder: (_, __) =>
                        const Divider(height: 1, color: Color(0xFFEEEEEE)),
                    itemBuilder: (context, index) {
                      final subject = selectedPerformance.subjects[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                subject.name,
                                style: const TextStyle(
                                  fontFamily: 'Urbanist',
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF1A1A1A),
                                ),
                              ),
                            ),
                            Text(
                              _formatGrade(subject.grade),
                              style: TextStyle(
                                fontFamily: 'Urbanist',
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F5F5),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
          child: Row(
            children: [
              SizedBox(
                width: 45,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Color(0xFF1A1A1A),
                    size: 22,
                  ),
                ),
              ),

              const Expanded(
                child: Text(
                  'PERFORMANCE',
                  style: TextStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStudentInfo() {
    final studentName = _studentInfo?.fullName.trim().isNotEmpty == true
        ? _studentInfo!.fullName.trim()
        : (widget.student['name']?.toString().trim().isNotEmpty ?? false)
        ? widget.student['name'].toString().trim()
        : 'Student';
    final sectionName = _studentInfo?.section.trim().isNotEmpty == true
        ? _studentInfo!.section.trim()
        : widget.section['name']?.toString().trim() ?? '';
    final imageUrl = _studentInfo?.picture.trim().isNotEmpty == true
        ? _studentInfo!.picture.trim()
        : widget.student['slink']?.toString().trim() ?? '';
    final initials = _buildInitials(studentName);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: Color(0xFFE8E8E8),
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: imageUrl.isEmpty
                  ? Center(
                      child: Text(
                        initials,
                        style: const TextStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF555555),
                        ),
                      ),
                    )
                  : Image.network(
                      imageUrl,
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Text(
                            initials,
                            style: const TextStyle(
                              fontFamily: 'Urbanist',
                              fontSize: 16,
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
                  widget.student['name'],
                  style: const TextStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  sectionName,
                  style: const TextStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 12,
                    color: Color(0xFF888888),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuarterTabs() {
    if (_quarters.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      color: Colors.white,
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: _quarters.length,
        itemBuilder: (context, index) {
          final isActive = _selectedQuarter == index;
          return GestureDetector(
            onTap: () => setState(() => _selectedQuarter = index),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isActive
                        ? const Color(0xFFD4A017)
                        : Colors.transparent,
                    width: 3,
                  ),
                ),
              ),
              child: Text(
                _quarters[index].name,
                style: TextStyle(
                  fontFamily: 'Urbanist',
                  fontSize: 14,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                  color: isActive
                      ? const Color(0xFF1A1A1A)
                      : const Color(0xFF888888),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryCard(QuarterPerformance? performance) {
    if (performance == null) {
      return const SizedBox.shrink();
    }

    return Container(
      color: const Color(0xFFF5F5F5),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: Color(0xFFE8E8E8),
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: performance.sectionImage.isEmpty
                  ? const Icon(Icons.image_outlined, color: Color(0xFF888888))
                  : Image.network(
                      performance.sectionImage,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.image_outlined,
                          color: Color(0xFF888888),
                        );
                      },
                    ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  performance.quarterTime,
                  style: const TextStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  performance.rating.isEmpty
                      ? 'No rating available'
                      : performance.rating,
                  style: TextStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 12,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStateMessage(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'Urbanist',
            fontSize: 15,
            color: Color(0xFF6B7280),
          ),
        ),
      ),
    );
  }
}
