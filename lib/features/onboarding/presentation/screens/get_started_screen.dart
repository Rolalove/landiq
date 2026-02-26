import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:landiq/core/theme/app_buttons.dart';
import 'package:landiq/core/theme/app_colors.dart';
import 'package:landiq/core/theme/app_sizes.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Image.asset(
              'assets/images/onboarding/Getstarted.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'LandIQ',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.secondary,
                        fontSize: 64,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: AppSizes.xs),
                    Text(
                      'Land intelligence for Agriculture\n',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.secondary),
                    ),
                    Text(
                      'Make informed decision before investing in a farmland.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.secondary),
                    ),

                    SizedBox(height: AppSizes.xxl),
                    AppButton(
                      onPressed: () {
                        context.goNamed('signUp');
                      },
                      label: 'Get Started',
                      variant: AppButtonVariant.primary,
                      showTrailingArrow: false,
                    ),
                    SizedBox(height: AppSizes.lg),
                    AppButton(
                      onPressed: () {
                        context.goNamed('login');
                      },
                      label: 'Log In',
                      variant: AppButtonVariant.primary,
                      showTrailingArrow: false,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ButtonBarTheme(data: data, child: child),
        ],
      ),
    );
  }
}
