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

  static final List<Map<String, dynamic>> _allStudents = [
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
        .where((s) =>
            s['name'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
            s['id'].toString().contains(_searchQuery))
        .toList();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sectionColor = Color(widget.section['color'] as int);
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          _buildHeader(context, sectionColor),
          _buildSearch(),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
            child: Row(
              children: [
                Text(
                  '${_filtered.length} Students',
                  style: const TextStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
                const Spacer(),
                Text(
                  widget.section['adviser'],
                  style: const TextStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _filtered.length,
              itemBuilder: (context, i) {
                final student = _filtered[i];
                return _StudentTile(
                  student: student,
                  sectionColor: sectionColor,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => GradesScreen(
                        student: student,
                        section: widget.section,
                      ),
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
          padding: const EdgeInsets.fromLTRB(8, 8, 20, 16),
          child: Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.section['name'],
                      style: const TextStyle(
                        fontFamily: 'Urbanist',
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${widget.section['level']} • ${widget.section['count']} Students',
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
        ),
      ),
    );
  }

  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: TextField(
        controller: _searchCtrl,
        onChanged: (v) => setState(() => _searchQuery = v),
        style: const TextStyle(fontFamily: 'Urbanist', fontSize: 14),
        decoration: InputDecoration(
          hintText: 'Search students by name or ID...',
          hintStyle: TextStyle(
              fontFamily: 'Urbanist', fontSize: 13, color: Colors.grey[400]),
          prefixIcon:
              Icon(Icons.search_rounded, color: Colors.grey[400], size: 20),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear_rounded,
                      color: Colors.grey[400], size: 18),
                  onPressed: () {
                    _searchCtrl.clear();
                    setState(() => _searchQuery = '');
                  },
                )
              : null,
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF4A90E2), width: 2),
          ),
        ),
      ),
    );
  }
}

class _StudentTile extends StatelessWidget {
  final Map<String, dynamic> student;
  final Color sectionColor;
  final VoidCallback onTap;

  const _StudentTile({
    required this.student,
    required this.sectionColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isFemale = student['gender'] == 'F';
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
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
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: (isFemale
                          ? const Color(0xFFEC4899)
                          : const Color(0xFF4A90E2))
                      .withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    student['name'].toString().split(' ').first[0] +
                        student['name'].toString().split(' ').last[0],
                    style: TextStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: isFemale
                          ? const Color(0xFFEC4899)
                          : const Color(0xFF4A90E2),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      student['name'],
                      style: const TextStyle(
                        fontFamily: 'Urbanist',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'ID: ${student['id']}',
                      style: const TextStyle(
                        fontFamily: 'Urbanist',
                        fontSize: 12,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: sectionColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Rank #${student['rank']}',
                  style: TextStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: sectionColor,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.chevron_right_rounded,
                  color: Colors.grey[400], size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
