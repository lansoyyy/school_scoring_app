import 'package:flutter/material.dart';
import '../features/home/home_screen.dart';
import '../features/sports/sports_screen.dart';
import '../features/live/live_screen.dart';
import '../features/sections/sections_screen.dart';
import '../features/stats/stats_screen.dart';
import '../widgets/common/activities_banner.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  // Each element tracks how many times that tab has been tapped.
  // Incrementing forces a new ValueKey, which rebuilds the screen and
  // triggers initState (and thus the API call) on every tap.
  final List<int> _tapCounts = [0, 0, 0, 0, 0];

  void _onNavTap(int index) {
    setState(() {
      _currentIndex = index;
      _tapCounts[index]++;
    });
  }

  Widget _buildScreen() {
    switch (_currentIndex) {
      case 0:
        return HomeScreen(key: ValueKey('home_${_tapCounts[0]}'));
      case 1:
        return SportsScreen(key: ValueKey('sports_${_tapCounts[1]}'));
      case 2:
        return LiveScreen(key: ValueKey('live_${_tapCounts[2]}'));
      case 3:
        return SectionsScreen(key: ValueKey('sections_${_tapCounts[3]}'));
      case 4:
        return StatsScreen(key: ValueKey('stats_${_tapCounts[4]}'));
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildScreen(),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const ActivitiesBanner(),
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Color(0xFFE8E8E8), width: 1),
              ),
            ),
            child: SafeArea(
              child: SizedBox(
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _NavItem(
                      icon: Icons.home_outlined,
                      activeIcon: Icons.home,
                      label: 'Home',
                      isActive: _currentIndex == 0,
                      onTap: () => _onNavTap(0),
                    ),
                    _NavItem(
                      icon: Icons.calendar_today_outlined,
                      activeIcon: Icons.calendar_today,
                      label: 'Games',
                      isActive: _currentIndex == 1,
                      onTap: () => _onNavTap(1),
                    ),
                    _NavItem(
                      icon: Icons.play_circle_outline,
                      activeIcon: Icons.play_circle,
                      label: 'Live',
                      isActive: _currentIndex == 2,
                      onTap: () => _onNavTap(2),
                    ),
                    _NavItem(
                      icon: Icons.people_outline,
                      activeIcon: Icons.people,
                      label: 'Teams',
                      isActive: _currentIndex == 3,
                      onTap: () => _onNavTap(3),
                    ),
                    _NavItem(
                      icon: Icons.bar_chart_outlined,
                      activeIcon: Icons.bar_chart,
                      label: 'Statistics',
                      isActive: _currentIndex == 4,
                      onTap: () => _onNavTap(4),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 64,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              color: isActive
                  ? const Color(0xFF1A1A1A)
                  : const Color(0xFFAAAAAA),
              size: 24,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Urbanist',
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                color: isActive
                    ? const Color(0xFF1A1A1A)
                    : const Color(0xFFAAAAAA),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
