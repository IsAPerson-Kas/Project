import 'package:flutter/material.dart';
import 'package:media_guard_v2/core/constaints/app_strings.dart';
import 'package:media_guard_v2/core/extensions/color_extension.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.help),
        titleTextStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w800,
          color: Colors.black,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              title: AppStrings.helpOverview,
              content: AppStrings.helpOverviewContent,
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: AppStrings.helpMainScreen,
              content: AppStrings.helpMainScreenContent,
            ),
            const SizedBox(height: 20),
            _buildSection(
              title: AppStrings.helpSettings,
              content: AppStrings.helpSettingsContent,
            ),
            const SizedBox(height: 20),
            _buildSection(
              title: AppStrings.helpCamera,
              content: AppStrings.helpCameraContent,
            ),
            const SizedBox(height: 20),
            _buildSection(
              title: AppStrings.helpAlbumDetail,
              content: AppStrings.helpAlbumDetailContent,
            ),
            const SizedBox(height: 20),
            _buildSection(
              title: AppStrings.helpSecurity,
              content: AppStrings.helpSecurityContent,
            ),
            const SizedBox(height: 20),
            _buildSection(
              title: AppStrings.helpNotes,
              content: AppStrings.helpNotesContent,
            ),
            const SizedBox(height: 20),
            _buildSection(
              title: AppStrings.helpSupport,
              content: AppStrings.helpSupportContent,
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required String content}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacityValue(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black54,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
