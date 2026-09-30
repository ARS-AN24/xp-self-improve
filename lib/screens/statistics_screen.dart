import 'dart:ui';

import 'package:flutter/material.dart';

import '../models/task.dart';
import '../services/app_state.dart';

class StatisticsScreen extends StatelessWidget {
  final AppState appState;

  const StatisticsScreen({
    super.key,
    required this.appState,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isLight = theme.brightness == Brightness.light;
    final strings = appState.strings;

    final now = DateTime.now();

    int xpForDate(String date) {
      return appState.completions
          .where((completion) => completion['date'] == date)
          .fold<int>(
            0,
            (sum, completion) =>
                sum + (completion['xp'] as int),
          );
    }

    String dateKey(DateTime date) {
      final year = date.year.toString().padLeft(4, '0');
      final month = date.month.toString().padLeft(2, '0');
      final day = date.day.toString().padLeft(2, '0');

      return '$year-$month-$day';
    }

    final todayDate = DateTime(
      now.year,
      now.month,
      now.day,
    );

    final weekXP = List.generate(7, (index) {
      final date =
          todayDate.subtract(Duration(days: 6 - index));
      return xpForDate(dateKey(date));
    });

    final weekTotal =
        weekXP.fold<int>(0, (a, b) => a + b);

    final monthPrefix =
        '${now.year.toString().padLeft(4, '0')}-'
        '${now.month.toString().padLeft(2, '0')}';

    final monthXP = appState.completions
        .where(
          (completion) =>
              (completion['date'] as String)
                  .startsWith(monthPrefix),
        )
        .fold<int>(
          0,
          (sum, completion) =>
              sum + (completion['xp'] as int),
        );

    final average =
        weekTotal / 7;

    final bestDay =
        weekXP.isEmpty ? 0 : weekXP.reduce((a, b) => a > b ? a : b);

    final categoryXP = <TaskCategory, int>{};

    for (final completion in appState.completions) {
      final categoryName = completion['category'];

      final category = TaskCategory.values.firstWhere(
        (item) => item.name == categoryName,
        orElse: () => TaskCategory.other,
      );

      categoryXP[category] =
          (categoryXP[category] ?? 0) +
              (completion['xp'] as int);
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          strings.get('statistics'),
          style: const TextStyle(
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            top: -110,
            right: -100,
            child: _Glow(
              color: colors.primary,
              size: 280,
              opacity: isLight ? 0.07 : 0.12,
            ),
          ),
          Positioned(
            top: 370,
            left: -150,
            child: _Glow(
              color: colors.primary,
              size: 300,
              opacity: isLight ? 0.025 : 0.055,
            ),
          ),
          ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(
              20,
              8,
              20,
              35,
            ),
            children: [
              _GlassCard(
                child: Padding(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        strings.get('total_xp'),
                        style: TextStyle(
                          color: colors.onSurface
                              .withValues(alpha: 0.48),
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        '${appState.totalXP}',
                        style: TextStyle(
                          color: colors.onSurface,
                          fontSize: 38,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -1.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${strings.get('level')} ${appState.level}',
                        style: TextStyle(
                          color: colors.primary,
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      title: strings.get('today'),
                      value: '${appState.todayXP}',
                      suffix: 'XP',
                    ),
                  ),
                  const SizedBox(width: 11),
                  Expanded(
                    child: _StatCard(
                      title: strings.get('this_week'),
                      value: '$weekTotal',
                      suffix: 'XP',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 11),
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      title: strings.get('this_month'),
                      value: '$monthXP',
                      suffix: 'XP',
                    ),
                  ),
                  const SizedBox(width: 11),
                  Expanded(
                    child: _StatCard(
                      title: strings.get('average_day'),
                      value: average.round().toString(),
                      suffix: 'XP',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 11),
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      title: strings.get('best_day'),
                      value: '$bestDay',
                      suffix: 'XP',
                    ),
                  ),
                  const SizedBox(width: 11),
                  Expanded(
                    child: _StatCard(
                      title: strings.get('streak'),
                      value:
                          _streak(appState).toString(),
                      suffix: strings.get('days'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              Text(
                strings.get('last_7_days'),
                style: TextStyle(
                  color: colors.onSurface,
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.6,
                ),
              ),
              const SizedBox(height: 13),
              _GlassCard(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    16,
                    22,
                    16,
                    18,
                  ),
                  child: SizedBox(
                    height: 190,
                    child: _XPChart(
                      values: weekXP,
                      accent: colors.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              Text(
                strings.get('xp_by_category'),
                style: TextStyle(
                  color: colors.onSurface,
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.6,
                ),
              ),
              const SizedBox(height: 13),
              _GlassCard(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    children: TaskCategory.values.map(
                      (category) {
                        final value =
                            categoryXP[category] ?? 0;

                        return Padding(
                          padding:
                              const EdgeInsets.symmetric(
                            vertical: 7,
                          ),
                          child: _CategoryRow(
                            category: category,
                            value: value,
                            total: appState.totalXP,
                            appState: appState,
                          ),
                        );
                      },
                    ).toList(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  int _streak(AppState state) {
    if (state.completions.isEmpty) {
      return 0;
    }

    final dates = state.completions
        .map(
          (completion) =>
              completion['date'] as String,
        )
        .toSet();

    int streak = 0;
    DateTime current = DateTime.now();

    if (!dates.contains(state.todayKey())) {
      current = current.subtract(
        const Duration(days: 1),
      );
    }

    while (dates.contains(_dateKey(current))) {
      streak++;
      current = current.subtract(
        const Duration(days: 1),
      );
    }

    return streak;
  }

  String _dateKey(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    return '$year-$month-$day';
  }
}

class _GlassCard extends StatelessWidget {
  final Widget child;

  const _GlassCard({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isLight =
        theme.brightness == Brightness.light;

    return ClipRRect(
      borderRadius: BorderRadius.circular(27),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 28,
          sigmaY: 28,
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(27),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                colors.onSurface.withValues(
                  alpha: isLight ? 0.17 : 0.09,
                ),
                colors.surface.withValues(
                  alpha: isLight ? 0.58 : 0.045,
                ),
                colors.surface.withValues(
                  alpha: isLight ? 0.38 : 0.10,
                ),
              ],
            ),
            border: Border.all(
              color: colors.onSurface.withValues(
                alpha: isLight ? 0.20 : 0.15,
              ),
              width: 1.1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: isLight ? 0.06 : 0.25,
                ),
                blurRadius: 30,
                offset: const Offset(0, 14),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 18,
                right: 18,
                child: Container(
                  height: 1.2,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        colors.onSurface.withValues(
                          alpha: 0.34,
                        ),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String suffix;

  const _StatCard({
    required this.title,
    required this.value,
    required this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isLight =
        theme.brightness == Brightness.light;

    return ClipRRect(
      borderRadius: BorderRadius.circular(23),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 22,
          sigmaY: 22,
        ),
        child: Container(
          padding: const EdgeInsets.all(17),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(23),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                colors.onSurface.withValues(
                  alpha: isLight ? 0.13 : 0.075,
                ),
                colors.surface.withValues(
                  alpha: isLight ? 0.52 : 0.045,
                ),
              ],
            ),
            border: Border.all(
              color: colors.onSurface.withValues(
                alpha: isLight ? 0.16 : 0.13,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: isLight ? 0.045 : 0.18,
                ),
                blurRadius: 20,
                offset: const Offset(0, 9),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: colors.onSurface.withValues(
                    alpha: 0.43,
                  ),
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment:
                    CrossAxisAlignment.end,
                children: [
                  Text(
                    value,
                    style: TextStyle(
                      color: colors.onSurface,
                      fontSize: 23,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Padding(
                    padding:
                        const EdgeInsets.only(bottom: 3),
                    child: Text(
                      suffix,
                      style: TextStyle(
                        color: colors.primary,
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _XPChart extends StatelessWidget {
  final List<int> values;
  final Color accent;

  const _XPChart({
    required this.values,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final maxValue = values.isEmpty
        ? 1
        : values.reduce(
            (a, b) => a > b ? a : b,
          );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(
        values.length,
        (index) {
          final value = values[index];
          final height = maxValue == 0
              ? 4.0
              : 115 * (value / maxValue);

          return Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 5),
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.end,
                children: [
                  if (value > 0)
                    Text(
                      '$value',
                      style: TextStyle(
                        color: colors.onSurface
                            .withValues(alpha: 0.45),
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  const SizedBox(height: 5),
                  AnimatedContainer(
                    duration:
                        const Duration(milliseconds: 400),
                    height: height.clamp(4.0, 115.0),
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(12),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          accent.withValues(alpha: 0.95),
                          accent.withValues(alpha: 0.35),
                        ],
                      ),
                      border: Border.all(
                        color: accent.withValues(
                          alpha: 0.35,
                        ),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: accent.withValues(
                            alpha: 0.22,
                          ),
                          blurRadius: 12,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _dayLabel(
                      DateTime.now().subtract(
                        Duration(
                          days: 6 - index,
                        ),
                      ),
                    ),
                    style: TextStyle(
                      color: colors.onSurface
                          .withValues(alpha: 0.35),
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _dayLabel(DateTime date) {
    const labels = [
      'M',
      'T',
      'W',
      'T',
      'F',
      'S',
      'S',
    ];

    return labels[date.weekday - 1];
  }
}

class _CategoryRow extends StatelessWidget {
  final TaskCategory category;
  final int value;
  final int total;
  final AppState appState;

  const _CategoryRow({
    required this.category,
    required this.value,
    required this.total,
    required this.appState,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final progress = total == 0
        ? 0.0
        : (value / total).clamp(0.0, 1.0);

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                category.localizedName(
                  appState.language,
                ),
                style: TextStyle(
                  color: colors.onSurface,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Text(
              '$value XP',
              style: TextStyle(
                color: colors.onSurface.withValues(
                  alpha: 0.45,
                ),
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 7),
        Container(
          height: 7,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: colors.onSurface.withValues(
              alpha: 0.06,
            ),
            border: Border.all(
              color: colors.onSurface.withValues(
                alpha: 0.08,
              ),
            ),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: progress,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(
                  colors: [
                    colors.primary.withValues(
                      alpha: 0.45,
                    ),
                    colors.primary,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: colors.primary.withValues(
                      alpha: 0.28,
                    ),
                    blurRadius: 8,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Glow extends StatelessWidget {
  final Color color;
  final double size;
  final double opacity;

  const _Glow({
    required this.color,
    required this.size,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: ImageFiltered(
        imageFilter: ImageFilter.blur(
          sigmaX: 65,
          sigmaY: 65,
        ),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withValues(
              alpha: opacity,
            ),
          ),
        ),
      ),
    );
  }
}