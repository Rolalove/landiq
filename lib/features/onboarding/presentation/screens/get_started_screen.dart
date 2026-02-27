import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:landiq/core/theme/app_buttons.dart';
import 'package:landiq/core/theme/app_colors.dart';
import 'package:landiq/core/theme/app_sizes.dart';

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({super.key});

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  bool _initialized = false;
  static const String _imagePath = 'assets/images/onboarding/Getstarted.jpg';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      precacheImage(const AssetImage(_imagePath), context);
      _initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Image.asset(
              _imagePath,
              fit: BoxFit.cover,
              filterQuality: FilterQuality.high,
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
        ],
      ),
    );
  }
}
