import 'package:flutter/material.dart';

class Achievement {
  final String id;
  final String title;
  final String description;
  final IconData icon;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
  });
}

class AchievementDefinitions {
  static const List<Achievement> all = [
    Achievement(
      id: 'first_task',
      title: 'First Step',
      description: 'Complete your first task.',
      icon: Icons.flag_rounded,
    ),

    Achievement(
      id: '100_xp',
      title: 'Century',
      description: 'Reach 100 total XP.',
      icon: Icons.bolt_rounded,
    ),

    Achievement(
      id: '500_xp',
      title: 'Getting Serious',
      description: 'Reach 500 total XP.',
      icon: Icons.local_fire_department_rounded,
    ),

    Achievement(
      id: '1000_xp',
      title: 'XP Master',
      description: 'Reach 1,000 total XP.',
      icon: Icons.workspace_premium_rounded,
    ),

    Achievement(
      id: 'level_5',
      title: 'Level 5',
      description: 'Reach Level 5.',
      icon: Icons.trending_up_rounded,
    ),

    Achievement(
      id: 'level_10',
      title: 'Level 10',
      description: 'Reach Level 10.',
      icon: Icons.military_tech_rounded,
    ),

    Achievement(
      id: '10_tasks',
      title: '10 Tasks',
      description: 'Complete 10 tasks.',
      icon: Icons.check_circle_rounded,
    ),

    Achievement(
      id: '50_tasks',
      title: '50 Tasks',
      description: 'Complete 50 tasks.',
      icon: Icons.task_alt_rounded,
    ),

    Achievement(
      id: 'education_1000',
      title: 'Education 1K',
      description: 'Earn 1,000 XP from Education tasks.',
      icon: Icons.school_rounded,
    ),

    Achievement(
      id: 'fitness_1000',
      title: 'Fitness 1K',
      description: 'Earn 1,000 XP from Fitness tasks.',
      icon: Icons.fitness_center_rounded,
    ),

    Achievement(
      id: 'development_1000',
      title: 'Development 1K',
      description: 'Earn 1,000 XP from Development tasks.',
      icon: Icons.code_rounded,
    ),

    Achievement(
      id: 'hobby_1000',
      title: 'Hobby 1K',
      description: 'Earn 1,000 XP from Hobby tasks.',
      icon: Icons.palette_rounded,
    ),

    Achievement(
      id: 'mind_1000',
      title: 'Mind 1K',
      description: 'Earn 1,000 XP from Mind tasks.',
      icon: Icons.psychology_rounded,
    ),

    Achievement(
      id: '7_day_streak',
      title: '7-Day Consistency',
      description: 'Complete at least one task for 7 consecutive days.',
      icon: Icons.calendar_month_rounded,
    ),
  ];
}