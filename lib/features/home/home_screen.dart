import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  String _searchQuery = '';

  static const List<Map<String, String>> _news = [
    {
      'title': 'DSI Basketball Team Wins Regional Championship',
      'date': 'February 18, 2026',
      'desc':
          'Our basketball team clinched the regional championship after an outstanding performance against rival schools. The team showed exceptional teamwork and dedication throughout the tournament.',
      'image': 'basketball',
    },
    {
      'title': 'Honor Roll Announcement – 2nd Quarter',
      'date': 'February 15, 2026',
      'desc':
          'The 2nd quarter honor roll has been released. Congratulations to all students who made the list this quarter.',
      'image': 'academic',
    },
    {
      'title': 'Annual Sports Festival 2026 Opening Ceremony',
      'date': 'February 12, 2026',
      'desc':
          'The Annual Sports Festival opened with a grand ceremony featuring all sections competing for the championship.',
      'image': 'sports',
    },
    {
      'title': 'Volleyball Intramurals: JHS Finals Recap',
      'date': 'February 10, 2026',
      'desc':
          'Grade 10-Rizal defeated Grade 9-Bonifacio in a thrilling 5-set volleyball match to claim the JHS title.',
      'image': 'volleyball',
    },
    {
      'title': 'Science Fair 2026 – Outstanding Projects',
      'date': 'February 5, 2026',
      'desc':
          'Students from Grade 8 and Grade 11 presented remarkable science projects that wowed the judges.',
      'image': 'science',
    },
    {
      'title': 'Enrollment for S.Y. 2026-2027 Now Open',
      'date': 'February 1, 2026',
      'desc':
          'Enrollment for the upcoming school year is now open. Visit the registrar\'s office for more information.',
      'image': 'enrollment',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
              indicatorSize: TabBarIndicatorSize.label,
              tabs: const [
                Tab(text: 'Latest'),
                Tab(text: 'Standings'),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [_buildLatestTab(), _buildStandingsTab()],
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: _isSearching
              ? Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _isSearching = false;
                          _searchQuery = '';
                          _searchController.clear();
                        });
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: (v) => setState(() => _searchQuery = v),
                        autofocus: true,
                        decoration: const InputDecoration(
                          hintText: 'Search news...',
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
                            _searchController.clear();
                          });
                        },
                        icon: const Icon(Icons.clear, color: Color(0xFF888888)),
                      ),
                  ],
                )
              : Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFCCCCCC)),
                        borderRadius: BorderRadius.circular(6),
                        color: Colors.white,
                      ),
                      child: const Center(
                        child: Text(
                          'DSI',
                          style: TextStyle(
                            fontFamily: 'Urbanist',
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => setState(() => _isSearching = true),
                      icon: const Icon(
                        Icons.search,
                        size: 24,
                        color: Color(0xFF555555),
                      ),
                    ),
                    const Icon(
                      Icons.person_outline,
                      size: 28,
                      color: Color(0xFF555555),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  List<Map<String, String>> get _filteredNews {
    if (_searchQuery.isEmpty) return _news;
    return _news
        .where(
          (n) =>
              n['title']!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              n['desc']!.toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList();
  }

  Widget _buildLatestTab() {
    final news = _isSearching ? _filteredNews : _news;
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: news.length,
      itemBuilder: (context, index) {
        final item = news[index];
        return _NewsCard(news: item);
      },
    );
  }

  Widget _buildStandingsTab() {
    final standings = [
      {'section': 'Grade 12-STEM', 'pts': '96.2', 'rank': '1'},
      {'section': 'Grade 11-STEM', 'pts': '97.5', 'rank': '1'},
      {'section': 'Grade 11-ABM', 'pts': '95.7', 'rank': '2'},
      {'section': 'Grade 10-Aguinaldo', 'pts': '96.8', 'rank': '1'},
      {'section': 'Grade 10-Mabini', 'pts': '95.1', 'rank': '2'},
      {'section': 'Grade 9-Rizal', 'pts': '94.6', 'rank': '1'},
    ];

    // Group standings by grade
    final groupedStandings = <String, List<Map<String, String>>>{};
    for (var s in standings) {
      final section = s['section'] as String;
      final gradeMatch = RegExp(r'(Grade \d+)').firstMatch(section);
      final grade = gradeMatch != null ? gradeMatch.group(1)! : 'Other';

      if (!groupedStandings.containsKey(grade)) {
        groupedStandings[grade] = [];
      }
      groupedStandings[grade]!.add(s);
    }

    final sortedGrades = groupedStandings.keys.toList()
      ..sort((a, b) {
        if (a == 'Other') return 1;
        if (b == 'Other') return -1;
        final numA = int.parse(a.split(' ')[1]);
        final numB = int.parse(b.split(' ')[1]);
        return numB.compareTo(numA); // Descending order
      });

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: sortedGrades.length,
      itemBuilder: (context, i) {
        final grade = sortedGrades[i];
        final gradeStandings = groupedStandings[grade]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: const Color(0xFFF5F5F5),
              child: Text(
                grade,
                style: const TextStyle(
                  fontFamily: 'Urbanist',
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF555555),
                ),
              ),
            ),
            ...gradeStandings.asMap().entries.map((entry) {
              final index = entry.key;
              final s = entry.value;
              final sectionName = s['section']!;
              final initials =
                  sectionName.split('-').first.split(' ').last[0] +
                  sectionName.split('-').last[0];

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                    child: Row(
                      children: [
                        // Rank
                        SizedBox(
                          width: 28,
                          child: Text(
                            s['rank']!,
                            style: const TextStyle(
                              fontFamily: 'Urbanist',
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1A1A1A),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Section Avatar
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
                        const SizedBox(width: 12),
                        // Section Name and Record
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                sectionName,
                                style: const TextStyle(
                                  fontFamily: 'Urbanist',
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1A1A1A),
                                ),
                              ),
                              const SizedBox(height: 2),
                              const Text(
                                '10-1',
                                style: TextStyle(
                                  fontFamily: 'Urbanist',
                                  fontSize: 13,
                                  color: Color(0xFF888888),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Points
                        Text(
                          s['pts']!,
                          style: const TextStyle(
                            fontFamily: 'Urbanist',
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (index < gradeStandings.length - 1)
                    const Divider(height: 1, color: Color(0xFFEEEEEE)),
                ],
              );
            }).toList(),
          ],
        );
      },
    );
  }
}

class _NewsCard extends StatelessWidget {
  final Map<String, String> news;
  const _NewsCard({required this.news});

  IconData _getIcon(String? type) {
    switch (type) {
      case 'basketball':
        return Icons.sports_basketball;
      case 'volleyball':
        return Icons.sports_volleyball;
      case 'sports':
        return Icons.emoji_events;
      case 'science':
        return Icons.science;
      case 'academic':
        return Icons.school;
      case 'enrollment':
        return Icons.app_registration;
      default:
        return Icons.article;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          height: 200,
          color: const Color(0xFF1A1A1A),
          child: Center(
            child: Icon(
              _getIcon(news['image']),
              size: 80,
              color: const Color(0xFF444444),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                news['date']!.toUpperCase(),
                style: const TextStyle(
                  fontFamily: 'Urbanist',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF888888),
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                news['title']!,
                style: const TextStyle(
                  fontFamily: 'Urbanist',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A1A),
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                news['desc']!,
                style: const TextStyle(
                  fontFamily: 'Urbanist',
                  fontSize: 14,
                  color: Color(0xFF555555),
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1, color: Color(0xFFEEEEEE)),
      ],
    );
  }
}
