import 'package:flutter/material.dart';
import 'package:media_guard_v2/core/constaints/app_strings.dart';

class LanguageSelector extends StatelessWidget {
  final VoidCallback? onLanguageChanged;

  const LanguageSelector({
    super.key,
    this.onLanguageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Language>(
      icon: const Icon(
        Icons.language,
        color: Color(0xFF8B92A5),
      ),
      tooltip: AppStrings.language,
      onSelected: (Language language) {
        AppStrings.setLanguage(language);
        onLanguageChanged?.call();
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<Language>>[
        PopupMenuItem<Language>(
          value: Language.english,
          child: Row(
            children: [
              Text(
                '🇺🇸',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(width: 12),
              Text(AppStrings.english),
              if (AppStrings.currentLanguage == Language.english) const Spacer(),
              if (AppStrings.currentLanguage == Language.english) const Icon(Icons.check, color: Colors.green),
            ],
          ),
        ),
        PopupMenuItem<Language>(
          value: Language.vietnamese,
          child: Row(
            children: [
              Text(
                '🇻🇳',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(width: 12),
              Text(AppStrings.vietnamese),
              if (AppStrings.currentLanguage == Language.vietnamese) const Spacer(),
              if (AppStrings.currentLanguage == Language.vietnamese) const Icon(Icons.check, color: Colors.green),
            ],
          ),
        ),
      ],
    );
  }
}
