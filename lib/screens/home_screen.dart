import 'dart:ui';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/achievement.dart';
import '../models/task.dart';
import '../services/app_state.dart';
import '../widgets/ios_widgets.dart';

class HomeScreen extends StatefulWidget {
  final AppState appState;

  const HomeScreen({
    super.key,
    required this.appState,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int _quoteNumber;

  @override
  void initState() {
    super.initState();
    _quoteNumber = Random().nextInt(10) + 1;
  }

  String _greeting(AppState state) {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return state.strings.get('good_morning');
    }

    if (hour < 18) {
      return state.strings.get('good_afternoon');
    }

    return state.strings.get('good_evening');
  }

  String _quote(AppState state) {
    return state.strings.get('quote_$_quoteNumber');
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) {
        final theme = Theme.of(context);
        final accent = Color(state.accentColorValue);

        return LayoutBuilder(
          builder: (context, constraints) {
            return SizedBox(
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // ========================================================
                  // FULL SCREEN BACKGROUND
                  // ========================================================

                  Positioned.fill(
                    child: ColoredBox(
                      color: theme.scaffoldBackgroundColor,
                    ),
                  ),

                  // ========================================================
                  // TOP-RIGHT GLOW
                  // Uses the EXACT selected secondary/accent color.
                  // No hue shifting.
                  // ========================================================

                  Positioned(
                    top: -170,
                    right: -120,
                    child: IgnorePointer(
                      child: ImageFiltered(
                        imageFilter: ImageFilter.blur(
                          sigmaX: 70,
                          sigmaY: 70,
                        ),
                        child: Container(
                          width: 360,
                          height: 360,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                accent.withOpacity(0.14),
                                accent.withOpacity(0.0),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // ========================================================
                  // BOTTOM-LEFT GLOW
                  // Same exact selected color.
                  // ========================================================

                  Positioned(
                    bottom: -220,
                    left: -160,
                    child: IgnorePointer(
                      child: ImageFiltered(
                        imageFilter: ImageFilter.blur(
                          sigmaX: 75,
                          sigmaY: 75,
                        ),
                        child: Container(
                          width: 420,
                          height: 420,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                accent.withOpacity(0.12),
                                accent.withOpacity(0.0),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // ========================================================
                  // CONTENT
                  // ========================================================

                  Positioned.fill(
                    child: SafeArea(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(
                          20,
                          18,
                          20,
                          30,
                        ),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            _buildHeader(context, state),
                            const SizedBox(height: 20),
                            _buildLevelCard(context, state),
                            const SizedBox(height: 20),
                            _buildMiniStats(state),
                            const SizedBox(height: 28),
                            _buildTasksHeader(context, state),
                            const SizedBox(height: 12),
                            _buildTasks(context, state),

                            // Extra bottom space so the last card never
                            // feels cut off behind the navigation area.
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildHeader(
    BuildContext context,
    AppState state,
  ) {
    final nickname = state.nickname?.trim();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _greeting(state),
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: 1.5,
              ),
        ),
        const SizedBox(height: 5),
        Text(
          nickname?.isNotEmpty == true
              ? nickname!
              : 'XP Self Improve',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w900,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          _quote(state),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.color
                    ?.withOpacity(0.65),
                fontStyle: FontStyle.italic,
              ),
        ),
      ],
    );
  }

  Widget _buildLevelCard(
    BuildContext context,
    AppState state,
  ) {
    final theme = Theme.of(context);
    final accent = Color(state.accentColorValue);

    return IOSGlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: accent.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: accent.withOpacity(0.35),
                  ),
                ),
                child: Center(
                  child: Text(
                    '${state.level}',
                    style: TextStyle(
                      color: accent,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${state.strings.get('level')} ${state.level}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${state.xpIntoLevel} / ${state.xpNeededForLevel} ${state.strings.get('xp')}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.textTheme.bodySmall?.color
                            ?.withOpacity(0.65),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${state.totalXP} XP',
                style: TextStyle(
                  color: accent,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: state.levelProgress,
              minHeight: 8,
              backgroundColor:
                  theme.dividerColor.withOpacity(0.12),
              valueColor:
                  AlwaysStoppedAnimation<Color>(accent),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStats(AppState state) {
    return Row(
      children: [
        Expanded(
          child: _buildMiniStat(
            context,
            state.strings.get('today_xp'),
            '${state.todayXP}',
            Icons.bolt_rounded,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildMiniStat(
            context,
            state.strings.get('todays_tasks'),
            '${state.todaysTasks.length}',
            Icons.check_circle_outline_rounded,
          ),
        ),
      ],
    );
  }

  Widget _buildMiniStat(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    final theme = Theme.of(context);
    final accent = Color(widget.appState.accentColorValue);

    return IOSGlassCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(
            icon,
            size: 22,
            color: accent,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.textTheme.bodySmall?.color
                        ?.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTasksHeader(
    BuildContext context,
    AppState state,
  ) {
    return Row(
      children: [
        Expanded(
          child: Text(
            state.strings.get('todays_tasks'),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
          ),
        ),
        TextButton(
          onPressed: () => _showAddTaskDialog(context),
          child: Text(
            state.strings.get('add_task'),
            style: const TextStyle(
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTasks(
    BuildContext context,
    AppState state,
  ) {
    final tasks = state.todaysTasks;

    if (tasks.isEmpty) {
      return IOSGlassCard(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Text(
            state.strings.get('no_tasks'),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.color
                      ?.withOpacity(0.65),
                ),
          ),
        ),
      );
    }

    return Column(
      children: [
        for (final task in tasks) ...[
          _buildTaskCard(context, state, task),
          const SizedBox(height: 10),
        ],
      ],
    );
  }

  Widget _buildTaskCard(
    BuildContext context,
    AppState state,
    Task task,
  ) {
    final theme = Theme.of(context);
    final accent = Color(state.accentColorValue);
    final completed = state.isCompletedToday(task);

    return GestureDetector(
      onTap: () => _toggleTask(context, state, task),
      onLongPress: () => _showDeleteConfirmation(
        context,
        state,
        task,
      ),
      child: IOSGlassCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: completed
                    ? accent.withOpacity(0.18)
                    : theme.dividerColor.withOpacity(0.08),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: completed
                      ? accent.withOpacity(0.5)
                      : theme.dividerColor.withOpacity(0.12),
                ),
              ),
              child: Icon(
                completed
                    ? Icons.check_rounded
                    : Icons.circle_outlined,
                color: completed
                    ? accent
                    : theme.iconTheme.color?.withOpacity(0.55),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    task.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      decoration:
                          completed
                              ? TextDecoration.lineThrough
                              : null,
                      color: completed
                          ? theme.textTheme.titleMedium?.color
                              ?.withOpacity(0.55)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    task.category.localizedName(
                      state.language,
                    ),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.textTheme.bodySmall?.color
                          ?.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Text(
              '+${task.xp}',
              style: TextStyle(
                color: accent,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _toggleTask(
    BuildContext context,
    AppState state,
    Task task,
  ) async {
    final achievements = await state.toggleTask(task);

    if (!context.mounted || achievements.isEmpty) {
      return;
    }

    for (final achievement in achievements) {
      await _showAchievementPopup(
        context,
        state,
        achievement,
      );
    }
  }

  Future<void> _showAchievementPopup(
    BuildContext context,
    AppState state,
    Achievement achievement,
  ) async {
    final theme = Theme.of(context);
    final accent = Color(state.accentColorValue);

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            state.strings.get('achievement_unlocked'),
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                achievement.icon,
                size: 58,
                color: accent,
              ),
              const SizedBox(height: 16),
              Text(
                achievement.title,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                achievement.description,
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                state.strings.get('continue_button'),
              ),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // DELETE TASK
  // ============================================================

  Future<void> _showDeleteConfirmation(
    BuildContext context,
    AppState state,
    Task task,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.48),
      builder: (dialogContext) {
        return _LiquidGlassDialog(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _DialogIcon(
                    icon: Icons.delete_outline_rounded,
                    color: Colors.redAccent,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      state.strings.get(
                        'delete_task_title',
                      ),
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(
                            fontWeight: FontWeight.w900,
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Text(
                state.strings.get(
                  'delete_task_description',
                ),
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(
                      height: 1.45,
                      color: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.color
                          ?.withOpacity(0.68),
                    ),
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.055),
                  borderRadius:
                      BorderRadius.circular(15),
                  border: Border.all(
                    color:
                        Colors.white.withOpacity(0.10),
                  ),
                ),
                child: Text(
                  task.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  Expanded(
                    child: _DialogButton(
                      label:
                          state.strings.get('cancel'),
                      onPressed: () {
                        Navigator.pop(
                          dialogContext,
                          false,
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _DialogButton(
                      label:
                          state.strings.get('delete'),
                      color: Colors.redAccent,
                      filled: true,
                      onPressed: () {
                        Navigator.pop(
                          dialogContext,
                          true,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );

    if (!mounted || confirmed != true) {
      return;
    }

    await state.deleteTask(task);
  }

  // ============================================================
  // ADD TASK
  // ============================================================

  Future<void> _showAddTaskDialog(
    BuildContext context,
  ) async {
    final state = widget.appState;

    final result =
        await showDialog<Map<String, dynamic>>(
      context: context,
      barrierDismissible: true,
      barrierColor:
          Colors.black.withOpacity(0.48),
      builder: (dialogContext) {
        return _AddTaskDialogContent(
          state: state,
        );
      },
    );

    if (!mounted || result == null) {
      return;
    }

    final name = result['name'] as String?;

    if (name == null || name.trim().isEmpty) {
      return;
    }

    final xp = result['xp'] as int;
    final category =
        result['category'] as TaskCategory;

    final task = Task(
      id: DateTime.now()
          .microsecondsSinceEpoch
          .toString(),
      name: name.trim(),
      xp: xp,
      category: category,
      days: List.generate(
        7,
        (index) => index + 1,
      ),
      time: 'Any time',
    );

    await state.addTask(task);
  }
}

// ============================================================
// ADD TASK DIALOG
// ============================================================

class _AddTaskDialogContent extends StatefulWidget {
  final AppState state;

  const _AddTaskDialogContent({
    required this.state,
  });

  @override
  State<_AddTaskDialogContent> createState() =>
      _AddTaskDialogContentState();
}

class _AddTaskDialogContentState
    extends State<_AddTaskDialogContent> {
  late final TextEditingController
      _nameController;

  int _selectedXP = 10;
  TaskCategory _selectedCategory =
      TaskCategory.other;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final theme = Theme.of(context);
    final accent =
        Color(state.accentColorValue);

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding:
          const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 24,
      ),
      child: ClipRRect(
        borderRadius:
            BorderRadius.circular(32),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 24,
            sigmaY: 24,
          ),
          child: Container(
            constraints:
                const BoxConstraints(
              maxWidth: 500,
            ),
            decoration:
                BoxDecoration(
              borderRadius:
                  BorderRadius.circular(32),
              gradient:
                  LinearGradient(
                begin:
                    Alignment.topLeft,
                end:
                    Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(
                    theme.brightness ==
                            Brightness.dark
                        ? 0.10
                        : 0.58,
                  ),
                  accent.withOpacity(
                    theme.brightness ==
                            Brightness.dark
                        ? 0.06
                        : 0.10,
                  ),
                  accent.withOpacity(
                    theme.brightness ==
                            Brightness.dark
                        ? 0.045
                        : 0.07,
                  ),
                ],
              ),
              border:
                  Border.all(
                color:
                    Colors.white.withOpacity(
                  theme.brightness ==
                          Brightness.dark
                      ? 0.16
                      : 0.38,
                ),
                width: 1.1,
              ),
              boxShadow: [
                BoxShadow(
                  color:
                      Colors.black.withOpacity(
                    theme.brightness ==
                            Brightness.dark
                        ? 0.35
                        : 0.14,
                  ),
                  blurRadius: 40,
                  offset:
                      const Offset(0, 18),
                ),
                BoxShadow(
                  color:
                      accent.withOpacity(0.10),
                  blurRadius: 50,
                  spreadRadius: -10,
                ),
              ],
            ),
            child:
                SingleChildScrollView(
              padding:
                  const EdgeInsets.all(22),
              child: Column(
                mainAxisSize:
                    MainAxisSize.min,
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _DialogIcon(
                        icon:
                            Icons.add_task_rounded,
                        color: accent,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          state.strings.get(
                            'add_task_title',
                          ),
                          style: theme
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                            fontWeight:
                                FontWeight.w900,
                          ),
                        ),
                      ),
                      _CloseButton(
                        onPressed: () {
                          Navigator.pop(
                            context,
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  _GlassTextField(
                    controller:
                        _nameController,
                    label:
                        state.strings.get(
                      'task_name',
                    ),
                    icon:
                        Icons.edit_rounded,
                    accent: accent,
                  ),
                  const SizedBox(height: 14),
                  _GlassDropdown<int>(
                    value: _selectedXP,
                    label:
                        state.strings.get(
                      'xp_reward',
                    ),
                    icon:
                        Icons.bolt_rounded,
                    accent: accent,
                    items: const [
                      DropdownMenuItem(
                        value: 10,
                        child: Text(
                          '10 XP',
                        ),
                      ),
                      DropdownMenuItem(
                        value: 20,
                        child: Text(
                          '20 XP',
                        ),
                      ),
                      DropdownMenuItem(
                        value: 30,
                        child: Text(
                          '30 XP',
                        ),
                      ),
                      DropdownMenuItem(
                        value: 40,
                        child: Text(
                          '40 XP',
                        ),
                      ),
                      DropdownMenuItem(
                        value: 50,
                        child: Text(
                          '50 XP',
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }

                      setState(() {
                        _selectedXP = value;
                      });
                    },
                  ),
                  const SizedBox(height: 14),
                  _GlassDropdown<TaskCategory>(
                    value:
                        _selectedCategory,
                    label:
                        state.strings.get(
                      'category',
                    ),
                    icon:
                        Icons.category_rounded,
                    accent: accent,
                    items:
                        TaskCategory.values
                            .map(
                      (category) {
                        return DropdownMenuItem<
                            TaskCategory>(
                          value: category,
                          child: Text(
                            category
                                .localizedName(
                              state.language,
                            ),
                          ),
                        );
                      },
                    ).toList(),
                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }

                      setState(() {
                        _selectedCategory =
                            value;
                      });
                    },
                  ),
                  const SizedBox(height: 22),
                  Row(
                    children: [
                      Expanded(
                        child:
                            _DialogButton(
                          label:
                              state.strings.get(
                            'cancel',
                          ),
                          onPressed: () {
                            Navigator.pop(
                              context,
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child:
                            _DialogButton(
                          label:
                              state.strings.get(
                            'add',
                          ),
                          color: accent,
                          filled: true,
                          onPressed: () {
                            final name =
                                _nameController
                                    .text
                                    .trim();

                            if (name.isEmpty) {
                              return;
                            }

                            Navigator.pop(
                              context,
                              {
                                'name': name,
                                'xp':
                                    _selectedXP,
                                'category':
                                    _selectedCategory,
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// LIQUID GLASS DIALOG
// ============================================================

class _LiquidGlassDialog
    extends StatelessWidget {
  final Widget child;

  const _LiquidGlassDialog({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme =
        Theme.of(context);

    final accent = Color(
      context
          .read<AppState>()
          .accentColorValue,
    );

    return Dialog(
      backgroundColor:
          Colors.transparent,
      elevation: 0,
      insetPadding:
          const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 24,
      ),
      child: ClipRRect(
        borderRadius:
            BorderRadius.circular(32),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 24,
            sigmaY: 24,
          ),
          child: Container(
            constraints:
                const BoxConstraints(
              maxWidth: 500,
            ),
            padding:
                const EdgeInsets.all(22),
            decoration:
                BoxDecoration(
              borderRadius:
                  BorderRadius.circular(32),
              gradient:
                  LinearGradient(
                begin:
                    Alignment.topLeft,
                end:
                    Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(
                    theme.brightness ==
                            Brightness.dark
                        ? 0.10
                        : 0.58,
                  ),
                  accent.withOpacity(
                    theme.brightness ==
                            Brightness.dark
                        ? 0.055
                        : 0.10,
                  ),
                  accent.withOpacity(
                    theme.brightness ==
                            Brightness.dark
                        ? 0.045
                        : 0.07,
                  ),
                ],
              ),
              border:
                  Border.all(
                color:
                    Colors.white.withOpacity(
                  theme.brightness ==
                          Brightness.dark
                      ? 0.16
                      : 0.38,
                ),
                width: 1.1,
              ),
              boxShadow: [
                BoxShadow(
                  color:
                      Colors.black.withOpacity(
                    theme.brightness ==
                            Brightness.dark
                        ? 0.35
                        : 0.14,
                  ),
                  blurRadius: 40,
                  offset:
                      const Offset(0, 18),
                ),
              ],
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

// ============================================================
// DIALOG ICON
// ============================================================

class _DialogIcon
    extends StatelessWidget {
  final IconData icon;
  final Color color;

  const _DialogIcon({
    required this.icon,
    required this.color,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      width: 48,
      height: 48,
      decoration:
          BoxDecoration(
        borderRadius:
            BorderRadius.circular(16),
        color:
            color.withOpacity(0.12),
        border:
            Border.all(
          color:
              color.withOpacity(0.25),
        ),
        boxShadow: [
          BoxShadow(
            color:
                color.withOpacity(0.12),
            blurRadius: 18,
            spreadRadius: -4,
          ),
        ],
      ),
      child: Icon(
        icon,
        color: color,
        size: 24,
      ),
    );
  }
}

// ============================================================
// CLOSE BUTTON
// ============================================================

class _CloseButton
    extends StatelessWidget {
  final VoidCallback onPressed;

  const _CloseButton({
    required this.onPressed,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius:
            BorderRadius.circular(14),
        child: Container(
          width: 40,
          height: 40,
          decoration:
              BoxDecoration(
            color:
                Colors.white.withOpacity(
              0.06,
            ),
            borderRadius:
                BorderRadius.circular(14),
            border:
                Border.all(
              color:
                  Colors.white.withOpacity(
                0.10,
              ),
            ),
          ),
          child: Icon(
            Icons.close_rounded,
            size: 20,
            color: Theme.of(context)
                .iconTheme
                .color
                ?.withOpacity(0.65),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// DIALOG BUTTON
// ============================================================

class _DialogButton
    extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color? color;
  final bool filled;

  const _DialogButton({
    required this.label,
    required this.onPressed,
    this.color,
    this.filled = false,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    final theme =
        Theme.of(context);

    final buttonColor = color ??
        theme.textTheme.bodyMedium?.color;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius:
            BorderRadius.circular(17),
        child: AnimatedContainer(
          duration:
              const Duration(
            milliseconds: 160,
          ),
          height: 50,
          decoration:
              BoxDecoration(
            borderRadius:
                BorderRadius.circular(17),
            color: filled
                ? buttonColor
                    ?.withOpacity(0.82)
                : Colors.white
                    .withOpacity(0.055),
            border:
                Border.all(
              color: filled
                  ? buttonColor
                          ?.withOpacity(
                        0.55,
                      ) ??
                      Colors.white
                          .withOpacity(
                        0.15,
                      )
                  : Colors.white
                      .withOpacity(0.11),
            ),
            boxShadow:
                filled
                    ? [
                        BoxShadow(
                          color: buttonColor
                                  ?.withOpacity(
                                0.16,
                              ) ??
                              Colors
                                  .transparent,
                          blurRadius: 18,
                          spreadRadius: -4,
                        ),
                      ]
                    : null,
          ),
          child: Center(
            child: Text(
              label,
              maxLines: 1,
              overflow:
                  TextOverflow.ellipsis,
              style: TextStyle(
                color: filled
                    ? Colors.white
                    : theme.textTheme
                        .bodyMedium
                        ?.color,
                fontWeight:
                    FontWeight.w800,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// GLASS TEXT FIELD
// ============================================================

class _GlassTextField
    extends StatelessWidget {
  final TextEditingController
      controller;
  final String label;
  final IconData icon;
  final Color accent;

  const _GlassTextField({
    required this.controller,
    required this.label,
    required this.icon,
    required this.accent,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return TextField(
      controller: controller,
      autofocus: true,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
      ),
      decoration:
          InputDecoration(
        labelText: label,
        prefixIcon:
            Icon(icon),
        filled: true,
        fillColor:
            Colors.white.withOpacity(
          0.055,
        ),
        border:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
            17,
          ),
          borderSide:
              BorderSide(
            color:
                Colors.white.withOpacity(
              0.10,
            ),
          ),
        ),
        enabledBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
            17,
          ),
          borderSide:
              BorderSide(
            color:
                Colors.white.withOpacity(
              0.10,
            ),
          ),
        ),
        focusedBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
            17,
          ),
          borderSide:
              BorderSide(
            color:
                accent.withOpacity(0.55),
            width: 1.4,
          ),
        ),
      ),
    );
  }
}

// ============================================================
// GLASS DROPDOWN
// ============================================================

class _GlassDropdown<T>
    extends StatelessWidget {
  final T value;
  final String label;
  final IconData icon;
  final Color accent;
  final List<
      DropdownMenuItem<T>> items;
  final ValueChanged<T?>
      onChanged;

  const _GlassDropdown({
    required this.value,
    required this.label,
    required this.icon,
    required this.accent,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      decoration:
          InputDecoration(
        labelText: label,
        prefixIcon:
            Icon(icon),
        filled: true,
        fillColor:
            Colors.white.withOpacity(
          0.055,
        ),
        border:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
            17,
          ),
          borderSide:
              BorderSide(
            color:
                Colors.white.withOpacity(
              0.10,
            ),
          ),
        ),
        enabledBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
            17,
          ),
          borderSide:
              BorderSide(
            color:
                Colors.white.withOpacity(
              0.10,
            ),
          ),
        ),
        focusedBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
            17,
          ),
          borderSide:
              BorderSide(
            color:
                accent.withOpacity(0.55),
            width: 1.4,
          ),
        ),
      ),
      items: items,
      onChanged: onChanged,
      dropdownColor:
          Theme.of(context).cardColor,
      borderRadius:
          BorderRadius.circular(18),
    );
  }
}