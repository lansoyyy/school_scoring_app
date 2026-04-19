import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../core/constants/app_constants.dart';
import '../../core/services/local_profile_service.dart';
import 'settings_screen.dart';

class NewsItem {
  final int id;
  final String title;
  final String nlink;
  final String postDate;
  final String details;

  NewsItem({
    required this.id,
    required this.title,
    required this.nlink,
    required this.postDate,
    required this.details,
  });

  factory NewsItem.fromJson(Map<String, dynamic> json) {
    return NewsItem(
      id: json['id'] as int,
      title: json['title'] as String,
      nlink: json['nlink'] as String,
      postDate: json['postDate'] as String,
      details: json['details'] as String,
    );
  }
}

class StandingItem {
  final int id;
  final String slink;
  final String name;
  final String teamName;
  final String standing;

  StandingItem({
    required this.id,
    required this.slink,
    required this.name,
    required this.teamName,
    required this.standing,
  });

  factory StandingItem.fromJson(Map<String, dynamic> json) {
    return StandingItem(
      id: json['id'] as int,
      slink: json['slink'] as String,
      name: json['name'] as String,
      teamName: json['team_name'] as String,
      standing: json['standing'] as String,
    );
  }
}

class GradeStandings {
  final String grade;
  final List<StandingItem> teams;

  GradeStandings({required this.grade, required this.teams});
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final LocalProfileService _profileService = const LocalProfileService();
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  String _searchQuery = '';
  List<NewsItem> _news = [];
  bool _isLoadingNews = true;
  List<GradeStandings> _standings = [];
  bool _isLoadingStandings = true;
  LocalProfileData _profile = const LocalProfileData(
    userId: '',
    name: '',
    email: '',
    imageBase64: '',
  );

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadProfile();
    _fetchNews();
    _fetchStandings();
  }

  Future<void> _loadProfile() async {
    final profile = await _profileService.loadProfile();
    if (!mounted) {
      return;
    }

    setState(() => _profile = profile);
  }

  Future<void> _openSettings() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsScreen()),
    );

    await _loadProfile();
  }

  Future<void> _fetchNews() async {
    try {
      final response = await http
          .get(Uri.parse('${AppConstants.apiBaseUrl}/latest'))
          .timeout(
            const Duration(milliseconds: AppConstants.connectionTimeout),
          );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _news = data.map((item) => NewsItem.fromJson(item)).toList();
          _isLoadingNews = false;
        });
      } else {
        setState(() => _isLoadingNews = false);
      }
    } catch (e) {
      setState(() => _isLoadingNews = false);
    }
  }

  Future<void> _fetchStandings() async {
    try {
      final response = await http
          .get(Uri.parse('${AppConstants.apiBaseUrl}/standings'))
          .timeout(
            const Duration(milliseconds: AppConstants.connectionTimeout),
          );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final List<GradeStandings> standingsList = [];

        for (var gradeData in data) {
          if (gradeData is List && gradeData.isNotEmpty) {
            final gradeInfo = gradeData[0] as Map<String, dynamic>;
            final grade = gradeInfo['grade'] as String;
            final teams = <StandingItem>[];

            for (int i = 1; i < gradeData.length; i++) {
              if (gradeData[i] is Map<String, dynamic>) {
                teams.add(
                  StandingItem.fromJson(gradeData[i] as Map<String, dynamic>),
                );
              }
            }

            standingsList.add(GradeStandings(grade: grade, teams: teams));
          }
        }

        setState(() {
          _standings = standingsList;
          _isLoadingStandings = false;
        });
      } else {
        setState(() => _isLoadingStandings = false);
      }
    } catch (e) {
      setState(() => _isLoadingStandings = false);
    }
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
    final profileImageBytes = _profile.imageBytes;

    return Container(
      height: 100,
      color: const Color(0xFFF5F5F5),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset('assets/images/logo.png'),
                    const Spacer(),
                    GestureDetector(
                      onTap: _openSettings,
                      child: SizedBox(
                        width: 25,
                        height: 25,
                        child: profileImageBytes == null
                            ? const Icon(
                                Icons.account_circle_outlined,
                                size: 25,
                                color: Color(0xFF1A1A1A),
                              )
                            : ClipOval(
                                child: Image.memory(
                                  profileImageBytes,
                                  width: 25,
                                  height: 25,
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  List<NewsItem> get _filteredNews {
    if (_searchQuery.isEmpty) return _news;
    return _news
        .where(
          (n) =>
              n.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              n.details.toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList();
  }

  Widget _buildLatestTab() {
    if (_isLoadingNews) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFFD4A017)),
      );
    }

    final news = _isSearching ? _filteredNews : _news;
    if (news.isEmpty) {
      return const Center(
        child: Text(
          'No news available',
          style: TextStyle(
            fontFamily: 'Urbanist',
            fontSize: 16,
            color: Color(0xFF888888),
          ),
        ),
      );
    }
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
    if (_isLoadingStandings) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFFD4A017)),
      );
    }

    if (_standings.isEmpty) {
      return const Center(
        child: Text(
          'No standings available',
          style: TextStyle(
            fontFamily: 'Urbanist',
            fontSize: 16,
            color: Color(0xFF888888),
          ),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: _standings.length,
      itemBuilder: (context, i) {
        final gradeStanding = _standings[i];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: const Color(0xFFF5F5F5),
              child: Text(
                gradeStanding.grade,
                style: const TextStyle(
                  fontFamily: 'Urbanist',
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF555555),
                ),
              ),
            ),
            ...gradeStanding.teams.asMap().entries.map((entry) {
              final index = entry.key;
              final team = entry.value;
              final initials =
                  team.name.split(' ').first[0] +
                  team.teamName.split(' ').first[0];

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                    child: Row(
                      children: [
                        // Rank (index + 1)
                        SizedBox(
                          width: 28,
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(
                              fontFamily: 'Urbanist',
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1A1A1A),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Team Avatar (with image)
                        Container(
                          width: 44,
                          height: 44,
                          decoration: const BoxDecoration(
                            color: Color(0xFFE8E8E8),
                            shape: BoxShape.circle,
                          ),
                          child: ClipOval(
                            child: Image.network(
                              team.slink,
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
                        const SizedBox(width: 12),
                        // Team Name and Record
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${team.name} - ${team.teamName}',
                                style: const TextStyle(
                                  fontFamily: 'Urbanist',
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1A1A1A),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                team.standing,
                                style: const TextStyle(
                                  fontFamily: 'Urbanist',
                                  fontSize: 13,
                                  color: Color(0xFF888888),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (index < gradeStanding.teams.length - 1)
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
  final NewsItem news;
  const _NewsCard({required this.news});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          height: 200,
          color: const Color(0xFF1A1A1A),
          child: Image.network(
            news.nlink,
            width: double.infinity,
            height: 200,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const Center(
                child: Icon(Icons.article, size: 80, color: Color(0xFF444444)),
              );
            },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFFD4A017)),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                news.postDate.toUpperCase(),
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
                news.title,
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
                news.details,
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
