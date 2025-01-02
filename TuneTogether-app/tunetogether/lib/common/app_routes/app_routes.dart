import 'package:flutter/material.dart';
import 'package:tunetogether/common/widgets/splash_screen.dart';
import 'package:tunetogether/core/auth_gate/auth_gate.dart';
import 'package:tunetogether/features/auth/presentation/screens/forgot_pass_screen.dart';
import 'package:tunetogether/features/auth/presentation/screens/onboarding_screen.dart';
import 'package:tunetogether/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:tunetogether/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:tunetogether/features/home/presentation/screens/home_screen.dart';
import 'package:tunetogether/features/home/presentation/screens/profile_screen.dart';
import 'package:tunetogether/features/join_groups/presentation/screen/join_group_screen.dart';

final routes = <String, WidgetBuilder>{
  // Auth
  '/': (context) => const SplashScreen(),
  '/auth-gate': (context) => const AuthGate(),
  '/on-boarding': (context) => const OnboardingScreen(),
  '/forgot-password': (context) => const ForgotPassScreen(),
  '/sign-up': (context) => const SignUpScreen(),
  '/sign-in': (context) => const SignInScreen(),

  // Home
  '/home': (context) => const HomeScreen(),
  '/join-group': (context) => const JoinGroupsScreen(),
  '/profile': (context) => const ProfileScreen(),
};
