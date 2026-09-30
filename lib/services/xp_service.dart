class XPService {
  // XP required to ENTER each level.
  //
  // Level 1:    0 XP
  // Level 2:  100 XP
  // Level 3:  250 XP
  // Level 4:  450 XP
  // Level 5:  700 XP
  // Level 6: 1000 XP
  // Level 7: 1400 XP
  // Level 8: 1800 XP
  // ...

  static int getLevel(int totalXP) {
    if (totalXP < 100) return 1;
    if (totalXP < 250) return 2;
    if (totalXP < 450) return 3;
    if (totalXP < 700) return 4;
    if (totalXP < 1000) return 5;

    return 6 + ((totalXP - 1000) ~/ 400);
  }

  static int getLevelStartXP(int level) {
    switch (level) {
      case 1:
        return 0;
      case 2:
        return 100;
      case 3:
        return 250;
      case 4:
        return 450;
      case 5:
        return 700;
      case 6:
        return 1000;
      default:
        return 1000 + ((level - 6) * 400);
    }
  }

  static int getNextLevelXP(int level) {
    return getLevelStartXP(level + 1);
  }

  static double getProgress(int totalXP) {
    final level = getLevel(totalXP);
    final startXP = getLevelStartXP(level);
    final nextXP = getNextLevelXP(level);

    if (nextXP <= startXP) {
      return 1.0;
    }

    final progress =
        (totalXP - startXP) / (nextXP - startXP);

    return progress.clamp(0.0, 1.0);
  }

  static int getXPIntoLevel(int totalXP) {
    final level = getLevel(totalXP);
    return totalXP - getLevelStartXP(level);
  }

  static int getXPNeededForLevel(int level) {
    return getNextLevelXP(level) -
        getLevelStartXP(level);
  }
}