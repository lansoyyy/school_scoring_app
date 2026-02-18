import 'package:flutter/material.dart';

class GradesScreen extends StatefulWidget {
  final Map<String, dynamic> student;
  final Map<String, dynamic> section;

  const GradesScreen({super.key, required this.student, required this.section});

  @override
  State<GradesScreen> createState() => _GradesScreenState();
}

class _GradesScreenState extends State<GradesScreen> {
  int _selectedQuarter = 1;

  static const List<Map<String, dynamic>> _subjects = [
    {
      'name': 'Mathematics',
      'icon': Icons.calculate_outlined,
      'color': 0xFF4A90E2,
    },
    {'name': 'Science', 'icon': Icons.science_outlined, 'color': 0xFF50C878},
    {'name': 'English', 'icon': Icons.menu_book_outlined, 'color': 0xFFFF6B35},
    {'name': 'Filipino', 'icon': Icons.translate_outlined, 'color': 0xFFEF4444},
    {
      'name': 'Araling Panlipunan',
      'icon': Icons.public_outlined,
      'color': 0xFF7C3AED,
    },
    {'name': 'MAPEH', 'icon': Icons.sports_outlined, 'color': 0xFF00A896},
    {
      'name': 'Values Education',
      'icon': Icons.favorite_outline,
      'color': 0xFFEC4899,
    },
    {
      'name': 'Technology & Livelihood',
      'icon': Icons.handyman_outlined,
      'color': 0xFFF5A623,
    },
  ];

  static const List<List<int>> _gradesData = [
    [92, 88, 95, 90, 85, 91, 88, 87],
    [89, 90, 87, 92, 88, 93, 90, 85],
    [94, 91, 88, 86, 90, 87, 92, 89],
    [91, 93, 90, 88, 92, 89, 86, 91],
  ];

  List<int> get _currentGrades => _gradesData[_selectedQuarter - 1];

  double get _gwa {
    final grades = _currentGrades;
    return grades.reduce((a, b) => a + b) / grades.length;
  }

  String _gradeLabel(int grade) {
    if (grade >= 90) return 'Outstanding';
    if (grade >= 85) return 'Very Satisfactory';
    if (grade >= 80) return 'Satisfactory';
    if (grade >= 75) return 'Fairly Satisfactory';
    return 'Did Not Meet';
  }

  Color _gradeColor(int grade) {
    if (grade >= 90) return const Color(0xFF10B981);
    if (grade >= 85) return const Color(0xFF4A90E2);
    if (grade >= 80) return const Color(0xFFF59E0B);
    if (grade >= 75) return const Color(0xFFFF6B35);
    return const Color(0xFFEF4444);
  }

  Color _gradeBackColor(int grade) {
    if (grade >= 90) return const Color(0xFFD1FAE5);
    if (grade >= 85) return const Color(0xFFDBEAFE);
    if (grade >= 80) return const Color(0xFFFEF3C7);
    if (grade >= 75) return const Color(0xFFFFEDD5);
    return const Color(0xFFFEE2E2);
  }

  @override
  Widget build(BuildContext context) {
    final sectionColor = Color(widget.section['color'] as int);
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          _buildHeader(context, sectionColor),
          _buildQuarterTabs(),
          _buildGWACard(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              itemCount: _subjects.length,
              itemBuilder: (context, i) {
                final subject = _subjects[i];
                final grade = _currentGrades[i];
                return _GradeCard(
                  subject: subject,
                  grade: grade,
                  gradeLabel: _gradeLabel(grade),
                  gradeColor: _gradeColor(grade),
                  gradeBackColor: _gradeBackColor(grade),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Color color) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color(0xFF0D2137), color.withOpacity(0.9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 20, 20),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const Text(
                    'Student Grades',
                    style: TextStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const SizedBox(width: 20),
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        widget.student['name'].toString().split(' ').first[0] +
                            widget.student['name']
                                .toString()
                                .split(' ')
                                .last[0],
                        style: const TextStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
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
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'ID: ${widget.student['id']}  •  ${widget.section['name']}',
                          style: const TextStyle(
                            fontFamily: 'Urbanist',
                            fontSize: 12,
                            color: Colors.white70,
                          ),
                        ),
                      ],
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

  Widget _buildQuarterTabs() {
    return Container(
      color: const Color(0xFF1A3F6F),
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
      child: Row(
        children: List.generate(4, (i) {
          final isActive = _selectedQuarter == i + 1;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedQuarter = i + 1),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isActive
                      ? Colors.white
                      : Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Q${i + 1}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: isActive ? const Color(0xFF1A3F6F) : Colors.white70,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildGWACard() {
    final gwa = _gwa;
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _gradeColor(gwa.round()),
            _gradeColor(gwa.round()).withOpacity(0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: _gradeColor(gwa.round()).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'General Weighted Average',
                style: TextStyle(
                  fontFamily: 'Urbanist',
                  fontSize: 12,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                gwa.toStringAsFixed(2),
                style: const TextStyle(
                  fontFamily: 'Urbanist',
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              Text(
                _gradeLabel(gwa.round()),
                style: const TextStyle(
                  fontFamily: 'Urbanist',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'Class Rank',
                style: TextStyle(
                  fontFamily: 'Urbanist',
                  fontSize: 12,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '#${widget.student['rank']}',
                style: const TextStyle(
                  fontFamily: 'Urbanist',
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              Text(
                'Quarter ${_selectedQuarter}',
                style: const TextStyle(
                  fontFamily: 'Urbanist',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GradeCard extends StatelessWidget {
  final Map<String, dynamic> subject;
  final int grade;
  final String gradeLabel;
  final Color gradeColor;
  final Color gradeBackColor;

  const _GradeCard({
    required this.subject,
    required this.grade,
    required this.gradeLabel,
    required this.gradeColor,
    required this.gradeBackColor,
  });

  @override
  Widget build(BuildContext context) {
    final subjectColor = Color(subject['color'] as int);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: subjectColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              subject['icon'] as IconData,
              color: subjectColor,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subject['name'],
                  style: const TextStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: grade / 100,
                    backgroundColor: const Color(0xFFE5E7EB),
                    valueColor: AlwaysStoppedAnimation<Color>(gradeColor),
                    minHeight: 5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$grade',
                style: TextStyle(
                  fontFamily: 'Urbanist',
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: gradeColor,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: gradeBackColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  gradeLabel,
                  style: TextStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: gradeColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
