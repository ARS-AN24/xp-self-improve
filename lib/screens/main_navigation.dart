import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/app_state.dart';
import 'achievements_screen.dart';
import 'home_screen.dart';
import 'options_screen.dart';
import 'statistics_screen.dart';

class MainNavigation extends StatefulWidget {
  final AppState appState;

  const MainNavigation({
    super.key,
    required this.appState,
  });

  @override
  State<MainNavigation> createState() =>
      _MainNavigationState();
}

class _MainNavigationState
    extends State<MainNavigation> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    final isLight =
        Theme.of(context).brightness ==
            Brightness.light;

    final accent =
        Color(appState.accentColorValue);

    final background = isLight
        ? const Color(0xFFEAEAEA)
        : const Color(0xFF111111);

    final pages = [
      HomeScreen(
        appState: widget.appState,
      ),
      StatisticsScreen(
        appState: widget.appState,
      ),
      AchievementsScreen(),
      const OptionsScreen(),
    ];

    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(
          milliseconds: 300,
        ),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        transitionBuilder: (
          child,
          animation,
        ) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        child: KeyedSubtree(
          key: ValueKey(_currentIndex),
          child: pages[_currentIndex],
        ),
      ),

      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          if (_currentIndex == index) return;

          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: background,
        indicatorColor:
            accent.withValues(alpha: 0.18),
        animationDuration: const Duration(
          milliseconds: 350,
        ),
        destinations: [
          NavigationDestination(
            icon: const Icon(
              Icons.home_outlined,
            ),
            selectedIcon: Icon(
              Icons.home_rounded,
              color: accent,
            ),
            label: appState.language == 'ru'
                ? 'Главная'
                : 'Home',
          ),
          NavigationDestination(
            icon: const Icon(
              Icons.bar_chart_outlined,
            ),
            selectedIcon: Icon(
              Icons.bar_chart_rounded,
              color: accent,
            ),
            label: appState.language == 'ru'
                ? 'Статистика'
                : 'Statistics',
          ),
          NavigationDestination(
            icon: const Icon(
              Icons.emoji_events_outlined,
            ),
            selectedIcon: Icon(
              Icons.emoji_events_rounded,
              color: accent,
            ),
            label: appState.language == 'ru'
                ? 'Достижения'
                : 'Achievements',
          ),
          NavigationDestination(
            icon: const Icon(
              Icons.settings_outlined,
            ),
            selectedIcon: Icon(
              Icons.settings_rounded,
              color: accent,
            ),
            label: appState.language == 'ru'
                ? 'Опции'
                : 'Options',
          ),
        ],
      ),
    );
  }
}