import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:school_scoring_app/core/constants/app_constants.dart';
import 'students_screen.dart';

class SectionItem {
  final int id;
  final String slink;
  final String name;
  final String adviser;

  SectionItem({
    required this.id,
    required this.slink,
    required this.name,
    required this.adviser,
  });

  factory SectionItem.fromJson(Map<String, dynamic> json) {
    return SectionItem(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      slink: json['slink']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      adviser: json['adviser']?.toString() ?? '',
    );
  }
}

class SectionGroup {
  final String grade;
  final List<SectionItem> sections;

  const SectionGroup({required this.grade, required this.sections});
}

class SectionsScreen extends StatefulWidget {
  const SectionsScreen({super.key});

  @override
  State<SectionsScreen> createState() => _SectionsScreenState();
}

class _SectionsScreenState extends State<SectionsScreen> {
  final String _searchQuery = '';
  List<SectionGroup> _sectionGroups = const <SectionGroup>[];
  bool _isLoadingSections = true;

  @override
  void initState() {
    super.initState();
    _fetchSections();
  }

  Future<void> _fetchSections() async {
    try {
      final response = await http
          .get(Uri.parse('${AppConstants.apiBaseUrl}/section'))
          .timeout(
            const Duration(milliseconds: AppConstants.connectionTimeout),
          );

      if (!mounted) {
        return;
      }

      if (response.statusCode == 200) {
        final dynamic decodedBody = json.decode(response.body);
        final sectionGroups = _parseSectionGroups(decodedBody);

        setState(() {
          _sectionGroups = sectionGroups;
          _isLoadingSections = false;
        });
      } else {
        setState(() => _isLoadingSections = false);
      }
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() => _isLoadingSections = false);
    }
  }

  List<SectionGroup> _parseSectionGroups(dynamic decodedBody) {
    if (decodedBody is! List) {
      return const <SectionGroup>[];
    }

    final sectionGroups = <SectionGroup>[];

    for (final group in decodedBody) {
      if (group is! List || group.isEmpty) {
        continue;
      }

      final header = group.first;
      if (header is! Map) {
        continue;
      }

      final headerMap = Map<String, dynamic>.from(header);
      final grade = _extractHeaderValue(headerMap, preferredKey: 'grade');
      if (grade.isEmpty) {
        continue;
      }

      final sections = group
          .skip(1)
          .whereType<Map>()
          .map((item) => SectionItem.fromJson(Map<String, dynamic>.from(item)))
          .toList();

      sectionGroups.add(SectionGroup(grade: grade, sections: sections));
    }

    return sectionGroups;
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

  List<SectionItem> _filteredSections(List<SectionItem> sections) {
    if (_searchQuery.isEmpty) return sections;
    return sections
        .where(
          (s) =>
              s.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              s.adviser.toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(child: _buildBody(context)),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (_isLoadingSections) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFFD4A017)),
      );
    }

    if (_sectionGroups.isEmpty) {
      return _buildEmptyState('No sections found');
    }

    return DefaultTabController(
      key: ValueKey(_sectionGroups.map((group) => group.grade).join('|')),
      length: _sectionGroups.length,
      child: Column(
        children: [
          Container(
            color: Colors.white,
            child: TabBar(
              labelStyle: const TextStyle(
                fontFamily: 'Urbanist',
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
              unselectedLabelStyle: const TextStyle(
                fontFamily: 'Urbanist',
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
              labelColor: const Color(0xFF1A1A1A),
              unselectedLabelColor: const Color(0xFF888888),
              indicatorColor: const Color(0xFFD4A017),
              indicatorWeight: 3,
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: _sectionGroups
                  .map((group) => Tab(text: group.grade))
                  .toList(),
            ),
          ),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          Expanded(
            child: TabBarView(
              children: _sectionGroups
                  .map(
                    (group) => _buildSectionList(
                      _filteredSections(group.sections),
                      context,
                    ),
                  )
                  .toList(),
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
                'TEAMS',
                style: TextStyle(
                  fontFamily: 'Urbanist',
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionList(List<SectionItem> sections, BuildContext context) {
    if (sections.isEmpty) {
      return _buildEmptyState('No sections found');
    }

    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: sections.length,
      separatorBuilder: (_, __) =>
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
      itemBuilder: (context, i) {
        final s = sections[i];
        return InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => StudentsScreen(
                section: {
                  'name': s.name,
                  'id': s.id,
                  'slink': s.slink,
                  'adviser': s.adviser,
                },
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
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
                      s.slink,
                      width: 64,
                      height: 64,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.school,
                          size: 32,
                          color: Color(0xFF555555),
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
                        s.adviser,
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
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.school_outlined, size: 56, color: Colors.grey[300]),
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
