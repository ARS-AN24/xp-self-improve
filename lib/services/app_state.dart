import 'package:flutter/foundation.dart';

import '../l10n/app_localizations.dart';
import '../models/achievement.dart';
import '../models/task.dart';
import 'storage_service.dart';
import 'xp_service.dart';
import 'home_widget_service.dart';

class AppState extends ChangeNotifier {
  String? nickname;

  int totalXP = 0;

  List<Task> tasks = [];

  List<Map<String, dynamic>> completions = [];

  List<String> unlockedAchievements = [];

  int resetHour = 0;

  String theme = 'dark';

  int accentColorValue = 0xFF4D8DFF;

  String language = 'en';

  bool loading = true;

  AppLocalizations get strings {
    return AppLocalizations(language);
  }

  int get level {
    return XPService.getLevel(totalXP);
  }

  int get xpIntoLevel {
    return XPService.getXPIntoLevel(totalXP);
  }

  int get xpNeededForLevel {
    return XPService.getXPNeededForLevel(level);
  }

  double get levelProgress {
    return XPService.getProgress(totalXP);
  }

  List<Task> get todaysTasks {
    final weekday = DateTime.now().weekday;

    return tasks.where((task) {
      return task.days.contains(weekday);
    }).toList();
  }

  String todayKey() {
    final now = DateTime.now();

    DateTime resetDate = now;

    if (now.hour < resetHour) {
      resetDate = now.subtract(
        const Duration(days: 1),
      );
    }

    final year = resetDate.year.toString().padLeft(4, '0');
    final month = resetDate.month.toString().padLeft(2, '0');
    final day = resetDate.day.toString().padLeft(2, '0');

    return '$year-$month-$day';
  }

  bool isCompletedToday(Task task) {
    final key = todayKey();

    return completions.any((completion) {
      return completion['taskId'] == task.id &&
          completion['date'] == key;
    });
  }

  int get todayXP {
    final key = todayKey();

    return completions
        .where(
          (completion) =>
              completion['date'] == key,
        )
        .fold<int>(
          0,
          (sum, completion) =>
              sum + (completion['xp'] as int),
        );
  }

  Future<void> load() async {

    nickname = await StorageService.getNickname();

    totalXP = await StorageService.getTotalXP();

    tasks = await StorageService.getTasks();

    completions =
        await StorageService.getCompletions();

    unlockedAchievements =
        await StorageService.getAchievements();

    resetHour =
        await StorageService.getResetHour();

    theme = await StorageService.getTheme();

    accentColorValue =
        await StorageService.getAccentColor();

    language =
        await StorageService.getLanguage();

    await _updateHomeWidget();

    loading = false;

    notifyListeners();
  }

  Future<void> setNickname(String value) async {
  nickname = value;

  await StorageService.saveNickname(value);

  notifyListeners();
}

  Future<void> setTheme(String value) async {
    theme = value;

    await StorageService.saveTheme(value);

    notifyListeners();
  }

  Future<void> setAccentColor(int value) async {
    accentColorValue = value;

    await StorageService.saveAccentColor(value);

    notifyListeners();
  }

  Future<void> setLanguage(String value) async {
    if (!AppLocalizations.supportedLanguages
        .contains(value)) {
      return;
    }

    language = value;

    await StorageService.saveLanguage(value);

    notifyListeners();
  }

  Future<void> setResetHour(int hour) async {
    resetHour = hour;

    await StorageService.saveResetHour(hour);

    await _updateHomeWidget();

    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    tasks.add(task);

    await StorageService.saveTasks(tasks);

    notifyListeners();
  }

  Future<void> deleteTask(Task task) async {
    tasks.removeWhere(
      (item) => item.id == task.id,
    );

    completions.removeWhere(
      (completion) =>
          completion['taskId'] == task.id,
    );

    await StorageService.saveTasks(tasks);

    await StorageService.saveCompletions(
      completions,
    );

    await _updateHomeWidget();

    notifyListeners();
  }

  Future<void> _updateHomeWidget() async {
  await HomeWidgetService.update(
    totalXP: totalXP,
    level: level,
    xpIntoLevel: xpIntoLevel,
    xpNeededForLevel: xpNeededForLevel,
    todayXP: todayXP,
  );
}

  Future<List<Achievement>> toggleTask(
    Task task,
  ) async {
    final alreadyCompleted =
        isCompletedToday(task);

    final key = todayKey();

    if (alreadyCompleted) {
      completions.removeWhere(
        (completion) =>
            completion['taskId'] == task.id &&
            completion['date'] == key,
      );

      totalXP -= task.xp;

      if (totalXP < 0) {
        totalXP = 0;
      }
    } else {
      completions.add({
        'taskId': task.id,
        'date': key,
        'xp': task.xp,
        'category': task.category.name,
      });

      totalXP += task.xp;
    }

    await StorageService.saveTotalXP(totalXP);

    await StorageService.saveCompletions(
      completions,
    );

    await _updateHomeWidget();

    final newlyUnlocked =
        checkAchievements();

    await StorageService.saveAchievements(
      unlockedAchievements,
    );

    notifyListeners();

    return newlyUnlocked;
  }

  List<Achievement> checkAchievements() {
    final newlyUnlocked = <Achievement>[];

    final completedCount =
        completions.length;

    final categoryXP =
        <TaskCategory, int>{};

    for (final completion in completions) {
      final categoryName =
          completion['category'];

      final category =
          TaskCategory.values.firstWhere(
        (item) =>
            item.name == categoryName,
        orElse: () => TaskCategory.other,
      );

      categoryXP[category] =
          (categoryXP[category] ?? 0) +
              (completion['xp'] as int);
    }

    bool unlock(String id) {
      if (unlockedAchievements.contains(id)) {
        return false;
      }

      unlockedAchievements.add(id);

      final achievement =
          AchievementDefinitions.all.firstWhere(
        (item) => item.id == id,
      );

      newlyUnlocked.add(achievement);

      return true;
    }

    if (completedCount >= 1) {
      unlock('first_task');
    }

    if (totalXP >= 100) {
      unlock('100_xp');
    }

    if (totalXP >= 500) {
      unlock('500_xp');
    }

    if (totalXP >= 1000) {
      unlock('1000_xp');
    }

    if (level >= 5) {
      unlock('level_5');
    }

    if (level >= 10) {
      unlock('level_10');
    }

    if (completedCount >= 10) {
      unlock('10_tasks');
    }

    if (completedCount >= 50) {
      unlock('50_tasks');
    }

    if ((categoryXP[TaskCategory.education] ?? 0) >=
        1000) {
      unlock('education_1000');
    }

    if ((categoryXP[TaskCategory.fitness] ?? 0) >=
        1000) {
      unlock('fitness_1000');
    }

    if ((categoryXP[TaskCategory.development] ?? 0) >=
        1000) {
      unlock('development_1000');
    }

    if ((categoryXP[TaskCategory.hobby] ?? 0) >=
        1000) {
      unlock('hobby_1000');
    }

    if ((categoryXP[TaskCategory.mind] ?? 0) >=
        1000) {
      unlock('mind_1000');
    }

    if (hasSevenDayStreak()) {
      unlock('7_day_streak');
    }

    return newlyUnlocked;
  }

  bool hasSevenDayStreak() {
    if (completions.isEmpty) {
      return false;
    }

    final dates = completions
        .map((completion) {
          return completion['date'] as String;
        })
        .toSet();

    final sortedDates = dates.toList()..sort();

    if (sortedDates.length < 7) {
      return false;
    }

    for (int i = 0;
        i <= sortedDates.length - 7;
        i++) {
      bool consecutive = true;

      for (int j = 1; j < 7; j++) {
        final previous =
            DateTime.parse(sortedDates[i + j - 1]);

        final current =
            DateTime.parse(sortedDates[i + j]);

        if (current
                .difference(previous)
                .inDays !=
            1) {
          consecutive = false;
          break;
        }
      }

      if (consecutive) {
        return true;
      }
    }

    return false;
  }

  Future<void> resetProgress() async {
    totalXP = 0;

    completions = [];

    unlockedAchievements = [];

    await StorageService.saveTotalXP(0);

    await StorageService.saveCompletions(
      [],
    );

    await StorageService.saveAchievements(
      [],
    );

    await _updateHomeWidget();

    notifyListeners();
  }
}