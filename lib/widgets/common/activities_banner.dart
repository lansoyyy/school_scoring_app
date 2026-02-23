import 'package:flutter/material.dart';

class ActivitiesBanner extends StatelessWidget {
  const ActivitiesBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFD4A017),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          const Icon(Icons.campaign, color: Colors.white, size: 20),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'Upcoming: Intramurals 2026 Opening Ceremony - Feb 24',
              style: TextStyle(
                fontFamily: 'Urbanist',
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          Icon(Icons.arrow_forward_ios, color: Colors.white.withOpacity(0.8), size: 14),
        ],
      ),
    );
  }
}
