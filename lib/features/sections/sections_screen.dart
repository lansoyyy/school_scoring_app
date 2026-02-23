import 'package:flutter/material.dart';
import 'students_screen.dart';

class SectionsScreen extends StatefulWidget {
  const SectionsScreen({super.key});

  @override
  State<SectionsScreen> createState() => _SectionsScreenState();
}

class _SectionsScreenState extends State<SectionsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  static final List<Map<String, dynamic>> _sections = [
    {
      'name': 'Prep-Apple',
      'level': 'PREP',
      'adviser': 'Ms. Gomez',
      'count': 25,
      'color': 0xFFFFB6C1,
      'logo': 'P-A',
    },
    {
      'name': 'Prep-Orange',
      'level': 'PREP',
      'adviser': 'Ms. Lim',
      'count': 24,
      'color': 0xFFFFDAB9,
      'logo': 'P-O',
    },
    {
      'name': 'Grade 1-Sampaguita',
      'level': 'ELEM',
      'adviser': 'Ms. Reyes',
      'count': 38,
      'color': 0xFF4A90E2,
      'logo': 'G1-S',
    },
    {
      'name': 'Grade 1-Rosal',
      'level': 'ELEM',
      'adviser': 'Ms. Santos',
      'count': 36,
      'color': 0xFF50C878,
      'logo': 'G1-R',
    },
    {
      'name': 'Grade 2-Jasmine',
      'level': 'ELEM',
      'adviser': 'Ms. Cruz',
      'count': 40,
      'color': 0xFFFF6B35,
      'logo': 'G2-J',
    },
    {
      'name': 'Grade 2-Adelfa',
      'level': 'ELEM',
      'adviser': 'Mr. Dela Cruz',
      'count': 37,
      'color': 0xFF7C3AED,
      'logo': 'G2-A',
    },
    {
      'name': 'Grade 3-Dahlia',
      'level': 'ELEM',
      'adviser': 'Ms. Garcia',
      'count': 39,
      'color': 0xFF00A896,
      'logo': 'G3-D',
    },
    {
      'name': 'Grade 4-Ilang-Ilang',
      'level': 'ELEM',
      'adviser': 'Mr. Lopez',
      'count': 35,
      'color': 0xFFF5A623,
      'logo': 'G4-I',
    },
    {
      'name': 'Grade 5-Cadena de Amor',
      'level': 'ELEM',
      'adviser': 'Ms. Flores',
      'count': 38,
      'color': 0xFFEF4444,
      'logo': 'G5-C',
    },
    {
      'name': 'Grade 6-Orchid',
      'level': 'ELEM',
      'adviser': 'Mr. Mendoza',
      'count': 36,
      'color': 0xFF0077B6,
      'logo': 'G6-O',
    },
    {
      'name': 'Grade 7-Einstein',
      'level': 'JHS',
      'adviser': 'Ms. Bautista',
      'count': 42,
      'color': 0xFF4A90E2,
      'logo': 'G7-E',
    },
    {
      'name': 'Grade 7-Newton',
      'level': 'JHS',
      'adviser': 'Ms. Villanueva',
      'count': 40,
      'color': 0xFF50C878,
      'logo': 'G7-N',
    },
    {
      'name': 'Grade 8-Sampaguita',
      'level': 'JHS',
      'adviser': 'Mr. Aquino',
      'count': 41,
      'color': 0xFFFF6B35,
      'logo': 'G8-S',
    },
    {
      'name': 'Grade 8-Rosal',
      'level': 'JHS',
      'adviser': 'Ms. Ramos',
      'count': 39,
      'color': 0xFF7C3AED,
      'logo': 'G8-R',
    },
    {
      'name': 'Grade 9-Rizal',
      'level': 'JHS',
      'adviser': 'Mr. Torres',
      'count': 43,
      'color': 0xFF00A896,
      'logo': 'G9-R',
    },
    {
      'name': 'Grade 9-Bonifacio',
      'level': 'JHS',
      'adviser': 'Ms. Aguilar',
      'count': 40,
      'color': 0xFFF5A623,
      'logo': 'G9-B',
    },
    {
      'name': 'Grade 10-Aguinaldo',
      'level': 'JHS',
      'adviser': 'Mr. Pascual',
      'count': 42,
      'color': 0xFFEF4444,
      'logo': 'G10-A',
    },
    {
      'name': 'Grade 10-Mabini',
      'level': 'JHS',
      'adviser': 'Ms. Navarro',
      'count': 38,
      'color': 0xFF0077B6,
      'logo': 'G10-M',
    },
    {
      'name': 'Grade 11-STEM',
      'level': 'SHS',
      'adviser': 'Mr. Fernandez',
      'count': 44,
      'color': 0xFF4A90E2,
      'logo': 'STEM',
    },
    {
      'name': 'Grade 11-ABM',
      'level': 'SHS',
      'adviser': 'Ms. Castillo',
      'count': 40,
      'color': 0xFF50C878,
      'logo': 'ABM',
    },
    {
      'name': 'Grade 11-HUMSS',
      'level': 'SHS',
      'adviser': 'Ms. Morales',
      'count': 38,
      'color': 0xFFFF6B35,
      'logo': 'HUMSS',
    },
    {
      'name': 'Grade 12-STEM',
      'level': 'SHS',
      'adviser': 'Mr. Jimenez',
      'count': 42,
      'color': 0xFF7C3AED,
      'logo': 'STEM',
    },
    {
      'name': 'Grade 12-ABM',
      'level': 'SHS',
      'adviser': 'Ms. Guerrero',
      'count': 36,
      'color': 0xFF00A896,
      'logo': 'ABM',
    },
    {
      'name': 'Grade 12-GAS',
      'level': 'SHS',
      'adviser': 'Mr. Miranda',
      'count': 39,
      'color': 0xFFF5A623,
      'logo': 'GAS',
    },
  ];

  List<Map<String, dynamic>> _byLevel(String level) =>
      _sections.where((s) => s['level'] == level).toList();

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
                Tab(text: 'PREP'),
                Tab(text: 'ELEM'),
                Tab(text: 'JHS'),
                Tab(text: 'SHS'),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          Expanded(
            child: TabBarView(
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
      width: double.infinity,
      color: const Color(0xFFF5F5F5),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: const Text(
            'SECTIONS',
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

  Widget _buildSectionList(
    List<Map<String, dynamic>> sections,
    BuildContext context,
  ) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: sections.length,
      separatorBuilder: (_, __) =>
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
      itemBuilder: (context, i) {
        final s = sections[i];
        final initials = s['logo'] as String;
        return InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => StudentsScreen(section: s)),
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
                  child: Center(
                    child: Text(
                      initials.length > 3 ? initials.substring(0, 3) : initials,
                      style: const TextStyle(
                        fontFamily: 'Urbanist',
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
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
                        '${s['adviser']} · ${s['count']} students',
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
