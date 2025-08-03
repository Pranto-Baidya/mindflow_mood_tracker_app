import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/provider/theme_provider/theme_provider.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/widgets/app_loader/app_loader.dart';
import 'package:provider/provider.dart';

import '../../../provider/local_auth_provider/local_auth_provider.dart';
import '../../../provider/preferences_provider/preferences_provider.dart';
import '../../ui_screens/home/all_mood_journal_screen.dart';
import '../pin_lock_screen/pin_lock_screen.dart';
import '../sign_in_sign_up/sign_in_sign_up.dart';

class CheckUser extends StatefulWidget {
  const CheckUser({super.key});

  @override
  State<CheckUser> createState() => _CheckUserState();
}

class _CheckUserState extends State<CheckUser> {

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    final prefs = context.read<PreferencesProvider>();
    final localAuth = context.read<LocalAuthProvider>();

    await prefs.loadLocalAuth();
    await localAuth.loadPin();

    final user = FirebaseAuth.instance.currentUser;

    if (!mounted) return;

    if (user != null) {
      if (prefs.isAuthEnabled && localAuth.isPinSet) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const PinLockScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AllMoodJournals()),
        );
      }
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const SignInSignUp()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = context.watch<ThemeProvider>().currentTheme==ThemeMode.dark;
    return Scaffold(
      body: Center(
          child: isDark?AppLoader.darkThemeLoaderPrimary():AppLoader.lightThemeLoaderPrimary()
      ),
    );
  }
}

