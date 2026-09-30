import 'dart:ui';

import 'package:flutter/material.dart';

import '../services/app_state.dart';
import '../services/storage_service.dart';

class SetupScreen extends StatefulWidget {
  final AppState appState;

  const SetupScreen({
    super.key,
    required this.appState,
  });

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  final TextEditingController _nicknameController =
      TextEditingController();

  bool _saving = false;

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  Future<void> _continue() async {
    final nickname =
        _nicknameController.text.trim();

    if (nickname.isEmpty || _saving) {
      return;
    }

    setState(() {
      _saving = true;
    });

    // IMPORTANT:
    // Do not call AppState.setNickname().
    // We are testing whether notifyListeners()
    // is what causes the red screen.

    widget.appState.nickname = nickname;

    await StorageService.saveNickname(nickname);

    if (!mounted) return;

    setState(() {
      _saving = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLight =
        Theme.of(context).brightness ==
            Brightness.light;

    final accent =
        Color(widget.appState.accentColorValue);

    final textColor =
        isLight ? Colors.black : Colors.white;

    final secondaryColor =
        isLight
            ? Colors.black.withValues(alpha: 0.55)
            : Colors.white.withValues(alpha: 0.55);

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor:
            isLight
                ? const Color(0xFFF3F3F3)
                : const Color(0xFF090909),

        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),

              child: ConstrainedBox(
                constraints:
                    const BoxConstraints(
                  maxWidth: 520,
                ),

                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center,

                  children: [
                    const SizedBox(height: 40),

                    Container(
                      width: 86,
                      height: 86,

                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(28),

                        border: Border.all(
                          color:
                              accent.withValues(
                            alpha: 0.45,
                          ),
                        ),

                        gradient:
                            LinearGradient(
                          begin:
                              Alignment.topLeft,
                          end:
                              Alignment.bottomRight,

                          colors: [
                            accent.withValues(
                              alpha: 0.22,
                            ),
                            isLight
                                ? Colors.white.withValues(
                                    alpha: 0.7,
                                  )
                                : Colors.white.withValues(
                                    alpha: 0.05,
                                  ),
                          ],
                        ),

                        boxShadow: [
                          BoxShadow(
                            color:
                                accent.withValues(
                              alpha: 0.22,
                            ),
                            blurRadius: 30,
                            spreadRadius: 2,
                          ),
                        ],
                      ),

                      child: Icon(
                        Icons.bolt_rounded,
                        size: 44,
                        color: accent,
                      ),
                    ),

                    const SizedBox(height: 28),

                    Text(
                      'XP Self Improve',
                      textAlign: TextAlign.center,

                      style: TextStyle(
                        color: textColor,
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -1,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      'Your personal system for improving every day.',
                      textAlign: TextAlign.center,

                      style: TextStyle(
                        color: secondaryColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 42),

                    ClipRRect(
                      borderRadius:
                          BorderRadius.circular(30),

                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 18,
                          sigmaY: 18,
                        ),

                        child: Container(
                          padding:
                              const EdgeInsets.all(24),

                          decoration:
                              BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(30),

                            border: Border.all(
                              color:
                                  isLight
                                      ? Colors.black
                                          .withValues(
                                          alpha: 0.10,
                                        )
                                      : Colors.white
                                          .withValues(
                                          alpha: 0.12,
                                        ),
                            ),

                            gradient:
                                LinearGradient(
                              begin:
                                  Alignment.topLeft,
                              end:
                                  Alignment.bottomRight,

                              colors: [
                                isLight
                                    ? Colors.white
                                        .withValues(
                                        alpha: 0.75,
                                      )
                                    : Colors.white
                                        .withValues(
                                        alpha: 0.09,
                                      ),

                                isLight
                                    ? Colors.white
                                        .withValues(
                                        alpha: 0.40,
                                      )
                                    : Colors.white
                                        .withValues(
                                        alpha: 0.025,
                                      ),
                              ],
                            ),

                            boxShadow: [
                              BoxShadow(
                                color: Colors.black
                                    .withValues(
                                  alpha:
                                      isLight
                                          ? 0.08
                                          : 0.35,
                                ),
                                blurRadius: 30,
                                offset:
                                    const Offset(0, 15),
                              ),

                              BoxShadow(
                                color:
                                    accent.withValues(
                                  alpha: 0.08,
                                ),
                                blurRadius: 35,
                              ),
                            ],
                          ),

                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,

                            children: [
                              Text(
                                'What should we call you?',

                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 20,
                                  fontWeight:
                                      FontWeight.w800,
                                ),
                              ),

                              const SizedBox(height: 8),

                              Text(
                                'Choose a nickname for your profile.',

                                style: TextStyle(
                                  color:
                                      secondaryColor,
                                  fontSize: 14,
                                  fontWeight:
                                      FontWeight.w500,
                                ),
                              ),

                              const SizedBox(height: 20),

                              TextField(
                                controller:
                                    _nicknameController,

                                autofocus: false,

                                textInputAction:
                                    TextInputAction.done,

                                onSubmitted: (_) =>
                                    _continue(),

                                style: TextStyle(
                                  color: textColor,
                                  fontWeight:
                                      FontWeight.w700,
                                ),

                                decoration:
                                    const InputDecoration(
                                  hintText:
                                      'Your nickname',

                                  prefixIcon: Icon(
                                    Icons.person_rounded,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 18),

                              SizedBox(
                                width:
                                    double.infinity,
                                height: 56,

                                child:
                                    ElevatedButton(
                                  onPressed:
                                      _saving
                                          ? null
                                          : _continue,

                                  style:
                                      ElevatedButton
                                          .styleFrom(
                                    backgroundColor:
                                        accent,

                                    foregroundColor:
                                        Colors.white,

                                    disabledBackgroundColor:
                                        accent.withValues(
                                      alpha: 0.45,
                                    ),

                                    elevation: 0,

                                    shape:
                                        RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius
                                              .circular(18),
                                    ),
                                  ),

                                  child: _saving
                                      ? const SizedBox(
                                          width: 22,
                                          height: 22,
                                          child:
                                              CircularProgressIndicator(
                                            strokeWidth: 2.5,
                                            color:
                                                Colors.white,
                                          ),
                                        )
                                      : const Text(
                                          'Continue',
                                          style:
                                              TextStyle(
                                            fontSize: 16,
                                            fontWeight:
                                                FontWeight.w800,
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    Text(
                      'Do tasks. Gain XP. Level up. Improve.',
                      textAlign: TextAlign.center,

                      style: TextStyle(
                        color: secondaryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}