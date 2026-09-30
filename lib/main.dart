import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/main_navigation.dart';
import 'screens/setup_screen.dart';
import 'services/app_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appState = AppState();
  await appState.load();

  runApp(
    XSISApp(
      appState: appState,
    ),
  );
}

class XSISApp extends StatefulWidget {
  final AppState appState;

  const XSISApp({
    super.key,
    required this.appState,
  });

  @override
  State<XSISApp> createState() => _XSISAppState();
}

class _XSISAppState extends State<XSISApp> {
  late String _theme;
  late int _accentColor;

  @override
  void initState() {
    super.initState();

    _theme = widget.appState.theme;
    _accentColor = widget.appState.accentColorValue;

    widget.appState.addListener(_onAppStateChanged);
  }

  void _onAppStateChanged() {
    if (!mounted) return;

    final newTheme = widget.appState.theme;
    final newAccent = widget.appState.accentColorValue;

    if (newTheme != _theme || newAccent != _accentColor) {
      setState(() {
        _theme = newTheme;
        _accentColor = newAccent;
      });
    }
  }

  ThemeData _buildTheme({
    required bool isLight,
    required Color accent,
  }) {
    return ThemeData(
      useMaterial3: true,
      brightness:
          isLight ? Brightness.light : Brightness.dark,

      colorScheme: ColorScheme.fromSeed(
        seedColor: accent,
        brightness:
            isLight ? Brightness.light : Brightness.dark,
      ),

      scaffoldBackgroundColor:
          isLight
              ? const Color(0xFFF3F3F3)
              : const Color(0xFF090909),

      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor:
            isLight ? Colors.black : Colors.white,
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor:
            isLight
                ? const Color(0xFFEAEAEA)
                : const Color(0xFF111111),
        indicatorColor:
            accent.withValues(alpha: 0.18),
        labelTextStyle:
            WidgetStateProperty.all(
          const TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor:
            isLight
                ? Colors.white.withValues(alpha: 0.8)
                : Colors.white.withValues(alpha: 0.06),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color:
                isLight
                    ? Colors.black.withValues(alpha: 0.12)
                    : Colors.white.withValues(alpha: 0.12),
          ),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color:
                isLight
                    ? Colors.black.withValues(alpha: 0.12)
                    : Colors.white.withValues(alpha: 0.12),
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: accent,
            width: 1.5,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    widget.appState.removeListener(
      _onAppStateChanged,
    );

    widget.appState.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLight = _theme == 'light';
    final accent = Color(_accentColor);

    return ChangeNotifierProvider<AppState>.value(
      value: widget.appState,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'XP Self Improve',

        theme: _buildTheme(
          isLight: isLight,
          accent: accent,
        ),

        home: AppRoot(
          appState: widget.appState,
        ),
      ),
    );
  }
}

class AppRoot extends StatelessWidget {
  final AppState appState;

  const AppRoot({
    super.key,
    required this.appState,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appState,
      builder: (context, child) {
        final hasNickname =
            appState.nickname != null &&
            appState.nickname!.trim().isNotEmpty;

        if (hasNickname) {
          return MainNavigation(
            key: const ValueKey('main_navigation'),
            appState: appState,
          );
        }

        return SetupScreen(
          key: const ValueKey('setup_screen'),
          appState: appState,
        );
      },
    );
  }
}