import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:school_scoring_app/core/constants/app_constants.dart';
import 'grades_screen.dart';

class StudentItem {
  final int id;
  final String slink;
  final String fname;
  final String sname;
  final String position;

  StudentItem({
    required this.id,
    required this.slink,
    required this.fname,
    required this.sname,
    required this.position,
  });

  factory StudentItem.fromJson(Map<String, dynamic> json) {
    return StudentItem(
      id: _parseInt(json['id']),
      slink: (json['slink'] ?? '').toString(),
      fname: (json['fname'] ?? '').toString(),
      sname: (json['sname'] ?? '').toString(),
      position: (json['position'] ?? '').toString(),
    );
  }

  static int _parseInt(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}

class StudentsScreen extends StatefulWidget {
  final Map<String, dynamic> section;

  const StudentsScreen({super.key, required this.section});

  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  final _searchCtrl = TextEditingController();
  final bool _isSearching = false;
  String _searchQuery = '';
  List<StudentItem> _allStudents = [];
  bool _isLoadingStudents = true;

  String get _sectionName => (widget.section['name'] ?? 'Students').toString();

  String _studentDisplayName(StudentItem student) {
    final name = '${student.fname} ${student.sname}'.trim();
    return name.isEmpty ? 'Unknown Student' : name;
  }

  String _studentInitials(StudentItem student) {
    final first = student.fname.trim();
    final last = student.sname.trim();
    final f = first.isNotEmpty ? first[0] : '';
    final l = last.isNotEmpty ? last[0] : '';
    final initials = '$f$l';
    return initials.isEmpty ? 'S' : initials.toUpperCase();
  }

  @override
  void initState() {
    super.initState();
    _fetchStudents();
  }

  Future<void> _fetchStudents() async {
    final sectionId = widget.section['id']?.toString().trim() ?? '';
    if (sectionId.isEmpty) {
      setState(() => _isLoadingStudents = false);
      return;
    }

    try {
      final response = await http
          .get(
            Uri.parse('${AppConstants.apiBaseUrl}/student').replace(
              queryParameters: <String, String>{'sectionId': sectionId},
            ),
          )
          .timeout(
            const Duration(milliseconds: AppConstants.connectionTimeout),
          );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final List<dynamic> data = decoded is List<dynamic> ? decoded : [];
        setState(() {
          _allStudents = data
              .whereType<Map<String, dynamic>>()
              .map((item) => StudentItem.fromJson(item))
              .toList();
          _isLoadingStudents = false;
        });
      } else {
        setState(() => _isLoadingStudents = false);
      }
    } catch (e) {
      setState(() => _isLoadingStudents = false);
    }
  }

  List<StudentItem> get _filtered {
    if (_searchQuery.isEmpty) return _allStudents;
    return _allStudents
        .where(
          (s) => '${s.fname} ${s.sname}'.toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ),
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
            child: _isLoadingStudents
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFFD4A017)),
                  )
                : _filtered.isEmpty
                    ? _buildEmptyState()
                    : ListView.separated(
                    padding: EdgeInsets.zero,
                    itemCount: _filtered.length,
                    separatorBuilder: (_, __) =>
                        const Divider(height: 1, color: Color(0xFFEEEEEE)),
                    itemBuilder: (context, i) {
                      final student = _filtered[i];
                      final initials = _studentInitials(student);
                      return InkWell(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => GradesScreen(
                              student: {
                                'id': student.id,
                                'name': _studentDisplayName(student),
                                'gender': '',
                                'rank': '',
                                'slink': student.slink,
                                'position': student.position,
                              },
                              section: widget.section,
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 0,
                            vertical: 12,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 64,
                                height: 64,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFE8E8E8),
                                  shape: BoxShape.circle,
                                ),
                                child: ClipOval(
                                  child: Image.network(
                                    student.slink,
                                    width: 64,
                                    height: 64,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Center(
                                        child: Text(
                                          initials,
                                          style: const TextStyle(
                                            fontFamily: 'Urbanist',
                                            fontSize: 22,
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
                                      _studentDisplayName(student),
                                      style: const TextStyle(
                                        fontFamily: 'Urbanist',
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF1A1A1A),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      student.position.isNotEmpty
                                          ? student.position
                                          : 'Student',
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
                              const SizedBox(width: 15),
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
          padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
          child: _isSearching
              ? Row(
                  children: [
                    Icon(Icons.arrow_back, color: Color(0xFF1A1A1A)),
                    Expanded(
                      child: TextField(
                        controller: _searchCtrl,
                        onChanged: (v) => setState(() => _searchQuery = v),
                        autofocus: true,
                        decoration: const InputDecoration(
                          hintText: 'Search students...',
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            fontFamily: 'Urbanist',
                            color: Color(0xFF888888),
                          ),
                        ),
                        style: const TextStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 16,
                        ),
                      ),
                    ),
                    if (_searchQuery.isNotEmpty)
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _searchQuery = '';
                            _searchCtrl.clear();
                          });
                        },
                        icon: const Icon(Icons.clear, color: Color(0xFF888888)),
                      ),
                  ],
                )
              : Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        _sectionName,
                        style: const TextStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
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

  Widget _buildEmptyState() {
    final isSearching = _searchQuery.trim().isNotEmpty;
    final title = isSearching ? 'No matching players' : 'No players yet';
    final subtitle = isSearching
        ? 'Try a different name or clear the search.'
        : 'There are no players available for this team right now.';

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.groups_outlined, size: 56, color: Color(0xFFBDBDBD)),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Urbanist',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Urbanist',
                fontSize: 14,
                color: Color(0xFF8A8A8A),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
