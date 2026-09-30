import 'dart:ui';

import 'package:flutter/material.dart';

class IOSGlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;
  final VoidCallback? onTap;
  final double blur;

  const IOSGlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.borderRadius = const BorderRadius.all(Radius.circular(26)),
    this.onTap,
    this.blur = 18,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final light = theme.brightness == Brightness.light;
    final accent = theme.colorScheme.primary;

    Widget card = ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: light ? .70 : .10),
                Colors.white.withValues(alpha: light ? .38 : .035),
              ],
            ),
            border: Border.all(
              color: Colors.white.withValues(alpha: light ? .65 : .16),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: light ? .08 : .30),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
              BoxShadow(
                color: accent.withValues(alpha: .08),
                blurRadius: 28,
                spreadRadius: -8,
              ),
            ],
          ),
          child: child,
        ),
      ),
    );

    if (onTap == null) return card;

    return _IOSPressable(
      onTap: onTap,
      child: card,
    );
  }
}

class IOSGlassButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final Color? color;
  final bool filled;

  const IOSGlassButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.color,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    final accent = color ?? Theme.of(context).colorScheme.primary;
    final light = Theme.of(context).brightness == Brightness.light;

    return _IOSPressable(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 13,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: filled
              ? accent.withValues(alpha: .90)
              : Colors.white.withValues(alpha: light ? .55 : .08),
          border: Border.all(
            color: Colors.white.withValues(alpha: .15),
          ),
          boxShadow: filled
              ? [
                  BoxShadow(
                    color: accent.withValues(alpha: .28),
                    blurRadius: 18,
                    offset: const Offset(0, 7),
                  ),
                ]
              : null,
        ),
        child: DefaultTextStyle(
          style: TextStyle(
            color: filled
                ? Colors.white
                : Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.w800,
          ),
          child: child,
        ),
      ),
    );
  }
}

class IOSSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;

  const IOSSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;
    final light = Theme.of(context).brightness == Brightness.light;

    return GestureDetector(
      onTap: onChanged == null ? null : () => onChanged!(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        width: 52,
        height: 32,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: value
              ? accent
              : (light
                  ? Colors.black.withValues(alpha: .14)
                  : Colors.white.withValues(alpha: .14)),
          border: Border.all(
            color: Colors.white.withValues(alpha: value ? .24 : .12),
          ),
          boxShadow: value
              ? [
                  BoxShadow(
                    color: accent.withValues(alpha: .32),
                    blurRadius: 14,
                  ),
                ]
              : null,
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutBack,
          alignment:
              value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: .20),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class IOSSegmentedControl<T> extends StatelessWidget {
  final List<T> values;
  final T selected;
  final ValueChanged<T> onChanged;
  final String Function(T value) labelBuilder;

  const IOSSegmentedControl({
    super.key,
    required this.values,
    required this.selected,
    required this.onChanged,
    required this.labelBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;

    return IOSGlassCard(
      padding: const EdgeInsets.all(4),
      borderRadius: BorderRadius.circular(17),
      blur: 14,
      child: Row(
        children: values.map((value) {
          final selected = value == this.selected;

          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(value),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 8,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(13),
                  color: selected
                      ? accent.withValues(alpha: .18)
                      : Colors.transparent,
                  border: Border.all(
                    color: selected
                        ? accent.withValues(alpha: .35)
                        : Colors.transparent,
                  ),
                ),
                child: Center(
                  child: Text(
                    labelBuilder(value),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight:
                          selected ? FontWeight.w900 : FontWeight.w700,
                      color: selected
                          ? accent
                          : Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: .70),
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class IOSGlassSlider extends StatelessWidget {
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;

  const IOSGlassSlider({
    super.key,
    required this.value,
    this.min = 0,
    this.max = 100,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;

    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: 7,
        activeTrackColor: accent,
        inactiveTrackColor:
            Colors.white.withValues(alpha: .10),
        thumbColor: Colors.white,
        overlayColor: accent.withValues(alpha: .12),
        thumbShape: const RoundSliderThumbShape(
          enabledThumbRadius: 10,
        ),
      ),
      child: Slider(
        value: value.clamp(min, max),
        min: min,
        max: max,
        onChanged: onChanged,
      ),
    );
  }
}

class IOSGlassProgressBar extends StatelessWidget {
  final double value;
  final double height;

  const IOSGlassProgressBar({
    super.key,
    required this.value,
    this.height = 10,
  });

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;

    return ClipRRect(
      borderRadius: BorderRadius.circular(height),
      child: Container(
        height: height,
        color: Colors.white.withValues(alpha: .08),
        child: Align(
          alignment: Alignment.centerLeft,
          child: FractionallySizedBox(
            widthFactor: value.clamp(0.0, 1.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(height),
                gradient: LinearGradient(
                  colors: [
                    accent.withValues(alpha: .72),
                    accent,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: accent.withValues(alpha: .35),
                    blurRadius: 10,
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

class IOSIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final double size;

  const IOSIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.size = 46,
  });

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;
    final light = Theme.of(context).brightness == Brightness.light;

    Widget button = _IOSPressable(
      onTap: onPressed,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white.withValues(alpha: light ? .55 : .07),
          border: Border.all(
            color: Colors.white.withValues(alpha: .15),
          ),
        ),
        child: Icon(
          icon,
          color: accent,
          size: 21,
        ),
      ),
    );

    if (tooltip != null) {
      button = Tooltip(
        message: tooltip!,
        child: button,
      );
    }

    return button;
  }
}

class _IOSPressable extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;

  const _IOSPressable({
    required this.child,
    required this.onTap,
  });

  @override
  State<_IOSPressable> createState() => _IOSPressableState();
}

class _IOSPressableState extends State<_IOSPressable> {
  bool pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onTap,
      onTapDown:
          widget.onTap == null ? null : (_) => setState(() => pressed = true),
      onTapCancel:
          widget.onTap == null ? null : () => setState(() => pressed = false),
      onTapUp: widget.onTap == null
          ? null
          : (_) => setState(() => pressed = false),
      child: AnimatedScale(
        scale: pressed ? .975 : 1,
        duration: const Duration(milliseconds: 110),
        child: widget.child,
      ),
    );
  }
}
