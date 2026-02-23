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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildHeader(context),
          _buildStudentInfo(),
          _buildQuarterTabs(),
          _buildGWARow(),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.zero,
              itemCount: _subjects.length,
              separatorBuilder: (_, __) =>
                  const Divider(height: 1, color: Color(0xFFEEEEEE)),
              itemBuilder: (context, i) {
                final subject = _subjects[i];
                final grade = _currentGrades[i];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          subject['name'],
                          style: const TextStyle(
                            fontFamily: 'Urbanist',
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                      ),
                      Text(
                        '$grade',
                        style: TextStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: _gradeColor(grade),
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
      height: 80, // Updated header height
      color: const Color(0xFFF5F5F5),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(4, 8, 16, 12),
          child: Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.arrow_back,
                  color: Color(0xFF1A1A1A),
                  size: 22,
                ),
              ),
              const SizedBox(width: 4),
              const Expanded(
                child: Text(
                  'GRADES',
                  style: TextStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 22, // Updated font size
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
    final initials =
        widget.student['name'].toString().split(' ').first[0] +
        widget.student['name'].toString().split(' ').last[0];
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
            child: Center(
              child: Text(
                initials,
                style: const TextStyle(
                  fontFamily: 'Urbanist',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF555555),
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
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${widget.student['id']} · ${widget.section['name']}',
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

  int _selectedYear = 0; // 0=This Year, 1=Last Year, 2=Last 2 Year
  final List<String> _yearLabels = ['This Year', 'Last Year', 'Last 2 Year'];

  Widget _buildQuarterTabs() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // Scrollable Year Header
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(3, (index) {
                final isActive = _selectedYear == index;
                return GestureDetector(
                  onTap: () => setState(() => _selectedYear = index),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
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
                      _yearLabels[index],
                      style: TextStyle(
                        fontFamily: 'Urbanist',
                        fontSize: 14,
                        fontWeight: isActive
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: isActive
                            ? const Color(0xFF1A1A1A)
                            : const Color(0xFF888888),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          // Q1-Q4 Tabs
          Row(
            children: List.generate(4, (i) {
              final isActive = _selectedQuarter == i + 1;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedQuarter = i + 1),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          'Q${i + 1}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Urbanist',
                            fontSize: 14,
                            fontWeight: isActive
                                ? FontWeight.w700
                                : FontWeight.w400,
                            color: isActive
                                ? const Color(0xFF1A1A1A)
                                : const Color(0xFF888888),
                          ),
                        ),
                      ),
                      Container(
                        height: 3,
                        color: isActive
                            ? const Color(0xFFD4A017)
                            : Colors.transparent,
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildGWARow() {
    return Container(
      color: const Color(0xFFF5F5F5),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Link Image
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Color(0xFFE8E8E8),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.link, size: 20, color: Color(0xFF888888)),
          ),
          const SizedBox(width: 12),
          // Period and Remarks
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'June - August',
                  style: const TextStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Good',
                  style: TextStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 12,
                    color: _gradeColor(_gwa.round()),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          // GWA
          Row(
            children: [
              const Text(
                'GWA',
                style: TextStyle(
                  fontFamily: 'Urbanist',
                  fontSize: 13,
                  color: Color(0xFF888888),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _gwa.toStringAsFixed(2),
                style: const TextStyle(
                  fontFamily: 'Urbanist',
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          // Rank
          Text(
            'Rank #${widget.student['rank']}',
            style: const TextStyle(
              fontFamily: 'Urbanist',
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A1A),
            ),
          ),
        ],
      ),
    );
  }
}
