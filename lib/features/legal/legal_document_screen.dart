import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

class LegalSectionData {
  const LegalSectionData({
    required this.title,
    this.paragraphs = const <String>[],
    this.bullets = const <String>[],
    this.isHighlighted = false,
  });

  final String title;
  final List<String> paragraphs;
  final List<String> bullets;
  final bool isHighlighted;
}

class LegalDocumentScreen extends StatelessWidget {
  const LegalDocumentScreen({
    super.key,
    required this.title,
    required this.lastUpdated,
    required this.icon,
    required this.introParagraphs,
    required this.sections,
  });

  final String title;
  final String lastUpdated;
  final IconData icon;
  final List<String> introParagraphs;
  final List<LegalSectionData> sections;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
        ),
      ),
      body: SafeArea(
        child: SelectionArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _DocumentHeader(
                  title: title,
                  lastUpdated: lastUpdated,
                  icon: icon,
                  paragraphs: introParagraphs,
                ),
                const SizedBox(height: 20),
                ...sections.map(_buildSectionCard),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard(LegalSectionData section) {
    final borderColor = section.isHighlighted
        ? AppColors.primary.withValues(alpha: 0.14)
        : AppColors.border;
    final backgroundColor = section.isHighlighted
        ? const Color(0xFFF8FAFC)
        : AppColors.surface;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            section.title,
            style: const TextStyle(
              fontFamily: 'Urbanist',
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          if (section.paragraphs.isNotEmpty) const SizedBox(height: 12),
          ..._buildParagraphs(section.paragraphs),
          if (section.bullets.isNotEmpty) ...[
            if (section.paragraphs.isNotEmpty) const SizedBox(height: 12),
            ...section.bullets.map(_BulletPoint.new),
          ],
        ],
      ),
    );
  }

  List<Widget> _buildParagraphs(List<String> paragraphs) {
    return paragraphs
        .map(
          (paragraph) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              paragraph,
              style: const TextStyle(
                fontFamily: 'Urbanist',
                fontSize: 15,
                height: 1.6,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        )
        .toList();
  }
}

class _DocumentHeader extends StatelessWidget {
  const _DocumentHeader({
    required this.title,
    required this.lastUpdated,
    required this.icon,
    required this.paragraphs,
  });

  final String title;
  final String lastUpdated;
  final IconData icon;
  final List<String> paragraphs;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF8FAFC), Color(0xFFFFFFFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Urbanist',
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.gray100,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              lastUpdated,
              style: const TextStyle(
                fontFamily: 'Urbanist',
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 18),
          ...paragraphs.map(
            (paragraph) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                paragraph,
                style: const TextStyle(
                  fontFamily: 'Urbanist',
                  fontSize: 15,
                  height: 1.6,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BulletPoint extends StatelessWidget {
  const _BulletPoint(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 7,
            height: 7,
            margin: const EdgeInsets.only(top: 8),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontFamily: 'Urbanist',
                fontSize: 15,
                height: 1.6,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
