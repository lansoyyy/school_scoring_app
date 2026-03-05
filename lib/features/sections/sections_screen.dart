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
      id: json['id'] as int,
      slink: json['slink'] as String,
      name: json['name'] as String,
      adviser: json['adviser'] as String,
    );
  }
}

class SectionsScreen extends StatefulWidget {
  const SectionsScreen({super.key});

  @override
  State<SectionsScreen> createState() => _SectionsScreenState();
}

class _SectionsScreenState extends State<SectionsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<SectionItem> _allSections = [];
  bool _isLoadingSections = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _fetchSections();
  }

  Future<void> _fetchSections() async {
    try {
      final response = await http
          .get(Uri.parse('${AppConstants.apiBaseUrl}/section'))
          .timeout(
            const Duration(milliseconds: AppConstants.connectionTimeout),
          );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        List<SectionItem> sections = [];
        for (var item in data) {
          if (item is List && item.length > 1) {
            // item[0] is category name, item[1] onwards are section objects
            for (var i = 1; i < item.length; i++) {
              if (item[i] is Map) {
                sections.add(SectionItem.fromJson(item[i]));
              }
            }
          }
        }
        setState(() {
          _allSections = sections;
          _isLoadingSections = false;
        });
      } else {
        setState(() => _isLoadingSections = false);
      }
    } catch (e) {
      setState(() => _isLoadingSections = false);
    }
  }

  List<SectionItem> _byLevel(String level) {
    final sections = _allSections.where((s) => s.name.contains(level)).toList();
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
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

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
              tabs: const [
                Tab(text: 'PREP'),
                Tab(text: 'ELEM'),
                Tab(text: 'JHS'),
                Tab(text: 'SHS'),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          Expanded(
            child: _isLoadingSections
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFFD4A017)),
                  )
                : TabBarView(
                    controller: _tabController,
                    children: [
                      _buildSectionList(_byLevel('PREP'), context),
                      _buildSectionList(_byLevel('ELEM'), context),
                      _buildSectionList(_byLevel('JHS'), context),
                      _buildSectionList(_byLevel('SHS'), context),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: const Color(0xFFF5F5F5),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: Row(
            children: [
              const Text(
                'SECTIONS',
                style: TextStyle(
                  fontFamily: 'Urbanist',
                  fontSize: 22,
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
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.school_outlined, size: 56, color: Colors.grey[300]),
            const SizedBox(height: 12),
            Text(
              'No sections found',
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
                    child: Image.network(
                      s.slink,
                      width: 44,
                      height: 44,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.school,
                          size: 20,
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
              ],
            ),
          ),
        );
      },
    );
  }
}
