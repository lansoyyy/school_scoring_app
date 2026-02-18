import 'package:flutter/material.dart';
import 'students_screen.dart';

class SectionsScreen extends StatefulWidget {
  const SectionsScreen({super.key});

  @override
  State<SectionsScreen> createState() => _SectionsScreenState();
}

class _SectionsScreenState extends State<SectionsScreen> {
  int _filterIndex = 0;
  final List<String> _filters = ['ALL', 'ELEM', 'JHS', 'SHS'];

  static final List<Map<String, dynamic>> _sections = [
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

  List<Map<String, dynamic>> get _filtered {
    if (_filterIndex == 0) return _sections;
    final level = _filters[_filterIndex];
    return _sections.where((s) => s['level'] == level).toList();
  }

  String _levelLabel(int index) {
    switch (index) {
      case 1:
        return 'Elementary';
      case 2:
        return 'Junior High School';
      case 3:
        return 'Senior High School';
      default:
        return 'All Sections';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          _buildHeader(),
          _buildFilterTabs(),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Row(
              children: [
                Text(
                  _levelLabel(_filterIndex),
                  style: const TextStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4A90E2).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${_filtered.length}',
                    style: const TextStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF4A90E2),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.15,
              ),
              itemCount: _filtered.length,
              itemBuilder: (context, i) => _SectionCard(
                section: _filtered[i],
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => StudentsScreen(section: _filtered[i]),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sections',
                    style: TextStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Don Stevens Institute',
                    style: TextStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 13,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.search_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterTabs() {
    return Container(
      color: const Color(0xFF1A3F6F),
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
      child: Row(
        children: List.generate(_filters.length, (i) {
          final isActive = _filterIndex == i;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _filterIndex = i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isActive
                      ? Colors.white
                      : Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  _filters[i],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: isActive ? const Color(0xFF1A3F6F) : Colors.white70,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final Map<String, dynamic> section;
  final VoidCallback onTap;

  const _SectionCard({required this.section, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = Color(section['color'] as int);
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 6,
              decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [color, color.withOpacity(0.7)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: color.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          section['logo'],
                          style: const TextStyle(
                            fontFamily: 'Urbanist',
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      section['name'],
                      style: const TextStyle(
                        fontFamily: 'Urbanist',
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A2E),
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Icon(
                          Icons.person_outline,
                          size: 12,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            '${section['count']} students',
                            style: const TextStyle(
                              fontFamily: 'Urbanist',
                              fontSize: 11,
                              color: Color(0xFF6B7280),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
