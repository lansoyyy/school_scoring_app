import 'package:flutter/material.dart';

class NewsDetailScreen extends StatelessWidget {
  final Map<String, String> news;
  final Color accentColor;

  const NewsDetailScreen({
    super.key,
    required this.news,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: accentColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          news['category']!,
                          style: TextStyle(
                            fontFamily: 'Urbanist',
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: accentColor,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Icon(Icons.calendar_today_outlined,
                              size: 14, color: Colors.grey[500]),
                          const SizedBox(width: 4),
                          Text(
                            news['date']!,
                            style: TextStyle(
                              fontFamily: 'Urbanist',
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    news['title']!,
                    style: const TextStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1A1A2E),
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [accentColor, accentColor.withOpacity(0.7)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Icon(
                        _categoryIcon(news['category']!),
                        color: Colors.white,
                        size: 64,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Article',
                    style: TextStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    news['desc']!,
                    style: const TextStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 15,
                      color: Color(0xFF4B5563),
                      height: 1.7,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _getFullArticle(news['category']!),
                    style: const TextStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 15,
                      color: Color(0xFF4B5563),
                      height: 1.7,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: accentColor.withOpacity(0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.person_outline,
                              color: accentColor, size: 22),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'DSI Admin',
                                style: TextStyle(
                                  fontFamily: 'Urbanist',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF1A1A2E),
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'School Administrator',
                                style: TextStyle(
                                  fontFamily: 'Urbanist',
                                  fontSize: 12,
                                  color: Color(0xFF6B7280),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 0,
      pinned: true,
      backgroundColor: const Color(0xFF1A3F6F),
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
      ),
      title: const Text(
        'News Details',
        style: TextStyle(
          fontFamily: 'Urbanist',
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }

  IconData _categoryIcon(String category) {
    switch (category) {
      case 'Sports':
        return Icons.sports_basketball_outlined;
      case 'Academic':
        return Icons.school_outlined;
      case 'Event':
        return Icons.event_outlined;
      case 'Announcement':
        return Icons.campaign_outlined;
      default:
        return Icons.article_outlined;
    }
  }

  String _getFullArticle(String category) {
    switch (category) {
      case 'Sports':
        return 'The championship game was held at the main gymnasium with over 500 spectators in attendance. '
            'The team showed exceptional teamwork and determination throughout the tournament. '
            'Coach Martinez expressed his pride in the players\' performance and dedication. '
            'This victory marks the third consecutive regional championship for DSI.';
      case 'Academic':
        return 'Students who achieved a general weighted average of 90 and above are recognized in the honor roll. '
            'The list includes students from all grade levels, from elementary to senior high school. '
            'Certificates will be distributed during the flag ceremony next week. '
            'Parents are encouraged to attend and support their children\'s academic achievements.';
      case 'Event':
        return 'The opening ceremony featured a parade of all participating sections, each with their own themed costumes. '
            'The school principal delivered an inspiring message about sportsmanship and fair play. '
            'The torch was lit by last year\'s MVP, marking the official start of the sports festival. '
            'Various sports competitions will run throughout the week.';
      default:
        return 'For more information, please contact the school administration office or visit the official bulletin board. '
            'Stay tuned for more updates and announcements from Don Stevens Institute.';
    }
  }
}
