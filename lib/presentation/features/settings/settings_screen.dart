import 'package:flutter/material.dart';
import 'package:media_guard_v2/core/constaints/app_strings.dart';
import 'package:media_guard_v2/router/routes_named.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isLanguageExpanded = false;

  @override
  Widget build(BuildContext context) {
    final iconColor = Theme.of(context).textTheme.bodyLarge?.color;
    final textStyle = Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 16);
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.settings),
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
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.security, color: iconColor),
            title: Text(AppStrings.viewFailedAttempts, style: textStyle),
            onTap: () => Navigator.pushNamed(context, RoutesNamed.unlockFailed),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
            minLeadingWidth: 32,
          ),
          ListTile(
            leading: Icon(Icons.help_outline, color: iconColor),
            title: Text(AppStrings.help, style: textStyle),
            onTap: () => Navigator.pushNamed(context, RoutesNamed.help),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
            minLeadingWidth: 32,
          ),
          _buildLanguageTile(iconColor, textStyle),
          // _buildThemeTile(context, iconColor, textStyle),
        ],
      ),
    );
  }

  Widget _buildLanguageTile(Color? iconColor, TextStyle? textStyle) {
    return Column(
      children: [
        ListTile(
          leading: Icon(Icons.language, color: iconColor),
          title: Text(AppStrings.language, style: textStyle),
          trailing: !_isLanguageExpanded
              ? Text(
                  AppStrings.currentLanguage == Language.english ? AppStrings.english : AppStrings.vietnamese,
                  style: textStyle?.copyWith(fontWeight: FontWeight.w500),
                )
              : null,
          onTap: () {
            setState(() {
              _isLanguageExpanded = !_isLanguageExpanded;
            });
          },
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
          minLeadingWidth: 32,
        ),
        if (_isLanguageExpanded)
          Column(
            children: [
              ListTile(
                leading: const Text('🇺🇸', style: TextStyle(fontSize: 20)),
                title: Text(AppStrings.english, style: textStyle),
                trailing: AppStrings.currentLanguage == Language.english ? const Icon(Icons.check, color: Colors.green) : null,
                onTap: () => _selectLanguage(Language.english),
                contentPadding: const EdgeInsets.only(left: 48, right: 20),
                minLeadingWidth: 0,
              ),
              ListTile(
                leading: const Text('🇻🇳', style: TextStyle(fontSize: 20)),
                title: Text(AppStrings.vietnamese, style: textStyle),
                trailing: AppStrings.currentLanguage == Language.vietnamese ? const Icon(Icons.check, color: Colors.green) : null,
                onTap: () => _selectLanguage(Language.vietnamese),
                contentPadding: const EdgeInsets.only(left: 48, right: 20),
                minLeadingWidth: 0,
              ),
            ],
          ),
      ],
    );
  }

  void _selectLanguage(Language language) {
    AppStrings.setLanguage(language);
    setState(() {
      _isLanguageExpanded = false;
    });
  }

  // Widget _buildThemeTile(BuildContext context, Color? iconColor, TextStyle? textStyle) {
  //   final themeManager = Provider.of<ThemeManager>(context);
  //   final isDark = themeManager.themeMode == ThemeMode.dark;
  //   return ListTile(
  //     leading: Icon(isDark ? Icons.dark_mode : Icons.light_mode, color: iconColor),
  //     title: Text(isDark ? 'Dark Mode' : 'Light Mode', style: textStyle),
  //     trailing: Switch(
  //       value: isDark,
  //       onChanged: (value) {
  //         themeManager.setThemeMode(value ? ThemeMode.dark : ThemeMode.light);
  //       },
  //     ),
  //     contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
  //     minLeadingWidth: 32,
  //   );
  // }
}
