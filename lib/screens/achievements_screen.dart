// lib/screens/achievements_screen.dart

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/achievement.dart';
import '../services/app_state.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final strings = appState.strings;
    final colors = Theme.of(context).colorScheme;
    final isLight =
        Theme.of(context).brightness == Brightness.light;

    final achievements = AchievementDefinitions.all;

    return Scaffold(
      backgroundColor:
          Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          strings.get('achievements'),
          style: const TextStyle(
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            top: -120,
            right: -100,
            child: _Glow(
              color: colors.primary,
              size: 280,
              opacity: isLight ? 0.07 : 0.12,
            ),
          ),
          Positioned(
            top: 280,
            left: -150,
            child: _Glow(
              color: colors.primary,
              size: 300,
              opacity: isLight ? 0.025 : 0.06,
            ),
          ),
          ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(
              20,
              8,
              20,
              35,
            ),
            itemCount: achievements.length,
            itemBuilder: (context, index) {
              final achievement = achievements[index];

              final unlocked = appState
                  .unlockedAchievements
                  .contains(achievement.id);

              return Padding(
                padding: const EdgeInsets.only(
                  bottom: 12,
                ),
                child: _AchievementCard(
                  achievement: achievement,
                  unlocked: unlocked,
                  appState: appState,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _AchievementCard extends StatelessWidget {
  final Achievement achievement;
  final bool unlocked;
  final AppState appState;

  const _AchievementCard({
    required this.achievement,
    required this.unlocked,
    required this.appState,
  });

  String _titleKey(String id) {
    switch (id) {
      case 'first_task':
        return 'first_step';
      case '100_xp':
        return 'century';
      case '500_xp':
        return 'getting_serious';
      case '1000_xp':
        return 'xp_master';
      case 'level_5':
        return 'level_5';
      case 'level_10':
        return 'level_10';
      case '10_tasks':
        return 'ten_tasks';
      case '50_tasks':
        return 'fifty_tasks';
      case 'education_1000':
        return 'education_1k';
      case 'fitness_1000':
        return 'fitness_1k';
      case 'development_1000':
        return 'development_1k';
      case 'hobby_1000':
        return 'hobby_1k';
      case 'mind_1000':
        return 'mind_1k';
      case '7_day_streak':
        return 'seven_day_streak';
      default:
        return achievement.title;
    }
  }

  String _descriptionKey(String id) {
    switch (id) {
      case 'first_task':
        return 'first_step_description';
      case '100_xp':
        return 'century_description';
      case '500_xp':
        return 'getting_serious_description';
      case '1000_xp':
        return 'xp_master_description';
      case 'level_5':
        return 'level_5_description';
      case 'level_10':
        return 'level_10_description';
      case '10_tasks':
        return 'ten_tasks_description';
      case '50_tasks':
        return 'fifty_tasks_description';
      case 'education_1000':
        return 'education_1k_description';
      case 'fitness_1000':
        return 'fitness_1k_description';
      case 'development_1000':
        return 'development_1k_description';
      case 'hobby_1000':
        return 'hobby_1k_description';
      case 'mind_1000':
        return 'mind_1k_description';
      case '7_day_streak':
        return 'seven_day_streak_description';
      default:
        return achievement.description;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isLight =
        theme.brightness == Brightness.light;

    final title = appState.strings.get(
      _titleKey(achievement.id),
    );

    final description = appState.strings.get(
      _descriptionKey(achievement.id),
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 24,
          sigmaY: 24,
        ),
        child: Container(
          padding: const EdgeInsets.all(17),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: unlocked
                  ? [
                      colors.primary.withValues(
                        alpha: isLight ? 0.13 : 0.16,
                      ),
                      colors.surface.withValues(
                        alpha: isLight ? 0.58 : 0.07,
                      ),
                      colors.surface.withValues(
                        alpha: isLight ? 0.38 : 0.12,
                      ),
                    ]
                  : [
                      colors.onSurface.withValues(
                        alpha: isLight ? 0.08 : 0.065,
                      ),
                      colors.surface.withValues(
                        alpha: isLight ? 0.55 : 0.045,
                      ),
                      colors.surface.withValues(
                        alpha: isLight ? 0.35 : 0.08,
                      ),
                    ],
            ),
            border: Border.all(
              color: unlocked
                  ? colors.primary.withValues(
                      alpha: 0.38,
                    )
                  : colors.onSurface.withValues(
                      alpha: isLight ? 0.15 : 0.13,
                    ),
              width: 1.1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: isLight ? 0.055 : 0.20,
                ),
                blurRadius: 25,
                offset: const Offset(0, 11),
              ),
              if (unlocked)
                BoxShadow(
                  color: colors.primary.withValues(
                    alpha: 0.10,
                  ),
                  blurRadius: 25,
                  spreadRadius: -4,
                ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 15,
                right: 15,
                child: Container(
                  height: 1,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        colors.onSurface.withValues(
                          alpha: 0.30,
                        ),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Container(
                    width: 61,
                    height: 61,
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(19),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: unlocked
                            ? [
                                colors.primary.withValues(
                                  alpha: 0.32,
                                ),
                                colors.primary.withValues(
                                  alpha: 0.07,
                                ),
                              ]
                            : [
                                colors.onSurface.withValues(
                                  alpha: 0.08,
                                ),
                                colors.onSurface.withValues(
                                  alpha: 0.025,
                                ),
                              ],
                      ),
                      border: Border.all(
                        color: unlocked
                            ? colors.primary.withValues(
                                alpha: 0.38,
                              )
                            : colors.onSurface.withValues(
                                alpha: 0.10,
                              ),
                      ),
                      boxShadow: unlocked
                          ? [
                              BoxShadow(
                                color: colors.primary
                                    .withValues(
                                  alpha: 0.22,
                                ),
                                blurRadius: 18,
                              ),
                            ]
                          : null,
                    ),
                    child: Icon(
                      achievement.icon,
                      color: unlocked
                          ? colors.primary
                          : colors.onSurface.withValues(
                              alpha: 0.25,
                            ),
                      size: 29,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            color: unlocked
                                ? colors.onSurface
                                : colors.onSurface
                                    .withValues(
                                    alpha: 0.43,
                                  ),
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          description,
                          style: TextStyle(
                            color: colors.onSurface
                                .withValues(
                              alpha:
                                  unlocked ? 0.55 : 0.28,
                            ),
                            fontSize: 12,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Icon(
                    unlocked
                        ? Icons.check_circle_rounded
                        : Icons.lock_outline_rounded,
                    color: unlocked
                        ? colors.primary
                        : colors.onSurface.withValues(
                            alpha: 0.23,
                          ),
                    size: 22,
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