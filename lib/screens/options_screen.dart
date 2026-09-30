import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';

class OptionsScreen extends StatelessWidget {
  const OptionsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final strings = appState.strings;
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isLight = theme.brightness == Brightness.light;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          strings.get('options'),
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
              size: 290,
              opacity: isLight ? 0.07 : 0.12,
            ),
          ),
          Positioned(
            top: 430,
            left: -160,
            child: _Glow(
              color: colors.primary,
              size: 320,
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
              _SectionTitle(
                strings.get('profile'),
              ),
              const SizedBox(height: 10),
              _GlassSection(
                child: Column(
                  children: [
                    _OptionTile(
                      icon: Icons.person_outline_rounded,
                      title: strings.get('nickname'),
                      value: appState.nickname ?? '',
                      onTap: () => _editNickname(
                        context,
                        appState,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              _SectionTitle(
                strings.get('daily_reset'),
              ),
              const SizedBox(height: 10),
              _GlassSection(
                child: Column(
                  children: [
                    _OptionTile(
                      icon: Icons.restart_alt_rounded,
                      title: strings.get('reset_time'),
                      value: _formatHour(
                        appState.resetHour,
                      ),
                      onTap: () => _selectResetTime(
                        context,
                        appState,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              _SectionTitle(
                strings.get('appearance'),
              ),
              const SizedBox(height: 10),
              _GlassSection(
                child: Column(
                  children: [
                    _OptionTile(
                      icon: Icons.palette_outlined,
                      title: strings.get('theme'),
                      value: appState.theme == 'light'
                          ? strings.get('light')
                          : strings.get('dark'),
                      onTap: () => _showThemePicker(
                        context,
                        appState,
                      ),
                    ),
                    _Divider(),
                    _OptionTile(
                      icon: Icons.language_rounded,
                      title: strings.get('language'),
                      value: appState.language == 'ru'
                          ? strings.get('russian')
                          : strings.get('english'),
                      onTap: () => _showLanguagePicker(
                        context,
                        appState,
                      ),
                    ),
                    _Divider(),
                    _ColorOption(
                      appState: appState,
                      title: strings.get(
                        'secondary_color',
                      ),
                      onTap: () => _showColorPicker(
                        context,
                        appState,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              _SectionTitle(
                strings.get('danger_zone'),
              ),
              const SizedBox(height: 10),
              _DangerCard(
                appState: appState,
                onTap: () => _confirmReset(
                  context,
                  appState,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatHour(int hour) {
    final suffix = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour % 12 == 0 ? 12 : hour % 12;
    return '$displayHour:00 $suffix';
  }

  Future<void> _editNickname(
    BuildContext context,
    AppState appState,
  ) async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return _NicknameDialog(
          appState: appState,
        );
      },
    );
  }

  Future<void> _selectResetTime(
  BuildContext context,
  AppState appState,
) async {
  int selectedHour = appState.resetHour;

  final result = await showDialog<int>(
    context: context,
    builder: (dialogContext) {
      final colors = Theme.of(context).colorScheme;

      return _GlassDialog(
        child: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  appState.strings.get('reset_time'),
                  style: TextStyle(
                    color: colors.onSurface,
                    fontSize: 21,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                const SizedBox(height: 22),

                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: colors.onSurface.withValues(
                        alpha: 0.07,
                      ),
                      border: Border.all(
                        color: colors.onSurface.withValues(
                          alpha: 0.10,
                        ),
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<int>(
                        value: selectedHour,
                        dropdownColor: colors.surface,
                        icon: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: colors.primary,
                        ),
                        style: TextStyle(
                          color: colors.onSurface,
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                        ),
                        items: List.generate(
                          24,
                          (hour) {
                            final suffix =
                                hour >= 12 ? 'PM' : 'AM';
                            final displayHour =
                                hour % 12 == 0
                                    ? 12
                                    : hour % 12;

                            return DropdownMenuItem<int>(
                              value: hour,
                              child: Text(
                                '$displayHour:00 $suffix',
                              ),
                            );
                          },
                        ),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              selectedHour = value;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 26),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(dialogContext);
                      },
                      child: Text(
                        appState.strings.get('cancel'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    FilledButton(
                      onPressed: () {
                        Navigator.pop(
                          dialogContext,
                          selectedHour,
                        );
                      },
                      child: Text(
                        appState.strings.get('save'),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      );
    },
  );

  if (result == null) return;

  await appState.setResetHour(result);
}

  Future<void> _showThemePicker(
    BuildContext context,
    AppState appState,
  ) async {
    final strings = appState.strings;

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return _GlassBottomSheet(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _SheetHandle(),
              const SizedBox(height: 18),
              _PickerTile(
                icon: Icons.dark_mode_rounded,
                title: strings.get('dark'),
                selected: appState.theme == 'dark',
                onTap: () async {
                  await appState.setTheme('dark');

                  if (sheetContext.mounted) {
                    Navigator.pop(sheetContext);
                  }
                },
              ),
              _PickerTile(
                icon: Icons.light_mode_rounded,
                title: strings.get('light'),
                selected: appState.theme == 'light',
                onTap: () async {
                  await appState.setTheme('light');

                  if (sheetContext.mounted) {
                    Navigator.pop(sheetContext);
                  }
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showLanguagePicker(
    BuildContext context,
    AppState appState,
  ) async {
    final strings = appState.strings;

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return _GlassBottomSheet(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _SheetHandle(),
              const SizedBox(height: 18),
              _PickerTile(
                icon: Icons.language_rounded,
                title: strings.get('english'),
                selected: appState.language == 'en',
                onTap: () async {
                  await appState.setLanguage('en');

                  if (sheetContext.mounted) {
                    Navigator.pop(sheetContext);
                  }
                },
              ),
              _PickerTile(
                icon: Icons.language_rounded,
                title: strings.get('russian'),
                selected: appState.language == 'ru',
                onTap: () async {
                  await appState.setLanguage('ru');

                  if (sheetContext.mounted) {
                    Navigator.pop(sheetContext);
                  }
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showColorPicker(
    BuildContext context,
    AppState appState,
  ) async {
    final colors = Theme.of(context).colorScheme;

    const accentColors = [
      0xFF4D8DFF,
      0xFF9B6CFF,
      0xFF4DFF88,
      0xFFFFA64D,
      0xFFFF5C8A,
      0xFF39D9FF,
    ];

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return _GlassBottomSheet(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _SheetHandle(),
              const SizedBox(height: 18),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  appState.strings.get(
                    'secondary_color',
                  ),
                  style: TextStyle(
                    color: colors.onSurface,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 14,
                runSpacing: 14,
                children: accentColors.map(
                  (value) {
                    final color = Color(value);
                    final selected =
                        appState.accentColorValue == value;

                    return GestureDetector(
                      onTap: () async {
                        await appState.setAccentColor(
                          value,
                        );

                        if (sheetContext.mounted) {
                          Navigator.pop(
                            sheetContext,
                          );
                        }
                      },
                      child: AnimatedContainer(
                        duration: const Duration(
                          milliseconds: 180,
                        ),
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: color,
                          border: Border.all(
                            color: selected
                                ? colors.onSurface
                                : Colors.white.withValues(
                                    alpha: 0.22,
                                  ),
                            width: selected ? 3 : 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: color.withValues(
                                alpha: 0.40,
                              ),
                              blurRadius:
                                  selected ? 18 : 10,
                              spreadRadius:
                                  selected ? 2 : 0,
                            ),
                          ],
                        ),
                        child: selected
                            ? const Icon(
                                Icons.check_rounded,
                                color: Colors.white,
                                size: 23,
                              )
                            : null,
                      ),
                    );
                  },
                ).toList(),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  Future<void> _confirmReset(
    BuildContext context,
    AppState appState,
  ) async {
    final strings = appState.strings;

    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        final colors = Theme.of(context).colorScheme;

        return _GlassDialog(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                strings.get(
                  'reset_progress_title',
                ),
                style: TextStyle(
                  color: colors.onSurface,
                  fontSize: 21,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                strings.get(
                  'reset_progress_warning',
                ),
                style: TextStyle(
                  color: colors.onSurface.withValues(
                    alpha: 0.55,
                  ),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(
                      dialogContext,
                      false,
                    ),
                    child: Text(
                      strings.get('cancel'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: colors.error,
                    ),
                    onPressed: () => Navigator.pop(
                      dialogContext,
                      true,
                    ),
                    child: Text(
                      strings.get('delete'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );

    if (result == true) {
      await appState.resetProgress();

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            strings.get('progress_reset'),
          ),
        ),
      );
    }
  }
}

class _NicknameDialog extends StatefulWidget {
  final AppState appState;

  const _NicknameDialog({
    required this.appState,
  });

  @override
  State<_NicknameDialog> createState() =>
      _NicknameDialogState();
}

class _NicknameDialogState extends State<_NicknameDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.appState.nickname ?? '',
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = widget.appState.strings;
    final colors = Theme.of(context).colorScheme;

    return _GlassDialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            strings.get('nickname'),
            style: TextStyle(
              color: colors.onSurface,
              fontSize: 21,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 18),
          TextField(
            controller: _controller,
            autofocus: true,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              hintText: strings.get('nickname'),
            ),
          ),
          const SizedBox(height: 22),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  strings.get('cancel'),
                ),
              ),
              const SizedBox(width: 8),
              FilledButton(
                onPressed: () async {
                  final value = _controller.text.trim();

                  if (value.isEmpty) return;

                  await widget.appState.setNickname(value);

                  if (mounted) {
                    Navigator.pop(context);
                  }
                },
                child: Text(
                  strings.get('save'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;

  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(left: 3),
      child: Text(
        text,
        style: TextStyle(
          color: colors.onSurface,
          fontSize: 12,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.6,
        ),
      ),
    );
  }
}

class _GlassSection extends StatelessWidget {
  final Widget child;

  const _GlassSection({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isLight =
        theme.brightness == Brightness.light;

    return ClipRRect(
      borderRadius: BorderRadius.circular(26),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 28,
          sigmaY: 28,
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                colors.onSurface.withValues(
                  alpha: isLight ? 0.10 : 0.06,
                ),
                colors.surface.withValues(
                  alpha: isLight ? 0.42 : 0.035,
                ),
                colors.surface.withValues(
                  alpha: isLight ? 0.28 : 0.07,
                ),
              ],
            ),
            border: Border.all(
              color: colors.onSurface.withValues(
                alpha: isLight ? 0.19 : 0.15,
              ),
              width: 1.1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: isLight ? 0.055 : 0.22,
                ),
                blurRadius: 28,
                offset: const Offset(0, 13),
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
                          alpha: 0.32,
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

class _OptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final VoidCallback onTap;

  const _OptionTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 17,
          vertical: 16,
        ),
        child: Row(
          children: [
            _IconGlass(
              icon: icon,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: colors.onSurface,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            if (value.isNotEmpty)
              Flexible(
                child: Text(
                  value,
                  textAlign: TextAlign.end,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: colors.onSurface.withValues(
                      alpha: 0.42,
                    ),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            const SizedBox(width: 8),
            Icon(
              Icons.chevron_right_rounded,
              color: colors.onSurface.withValues(
                alpha: 0.28,
              ),
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}

class _ColorOption extends StatelessWidget {
  final AppState appState;
  final String title;
  final VoidCallback onTap;

  const _ColorOption({
    required this.appState,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 17,
          vertical: 16,
        ),
        child: Row(
          children: [
            _IconGlass(
              icon: Icons.color_lens_outlined,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: colors.onSurface,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Container(
              width: 27,
              height: 27,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(
                  appState.accentColorValue,
                ),
                border: Border.all(
                  color: Colors.white.withValues(
                    alpha: 0.30,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(
                      appState.accentColorValue,
                    ).withValues(
                      alpha: 0.38,
                    ),
                    blurRadius: 12,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.chevron_right_rounded,
              color: colors.onSurface.withValues(
                alpha: 0.28,
              ),
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}

class _IconGlass extends StatelessWidget {
  final IconData icon;

  const _IconGlass({
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colors.onSurface.withValues(
              alpha: 0.13,
            ),
            colors.surface.withValues(
              alpha: 0.05,
            ),
          ],
        ),
        border: Border.all(
          color: colors.onSurface.withValues(
            alpha: 0.12,
          ),
        ),
      ),
      child: Icon(
        icon,
        color: colors.primary,
        size: 21,
      ),
    );
  }
}

class _DangerCard extends StatelessWidget {
  final AppState appState;
  final VoidCallback onTap;

  const _DangerCard({
    required this.appState,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isLight =
        theme.brightness == Brightness.light;

    return ClipRRect(
      borderRadius: BorderRadius.circular(26),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 25,
          sigmaY: 25,
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(26),
          child: Container(
            padding: const EdgeInsets.all(17),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(26),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  colors.error.withValues(
                    alpha: isLight ? 0.07 : 0.09,
                  ),
                  colors.surface.withValues(
                    alpha: isLight ? 0.50 : 0.045,
                  ),
                ],
              ),
              border: Border.all(
                color: colors.error.withValues(
                  alpha: 0.28,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: colors.error.withValues(
                    alpha: 0.07,
                  ),
                  blurRadius: 25,
                ),
              ],
            ),
            child: Row(
              children: [
                _IconGlass(
                  icon: Icons.delete_outline_rounded,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        appState.strings.get(
                          'reset_progress',
                        ),
                        style: TextStyle(
                          color: colors.error,
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        appState.strings.get(
                          'reset_progress_description',
                        ),
                        style: TextStyle(
                          color: colors.onSurface.withValues(
                            alpha: 0.42,
                          ),
                          fontSize: 11,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: colors.error.withValues(
                    alpha: 0.55,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Divider(
      height: 1,
      indent: 73,
      endIndent: 17,
      color: colors.onSurface.withValues(
        alpha: 0.08,
      ),
    );
  }
}

class _PickerTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const _PickerTile({
    required this.icon,
    required this.title,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return ListTile(
      onTap: onTap,
      leading: Icon(
        icon,
        color: selected
            ? colors.primary
            : colors.onSurface.withValues(
                alpha: 0.45,
              ),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: colors.onSurface,
          fontWeight: FontWeight.w800,
        ),
      ),
      trailing: selected
          ? Icon(
              Icons.check_circle_rounded,
              color: colors.primary,
            )
          : null,
    );
  }
}

class _SheetHandle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      width: 42,
      height: 4,
      decoration: BoxDecoration(
        color: colors.onSurface.withValues(
          alpha: 0.20,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}

class _GlassBottomSheet extends StatelessWidget {
  final Widget child;

  const _GlassBottomSheet({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(31),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 30,
          sigmaY: 30,
        ),
        child: Container(
          padding: const EdgeInsets.fromLTRB(
            20,
            12,
            20,
            20,
          ),
          decoration: BoxDecoration(
            color: colors.surface.withValues(
              alpha: 0.78,
            ),
            border: Border(
              top: BorderSide(
                color: colors.onSurface.withValues(
                  alpha: 0.18,
                ),
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: 0.25,
                ),
                blurRadius: 35,
                offset: const Offset(0, -10),
              ),
            ],
          ),
          child: SafeArea(
            child: child,
          ),
        ),
      ),
    );
  }
}

class _GlassDialog extends StatelessWidget {
  final Widget child;

  const _GlassDialog({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 22,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 30,
            sigmaY: 30,
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: colors.surface.withValues(
                alpha: 0.78,
              ),
              border: Border.all(
                color: colors.onSurface.withValues(
                  alpha: 0.16,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(
                    alpha: 0.25,
                  ),
                  blurRadius: 35,
                  offset: const Offset(0, 14),
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
