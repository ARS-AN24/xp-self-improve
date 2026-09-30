import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/task.dart';

class StorageService {
  static const String nicknameKey = 'nickname';
  static const String totalXPKey = 'totalXP';
  static const String tasksKey = 'tasks';
  static const String completionsKey = 'completions';
  static const String achievementsKey = 'achievements';
  static const String resetHourKey = 'resetHour';
  static const String themeKey = 'theme';
  static const String accentColorKey = 'accentColor';
  static const String languageKey = 'language';

  static Future<SharedPreferences> get _prefs async {
    return await SharedPreferences.getInstance();
  }

  static Future<void> saveNickname(String nickname) async {
    final prefs = await _prefs;
    await prefs.setString(nicknameKey, nickname);
  }

  static Future<String?> getNickname() async {
    final prefs = await _prefs;
    return prefs.getString(nicknameKey);
  }

  static Future<void> saveTotalXP(int xp) async {
    final prefs = await _prefs;
    await prefs.setInt(totalXPKey, xp);
  }

  static Future<int> getTotalXP() async {
    final prefs = await _prefs;
    return prefs.getInt(totalXPKey) ?? 0;
  }

  static Future<void> saveTasks(List<Task> tasks) async {
    final prefs = await _prefs;

    final data = tasks.map((task) => task.toJson()).toList();

    await prefs.setString(
      tasksKey,
      jsonEncode(data),
    );
  }

  static Future<List<Task>> getTasks() async {
    final prefs = await _prefs;

    final raw = prefs.getString(tasksKey);

    if (raw == null || raw.isEmpty) {
      return [];
    }

    final decoded = jsonDecode(raw);

    if (decoded is! List) {
      return [];
    }

    return decoded
        .map(
          (item) => Task.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
        .toList();
  }

  static Future<void> saveCompletions(
    List<Map<String, dynamic>> completions,
  ) async {
    final prefs = await _prefs;

    await prefs.setString(
      completionsKey,
      jsonEncode(completions),
    );
  }

  static Future<List<Map<String, dynamic>>> getCompletions() async {
    final prefs = await _prefs;

    final raw = prefs.getString(completionsKey);

    if (raw == null || raw.isEmpty) {
      return [];
    }

    final decoded = jsonDecode(raw);

    if (decoded is! List) {
      return [];
    }

    return decoded.map<Map<String, dynamic>>((item) {
      return Map<String, dynamic>.from(item);
    }).toList();
  }

  static Future<void> saveAchievements(
    List<String> achievements,
  ) async {
    final prefs = await _prefs;

    await prefs.setStringList(
      achievementsKey,
      achievements,
    );
  }

  static Future<List<String>> getAchievements() async {
    final prefs = await _prefs;

    return prefs.getStringList(achievementsKey) ?? [];
  }

  static Future<void> saveResetHour(int hour) async {
    final prefs = await _prefs;

    await prefs.setInt(
      resetHourKey,
      hour,
    );
  }

  static Future<int> getResetHour() async {
    final prefs = await _prefs;

    return prefs.getInt(resetHourKey) ?? 0;
  }

  static Future<void> saveTheme(String theme) async {
    final prefs = await _prefs;

    await prefs.setString(
      themeKey,
      theme,
    );
  }

  static Future<String> getTheme() async {
    final prefs = await _prefs;

    return prefs.getString(themeKey) ?? 'dark';
  }

  static Future<void> saveAccentColor(int colorValue) async {
    final prefs = await _prefs;

    await prefs.setInt(
      accentColorKey,
      colorValue,
    );
  }

  static Future<int> getAccentColor() async {
    final prefs = await _prefs;

    return prefs.getInt(accentColorKey) ?? 0xFF4D8DFF;
  }

  static Future<void> saveLanguage(String language) async {
    final prefs = await _prefs;

    await prefs.setString(
      languageKey,
      language,
    );
  }

  static Future<String> getLanguage() async {
    final prefs = await _prefs;

    return prefs.getString(languageKey) ?? 'en';
  }
}