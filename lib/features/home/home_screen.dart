import 'package:flutter/material.dart';
import 'news_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  static const List<Map<String, String>> _news = [
    {
      'title': 'DSI Basketball Team Wins Regional Championship',
      'date': 'FEBRUARY 18, 2026',
      'desc':
          'Our basketball team clinched the regional championship after an outstanding performance against rival schools. The team showed exceptional teamwork and dedication throughout the tournament.',
    },
    {
      'title': 'Honor Roll Announcement – 2nd Quarter',
      'date': 'FEBRUARY 15, 2026',
      'desc':
          'The 2nd quarter honor roll has been released. Congratulations to all students who made the list this quarter.',
    },
    {
      'title': 'Annual Sports Festival 2026 Opening Ceremony',
      'date': 'FEBRUARY 12, 2026',
      'desc':
          'The Annual Sports Festival opened with a grand ceremony featuring all sections competing for the championship.',
    },
    {
      'title': 'Volleyball Intramurals: JHS Finals Recap',
      'date': 'FEBRUARY 10, 2026',
      'desc':
          'Grade 10-Rizal defeated Grade 9-Bonifacio in a thrilling 5-set volleyball match to claim the JHS title.',
    },
    {
      'title': 'Science Fair 2026 – Outstanding Projects',
      'date': 'FEBRUARY 5, 2026',
      'desc':
          'Students from Grade 8 and Grade 11 presented remarkable science projects that wowed the judges.',
    },
    {
      'title': 'Enrollment for S.Y. 2026-2027 Now Open',
      'date': 'FEBRUARY 1, 2026',
      'desc':
          'Enrollment for the upcoming school year is now open. Visit the registrar\'s office for more information.',
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: NestedScrollView(
        headerSliverBuilder: (context, _) => [
          SliverToBoxAdapter(child: _buildHeader()),
          SliverPersistentHeader(
            pinned: true,
            delegate: _TabBarDelegate(controller: _tabController),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [_buildLatestTab(), _buildStandingsTab()],
        ),
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
          child: Row(
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

  Widget _buildLatestTab() {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: _news.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) return _buildFeaturedCard();
        final item = _news[index - 1];
        return _NewsListItem(news: item);
      },
    );
  }

  Widget _buildFeaturedCard() {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => NewsDetailScreen(
            news: {..._news[0], 'category': 'Sports', 'color': 'red'},
            accentColor: const Color(0xFFCC0000),
          ),
        ),
      ),
      child: Container(
        width: double.infinity,
        height: 240,
        color: const Color(0xFF1A1A1A),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              color: const Color(0xFF2A2A2A),
              child: const Center(
                child: Icon(
                  Icons.sports_basketball,
                  size: 80,
                  color: Color(0xFF444444),
                ),
              ),
            ),
            Positioned(
              top: 12,
              right: 12,
              child: Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: Color(0x99000000),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.share_outlined,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Color(0xDD000000), Colors.transparent],
                  ),
                ),
                child: const Text(
                  'DSI Basketball Team Wins Regional Championship',
                  style: TextStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStandingsTab() {
    final standings = [
      {'section': 'Grade 11-STEM', 'pts': '97.5', 'rank': '1'},
      {'section': 'Grade 10-Aguinaldo', 'pts': '96.8', 'rank': '2'},
      {'section': 'Grade 12-STEM', 'pts': '96.2', 'rank': '3'},
      {'section': 'Grade 11-ABM', 'pts': '95.7', 'rank': '4'},
      {'section': 'Grade 10-Mabini', 'pts': '95.1', 'rank': '5'},
      {'section': 'Grade 9-Rizal', 'pts': '94.6', 'rank': '6'},
    ];
    return ListView.separated(
      padding: const EdgeInsets.only(top: 8, bottom: 20),
      itemCount: standings.length,
      separatorBuilder: (_, __) =>
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
      itemBuilder: (context, i) {
        final s = standings[i];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Row(
            children: [
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
              Expanded(
                child: Text(
                  s['section']!,
                  style: const TextStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
              ),
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
        );
      },
    );
  }
}

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabController controller;
  const _TabBarDelegate({required this.controller});

  @override
  double get minExtent => 46;
  @override
  double get maxExtent => 46;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: controller,
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
    );
  }

  @override
  bool shouldRebuild(_TabBarDelegate old) => false;
}

class _NewsListItem extends StatelessWidget {
  final Map<String, String> news;
  const _NewsListItem({required this.news});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => NewsDetailScreen(
            news: {...news, 'category': 'News', 'color': 'blue'},
            accentColor: const Color(0xFF1A1A1A),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  news['date']!,
                  style: const TextStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 11,
                    color: Color(0xFF888888),
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  news['title']!,
                  style: const TextStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A1A),
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  news['desc']!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 13,
                    color: Color(0xFF555555),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
        ],
      ),
    );
  }
}
