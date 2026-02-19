import 'package:flutter/material.dart';
import 'grades_screen.dart';

class StudentsScreen extends StatefulWidget {
  final Map<String, dynamic> section;

  const StudentsScreen({super.key, required this.section});

  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  final _searchCtrl = TextEditingController();
  String _searchQuery = '';

  static const List<Map<String, dynamic>> _allStudents = [
    {'id': '2024-001', 'name': 'Andrei Santos', 'gender': 'M', 'rank': 1},
    {'id': '2024-002', 'name': 'Bianca Reyes', 'gender': 'F', 'rank': 2},
    {'id': '2024-003', 'name': 'Carlo Mendoza', 'gender': 'M', 'rank': 3},
    {'id': '2024-004', 'name': 'Diana Cruz', 'gender': 'F', 'rank': 4},
    {'id': '2024-005', 'name': 'Eduardo Bautista', 'gender': 'M', 'rank': 5},
    {'id': '2024-006', 'name': 'Felicia Torres', 'gender': 'F', 'rank': 6},
    {'id': '2024-007', 'name': 'Gerald Villanueva', 'gender': 'M', 'rank': 7},
    {'id': '2024-008', 'name': 'Hannah Lopez', 'gender': 'F', 'rank': 8},
    {'id': '2024-009', 'name': 'Ivan Garcia', 'gender': 'M', 'rank': 9},
    {'id': '2024-010', 'name': 'Jasmine Ramos', 'gender': 'F', 'rank': 10},
    {'id': '2024-011', 'name': 'Kevin Flores', 'gender': 'M', 'rank': 11},
    {'id': '2024-012', 'name': 'Lara Aguilar', 'gender': 'F', 'rank': 12},
    {'id': '2024-013', 'name': 'Marco Navarro', 'gender': 'M', 'rank': 13},
    {'id': '2024-014', 'name': 'Nikki Castillo', 'gender': 'F', 'rank': 14},
    {'id': '2024-015', 'name': 'Oscar Morales', 'gender': 'M', 'rank': 15},
    {'id': '2024-016', 'name': 'Pamela Jimenez', 'gender': 'F', 'rank': 16},
    {'id': '2024-017', 'name': 'Quentin Guerrero', 'gender': 'M', 'rank': 17},
    {'id': '2024-018', 'name': 'Rhea Miranda', 'gender': 'F', 'rank': 18},
    {'id': '2024-019', 'name': 'Samuel Pascual', 'gender': 'M', 'rank': 19},
    {'id': '2024-020', 'name': 'Tricia Aquino', 'gender': 'F', 'rank': 20},
  ];

  List<Map<String, dynamic>> get _filtered {
    if (_searchQuery.isEmpty) return _allStudents;
    return _allStudents
        .where(
          (s) =>
              s['name'].toString().toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ) ||
              s['id'].toString().contains(_searchQuery),
        )
        .toList();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildHeader(context),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.zero,
              itemCount: _filtered.length,
              separatorBuilder: (_, __) =>
                  const Divider(height: 1, color: Color(0xFFEEEEEE)),
              itemBuilder: (context, i) {
                final student = _filtered[i];
                final initials =
                    student['name'].toString().split(' ').first[0] +
                    student['name'].toString().split(' ').last[0];
                return InkWell(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => GradesScreen(
                        student: student,
                        section: widget.section,
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: const BoxDecoration(
                            color: Color(0xFFE8E8E8),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              initials,
                              style: const TextStyle(
                                fontFamily: 'Urbanist',
                                fontSize: 14,
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
                                student['name'],
                                style: const TextStyle(
                                  fontFamily: 'Urbanist',
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1A1A1A),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${student['id']} | #${student['rank']} | ${student['gender']}',
                                style: const TextStyle(
                                  fontFamily: 'Urbanist',
                                  fontSize: 12,
                                  color: Color(0xFF888888),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right,
                          color: Color(0xFFCCCCCC),
                          size: 20,
                        ),
                      ],
                    ),
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
              Expanded(
                child: Text(
                  'STUDENTS',
                  style: const TextStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.search,
                  color: Color(0xFF555555),
                  size: 22,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
