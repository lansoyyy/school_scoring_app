import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  int _subjectIndex = 0;
  final List<String> _subjects = [
    'ALL',
    'MATH',
    'SCIENCE',
    'ENGLISH',
    'FILIPINO',
    'RELIGION',
  ];

  static final Map<String, List<Map<String, dynamic>>> _data = {
    'ALL': [
      {
        'name': 'Bianca Reyes',
        'section': 'Grade 11-STEM',
        'score': 97.5,
        'gender': 'F',
      },
      {
        'name': 'Andrei Santos',
        'section': 'Grade 10-Aguinaldo',
        'score': 96.8,
        'gender': 'M',
      },
      {
        'name': 'Diana Cruz',
        'section': 'Grade 12-STEM',
        'score': 96.2,
        'gender': 'F',
      },
      {
        'name': 'Carlo Mendoza',
        'section': 'Grade 11-ABM',
        'score': 95.7,
        'gender': 'M',
      },
      {
        'name': 'Tricia Aquino',
        'section': 'Grade 10-Mabini',
        'score': 95.1,
        'gender': 'F',
      },
      {
        'name': 'Eduardo Bautista',
        'section': 'Grade 9-Rizal',
        'score': 94.6,
        'gender': 'M',
      },
      {
        'name': 'Felicia Torres',
        'section': 'Grade 12-ABM',
        'score': 94.2,
        'gender': 'F',
      },
      {
        'name': 'Gerald Villanueva',
        'section': 'Grade 11-HUMSS',
        'score': 93.8,
        'gender': 'M',
      },
      {
        'name': 'Hannah Lopez',
        'section': 'Grade 9-Bonifacio',
        'score': 93.4,
        'gender': 'F',
      },
      {
        'name': 'Ivan Garcia',
        'section': 'Grade 10-Aguinaldo',
        'score': 93.0,
        'gender': 'M',
      },
    ],
    'MATH': [
      {
        'name': 'Andrei Santos',
        'section': 'Grade 10-Aguinaldo',
        'score': 99.0,
        'gender': 'M',
      },
      {
        'name': 'Carlo Mendoza',
        'section': 'Grade 11-STEM',
        'score': 98.0,
        'gender': 'M',
      },
      {
        'name': 'Bianca Reyes',
        'section': 'Grade 11-STEM',
        'score': 97.0,
        'gender': 'F',
      },
      {
        'name': 'Kevin Flores',
        'section': 'Grade 12-STEM',
        'score': 96.0,
        'gender': 'M',
      },
      {
        'name': 'Diana Cruz',
        'section': 'Grade 12-STEM',
        'score': 95.5,
        'gender': 'F',
      },
      {
        'name': 'Oscar Morales',
        'section': 'Grade 11-ABM',
        'score': 94.5,
        'gender': 'M',
      },
      {
        'name': 'Lara Aguilar',
        'section': 'Grade 9-Rizal',
        'score': 93.5,
        'gender': 'F',
      },
      {
        'name': 'Marco Navarro',
        'section': 'Grade 10-Mabini',
        'score': 92.5,
        'gender': 'M',
      },
      {
        'name': 'Eduardo Bautista',
        'section': 'Grade 9-Rizal',
        'score': 91.5,
        'gender': 'M',
      },
      {
        'name': 'Samuel Pascual',
        'section': 'Grade 12-GAS',
        'score': 90.5,
        'gender': 'M',
      },
    ],
    'SCIENCE': [
      {
        'name': 'Bianca Reyes',
        'section': 'Grade 11-STEM',
        'score': 99.5,
        'gender': 'F',
      },
      {
        'name': 'Diana Cruz',
        'section': 'Grade 12-STEM',
        'score': 98.5,
        'gender': 'F',
      },
      {
        'name': 'Andrei Santos',
        'section': 'Grade 10-Aguinaldo',
        'score': 97.0,
        'gender': 'M',
      },
      {
        'name': 'Tricia Aquino',
        'section': 'Grade 10-Mabini',
        'score': 96.0,
        'gender': 'F',
      },
      {
        'name': 'Ivan Garcia',
        'section': 'Grade 10-Aguinaldo',
        'score': 95.0,
        'gender': 'M',
      },
      {
        'name': 'Felicia Torres',
        'section': 'Grade 12-ABM',
        'score': 94.0,
        'gender': 'F',
      },
      {
        'name': 'Carlo Mendoza',
        'section': 'Grade 11-STEM',
        'score': 93.0,
        'gender': 'M',
      },
      {
        'name': 'Pamela Jimenez',
        'section': 'Grade 11-HUMSS',
        'score': 92.0,
        'gender': 'F',
      },
      {
        'name': 'Nikki Castillo',
        'section': 'Grade 9-Bonifacio',
        'score': 91.0,
        'gender': 'F',
      },
      {
        'name': 'Gerald Villanueva',
        'section': 'Grade 11-HUMSS',
        'score': 90.0,
        'gender': 'M',
      },
    ],
    'ENGLISH': [
      {
        'name': 'Felicia Torres',
        'section': 'Grade 12-ABM',
        'score': 99.0,
        'gender': 'F',
      },
      {
        'name': 'Hannah Lopez',
        'section': 'Grade 9-Bonifacio',
        'score': 98.0,
        'gender': 'F',
      },
      {
        'name': 'Bianca Reyes',
        'section': 'Grade 11-STEM',
        'score': 97.5,
        'gender': 'F',
      },
      {
        'name': 'Rhea Miranda',
        'section': 'Grade 11-HUMSS',
        'score': 96.5,
        'gender': 'F',
      },
      {
        'name': 'Diana Cruz',
        'section': 'Grade 12-STEM',
        'score': 95.5,
        'gender': 'F',
      },
      {
        'name': 'Andrei Santos',
        'section': 'Grade 10-Aguinaldo',
        'score': 94.5,
        'gender': 'M',
      },
      {
        'name': 'Nikki Castillo',
        'section': 'Grade 9-Bonifacio',
        'score': 93.5,
        'gender': 'F',
      },
      {
        'name': 'Tricia Aquino',
        'section': 'Grade 10-Mabini',
        'score': 92.5,
        'gender': 'F',
      },
      {
        'name': 'Pamela Jimenez',
        'section': 'Grade 11-HUMSS',
        'score': 91.5,
        'gender': 'F',
      },
      {
        'name': 'Gerald Villanueva',
        'section': 'Grade 11-HUMSS',
        'score': 90.5,
        'gender': 'M',
      },
    ],
    'FILIPINO': [
      {
        'name': 'Tricia Aquino',
        'section': 'Grade 10-Mabini',
        'score': 99.0,
        'gender': 'F',
      },
      {
        'name': 'Rhea Miranda',
        'section': 'Grade 11-HUMSS',
        'score': 98.0,
        'gender': 'F',
      },
      {
        'name': 'Felicia Torres',
        'section': 'Grade 12-ABM',
        'score': 97.0,
        'gender': 'F',
      },
      {
        'name': 'Hannah Lopez',
        'section': 'Grade 9-Bonifacio',
        'score': 96.0,
        'gender': 'F',
      },
      {
        'name': 'Eduardo Bautista',
        'section': 'Grade 9-Rizal',
        'score': 95.0,
        'gender': 'M',
      },
      {
        'name': 'Lara Aguilar',
        'section': 'Grade 9-Rizal',
        'score': 94.0,
        'gender': 'F',
      },
      {
        'name': 'Jasmine Ramos',
        'section': 'Grade 10-Mabini',
        'score': 93.0,
        'gender': 'F',
      },
      {
        'name': 'Bianca Reyes',
        'section': 'Grade 11-STEM',
        'score': 92.0,
        'gender': 'F',
      },
      {
        'name': 'Oscar Morales',
        'section': 'Grade 11-ABM',
        'score': 91.0,
        'gender': 'M',
      },
      {
        'name': 'Pamela Jimenez',
        'section': 'Grade 11-HUMSS',
        'score': 90.0,
        'gender': 'F',
      },
    ],
    'RELIGION': [
      {
        'name': 'Diana Cruz',
        'section': 'Grade 12-STEM',
        'score': 100.0,
        'gender': 'F',
      },
      {
        'name': 'Tricia Aquino',
        'section': 'Grade 10-Mabini',
        'score': 99.0,
        'gender': 'F',
      },
      {
        'name': 'Bianca Reyes',
        'section': 'Grade 11-STEM',
        'score': 98.5,
        'gender': 'F',
      },
      {
        'name': 'Hannah Lopez',
        'section': 'Grade 9-Bonifacio',
        'score': 97.5,
        'gender': 'F',
      },
      {
        'name': 'Felicia Torres',
        'section': 'Grade 12-ABM',
        'score': 97.0,
        'gender': 'F',
      },
      {
        'name': 'Rhea Miranda',
        'section': 'Grade 11-HUMSS',
        'score': 96.0,
        'gender': 'F',
      },
      {
        'name': 'Nikki Castillo',
        'section': 'Grade 9-Bonifacio',
        'score': 95.5,
        'gender': 'F',
      },
      {
        'name': 'Andrei Santos',
        'section': 'Grade 10-Aguinaldo',
        'score': 94.5,
        'gender': 'M',
      },
      {
        'name': 'Lara Aguilar',
        'section': 'Grade 9-Rizal',
        'score': 94.0,
        'gender': 'F',
      },
      {
        'name': 'Eduardo Bautista',
        'section': 'Grade 9-Rizal',
        'score': 93.0,
        'gender': 'M',
      },
    ],
  };

  List<Map<String, dynamic>> get _currentList =>
      _data[_subjects[_subjectIndex]] ?? [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildHeader()),
          SliverToBoxAdapter(child: _buildSubjectTabs()),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                children: [
                  const Icon(
                    Icons.analytics_rounded,
                    color: Color(0xFF4A90E2),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Analytics Overview',
                    style: TextStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: 200, child: _buildBarChart()),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: Row(
                children: [
                  const Icon(
                    Icons.pie_chart_rounded,
                    color: Color(0xFF50C878),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Grade Level Distribution',
                    style: TextStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: 200, child: _buildPieChart()),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: Row(
                children: [
                  const Icon(
                    Icons.emoji_events_rounded,
                    color: Color(0xFFF5A623),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Top 10 Students — ${_subjects[_subjectIndex]}',
                    style: const TextStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, i) => _RankCard(student: _currentList[i], rank: i + 1),
              childCount: _currentList.length,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }

  Widget _buildBarChart() {
    final scores = _currentList.map((s) => s['score'] as double).toList();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: 100,
            barTouchData: BarTouchData(enabled: false),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, _) {
                    if (value.toInt() < scores.length) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          '#${value.toInt() + 1}',
                          style: const TextStyle(
                            fontFamily: 'Urbanist',
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 25,
                  getTitlesWidget: (value, _) => Text(
                    value.toInt().toString(),
                    style: const TextStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 10,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                ),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            borderData: FlBorderData(show: false),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: 25,
              getDrawingHorizontalLine: (value) =>
                  FlLine(color: const Color(0xFFE5E7EB), strokeWidth: 1),
            ),
            barGroups: scores.asMap().entries.map((e) {
              final color = e.key == 0
                  ? const Color(0xFFF5A623)
                  : e.key == 1
                  ? const Color(0xFF9CA3AF)
                  : e.key == 2
                  ? const Color(0xFFCD7F32)
                  : const Color(0xFF4A90E2);
              return BarChartGroupData(
                x: e.key,
                barRods: [
                  BarChartRodData(
                    toY: e.value,
                    color: color,
                    width: 20,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(6),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildPieChart() {
    final sections = <String, int>{};
    for (final s in _currentList) {
      final section = s['section'] as String;
      final level = section.contains('Grade 11') || section.contains('Grade 12')
          ? 'SHS'
          : section.contains('Grade 7') ||
                section.contains('Grade 8') ||
                section.contains('Grade 9') ||
                section.contains('Grade 10')
          ? 'JHS'
          : 'ELEM';
      sections[level] = (sections[level] ?? 0) + 1;
    }

    final colors = {
      'SHS': const Color(0xFF4A90E2),
      'JHS': const Color(0xFF50C878),
      'ELEM': const Color(0xFFFF6B35),
    };

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                  sections: sections.entries.map((e) {
                    return PieChartSectionData(
                      value: e.value.toDouble(),
                      color: colors[e.key] ?? const Color(0xFF4A90E2),
                      radius: 50,
                      title: '${e.value}',
                      titleStyle: const TextStyle(
                        fontFamily: 'Urbanist',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _LegendItem(color: colors['SHS']!, label: 'Senior High'),
                const SizedBox(height: 8),
                _LegendItem(color: colors['JHS']!, label: 'Junior High'),
                const SizedBox(height: 8),
                _LegendItem(color: colors['ELEM']!, label: 'Elementary'),
              ],
            ),
            const SizedBox(width: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0D2137), Color(0xFF1A3F6F), Color(0xFF2E6AAD)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Statistics',
                style: TextStyle(
                  fontFamily: 'Urbanist',
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Top 10 Students per Subject',
                style: TextStyle(
                  fontFamily: 'Urbanist',
                  fontSize: 13,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubjectTabs() {
    return Container(
      color: const Color(0xFF1A3F6F),
      height: 52,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        itemCount: _subjects.length,
        itemBuilder: (context, i) {
          final isActive = _subjectIndex == i;
          return GestureDetector(
            onTap: () => setState(() => _subjectIndex = i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: isActive ? Colors.white : Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _subjects[i],
                style: TextStyle(
                  fontFamily: 'Urbanist',
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: isActive ? const Color(0xFF1A3F6F) : Colors.white70,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Urbanist',
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF4B5563),
          ),
        ),
      ],
    );
  }
}

class _RankCard extends StatelessWidget {
  final Map<String, dynamic> student;
  final int rank;

  const _RankCard({required this.student, required this.rank});

  Color get _rankColor {
    if (rank == 1) return const Color(0xFFF5A623);
    if (rank == 2) return const Color(0xFF9CA3AF);
    if (rank == 3) return const Color(0xFFCD7F32);
    return const Color(0xFF4A90E2);
  }

  Widget _rankBadge() {
    if (rank <= 3) {
      return Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: _rankColor.withOpacity(0.15),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Icon(Icons.emoji_events_rounded, color: _rankColor, size: 24),
        ),
      );
    }
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: const Color(0xFF4A90E2).withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          '#$rank',
          style: const TextStyle(
            fontFamily: 'Urbanist',
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: Color(0xFF4A90E2),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isFemale = student['gender'] == 'F';
    final avatarColor = isFemale
        ? const Color(0xFFEC4899)
        : const Color(0xFF4A90E2);
    final nameInitials =
        student['name'].toString().split(' ').first[0] +
        student['name'].toString().split(' ').last[0];

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: rank <= 3 ? _rankColor.withOpacity(0.06) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: rank <= 3
            ? Border.all(color: _rankColor.withOpacity(0.3), width: 1.5)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            _rankBadge(),
            const SizedBox(width: 12),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: avatarColor.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  nameInitials,
                  style: TextStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: avatarColor,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
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
                    student['section'],
                    style: const TextStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 12,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  student['score'].toStringAsFixed(1),
                  style: TextStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: _rankColor,
                  ),
                ),
                Text(
                  'Average',
                  style: TextStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 10,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
