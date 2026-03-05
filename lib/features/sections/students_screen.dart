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
      id: json['id'] as int,
      slink: json['slink'] as String,
      fname: json['fname'] as String,
      sname: json['sname'] as String,
      position: json['position'] as String? ?? '',
    );
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
  bool _isSearching = false;
  String _searchQuery = '';
  List<StudentItem> _allStudents = [];
  bool _isLoadingStudents = true;

  @override
  void initState() {
    super.initState();
    _fetchStudents();
  }

  Future<void> _fetchStudents() async {
    try {
      final response = await http
          .get(Uri.parse('${AppConstants.apiBaseUrl}/student'))
          .timeout(
            const Duration(milliseconds: AppConstants.connectionTimeout),
          );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _allStudents = data
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
                : ListView.separated(
                    padding: EdgeInsets.zero,
                    itemCount: _filtered.length,
                    separatorBuilder: (_, __) =>
                        const Divider(height: 1, color: Color(0xFFEEEEEE)),
                    itemBuilder: (context, i) {
                      final student = _filtered[i];
                      final initials = student.fname[0] + student.sname[0];
                      return InkWell(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => GradesScreen(
                              student: {
                                'id': student.id,
                                'name': '${student.fname} ${student.sname}',
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
                                child: ClipOval(
                                  child: Image.network(
                                    student.slink,
                                    width: 44,
                                    height: 44,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Center(
                                        child: Text(
                                          initials,
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
                                      '${student.fname} ${student.sname}',
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
                        widget.section['name'],
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
}
