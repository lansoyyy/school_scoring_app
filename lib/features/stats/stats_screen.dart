import 'package:flutter/material.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _subjects = [
    'ALL',
    'MATH',
    'SCIENCE',
    'ENGLISH',
    'FILIPINO',
    'RELIGION',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _subjects.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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

  List<Map<String, dynamic>> _listFor(String subject) => _data[subject] ?? [];

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
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              labelStyle: const TextStyle(
                fontFamily: 'Urbanist',
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
              unselectedLabelStyle: const TextStyle(
                fontFamily: 'Urbanist',
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              labelColor: const Color(0xFF1A1A1A),
              unselectedLabelColor: const Color(0xFF888888),
              indicatorColor: const Color(0xFFD4A017),
              indicatorWeight: 3,
              indicatorSize: TabBarIndicatorSize.label,
              tabs: _subjects.map((s) => Tab(text: s)).toList(),
            ),
          ),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: _subjects
                  .map((s) => _buildRankList(_listFor(s)))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      color: const Color(0xFFF5F5F5),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: const Text(
            'Statistics',
            style: TextStyle(
              fontFamily: 'Urbanist',
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1A1A),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRankList(List<Map<String, dynamic>> students) {
    // Group students by grade/level
    final groupedStudents = <String, List<Map<String, dynamic>>>{};
    for (var s in students) {
      final section = s['section'] as String;
      final gradeMatch = RegExp(r'(Grade \d+)').firstMatch(section);
      final grade = gradeMatch != null ? gradeMatch.group(1)! : 'Other';

      if (!groupedStudents.containsKey(grade)) {
        groupedStudents[grade] = [];
      }
      groupedStudents[grade]!.add(s);
    }

    final sortedGrades = groupedStudents.keys.toList()
      ..sort((a, b) {
        if (a == 'Other') return 1;
        if (b == 'Other') return -1;
        final numA = int.parse(a.split(' ')[1]);
        final numB = int.parse(b.split(' ')[1]);
        return numB.compareTo(numA); // Descending order (Grade 12 -> Grade 9)
      });

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: sortedGrades.length,
      itemBuilder: (context, i) {
        final grade = sortedGrades[i];
        final gradeStudents = groupedStudents[grade]!;

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
            ...gradeStudents.asMap().entries.map((entry) {
              final index = entry.key;
              final s = entry.value;
              final rank = index + 1;
              final initials =
                  s['name'].toString().split(' ').first[0] +
                  s['name'].toString().split(' ').last[0];

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 24,
                          child: Text(
                            '$rank',
                            style: const TextStyle(
                              fontFamily: 'Urbanist',
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1A1A1A),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
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
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                s['name'],
                                style: const TextStyle(
                                  fontFamily: 'Urbanist',
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1A1A1A),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                s['section'],
                                style: const TextStyle(
                                  fontFamily: 'Urbanist',
                                  fontSize: 12,
                                  color: Color(0xFF888888),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          (s['score'] as double).toStringAsFixed(1),
                          style: const TextStyle(
                            fontFamily: 'Urbanist',
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (index < gradeStudents.length - 1)
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
