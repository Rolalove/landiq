import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:landiq/core/network/token_storage.dart';
import 'package:landiq/features/auth/presentation/screens/login_screen.dart';
import 'package:landiq/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:landiq/features/home/presentation/screens/home_screen.dart';
import 'package:landiq/features/notifications/presentation/screens/notifications_screen.dart';
import 'package:landiq/features/onboarding/presentation/screens/get_started_screen.dart';
import 'package:landiq/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:landiq/features/onboarding/presentation/screens/splash_intro_screen.dart';
import 'package:landiq/features/profile/presentation/screens/about_screen.dart';
import 'package:landiq/features/profile/presentation/screens/edit_profile_screen.dart';
import 'package:landiq/features/profile/presentation/screens/help_support_screen.dart';
import 'package:landiq/features/profile/presentation/screens/legal_screen.dart';
import 'package:landiq/features/walkthrough/presentation/screens/walkthrough_screen.dart';
import 'package:landiq/features/assessment/presentation/screens/new_assessment_screen.dart';
import 'package:landiq/features/assessment/presentation/screens/assessment_report_screen.dart';
import 'package:landiq/features/assessment/presentation/screens/all_assessments_screen.dart';

// Provider that determines the initial route based on onboarding + auth state
final initialLocationProvider = FutureProvider<String>((ref) async {
  final tokenStorage = TokenStorage();

  // Check onboarding
  final onboardingDone = await tokenStorage.isOnboardingComplete();
  if (!onboardingDone) return '/';

  // Check auth
  final hasToken = await tokenStorage.hasTokens();
  if (!hasToken) return '/login';

  return '/home';
});

// Creates the GoRouter — called after initial location is resolved
GoRouter createRouter(String initialLocation) {
  return GoRouter(
    initialLocation: initialLocation,
    routes: [
      GoRoute(
        path: '/',
        name: 'splashIntro',
        builder: (context, state) => const SplashIntroScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/get-started',
        name: 'getStarted',
        builder: (context, state) => const GetStartedScreen(),
      ),
      GoRoute(
        path: '/sign-up',
        name: 'signUp',
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) {
          final tabStr = state.uri.queryParameters['tab'];
          final tabIndex = int.tryParse(tabStr ?? '0') ?? 0;
          return HomeScreen(initialTabIndex: tabIndex);
        },
      ),
      GoRoute(
        path: '/edit-profile',
        name: 'editProfile',
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: '/help-support',
        name: 'helpSupport',
        builder: (context, state) => const HelpSupportScreen(),
      ),
      GoRoute(
        path: '/notifications',
        name: 'notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: '/legal',
        name: 'legal',
        builder: (context, state) => const LegalScreen(),
      ),
      GoRoute(
        path: '/about',
        name: 'about',
        builder: (context, state) => const AboutScreen(),
      ),
      GoRoute(
        path: '/walkthrough',
        name: 'walkthrough',
        builder: (context, state) => const WalkthroughScreen(),
      ),
      GoRoute(
        path: '/new-assessment',
        name: 'newAssessment',
        builder: (context, state) => const NewAssessmentScreen(),
      ),
      GoRoute(
        path: '/assessment-report',
        name: 'assessmentReport',
        builder: (context, state) => const AssessmentReportScreen(),
      ),
      GoRoute(
        path: '/all-assessments',
        name: 'allAssessments',
        builder: (context, state) => const AllAssessmentsScreen(),
      ),
    ],
  );
}
