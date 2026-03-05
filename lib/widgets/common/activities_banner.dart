import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../core/constants/app_constants.dart';

class ActivitiesBanner extends StatefulWidget {
  const ActivitiesBanner({super.key});

  @override
  State<ActivitiesBanner> createState() => _ActivitiesBannerState();
}

class _ActivitiesBannerState extends State<ActivitiesBanner> {
  String? _bannerUrl;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchBannerUrl();
  }

  Future<void> _fetchBannerUrl() async {
    try {
      final response = await http
          .get(Uri.parse('${AppConstants.apiBaseUrl}/system'))
          .timeout(
            const Duration(milliseconds: AppConstants.connectionTimeout),
          );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty && data[0]['banner'] != null) {
          setState(() {
            _bannerUrl = data[0]['banner'] as String;
            _isLoading = false;
          });
        } else {
          setState(() => _isLoading = false);
        }
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      color: const Color(0xFFD4A017),
      child: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : _bannerUrl != null
          ? Image.network(
              _bannerUrl!,
              width: double.infinity,

              errorBuilder: (context, error, stackTrace) {
                return _buildDefaultBanner();
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              },
            )
          : _buildDefaultBanner(),
    );
  }

  Widget _buildDefaultBanner() {
    return Padding(
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
          Icon(
            Icons.arrow_forward_ios,
            color: Colors.white.withOpacity(0.8),
            size: 14,
          ),
        ],
      ),
    );
  }
}
